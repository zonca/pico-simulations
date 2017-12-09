#!/bin/bash

# get the absolute path to the directory with this script
pushd $(dirname $0) > /dev/null
topdir=$(pwd -P)
popd > /dev/null

template="pico_template"

make_output () {
    sub=$1
    pixels=$2
    days=$3
    nodes=$4
    mach=$5

    outfile=$(printf "pico_%05dpix_%03dday_%s.slurm" "${pixels}" "${days}" "${mach}")
    echo "Generating ${outfile}"

    sub="${sub} -e 's#@@nodes@@#${nodes}#g'"
    sub="${sub} -e 's#@@pix@@#${pixels}#g'"
    sub="${sub} -e 's#@@days@@#${days}#g'"
    sub="${sub} -e 's#@@topdir@@#${topdir}#g'"

    rm -f "${outfile}"

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        echo "${line}" | eval sed ${sub} >> "${outfile}"
    done < "${template}"
}


for machine in edison-intel cori-intel-knl; do
    machfile="machine.${machine}"

    # Create list of substitutions

    confsub=""

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        # is this line commented?
        comment=$(echo "${line}" | cut -c 1)
        if [ "${comment}" != "#" ]; then

            check=$(echo "${line}" | sed -e "s#.*=.*#=#")
        
            if [ "x${check}" = "x=" ]; then
                # get the variable and its value
                var=$(echo ${line} | sed -e "s#\([^=]*\)=.*#\1#" | awk '{print $1}')
                val=$(echo ${line} | sed -e "s#[^=]*= *\(.*\)#\1#")
                # add to list of substitutions
                confsub="${confsub} -e 's#@@${var}@@#${val}#g'"
            fi
        fi

    done < "${machfile}"

    confsub="${confsub} -e 's#@@machine@@#${machine}#g'"

    # Case 1: 1 pixel, 1 day

    make_output "${confsub}" "1" "1" "1" "${machine}"

    # Case 2: 19 pixel, 1 day

    make_output "${confsub}" "19" "1" "6" "${machine}"

    # Case 3: 19 pixel, 10 day

    make_output "${confsub}" "19" "10" "72" "${machine}"

    # Case 4: 217 pixel, 1 day

    make_output "${confsub}" "217" "1" "72" "${machine}"

done



