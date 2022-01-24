# This script has one parameter to choose which version to run
# Choose options:
#   a   Parent example
#   b   Child (modified parent) example without heuristics
#   c   Child (modified parent) example with heuristics

BASE_DIR="${PWD}"
RUNSOLVER="${BASE_DIR}/../Tools/runsolver-3.4.0/src"
RESULT="${BASE_DIR}/results"
HEURISTIC="${BASE_DIR}/heuristic"
SCRIPT="${BASE_DIR}/postprocessing"
SPECIFICATION="${BASE_DIR}/instances/specification"
FRONT="${BASE_DIR}/instances/front"
IMPLEMENTATION="${BASE_DIR}/instances/implementation"

# Set time limit for dse in s
time_limit=10
# Set random seed
RANDOM=3337

# Activate right miniconda environment 
#conda activate dse_env

# Parent example
if [ $1 == "a" ]
then
    echo "Option a: Parent example"
    ${RUNSOLVER}/runsolver --timestamp -C ${time_limit} -o ${RESULT}/dseOutput1.txt python src/dseApp.py encodings/encoding_xyz.lp encodings/priorities.lp ${SPECIFICATION}/testParent.lp encodings/preferences.lp -q --dse-mode=breadth 0

    if [[ -f "${RESULT}/dseOutput1.txt" ]]
    then
        # Extract front from dse output
        > ${FRONT}/testParent.lp
        ${SCRIPT}/getFront.sh ${RESULT}/dseOutput1.txt ${FRONT}/testParent.lp

        # Select randomly an implementation from front
        > ${IMPLEMENTATION}/testParent.lp
        ${SCRIPT}/selectImpl.sh ${FRONT}/testParent.lp ${IMPLEMENTATION}/testParent.lp a # b ${RANDOM}

        # Set implementation as legacy
        > ${IMPLEMENTATION}/testLegacy.lp
        clingo ${SCRIPT}/setLegacyImplementation.lp ${SPECIFICATION}/testParent.lp ${IMPLEMENTATION}/testParent.lp --out-ifs="\n" --out-atomf=%s. | grep "legacy" > ${IMPLEMENTATION}/testLegacy.lp

        # Set specification as legacy
        > ${SPECIFICATION}/testLegacy.lp
        clingo ${SCRIPT}/setLegacySpecification.lp ${SPECIFICATION}/testParent.lp --out-ifs="\n" --out-atomf=%s. | grep "legacy" > ${SPECIFICATION}/testLegacy.lp

        echo "Legacy configuration saved in ${SPECIFICATION}/testLegacy.lp and ${IMPLEMENTATION}/testLegacy.lp"
    else
        echo "${RESULT}/dseOutput1.txt does not exist"
        exit 1
    fi

# Child example without heuristics
elif [ $1 == "b" ]
then
    echo "Option b: Child example without heuristics"
    ${RUNSOLVER}/runsolver --timestamp -C ${time_limit} -o ${RESULT}/dseOutput1.txt python src/dseApp.py encodings/encoding_hop_arb.lp encodings/priorities.lp ${SPECIFICATION}/testChild.lp encodings/preferences.lp --dse-mode=breadth 0

    if [[ -f "${RESULT}/dseOutput1.txt" ]]
    then
        # Extract front from dse output
        > ${FRONT}/testChild.lp
        ${SCRIPT}/getFront.sh ${RESULT}/dseOutput1.txt ${FRONT}/testChild.lp
    else
        echo "${RESULT}/dseOutput1.txt does not exist"
        exit 1
    fi

# Child example with heuristics
elif [ $1 == "c" ]
then
    echo "Option c: Child example with heuristics"
    ${RUNSOLVER}/runsolver --timestamp -C ${time_limit} -o ${RESULT}/dseOutput1.txt python src/dseApp.py ${HEURISTIC}/constants.lp -c heuristicValue=20 encodings/encoding_hop_arb.lp encodings/priorities.lp ${SPECIFICATION}/testChild2.lp ${SPECIFICATION}/testLegacy.lp ${IMPLEMENTATION}/testLegacy.lp encodings/preferences.lp ${HEURISTIC}/compareSpecification.lp ${HEURISTIC}/compareImplementation.lp ${HEURISTIC}/strategy1.lp  --heuristic=Domain --dse-mode=breadth 0 #--stats # runsolver --use-pty

# ${HEURISTIC}/compareImplementation.lp

else
    echo "Wrong input"
fi
