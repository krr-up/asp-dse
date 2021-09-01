#!/bin/bash

# 4 Inputs: a Pareto optimal front of a parent configuration, an output file, an option and additional a random seed
# Output: a certain implementation selected from the given front
# Option selection:
#   a   User choice
#   b   Randomly chosen
#TODO   (c  All implementations)

BASE_DIR="${PWD}"
RESULT="${BASE_DIR}"

# Random seed for bash script random number selection is assigned
RANDOM=$4

if [[ -f "${RESULT}/select_p_helper1.txt" ]]; then
    rm "${RESULT}/select_p_helper1.txt"
fi
if [[ -f "${RESULT}/select_p_helper2.txt" ]]; then
    rm "${RESULT}/select_p_helper2.txt"
fi

echo $1 "was chosen with option" $3

# Get the number of design points in front
impl_num=$(grep "Answer" $1 | tail -1 | rev | cut -d' ' -f1 | rev)
if [[ -z ${impl_num} ]]
then
    echo "No design points are available."
    exit 1
fi
echo "The given front contains" ${impl_num} "design points."

# TODO Extract and show characteristics for user input
# # Get and show the values (characteristics) of each design point
# echo -e "Num \t latency \t energy \t cost"
# for ((i=1; i<=${impl_num}; i++))
# do
#     line=$(( $(grep -m1 -n "Answer $i" $1 | cut -d : -f 1) + 5))
#     latency=$( sed -n ${line}p $1 | cut -d' ' -f3 )
#     ((line++))
#     energy=$( sed -n ${line}p $1 | cut -d' ' -f3 )
#     ((line++))
#     cost=$( sed -n ${line}p $1 | cut -d' ' -f3 )
    
#     echo -e $i '\t' ${latency} '\t' '\t' ${energy} '\t' '\t' ${cost}
# done

# Select an implementation in dependence of the chosen mode
if [ $3 == "a" ]    # User selection
then
    echo "Select a point from 1 to" ${impl_num}"!"
    read selection
    if [[ ${selection} -gt 0 && ${selection} -lt ${impl_num}+1 ]]
    then
        echo "Design point number" ${selection} "was chosen."
    else
        echo "Wrong selection number was chosen."
        exit 1
    fi
elif [ $3 == "b" ]  # Random selection
then
    selection=$(( $RANDOM % ${impl_num} + 1 ))
    echo "Design point number" ${selection} "was randomly chosen."
else
    echo "Second input parameter is wrong."
    exit 1
fi

# Get the implementation from the chosen design point (by use of select_p_helper1.txt, select_p_helper2.txt)
# Extract the decisions about allocation, binding and routing
line=$(( $(grep -n -w "Answer ${selection}" $1 | cut -d : -f 1) + 1))
sed -n ${line}p $1 > ${RESULT}/select_p_helper1.txt
cat ${RESULT}/${instance_name}/select_p_helper1.txt | cut -d $'\t' -f 2- | cut -d } -f 1 > ${RESULT}/${instance_name}/select_p_helper2.txt
cat ${RESULT}/${instance_name}/select_p_helper2.txt | sed 's/ /.\n/g' > $2
sed -i '$ s/$/./' $2

echo "Selected implementation saved in" $2