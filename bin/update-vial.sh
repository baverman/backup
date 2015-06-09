#!/bin/sh
echo -n vial vial-* | xargs -n1 -d ' ' --replace=^ echo "cd ^; git pull; cd .." | bash
