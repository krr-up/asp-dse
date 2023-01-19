# This script evaluates the results from the DSE runs.
# Per each instance, for different criteria the script ranks all cases
# For each case for each criteria over all instances the arithmetic mean of ranking is calculated

import os
from natsort import natsorted

WORKDIR = './results'
OUTPUT_FILE = './results/mdfiles/ranks.md'
OUTPUT_FILE_2 = './results/mdfiles/ranksAveraged.md'
OUTPUT_FILE_3 = './results/mdfiles/ranksAveragedOrdered.md'

wcMaximization = "0"
wcMinimization = "900" # This is the timeout

class Results():
    def __init__(self):
        self.timeFirstSolution_ = []
        self.completeSearchTime_ = []
        self.hammingTotal_ = []
        self.hammingTotalFirst_ = []
        self.hammingBinding_ = []
        self.hammingBindingFirst_ = []
        self.hammingRouting_ = []
        self.hammingRoutingFirst_ = []
        self.epsilon_ = []
        self.epsilonFirst_ = []
        self.epsilonFirstReachOne_ = []
        self.relation_ = []
        self.relationFirst_ = []

    def empty(self):
        isEmpty = (self.timeFirstSolution_ == [] or
        self.completeSearchTime_ == [] or
        self.hammingTotal_ == [] or
        self.hammingTotalFirst_ == [] or
        self.hammingBinding_ == [] or
        self.hammingBindingFirst_ == [] or
        self.hammingRouting_ == [] or
        self.hammingRoutingFirst_ == [] or
        self.epsilon_ == [] or
        self.epsilonFirst_ == [] or
        self.relation_ == [] or
        self.relationFirst_ == [])
        if isEmpty == 1:
            print("warning, empty instance")
        return isEmpty


    # Add to list the best (maximum) value for each case
    def buildMaxList(self, values, candidateValue, candidateCase):
        # Initialize list, if empty so far
        if(len(values) == 0):
            values.append([candidateValue, candidateCase])
            return # look for the next value
        # If answer is valid
        if(candidateValue  != '-1'):
            for value in values:
                # If that case is already in the list for another design point
                if value[1] == candidateCase:
                    # Replace value in list, if candidateValue is better
                    if float(value[0]) < float(candidateValue):
                        value[0] = candidateValue
                    return # look for the next value
        
            values.append([candidateValue, candidateCase])
            return # look for the next value


    # Add to list the best value (minimum) for each case
    def buildMinList(self, values, candidateValue, candidateCase):
        # Initialize list, if empty so far
        if(len(values) == 0):
            values.append([candidateValue, candidateCase])
            return # look for the next value
        # If answer is valid
        if(candidateValue  != '-1'):
            for value in values:
                # If that case is already in the list for another design point
                if value[1] == candidateCase:
                    # Replace value in list, if candidateValue is better
                    if float(value[0]) > float(candidateValue):
                        value[0] = candidateValue
                    return # look for the next value
                
            values.append([candidateValue, candidateCase])
            return # look for the next value


    # Order list descending
    def maximizedRanks(self, values):
        def SortFun(e):
            return float(e[0])

        values.sort(reverse = True, key=SortFun)


    # Order list ascending
    def minimizedRanks(self, values):    
        def SortFun(e):
            return float(e[0])

        values.sort(key=SortFun)
                    
            
    def bestRelation(self, candidateEpsilon, candidateHamming, candidateCase):
        self.buildMaxList(self.relation_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)

    def bestRelationFirst(self, candidateEpsilon, candidateHamming, candidateCase):
        self.buildMaxList(self.relationFirst_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)
        

# Function to format a line with multiple results
# Additionally the directories are updated
def formatOutputMultiple(text, results, dictionary, outputfile):
    rank = 0
    outputfile.write(text)
    for i in range(len(results)):
        # First element has rank 1
        if i == 0:
            rank = 1
        # The rank is only updated if values of results differ
        elif float(results[i-1][0]) != float(results[i][0]):
            rank = i + 1

        outputfile.write('**' + str(rank) + '.** ' + results[i][0] + ' ' + results[i][1] + '  \n')
        key = results[i][1]
        updateDictionaryMultiple(dictionary, key, rank)


# Function to format multiple lines output
def formatOutputNEntries(text, results, outputfile):
    outputfile.write(text)
    for i in range(len(results)):
        outputfile.write(results[i][0] + ' ' + results[i][1] + '  \n')


