# This script calculates the hamming similarity and the epsilon dominance for each answer in each DSE run (each answer per case and instance)

import os
import re
import sys
import subprocess
import time
from natsort import natsorted
import ctypes

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
SEARCH_TIME_STRING = 'found after '

SOLUTION_STRING = 'solution'
TIME_STRING = 'time'
EPSILON_STRING1 = 'epsilonSmallerOne'
EPSILON_STRING2 = 'epsilonLargerOne'
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

class ARRAY(ctypes.Structure):
        _fields_ = [("length", ctypes.c_int), ("content", ctypes.POINTER(ctypes.POINTER(ctypes.c_double)))]

# Call C++ functionality as a library
cppLib = ctypes.cdll.LoadLibrary('./qualityIndicators/epsilonDominance.so')

# Returns hamming distance as a normalized value (between 0 and 1)
def calculate_hamming(numberChanges, numberDecisions):
    if numberChanges==-1 or numberDecisions==-1:
        hamming = -1
    else:
        hamming = 1 - numberChanges / numberDecisions

    return hamming


def parse_data(inputLine):
    terms = inputLine.split(' ')
    for i in range(len(terms)):
        if "\n" in terms[i]:
            terms[i] = terms[i].replace('\n', '')

    return terms


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
    answerNumber = terms[1]
    time = terms[4]

    try:
        float(time)
    except ValueError:
        return [-1, "-1"] # Error parsing time

    if not answerNumber.isnumeric(): # Error parsing answer number
        return [-1, "-1"]

    return [int(answerNumber), time]


def translate_solution_line_to_ASP(line):
    line = line.replace("\n", ".\n")
    line = line.replace(" ", ".\n")

    return line

            
def prepare_and_output_hamming(instance, case, inputFilePath):

    # Remove '.lp' from instance file name
    instance = instance.split('.')[0]
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
            outputFile.write(SOLUTION_STRING + ' ' + TIME_STRING + ' ' + HAMMING_OUT_STRING1 + ' ' + HAMMING_OUT_STRING2 + ' ' + HAMMING_OUT_STRING3 + ' ' + HAMMING_OUT_STRING4 + ' ' + HAMMING_OUT_STRING5 + ' ' + HAMMING_OUT_STRING6 + ' ' + EPSILON_STRING1 + ' ' + EPSILON_STRING2 + '\n')

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

                # Check if line contains an answer (relevant data for calculation of hamming distance) 
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
                    if HammingData[0] == '-1':
                        print("Warning, unexpected hamming value for :" + inputFilePath)

                elif END_STRING in line:
                    break

                # Store the values in the list "solutions"
                if solutionNumber != -1:
                    while len(solutions) < int(solutionNumber):
                        solutions.append([solutionNumber, "-1", "-1", "-1", "-1", "-1", "-1", "-1"])

                    solutions[solutionNumber - 1][0] = solutionNumber

                    if solutionTime != -1:
                        solutions[solutionNumber - 1][1] = solutionTime

                    if HammingData != -1:
                        solutions[solutionNumber - 1][2] = HammingData[0]
                        solutions[solutionNumber - 1][3] = HammingData[1]
                        solutions[solutionNumber - 1][4] = HammingData[2]
                        solutions[solutionNumber - 1][5] = HammingData[3]
                        solutions[solutionNumber - 1][6] = HammingData[4]
                        solutions[solutionNumber - 1][7] = HammingData[5]

            # When all solutions have been read, print them to the output file
            for solution in solutions:
                outputFile.write(str(solution[0]) + ' ' + str(solution[1]) + ' ' + str(solution[2]) + ' ' + str(solution[3]) + ' ' + str(solution[4]) + ' ' + str(solution[5]) + ' ' + str(solution[6]) + ' ' + str(solution[7]) + '\n')


def get_pareto_front(inputPath):
    # Prepare usage of function from C++ library
    cppLib.initializeVector.restype = ARRAY
    referenceFrontArray = cppLib.initializeVector(bytes(inputPath, 'utf-8'))

    print("Received reference front")
    for i in range(referenceFrontArray.length):
            print(str(referenceFrontArray.content[i][0]) + " " + str(referenceFrontArray.content[i][1]) + " " + str(referenceFrontArray.content[i][2]))

    return referenceFrontArray


