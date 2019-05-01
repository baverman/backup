#!/bin/sh
user=$1
dest=$2
shift 2
ssh -T "$@" bash -c "cat | sudo -u $user tee $dest"
