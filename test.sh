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

# Original author: Maciej Barć (xgqt@protonmail.com)
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
        echo "File ${file}... checking"
        if command "${1}" "${file}"
        then
            echo "    file is correct"
        else
            echo "    there were errors found in the file"
            exit_result=1
        fi
        echo "Done: ${file}"
        echo
    done
}


sh_files="$(grep -R --exclude-dir='.git' '^#!/.*sh$' 2>/dev/null | cut -d ':' -f 1)"
py_files="$(grep -R --exclude-dir='.git' '^#!/.*python$' 2>/dev/null | cut -d ':' -f 1)"

run_test shellcheck "${sh_files}"
run_test pylint "${py_files}"

if [ ${exit_result} = 0 ]
then
    echo "No errors reported"
    echo "Exiting successfully"
    exit ${exit_result}
else
    echo "Some errors reported"
    echo "Exiting without success"
    exit ${exit_result}
fi
