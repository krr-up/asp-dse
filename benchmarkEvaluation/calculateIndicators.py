# This script calculates the hamming similarity and the epsilon dominance for each answer in each DSE run (each answer per case and instance)

import os
import subprocess
from natsort import natsorted

BIN_CLINGO_DIR = '/home/lum/miniconda3/envs/dse_env/bin/'
BIN_CLINGO = 'clingo '
CLINGO_ARGUMENTS = '../heuristic/hamming.lp ../heuristic/compareImplementation.lp ../heuristic/constants.lp '

TEMP_DIR = './temp'
OUTPUT_BASE_DIR = './results'
OUTPUT_FILE_NAME = 'results.txt'
INPUT_BASE_DIR = './output_asp-dse-ed/asp-dse-child/hpc/results/asp-dse-child'
INPUT_FILE_NAME = 'runsolver.solver'
BENCHMARK_FILE_DIR = '../instances/benchmarkInstances'
BENCHMARK_LEGACY_SPECIFICATION = BENCHMARK_FILE_DIR + '/parent/specification'
BENCHMARK_LEGACY_IMPLEMENTATION = BENCHMARK_FILE_DIR + '/parent/legacy_solution'
BENCHMARK_CHILD_SPECIFICATION = BENCHMARK_FILE_DIR + '/child/specification/1_20_20'
BENCHMARK_CHILD_IMPLEMENTATION = TEMP_DIR + '/answer.lp'

SEARCH_DATA_STRING = 'Answer: '
SEARCH_HAMMING_STRING = 'hamming('
SEARCH_TIME_STRING = 'found after '

TIME_STRING = 'time'
EPSILON_STRING = 'epsilon'
HAMMING_OUT_STRING1 = 'hammingTotal'
HAMMING_OUT_STRING2 = 'hammingBinding'
HAMMING_OUT_STRING3 = 'hammingRouting'
HAMMING_OUT_STRING4 = 'hammingTotalAdapted'
HAMMING_OUT_STRING5 = 'hammingBindingAdapted'
HAMMING_OUT_STRING6 = 'hammingRoutingAdapted'
HAMMING_SEARCH_STRING2 = 'hammingBindingDistance('
HAMMING_SEARCH_STRING3 = 'hammingRoutingDistance('
HAMMING_SEARCH_STRING5 = 'hammingBindingDistanceAdapted'
HAMMING_SEARCH_STRING6 = 'hammingRoutingDistanceAdapted'
HAMMING_SEARCH_STRING7 = 'numberMap'
HAMMING_SEARCH_STRING8 = 'numberLinksComm'

END_STRING = 'Pareto front'

def calculate_hamming(numberChanges, numberDecisions):
    if numberChanges==-1 or numberDecisions==-1:
        hamming = -1
    else:
        hamming = 1 - numberChanges / numberDecisions

    return hamming

def parse_hamming_data(inputData):
    content = []
    numberChangesBinding = -1
    numberChangesBindingAdapted = -1
    numberChangesRouting = -1
    numberChangesRoutingAdapted = -1
    numberDecisionsMap = -1
    numberDecisionsLinksComm = -1


    lines = inputData.split('\n')
    for line in lines:
        # Extract hamming values (distance and number of all decisions)
        if HAMMING_SEARCH_STRING2 in line:
            terms = line.split(' ')
            for term in terms:
                if HAMMING_SEARCH_STRING2 in term:
                    try:
                        numberChangesBinding = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberChangesBinding = '-1'  # Error parsing
            for term in terms:
                if HAMMING_SEARCH_STRING3 in term:
                    try:
                        numberChangesRouting = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberChangesRouting = '-1'  # Error parsing
            for term in terms:
                if HAMMING_SEARCH_STRING5 in term:
                    try:
                        numberChangesBindingAdapted = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberChangesBindingAdapted = '-1'  # Error parsing
            for term in terms:
                if HAMMING_SEARCH_STRING6 in term:
                    try:
                        numberChangesRoutingAdapted = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberChangesRoutingAdapted = '-1'  # Error parsing
            for term in terms:
                if HAMMING_SEARCH_STRING7 in term:
                    try:
                        numberDecisionsMap = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberDecisionsMap = '-1'  # Error parsing
            for term in terms:
                if HAMMING_SEARCH_STRING8 in term:
                    try:
                        numberDecisionsLinksComm = int(term.split('(')[1].split(')')[0])
                    except ValueError:
                        numberDecisionsLinksComm = '-1'  # Error parsing

            # Calculate hammingTotal
            content.append(calculate_hamming(numberChangesBinding+numberChangesRouting, numberDecisionsMap+numberDecisionsLinksComm))
            # Calculate hammingBind
            content.append(calculate_hamming(numberChangesBinding, numberDecisionsMap))
            # Calculate hammingRouting
            content.append(calculate_hamming(numberChangesRouting, numberDecisionsLinksComm))
            # Calculate hammingTotalAdapted
            content.append(calculate_hamming(numberChangesBindingAdapted+numberChangesRoutingAdapted, numberDecisionsMap+numberDecisionsLinksComm))
            # Calculate hammingBindAdapted
            content.append(calculate_hamming(numberChangesBindingAdapted, numberDecisionsMap))
            # Calculate hammingRoutingAdapted
            content.append(calculate_hamming(numberChangesRoutingAdapted, numberDecisionsLinksComm))

    return content


