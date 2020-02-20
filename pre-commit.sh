#!/bin/bash

Rscript -e "inteRgrate::check_tidy_description()"
Rscript -e "inteRgrate::check_r_filenames()"
Rscript -e "inteRgrate::check_lintr()"
