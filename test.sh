#!/bin/sh


# Original author: XGQT
# Licensed under the ISC License
# Copyright (c) 2020, src_prepare group


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
