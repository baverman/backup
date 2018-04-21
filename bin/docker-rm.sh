#!/bin/sh
docker ps -a -f "name=$1" -q | xargs docker stop
docker ps -a -f "name=$1" -q | xargs docker rm
