# From experimental results, this script is extracting all design points (cost, latency, energy for each answer) and the corresponding timestamps
# These information are stored in files where the script calculateIndicators.py is expecting them

import os
from natsort import natsorted

OUTPUT_BASE_DIR = './results'
OUTPUT_FILE_NAME = 'designPoints.txt'
INPUT_BASE_DIR = './output_asp-dse-ed/asp-dse-child/hpc/results/asp-dse-child'
INPUT_FILE_NAME = 'runsolver.solver'

SEARCH_DATA_STRING = 'Answer: '
SEARCH_SOLUTION_STRING = 'pref('
SEARCH_TIME_STRING = 'found after'
LATENCY_STRING = 'latency'
ENERGY_STRING = 'energy'
COST_STRING = 'cost'
TIME_STRING = 'time'
END_STRING = 'Pareto front'


def get_data_from_string(string):
    content = string.split('(')[1].split(')')[0]  # Keep only content within brackets.
    content = content.split(',')[2]
    try:
        int(content)
    except :
        return "-1"  # Error parsing time
    return str(int(content))


def parse_solution_n_line(line):
    terms = line.split(' ')
    try:
        time = int(terms[1])
    except ValueError:
        return -1  # Error parsing time
    return time


def parse_solution_line(line):
    terms = line.split(' ')
    latency = -1
    energy = -1
    cost = -1

    for term in terms:
        if LATENCY_STRING in term:
            latency = get_data_from_string(term)
        if ENERGY_STRING in term:
            energy = get_data_from_string(term)
        if COST_STRING in term:
            cost = get_data_from_string(term)
    return [latency, energy, cost]


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

    return [int(instance), str(float(time))]

            
def write_result_info(instance, case, inputFilePath):

    instance = instance.split('.')[0]  # The output instance file name in the folder structure does not contain the '.lp', remove it
    outputFilePath = OUTPUT_BASE_DIR + '/' + instance + '/' + case + '/' + OUTPUT_FILE_NAME
    # solutions [ cost, latency, energy, time ]
    solutions = []

    with open(inputFilePath, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        with open(outputFilePath, 'w') as outputFile:
            if outputFile.closed:
                print("file can not be opened: " + outputFilePath )
                return

            # Write header of the file
            outputFile.write(TIME_STRING + ' ' + COST_STRING + ' ' + LATENCY_STRING + ' ' + ENERGY_STRING + '\n')

            for line in inputFile:
                solutionNumber = -1
                solutionData = -1
                solutionTime = -1

                ## Extract data from output file of the DSE ##
                # Check if line contains an answer (relevant data)
                if SEARCH_DATA_STRING in line:  
                    solutionNumber = parse_solution_n_line(line)
                    solutionData = parse_solution_line(next(inputFile))
                    if solutionNumber == -1 or solutionTime == "-1":
                        print("Warning, unexpected value in :" + inputFilePath)
                        continue

                # Starting point for time stamp extracting of each answer
                elif SEARCH_TIME_STRING in line: 
                    [solutionNumber, solutionTime] = parse_time_line(line)
                    if solutionNumber == -1:
                        print("Warning, unexpected value in :" + inputFilePath)
                        continue

                elif END_STRING in line:
                    break

                # Store the values in the list "solutions"
                if solutionNumber != -1:
                    while len(solutions) < int(solutionNumber):
                        solutions.append(["-1", "-1", "-1", "-1"])

                    if solutionData != -1:
                        solutions[solutionNumber - 1][1] = solutionData[0]
                        solutions[solutionNumber - 1][2] = solutionData[1]
                        solutions[solutionNumber - 1][3] = solutionData[2]

                    if solutionTime != -1:
                        solutions[solutionNumber - 1][0] = solutionTime

            # When all solutions have been read, print them on the file
            for solution in solutions:
                outputFile.write(solution[0] + ' ' + solution[1] + ' ' + solution[2] + ' ' + solution[3] + '\n')

def main():
    
    cases = {entry.name for entry in os.scandir(INPUT_BASE_DIR) if entry.is_dir}
    cases = natsorted(cases)
    for case in cases:
        instancesPath = INPUT_BASE_DIR + '/' + case
        instances = { entry.name for entry in os.scandir(instancesPath) if entry.is_dir}
        instances = natsorted(instances)

        for instance in instances:
            filePath = instancesPath + '/' + instance + "/run1/" + INPUT_FILE_NAME
            write_result_info(instance, case, filePath)

    exit(0)


if __name__ == '__main__':
    main()