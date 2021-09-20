# This script takes two parameters: An input file ($1) and an output file ($2)
# From the input file (containing the output of a dse) the Pareto front is extracted
# and written into the output file

# Save the Pareto optimal front
line=$(grep -n 'Pareto front:' $1 | cut -d : -f 1)
if [ -z "$line" ]
then
    line=$(grep -n 'Search interrupted: Approximate Pareto front:' $1 | cut -d : -f 1)
fi
lowerBound=$(( ${line}+1 ))
sed -n ${lowerBound},'$p' $1 > $2

echo "Pareto-optimal front from" $1 "was saved in" $2
