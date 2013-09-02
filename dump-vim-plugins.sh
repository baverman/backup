#!/bin/sh

cat ~/.vim/bundle/*/.git/config | grep url | sed -r 's/\s+url\s+=\s+//'