def calculate_and_output_epsilon_dominance(inputPath, referenceFront):
    epsilonSmallerOne = -1.0
    epsilonLargerOne = -1.0

    solutionNumber = -1
    solutionTime = -1.0
    solutionDesignPoint = []
    resultDictionary = {}

    inputFilePath = inputPath + "/designPoints.txt"
    outputFilePath = inputPath + "/results.txt"

    with open(inputFilePath, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        # Read values of each design point from input file
        for line in inputFile:
            # Skip first line in file
            if SOLUTION_STRING in line:
                continue
            # Get data per entry in file
            terms = parse_data(line)
            solutionNumber = terms[0]
            solutionTime = terms[1]

            # Extent list of design points step by step
            # Every list element is an array with 3 ctypes.c_double values
            solutionDesignPoint.append( (ctypes.c_double * 3)() )
            solutionDesignPoint[-1][0] = ctypes.c_double(float(terms[2]))
            solutionDesignPoint[-1][1] = ctypes.c_double(float(terms[3]))
            solutionDesignPoint[-1][2] = ctypes.c_double(float(terms[4]))

            # Prepare approximatedFrontArray, which is input to epsilon dominance calculation
            # approximatedFront is an array where each element is a pointer to one design point (array of 3 ctypes.c_double values)
            # Casting is needed to remove information of length of array from pointer type and to only receive pointer to first element of array  
            approximatedFront = (ctypes.POINTER(ctypes.c_double)*len(solutionDesignPoint))()
            for i in range(len(solutionDesignPoint)):
                solutionDesignPointPointer = ctypes.pointer(solutionDesignPoint[i])
                solutionDesignPointPointer = ctypes.cast(solutionDesignPointPointer,ctypes.POINTER(ctypes.c_double))
                approximatedFront[i] = solutionDesignPointPointer
            # approximatedFrontPointer is a pointer to the first element of the array approximatedFront
            approximatedFrontPointer = ctypes.pointer(approximatedFront)
            approximatedFrontPointer = ctypes.cast(approximatedFrontPointer,ctypes.POINTER(ctypes.POINTER(ctypes.c_double)))

            # Build approximatedFrontArray
            approximatedFrontArray = ARRAY()
            approximatedFrontArray.length = ctypes.c_int(len(approximatedFront))
            approximatedFrontArray.content = approximatedFrontPointer

            # Calculate two kind of epsilon dominance: I(Pareto,Approximation) < 1 and I(Approximation,Pareto) > 1
            cppLib.epsilonDominance.argtypes = (ARRAY,ARRAY)
            cppLib.epsilonDominance.restype = ctypes.c_double
            epsilonSmallerOne = cppLib.epsilonDominance(referenceFront,approximatedFrontArray)
            epsilonLargerOne = cppLib.epsilonDominance(approximatedFrontArray,referenceFront)

            # Save result connected to solutionNumber
            resultDictionary[solutionNumber] = [epsilonSmallerOne, epsilonLargerOne]

    # Read from output file and add values of new results (2x epsilon dominance) to each line (regarding the solutionNumber)
    lines = []
    with open(outputFilePath, 'r') as outputFile:
        if outputFile.closed:
            print("file can not be opened: " + outputFilePath)
            return
        for line in outputFile:
            # Skip first line in file
            if SOLUTION_STRING in line:
                lines.append(line)
                continue
            terms = parse_data(line)
            line = ""
            # Skip the last values, because they are exchanged with the new values
            # Nicer way: range(len(terms)) (when script started from scratch) or range(len(terms)-2) (when epsilon dominance values have been already written to output file in a previous run)
            for i in range(8):
                line = line + str(terms[i]) + " "
            line = line + str(resultDictionary[terms[0]][0]) + " " + str(resultDictionary[terms[0]][1]) + "\n"
            lines.append(line)

    # Write adapted content to output file
    with open(outputFilePath, 'w') as outputFile:
        if outputFile.closed:
            print("file can not be opened: " + outputFilePath)
            return
        for line in lines:
            outputFile.write(line)


def main():

    if not os.path.exists(TEMP_DIR):
        os.makedirs(TEMP_DIR)
    time.gmtime(0)

    # Calculation of the hamming distance
    timeStart = time.time()
    cases = {entry.name for entry in os.scandir(INPUT_BASE_DIR) if entry.is_dir()}
    cases = natsorted(cases)

    for case in cases:
        instancesPath = INPUT_BASE_DIR + '/' + case
        instances = { entry.name for entry in os.scandir(instancesPath) if entry.is_dir()}
        instances = natsorted(instances)

        for instance in instances:
            filePath = instancesPath + '/' + instance + "/run1/" + INPUT_FILE_NAME
            prepare_and_output_hamming(instance, case, filePath)
    timeEnd = time.time()
    print("Calculation of Hamming similarity took " + str(timeEnd - timeStart) + "s")

    # Calculation of the epsilon dominance
    timeStart = time.time()

    instances = {entry.name for entry in os.scandir(OUTPUT_BASE_DIR) if entry.is_dir()}
    instances = natsorted(instances)

    for instance in instances:
        if instance != "mdfiles":
            casesPath = OUTPUT_BASE_DIR + '/' + instance
            cases = { entry.name for entry in os.scandir(casesPath) if entry.is_dir()}
            cases = natsorted(cases)

            # Get the Pareto front from all design points of all cases
            referenceFront = get_pareto_front(casesPath)

            for case in cases:
                calculate_and_output_epsilon_dominance(casesPath + "/" + case, referenceFront) 

            # Free the memory used by C++ library
            cppLib.freeVector(referenceFront)
        
    timeEnd = time.time()
    print("Calculation of Epsilon similarity took " + str(timeEnd - timeStart) + "s")

    exit(0)


if __name__ == '__main__':
    main()