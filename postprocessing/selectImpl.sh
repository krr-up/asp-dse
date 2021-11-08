#!/bin/bash

# 4 Inputs: a Pareto optimal front of a parent configuration / output of dse, an output file, an option and additional a random seed
# Output: a certain implementation selected from the given front
# Option selection:
#   a   User choice
#   b   Randomly chosen
#   c   All implementations
#TODO   (d  Best value concerning a certain objective function)

BASE_DIR="${PWD}"
RESULT="${BASE_DIR}/results"

# Random seed for bash script random number selection is assigned
RANDOM=$4

if [[ -f "${RESULT}/selectHelper1.txt" ]]; then
    rm "${RESULT}/selectHelper1.txt"
fi
if [[ -f "${RESULT}/selectHelper2.txt" ]]; then
    rm "${RESULT}/selectHelper2.txt"
fi

echo $1 "was chosen with option" $3

# Get the number of design points in front
implNum=$(grep "Answer" $1 | tail -1 | rev | cut -d' ' -f1 | rev)
if [[ -z ${implNum} ]]
then
    echo "No design points are available."
    exit 1
fi
echo "The given front contains" ${implNum} "design points."

# Get and show the values (characteristics) of each design point
echo -e "Num \t latency \t energy \t cost"
for ((i=1; i<=${implNum}; i++))
do
    line=$(( $(grep -m1 -n "Answer $i" $1 | cut -d : -f 1) + 1))
    latency=$(tail -n +$line $1 | grep -m1 -o 'latency.*' | cut -d, -f3 | cut -d')' -f1)
    energy=$(tail -n +$line $1 | grep -m1 -o 'energy.*' | cut -d, -f3 | cut -d')' -f1)
    cost=$(tail -n +$line $1 | grep -m1 -o 'cost.*' | cut -d, -f3 | cut -d')' -f1)
    
    echo -e $i '\t' ${latency} '\t' '\t' ${energy} '\t' '\t' ${cost}
done

# Select an implementation in dependence of the chosen mode
if [ $3 == "a" ]    # User selection
then
    echo "Select a point from 1 to" ${implNum}"!"
    read selection
    if [[ ${selection} -gt 0 && ${selection} -lt ${implNum}+1 ]]
    then
        echo "Design point number" ${selection} "was chosen."
    else
        echo "Wrong selection number was chosen."
        exit 1
    fi
elif [ $3 == "b" ]  # Random selection
then
    selection=$(( $RANDOM % ${implNum} + 1 ))
    echo "Design point number" ${selection} "was randomly chosen."
elif [ $3 == "c" ]  # Print out all implementations 
#NOTE implementation is redundant to the extraction part at the end of this document
# it would be better to call it as a function -> maybe switch to Python
then
    for ((i=1; i<=${implNum}; i++))
    do
        output=$(echo $2 | sed s/.lp/$i.lp/)
        line=$(( $(grep -n -w "Answer $i" $1 | cut -d : -f 1) + 1))
        sed -n ${line}p $1 > ${RESULT}/selectHelper1.txt
        cat ${RESULT}/selectHelper1.txt | cut -d $'\t' -f 2- | cut -d } -f 1 > ${RESULT}/selectHelper2.txt
        cat ${RESULT}/selectHelper2.txt | sed 's/ /.\n/g' > ${output}
        sed -i '$ s/$/./' ${output}
 
        echo "Selected implementation saved in" ${output}
    done
    echo "All implementations are stored."
    exit 1
else
    echo "Second input parameter is wrong."
    exit 1
fi

# Get the implementation from the chosen design point (by use of selectHelper1.txt, selectHelper2.txt)
# Extract the decisions about allocation, binding and routing
line=$(( $(grep -n -w "Answer ${selection}" $1 | cut -d : -f 1) + 1))
sed -n ${line}p $1 > ${RESULT}/selectHelper1.txt
cat ${RESULT}/selectHelper1.txt | cut -d $'\t' -f 2- | cut -d } -f 1 > ${RESULT}/selectHelper2.txt
cat ${RESULT}/selectHelper2.txt | sed 's/ /.\n/g' > $2
sed -i '$ s/$/./' $2

echo "Selected implementation saved in" $2
