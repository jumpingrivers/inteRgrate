#!/bin/bash

Rscript -e "inteRgrate::check_r_filenames()"
if [ "$?" -eq 1 ]; then
  exit 1
fi

Rscript -e "inteRgrate::check_lintr()"
if [ "$?" -eq 1 ]; then
  exit 1
fi

# This actually changes the description file.
Rscript -e "inteRgrate::check_tidy_description()"
if [ "$?" -eq 1 ]; then
  exit 1
fi

Rscript -e "inteRgrate::check_namespace()"
if [ "$?" -eq 1 ]; then
  exit 1
fi

# Running check_version doesn't currently work.
# Basically I need to figure out what is being compared
# If commit 1 update version
# Commit 2 doesn't need to update
# So need to comparse all commits to some "branch/master"
# What happens if branch doesn't exist on origin ....

# It would also be nice to scan gitlab-ci /travis and extract the right hooks
