#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from collections import defaultdict
from subprocess import Popen, PIPE
from datetime import datetime

def get_stats():
    p = Popen(['git', 'log',
               '--numstat',
               '--since', sys.argv[1],
               '--format=commit\t%aN\t%aE\t%ct'],
              stdout=PIPE)

    stats = []
    ctx = None
    for line in p.stdout:
        line = line.strip()
        if line.startswith('commit'):
            _, name, email, ts = line.split('\t')
            stat = {'name': name,
                    'email': email,
                    'date': datetime.fromtimestamp(int(ts)),
                    'added': 0,
                    'deleted': 0}

            stats.append(stat)
        elif line:
            added, deleted = line.split()[:2]
            if added != '-':
                stat['added'] += int(added)
            if deleted != '-':
                stat['deleted'] += int(deleted)

    return stats


def by_week(s):
    year = s['date'].year
    week = s['date'].isocalendar()[1]
    return (year, week), '{}-{}'.format(year, week)


def by_month(s):
    year = s['date'].year
    month = s['date'].month
    return (year, month), '{}-{}'.format(year, month)

def by_none(s):
    return 'all', 'all'


def get_groups(stats, grouper):
    groups = defaultdict(lambda: defaultdict(lambda: [0, 0]))
    for s in stats:
        g = grouper(s)
        gg = groups[g][(s['name'], s['email'])]
        gg[0] += s['added']
        gg[1] += s['deleted']

    return groups


def print_groups(groups):
    for g in sorted(groups):
        _, gname = g
        print gname
        sdata = sorted(groups[g].iteritems(),
                       reverse=True,
                       key=lambda r: r[1][0] + r[1][1])
        for (author, email), (added, deleted) in sdata:
            print '    {}\t{}\t{}\t{}'.format(author, email, added, deleted)


groups = get_groups(get_stats(), by_none)
print_groups(groups)
