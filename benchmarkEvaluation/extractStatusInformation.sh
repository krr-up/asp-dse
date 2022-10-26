#!/bin/bash

# From experimental results, this script is extracting all relevant status information for the evaluation afterwards
# These information are stored in files which are used by the script markdownGenerator.py later on

BASE_DIR="${PWD}"
OUTPUT="${BASE_DIR}/results"
ERROR="${BASE_DIR}/output_asp-dse-ed/asp-dse-child/hpc"
CASES="${BASE_DIR}/output_asp-dse-ed/asp-dse-child/hpc/results/asp-dse-child"
# One step further you can see the instances
# Three steps further you can find the solver output

# Organize the folder structure
echo "###############################################################"
echo "Get the name of the instances and create folders for them"
echo "Get the name of the cases and create folders for them"
echo "###############################################################"

cd ${CASES}/asp-dse-ed-v1.0.0-xyz-n1
instances=( $( find -name "*.lp" -type d) )
cd ${CASES}
cases=( $( find -name "asp-dse-ed*" -type d) )
for instance in ${instances[@]}
do 
    instanceName=$( echo ${instance} |cut -d. -f2 | cut -d/ -f2 )
    # Check if directory exists, if not found create it
    [ ! -d "${OUTPUT}/${instanceName}" ] && mkdir -p "${OUTPUT}/${instanceName}"

    for case in ${cases[@]}
    do
        caseName=$( echo ${case} | cut -d/ -f2 )
        # Check if directory exists, if not found create it
        [ ! -d "${OUTPUT}/${instanceName}/${caseName}" ] && mkdir -p "${OUTPUT}/${instanceName}/${caseName}"

        # Check if output files exist, if not found create them
        if [[ ! -f "${OUTPUT}/${instanceName}/${caseName}/statInfo.txt" ]]; then
            > "${OUTPUT}/${instanceName}/${caseName}/statInfo.txt"
        fi
        if [[ ! -f "${OUTPUT}/${instanceName}/${caseName}/designPoints.txt" ]]; then
            > "${OUTPUT}/${instanceName}/${caseName}/designPoints.txt"
        fi
        if [[ ! -f "${OUTPUT}/${instanceName}/${caseName}/results.txt" ]]; then
            > "${OUTPUT}/${instanceName}/${caseName}/results.txt"
        fi
    done
done

echo "###############################################################"
echo "Extract statistical information"
echo "###############################################################"
statusType1=( $( grep -r -m1 Answer | cut -d: -f 1) )  # Satisfiable
statusType2=( $( grep -r UNSAT | cut -d: -f 1) )       # Unsatisfiable
statusType3=( $( grep -r UNKNOWN | cut -d: -f 1) )     # Interrupted while Grounding
statusType4=( $(grep -rL 'Answer\|UNSAT\|UNKNOWN\|NoneType' | grep runsolver.solver) ) # Interrupted while Searching
statusType5=( $(grep -rx "Pareto front:" | cut -d: -f 1) ) # Satisfiable before timeout

timeout=900
timeFirstAnswer=-1

# The unsuccessful DSEs (type 2-4) get the default information
for type2 in ${statusType2[@]}
do
    instanceName=( $(echo ${type2} | cut -d/ -f2 | cut -d. -f1 ) )
    caseName=( $(echo ${type2} | cut -d/ -f1) )

    echo "Unsatisfiable" ${timeFirstAnswer} ${timeout} "0" > ${OUTPUT}/${instanceName}/${caseName}/statInfo.txt
done

for type3 in ${statusType3[@]}
do
    instanceName=( $(echo ${type3} | cut -d/ -f2 | cut -d. -f1 ) )
    caseName=( $(echo ${type3} | cut -d/ -f1) )

    echo "GroundTimeout" ${timeFirstAnswer} ${timeout} "0" > ${OUTPUT}/${instanceName}/${caseName}/statInfo.txt
done

for type4 in ${statusType4[@]}
do
    instanceName=( $(echo ${type4} | cut -d/ -f2 | cut -d. -f1 ) )
    caseName=( $(echo ${type4} | cut -d/ -f1) )

    echo "SolveTimeout" ${timeFirstAnswer} ${timeout} "0" > ${OUTPUT}/${instanceName}/${caseName}/statInfo.txt
done

# First type DSE has found answers, so we extract the searching time up to the first answer and the number of found design points
for type1 in ${statusType1[@]}
do
    instanceName=( $(echo ${type1} | cut -d/ -f2 | cut -d. -f1 ) )
    caseName=( $(echo ${type1} | cut -d/ -f1) )

    timeFirstAnswer=( $(cat ${type1} | grep "Answer 1 found after" | cut -d" " -f5) )
    numberDesignPoints=( $(cat ${type1} | grep "found after" | tail -1 | cut -d" " -f2) )
    # If entry is also of type5, we extract the searching time
    if [[ " ${statusType5[*]} " =~ " ${type1} " ]]; then
        timeout=( $(cat ${type1} | grep "CPU Time" | cut -d: -f2 | cut -d" " -f2 | rev | cut -ds -f2 | rev) ) 
        echo "SatisfiableNoTimeout" ${timeFirstAnswer} ${timeout} ${numberDesignPoints} > ${OUTPUT}/${instanceName}/${caseName}/statInfo.txt
    else
        timeout=900
        echo "SatisfiableTimeout" ${timeFirstAnswer} ${timeout} ${numberDesignPoints} > ${OUTPUT}/${instanceName}/${caseName}/statInfo.txt
    fi
done

cd ${BASE_DIR}
