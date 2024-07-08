#!/usr/bin/env python3
import re
import sys
import filecmp

from os import readlink, makedirs, unlink, symlink, chmod, environ
from glob import glob
from shutil import rmtree, copymode
from os.path import dirname, join, islink, isdir, realpath, abspath, isfile, \
    exists, relpath, commonprefix, expanduser

from mako.template import Template

ignore_regex = re.compile(r'.+\.pyc$')


_vars = None
def get_vars():
    global _vars
    if not _vars:
        _vars = dict(environ)
        exec(open(expanduser('~/.config/vars')).read(), _vars)

    return _vars


def expand_sources(sources):
    result = []
    for source in sources:
        source = source.rstrip()
        if not source:
            continue

        if '->' in source:
            source, _, dest = source.partition('->')
            yield expanduser(source.strip()), dest.strip()

        for name in glob(source):
            yield name, name


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


def unroll_source(source, dest):
    print('link {} -> {}'.format(source, dest))
    source = abspath(source)
    destdir = dirname(dest)
    if len(commonprefix([source, dest])) > 1:
        source = relpath(source, destdir)

    symlink(source, dest)


def unroll_template(source, dest):
    t = Template(filename=source)
    print('template {} -> {}'.format(source, dest))
    with open(dest, 'w') as f:
        f.write(t.render(**get_vars()))

    if hasattr(t.module, 'file_mode'):
        chmod(dest, t.module.file_mode)


def unroll(sources, root):
    for source, dest in expand_sources(sources):
        dest = join(root, dest)
        if dest.endswith(':tpl'):
            dest = dest[:-4]
            clean_dest(dest)
            unroll_template(source, dest)
        else:
            if can_be_unrolled(source, dest):
                clean_dest(dest)
                unroll_source(source, dest)


if __name__ == '__main__':
    source_list_fname = sys.argv[1]
    root = sys.argv[2]
    unroll(open(source_list_fname), root)