# Try to access case in dictionary, if there is no such key, initialize it
# Record the ranks (value) for each case (key)
def updateDictionaryMultiple(dictionary, key, rank):
    if rank != 0 :
        try: 
            dictionary[key] = dictionary[key] + rank
        except:
            dictionary[key] = rank
    else:
        print("Exception: Rank is 0")

# Function to format dictionary output
def outputDictionary(dictionary, numInstances, outputfile):
    outputfile.write('|Case|Average Rank||\n')
    outputfile.write('|:---:|:---:|:---:|\n')
    for i in sorted(dictionary) :
        outputfile.write('|' + i + '|' + str(dictionary[i]/numInstances) + '|    |\n')


# Function to format dictionary output (ordered by the values)
def outputDictionaryOrdered(dictionary, numInstances, outputfile):
    outputfile.write('|Case|Average Rank||\n')
    outputfile.write('|:---:|:---:|:---:|\n')
    for i in sorted(dictionary, key=dictionary.get) :
        if i == "asp-dse-ed-v1.0.0-xyz-n1" or i == "asp-dse-ed-v1.0.0-bound-n1" or i == "asp-dse-ed-v1.0.0-arb-n1" :
            outputfile.write('|' + "<span style=\"color: red;\">" + i + "</span>" + '|' + str(dictionary[i]/numInstances) + '|    |\n')
        else:
            outputfile.write('|' + i + '|' + str(dictionary[i]/numInstances) + '|    |\n')


