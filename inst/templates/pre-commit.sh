#!/bin/bash

Rscript -e "inteRgrate::git_pre_commit()"
if [ "$?" -eq 1 ]; then
  exit 1
fi
