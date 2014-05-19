#!/usr/bin/env python2
import re
import sys
import filecmp

from os import readlink, makedirs, unlink, symlink
from glob import glob
from shutil import rmtree, copymode
from os.path import dirname, join, islink, isdir, realpath, abspath, isfile, \
    exists, relpath, commonprefix, expanduser

ignore_regex = re.compile(r'.+\.pyc$')


_vars = None
def get_vars():
    global _vars
    if not _vars:
        _vars = {}
        execfile(expanduser('~/.config/vars'), _vars)

    return _vars


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
            print 'dirs are different {}: new {}, chg {}'.format(source, afiles, dfiles)
            return False

        return True
    elif isfile(dest) and isfile(source):
        if filecmp.cmp(source, dest):
            return True

        print 'files are different {} {}'.format(source, dest)
        return False
    else:
        print 'unknown case {} {}'.format(source, dest)


def chk_makedirs(path, cache=set()):
    if path in cache:
        return

    cache.add(path)
    if not exists(path):
        print 'creating', path
        makedirs(path)


def clean_dest(dest):
    destdir = dirname(dest)
    chk_makedirs(destdir)

    if isfile(dest) or islink(dest):
        print 'removing', dest
        unlink(dest)
    elif isdir(dest):
        print 'removing', dest
        rmtree(dest)


def unroll_source(source, dest):
    print 'link {} -> {}'.format(source, dest)
    source = abspath(source)
    destdir = dirname(dest)
    if len(commonprefix([source, dest])) > 1:
        source = relpath(source, destdir)

    symlink(source, dest)


def unroll_template(source, dest):
    print 'template {} -> {}'.format(source, dest)
    with open(dest, 'w') as f:
        f.write(open(source).read().format(**get_vars()))

    copymode(source, dest)


def unroll(sources, root):
    sources = expand_sources(sources)
    for source in sources:
        if source.endswith(':tpl'):
            dest = join(root, source[:-4])
            clean_dest(dest)
            unroll_template(source, dest)
        else:
            dest = join(root, source)
            if can_be_unrolled(source, dest):
                clean_dest(dest)
                unroll_source(source, dest)


if __name__ == '__main__':
    source_list_fname = sys.argv[1]
    root = sys.argv[2]
    unroll(open(source_list_fname), root)
