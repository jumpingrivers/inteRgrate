#!/bin/bash

Rscript -e "inteRgrate::check_pkg()"
if [ "$?" -eq 1 ]; then
  exit 1
fi

# It would also be nice to scan gitlab-ci /travis and extract the right hooks