def main(workdir, outputfile): 
    instances = {entry.name for entry in os.scandir(workdir) if "." not in entry.name and "mdfiles" not in entry.name}
    instances = natsorted(instances)

    # Create dictionaries to count all occurrences of cases for each criteria
    dictionaryTimeFirstSolution = {}
    dictionaryCompleteSearchTime = {}
    dictionaryHammingTotalFirst = {}
    dictionaryHammingTotal = {}
    dictionaryHammingBindingFirst = {}
    dictionaryHammingBinding = {}
    dictionaryHammingRoutingFirst = {}
    dictionaryHammingRouting = {}
    dictionaryEpsilonFirst = {}
    dictionaryEpsilon = {}
    dictionaryEpsilonFirstReachOne = {}
    dictionaryRelationFirst = {}
    dictionaryRelation = {}

    with open(outputfile, 'w') as outputfile:
        for instance in instances:             
            # Evaluate results for certain instance
            filePath = workdir + '/' + instance
            # Search through all cases for best hamming and epsilon values
            results = evaluateResults(filePath)

            # For each entry in instances, compose a section in output file
            outputfile.write('\n\n####################################################################\n')
            outputfile.write('# ' + instance + '\n\n')
            filePath = workdir + '/' + instance

            if(results.empty()):
                continue

            # Write data (ranking list) to output file and record the occurring ranks (value) for each case (key) per criteria
            formatOutputMultiple('## First solution time\n', results.timeFirstSolution_, dictionaryTimeFirstSolution, outputfile)
            formatOutputMultiple('## Complete search time\n', results.completeSearchTime_, dictionaryCompleteSearchTime, outputfile)

            formatOutputMultiple('## Hamming total, only first solution\n', results.hammingTotalFirst_, dictionaryHammingTotalFirst, outputfile)
            formatOutputMultiple('## Hamming total \n', results.hammingTotal_, dictionaryHammingTotal, outputfile)

            formatOutputMultiple('## Hamming binding, only first solution\n', results.hammingBindingFirst_, dictionaryHammingBindingFirst, outputfile)
            formatOutputMultiple('## Hamming binding \n', results.hammingBinding_, dictionaryHammingBinding, outputfile)

            formatOutputMultiple('## Hamming routing, only first solution\n', results.hammingRoutingFirst_, dictionaryHammingRoutingFirst, outputfile)
            formatOutputMultiple('## Hamming routing \n', results.hammingRouting_, dictionaryHammingRouting, outputfile)

            formatOutputMultiple('## Epsilon dominance, only first solution\n', results.epsilonFirst_, dictionaryEpsilonFirst, outputfile)
            formatOutputMultiple('## Epsilon dominance\n', results.epsilon_, dictionaryEpsilon, outputfile)

            formatOutputMultiple('## Time Epsilon dominance = 1 has been reached first\n', results.epsilonFirstReachOne_, dictionaryEpsilonFirstReachOne, outputfile)

            formatOutputMultiple('## Epsilon-Hamming relation, only first solution\n', results.relationFirst_, dictionaryRelationFirst, outputfile)
            formatOutputMultiple('## Epsilon-Hamming relation\n', results.relation_, dictionaryRelation, outputfile)

    # Output averaged ranks per criteria ordered by their key
    numInstances = len(instances)
    with open(OUTPUT_FILE_2, 'w') as outputfile:
        outputfile.write('## First solution time\n')
        outputDictionary(dictionaryTimeFirstSolution, numInstances, outputfile)
        outputfile.write('## Complete search time\n')
        outputDictionary(dictionaryCompleteSearchTime, numInstances, outputfile)
        outputfile.write('## Hamming total, only first solution\n')
        outputDictionary(dictionaryHammingTotalFirst, numInstances, outputfile)
        outputfile.write('## Hamming total \n')
        outputDictionary(dictionaryHammingTotal, numInstances, outputfile)
        outputfile.write('## Hamming binding, only first solution\n')
        outputDictionary(dictionaryHammingBindingFirst, numInstances, outputfile)
        outputfile.write('## Hamming binding \n')
        outputDictionary(dictionaryHammingBinding, numInstances, outputfile)
        outputfile.write('## Hamming routing, only first solution\n')
        outputDictionary(dictionaryHammingRoutingFirst, numInstances, outputfile)
        outputfile.write('## Hamming routing \n')
        outputDictionary(dictionaryHammingRouting, numInstances, outputfile)
        outputfile.write('## Epsilon dominance, only first solution\n')
        outputDictionary(dictionaryEpsilonFirst, numInstances, outputfile)
        outputfile.write('## Epsilon dominance\n')
        outputDictionary(dictionaryEpsilon, numInstances, outputfile)
        outputfile.write('## Time Epsilon dominance = 1 has been reached first\n')
        outputDictionary(dictionaryEpsilonFirstReachOne, numInstances, outputfile)
        outputfile.write('## Epsilon-Hamming relation, only first solution\n')
        outputDictionary(dictionaryRelationFirst, numInstances, outputfile)
        outputfile.write('## Epsilon-Hamming relation\n')
        outputDictionary(dictionaryRelation, numInstances, outputfile)

    # Output averaged ranks per criteria ordered by their value
    with open(OUTPUT_FILE_3, 'w') as outputfile:
        outputfile.write('## First solution time\n')
        outputDictionaryOrdered(dictionaryTimeFirstSolution, numInstances, outputfile)
        outputfile.write('## Complete search time\n')
        outputDictionaryOrdered(dictionaryCompleteSearchTime, numInstances, outputfile)
        outputfile.write('## Hamming total, only first solution\n')
        outputDictionaryOrdered(dictionaryHammingTotalFirst, numInstances, outputfile)
        outputfile.write('## Hamming total \n')
        outputDictionaryOrdered(dictionaryHammingTotal, numInstances, outputfile)
        outputfile.write('## Hamming binding, only first solution\n')
        outputDictionaryOrdered(dictionaryHammingBindingFirst, numInstances, outputfile)
        outputfile.write('## Hamming binding \n')
        outputDictionaryOrdered(dictionaryHammingBinding, numInstances, outputfile)
        outputfile.write('## Hamming routing, only first solution\n')
        outputDictionaryOrdered(dictionaryHammingRoutingFirst, numInstances, outputfile)
        outputfile.write('## Hamming routing \n')
        outputDictionaryOrdered(dictionaryHammingRouting, numInstances, outputfile)
        outputfile.write('## Epsilon dominance, only first solution\n')
        outputDictionaryOrdered(dictionaryEpsilonFirst, numInstances, outputfile)
        outputfile.write('## Epsilon dominance\n')
        outputDictionaryOrdered(dictionaryEpsilon, numInstances, outputfile)
        outputfile.write('## Time Epsilon dominance = 1 has been reached first\n')
        outputDictionaryOrdered(dictionaryEpsilonFirstReachOne, numInstances, outputfile)
        outputfile.write('## Epsilon-Hamming relation, only first solution\n')
        outputDictionaryOrdered(dictionaryRelationFirst, numInstances, outputfile)
        outputfile.write('## Epsilon-Hamming relation\n')
        outputDictionaryOrdered(dictionaryRelation, numInstances, outputfile)


