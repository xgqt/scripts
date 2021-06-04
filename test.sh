#!/bin/sh


# This file is part of scripts.

# scripts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# scripts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with scripts.  If not, see <https://www.gnu.org/licenses/>.

# Original author: Maciej Barć <xgqt@riseup.net>
# Copyright (c) 2020, src_prepare group
# Licensed under the GNU GPL v3 License

# $1 - code check tool
# $2 - files to check (quoed list)
# Examples:
#  - run_test shellcheck "src/check-commit src/repomanci"
#  - run_test pylint "${py_files}"

exit_result=0

run_test() {
    for file in ${2}
    do
        printf "%s\n" "File ${file}... checking"
        if command "${1}" "${file}"
        then
            printf "%s\n" "    file is correct"
        else
            printf "%s\n" "    there were errors found in the file" >> /dev/stderr
            exit_result=1
        fi
        printf "%s\n\n" "Done: ${file}"
    done
}


sh_files="$(grep -R --exclude-dir='.git' '^#!/.*sh$' 2>/dev/null | cut -d ':' -f 1)"
py_files="$(grep -R --exclude-dir='.git' '^#!/.*python$' 2>/dev/null | cut -d ':' -f 1)"

run_test shellcheck "${sh_files}"
run_test pylint "${py_files}"

if [ ${exit_result} = 0 ]
then
    printf "%s\n" "No errors reported" "Exiting successfully"
    exit ${exit_result}
else
    printf "%s\n" "Some errors reported" "Exiting without success" >> /dev/stderr
    exit ${exit_result}
fi
