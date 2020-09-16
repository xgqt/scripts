#!/bin/sh


exit_result=0
files="$(grep -R --exclude-dir='.git' '^#!/.*sh$' 2>/dev/null | cut -d ':' -f 1)"


for file in ${files}
do
    echo "File ${file}... checking"
    if shellcheck "${file}"
    then
        echo "    file is correct"
    else
        echo "    there were errors found in the file"
        exit_result=1
    fi
    echo "Done: ${file}"
    echo
done

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