# Iterate through all cases to find best hamming distances and best epsilon dominance values
def evaluateResults(casesPath):
    result = Results()

    cases = { entry.name for entry in os.scandir(casesPath) if entry.is_dir()}
    cases = natsorted(cases)

    for case in cases:
        resultFilePath = casesPath + '/'+ case + "/results.txt"
        statFilePath = casesPath + '/'+ case + "/statInfo.txt"

        with open(statFilePath, 'r') as inputFile:
            if inputFile.closed:
                print("file can not be opened: " + statFilePath)
                return
            
            terms = inputFile.readline().split(' ')
            # Minimize time up to first solution has been found
            # If data invalid, set to worst case
            if terms[1] == "-1":
                result.buildMinList(result.timeFirstSolution_, wcMinimization, case)
            else:
                result.buildMinList(result.timeFirstSolution_, terms[1], case)
            # Minimize time to complete the search or Timeout as worst case
            result.buildMinList(result.completeSearchTime_, terms[2].rstrip(), case)

        with open(resultFilePath, 'r') as inputFile:
            if inputFile.closed:
                print("file can not be opened: " + resultFilePath)
                return

            # Skip the first line, where the header is
            inputFile.readline()
            line = inputFile.readline()
            terms = line.split(' ')

            # Invalid case, when no data is available
            # Set data to worst case
            if len(terms) == 1:
                result.buildMaxList(result.hammingTotalFirst_, wcMaximization, case)
                result.buildMaxList(result.hammingBindingFirst_, wcMaximization, case)
                result.buildMaxList(result.hammingRoutingFirst_, wcMaximization, case)
                result.buildMaxList(result.epsilonFirst_, wcMaximization, case)
                result.bestRelationFirst(wcMaximization, wcMaximization, case)
                result.buildMaxList(result.hammingTotal_, wcMaximization, case)
                result.buildMaxList(result.hammingBinding_, wcMaximization, case)
                result.buildMaxList(result.hammingRouting_, wcMaximization, case)
                result.buildMaxList(result.epsilon_, wcMaximization, case)
                result.buildMinList(result.epsilonFirstReachOne_, wcMinimization, case)
                result.bestRelation(wcMaximization, wcMaximization, case)

            if len(terms) == 10:
                # Maximize the value of each criteria for the first entry in the input file
                result.buildMaxList(result.hammingTotalFirst_, terms[2], case)
                result.buildMaxList(result.hammingBindingFirst_, terms[3], case)
                result.buildMaxList(result.hammingRoutingFirst_, terms[4], case)
                result.buildMaxList(result.epsilonFirst_, terms[8], case)
                result.bestRelationFirst(terms[2], terms[8], case)

            caseErrorSup = False
            for line in inputFile:
                terms = line.split(' ')
                if len(terms) != 10:
                    if not caseErrorSup:
                        caseErrorSup = True
                        print("warning, not enough arguments in file: " + resultFilePath)
                    continue

                # Maximize the value of each criteria for all entries in the input file
                result.buildMaxList(result.hammingTotal_, terms[2], case)
                result.buildMaxList(result.hammingBinding_, terms[3], case)
                result.buildMaxList(result.hammingRouting_, terms[4], case)
                result.buildMaxList(result.epsilon_, terms[8], case)
                
                # Get the minimum time per case when epsilon == 1.0 was reached
                if float(terms[8]) == 1.0 :
                    result.buildMinList(result.epsilonFirstReachOne_, terms[1], case)
                
                result.bestRelation(terms[2], terms[8], case)

    # Put ranking lists in correct order
    result.minimizedRanks(result.timeFirstSolution_)
    result.minimizedRanks(result.completeSearchTime_)
    result.maximizedRanks(result.hammingTotalFirst_)
    result.maximizedRanks(result.hammingBindingFirst_)
    result.maximizedRanks(result.hammingRoutingFirst_)
    result.maximizedRanks(result.epsilonFirst_)
    result.maximizedRanks(result.relationFirst_)
    result.maximizedRanks(result.hammingTotal_)
    result.maximizedRanks(result.hammingBinding_)
    result.maximizedRanks(result.hammingRouting_)
    result.maximizedRanks(result.epsilon_)
    result.minimizedRanks(result.epsilonFirstReachOne_)
    result.maximizedRanks(result.relation_)

    return result
            

if __name__ == '__main__':
        main(WORKDIR, OUTPUT_FILE)