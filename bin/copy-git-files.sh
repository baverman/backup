#/bin/sh
host=${1:?"Host required"}
shift
remote_dir=${1:?"Remote dir required"}
shift
tar -cz -f - $(git ls-files "$@") | ssh $host tar -C $remote_dir -xzf -