def parse_solution_no_line(line):
    terms = line.split(' ')
    try:
        solution_no = int(terms[1])
    except ValueError:
        return -1  # Error parsing solution_no
    return solution_no


def parse_time_line(line):
    terms = line.split(' ')
    instance = terms[1]
    time = terms[4]

    try:
        float(time)
    except ValueError:
        return [-1, "-1"] # Error parsing time

    if not instance.isnumeric(): # Error parsing instance number
        return [-1, "-1"]

    return [int(instance), time]


def translate_solution_line_to_ASP(line):
    line = line.replace("\n", ".\n")
    line = line.replace(" ", ".\n")
    return line

            
def analyze_result_quality(instance, case, inputFilePath):

    instance = instance.split('.')[0]  # The output instance file name in the folder structure does not contain the '.lp', remove it
    outputFilePath = OUTPUT_BASE_DIR + '/' + instance + '/' + case + '/' + OUTPUT_FILE_NAME
    solutions = []
    # Set paths to specification and implementation of child and legacy configuration
    childSpecificationFile = BENCHMARK_CHILD_SPECIFICATION + '/' + instance + '_m0.lp '
    legacySpecificationFile = BENCHMARK_LEGACY_SPECIFICATION + '/' + instance + '.lp '
    legacyImplementationFile = BENCHMARK_LEGACY_IMPLEMENTATION + '/' + instance + '.lp '

    with open(inputFilePath, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        with open(outputFilePath, 'w') as outputFile:
            if outputFile.closed:
                print("file can not be opened: " + outputFilePath)
                return

            # Write header of the file
            outputFile.write(TIME_STRING + ' ' + HAMMING_OUT_STRING1 + ' ' + HAMMING_OUT_STRING2 + ' ' + HAMMING_OUT_STRING3 + ' ' + HAMMING_OUT_STRING4 + ' ' + HAMMING_OUT_STRING5 + ' ' + HAMMING_OUT_STRING6 + ' ' + EPSILON_STRING + '\n')

            for line in inputFile:
                solutionNumber = -1
                HammingData = -1
                solutionTime = -1

                ## Extract data from output file of the DSE ##

                # Starting point for time stamp extracting of each answer
                if SEARCH_TIME_STRING in line:
                    [solutionNumber, solutionTime] = parse_time_line(line)
                    if solutionNumber == -1 or solutionTime == "-1":
                        print("Warning, unexpected value in :" + inputFilePath)

                # Check if line contains an answer (relevant data)
                elif SEARCH_DATA_STRING in line:
                    solutionNumber = parse_solution_no_line(line)
                    if solutionNumber == -1:
                        print("Warning, unexpected value in :" + inputFilePath)
                        continue

                    clingo_line = translate_solution_line_to_ASP(next(inputFile))

                    with open(BENCHMARK_CHILD_IMPLEMENTATION, 'w') as clingoFile:
                        if clingoFile.closed:
                            print("file can not be opened: " + BENCHMARK_CHILD_IMPLEMENTATION)
                            return
                        clingoFile.write(clingo_line)

                    # Call clingo to calculate Hamming distance
                    result = subprocess.run(BIN_CLINGO_DIR + BIN_CLINGO + CLINGO_ARGUMENTS + BENCHMARK_CHILD_IMPLEMENTATION + " " + childSpecificationFile + legacySpecificationFile + legacyImplementationFile, shell=True, capture_output=True, text=True)
                    HammingData = parse_hamming_data(result.stdout)
                    print(result.stdout)
                    print(HammingData)
                    if HammingData[0] == '-1':
                        print("Warning, unexpected hamming value for :" + inputFilePath)


                elif END_STRING in line:
                    break

                # Store the values in the list "solutions"
                # TODO Is this part working properly? Or is always written the same data?
                if solutionNumber != -1:
                    while len(solutions) < int(solutionNumber):
                        solutions.append(["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"])

                    if solutionTime != -1:
                        solutions[solutionNumber - 1][0] = solutionTime

                    if HammingData != -1:
                        solutions[solutionNumber - 1][1] = HammingData[0]
                        solutions[solutionNumber - 1][2] = HammingData[1]
                        solutions[solutionNumber - 1][3] = HammingData[2]
                        solutions[solutionNumber - 1][4] = HammingData[3]
                        solutions[solutionNumber - 1][5] = HammingData[4]
                        solutions[solutionNumber - 1][6] = HammingData[5]
                    
                    #TODO if epsilon

            # When all solutions have been read, print them on the file
            for solution in solutions:
                outputFile.write(str(solution[0]) + ' ' + str(solution[1]) + ' ' + str(solution[2]) + ' ' + str(solution[3]) + ' ' + str(solution[4]) + ' ' + str(solution[5]) + ' ' + str(solution[6]) + '\n')

def main():

    if not os.path.exists(TEMP_DIR):
        os.makedirs(TEMP_DIR)

    cases = {entry.name for entry in os.scandir(INPUT_BASE_DIR) if entry.is_dir}
    cases = natsorted(cases)

    for case in cases:
        instancesPath = INPUT_BASE_DIR + '/' + case
        instances = { entry.name for entry in os.scandir(instancesPath) if entry.is_dir}
        instances = natsorted(instances)

        for instance in instances:
            filePath = instancesPath + '/' + instance + "/run1/" + INPUT_FILE_NAME
            analyze_result_quality(instance, case, filePath)

    exit(0)


if __name__ == '__main__':
    main()