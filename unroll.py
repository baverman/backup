#!/usr/bin/env python3
import re
import sys
import filecmp
import os
import site

import argparse
import difflib
from os import readlink, makedirs, unlink, symlink, chmod, environ
from glob import glob
from shutil import rmtree, copymode
from os.path import dirname, join, islink, isdir, realpath, abspath, isfile, \
    exists, relpath, commonprefix, expanduser, basename

sys.path.append(expanduser('~/.local/py'))

from mako.template import Template

ignore_regex = re.compile(r'.+\.pyc$')

dest_vars = {
  'pyver': '{}.{}'.format(*sys.version_info[:2]),
  'pysite': site.USER_SITE,
  'pybase': site.USER_BASE,
}

_vars = None
def get_vars():
    global _vars
    if not _vars:
        _vars = dict(environ)
        fname = expanduser('~/.config/vars')
        if exists(fname):
            exec(open(fname).read(), _vars)

    return _vars


def expand_sources(sources):
    result = []
    root = None
    for source in sources:
        source = source.rstrip()
        if not source:
            continue

        if source.startswith('#'):
            continue

        if source.startswith('root:'):
            root = expanduser(source.partition(':')[2].strip())
            continue

        if '->' in source:
            source, _, dest = source.partition('->')
            source = expanduser(source.strip())
            dest = dest.strip().format(**dest_vars)
            if dest.endswith('/'):
                dest += os.path.basename(source)
            result.append((source, dest))
            continue

        for name in glob(source):
            result.append((name, name))

    return result, root


def can_be_unrolled(source, dest):
    if not exists(dest):
        return True

    if islink(dest):
        if islink(source):
            return readlink(source) != readlink(dest)
        else:
            return realpath(dest) != abspath(source)
    elif isdir(dest) and isdir(source):
        dcmp = filecmp.dircmp(source, dest)
        afiles = [r for r in dcmp.right_only if not ignore_regex.match(r)]
        dfiles = dcmp.diff_files

        if afiles or dfiles:
            print('dirs are different {}: new {}, chg {}'.format(source, afiles, dfiles))
            return False

        return True
    elif isfile(dest) and isfile(source):
        if filecmp.cmp(source, dest):
            return True

        print('files are different {} {}'.format(source, dest))
        return False
    else:
        print('unknown case {} {}'.format(source, dest))


def chk_makedirs(path, cache=set()):
    if path in cache:
        return

    cache.add(path)
    if not exists(path):
        print('creating', path)
        makedirs(path)


def clean_dest(dest):
    destdir = dirname(dest)
    chk_makedirs(destdir)

    if isfile(dest) or islink(dest):
        print('removing', dest)
        unlink(dest)
    elif isdir(dest):
        print('removing', dest)
        rmtree(dest)


def unroll_source(source, dest, is_force):
    source = osource = abspath(source)
    destdir = dirname(dest)
    if len(commonprefix([source, dest])) > 1:
        rsource = relpath(source, destdir)
    else:
        rsource = source

    if not is_force and islink(dest) and os.readlink(dest) == rsource:
        return

    clean_dest(dest)
    print('link {} -> {}'.format(dest, rsource))
    symlink(rsource, dest)


def unroll_template(root, source, dest, is_force):
    t = Template(filename=source)
    new = t.render(root=root, **get_vars(), **dest_vars)

    old = None
    if not is_force and exists(dest):
        old = open(dest).read()
        if old == new:
            return

    print('template {} -> {}'.format(source, dest))
    if old is not None:
        print('  content differs, please review')
        diff = difflib.unified_diff(old.splitlines(), new.splitlines(), dest, source)
        for it in diff:
            print(it)
        return

    clean_dest(dest)
    with open(dest, 'w') as f:
        f.write(new)

    if hasattr(t.module, 'file_mode'):
        chmod(dest, t.module.file_mode)


def unroll(sources, optroot, is_force):
    rules, sroot = expand_sources(open(sources))
    root = optroot or sroot
    for source, dest in rules:
        dest = join(root, dest)
        if dest.endswith(':tpl'):
            dest = dest[:-4]
            unroll_template(root, source, dest, is_force)
        else:
            if can_be_unrolled(source, dest):
                unroll_source(source, dest, is_force)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('rules')
    parser.add_argument('-r', '--root')
    parser.add_argument('-f', '--force', action='store_true')
    args = parser.parse_args()
    unroll(args.rules, args.root, args.force)
