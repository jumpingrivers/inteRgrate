#!/bin/bash

Rscript -e "inteRgrate::check_tidy_description()"
Rscript -e "inteRgrate::check_r_filenames()"
Rscript -e "inteRgrate::check_lintr()"
Rscript -e "inteRgrate::check_namespace()"

# Running check_version doesn't currently work.
# Basically I need to figure out what is being compared
# If commit 1 update version
# Commit 2 doesn't need to update
# So need to comparse all commits to some "branch/master"
# What happens if branch doesn't exist on origin ....

# It would also be nice to scan gitlab-ci /travis and extract the right hooks
