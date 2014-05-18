#!/usr/bin/env python2
import re
import sys
import filecmp

from os import readlink, makedirs, unlink, symlink
from glob import glob
from shutil import rmtree
from os.path import dirname, join, islink, isdir, realpath, abspath, isfile, \
    exists, relpath, commonprefix

ignore_regex = re.compile(r'.+\.pyc$')


def expand_sources(sources):
    result = []
    for source in sources:
        source = source.rstrip()
        if not source:
            continue

        source_names = glob(source)
        if source_names:
            result.extend(source_names)
        else:
            print 'Non existing source', source

    return result


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
            print '{}: {} {}'.format(source, afiles, dfiles)
            return False

        return True
    elif isfile(dest) and isfile(source):
        if filecmp.cmp(source, dest):
            return True

        print '{} not the same with {}'.format(source, dest)
        return False
    else:
        print 'Unknown case: {} {}'.format(source, dest)


def chk_makedirs(path, cache=set()):
    if path in cache:
        return

    cache.add(path)
    if not exists(path):
        makedirs(path)


def unroll(source, dest):
    print 'link {} -> {}'.format(source, dest)
    destdir = dirname(dest)
    chk_makedirs(destdir)

    if isfile(dest) or islink(dest):
        unlink(dest)
    elif isdir(dest):
        rmtree(dest)

    source = abspath(source)
    if len(commonprefix([source, dest])) > 1:
        source = relpath(source, destdir)

    symlink(source, dest)


def main(sources, root):
    sources = expand_sources(sources)
    for source in sources:
        dest = join(root, source)
        if can_be_unrolled(source, dest):
            unroll(source, dest)


if __name__ == '__main__':
    source_list_fname = sys.argv[1]
    root = sys.argv[2]
    main(open(source_list_fname), root)
