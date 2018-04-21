#!/bin/sh
git diff --name-only ${1:-HEAD^} | cat
