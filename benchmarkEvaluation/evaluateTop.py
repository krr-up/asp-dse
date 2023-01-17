# This script evaluates the results from the DSE runs.
# Per each instance, for different criteria the script filters the Top 3 cases

import os
from natsort import natsorted

WORKDIR = './results'
OUTPUT_FILE = './results/mdfiles/top.md'
OUTPUT_FILE_2 = './results/mdfiles/topSummarized.md'

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
        self.hammingTotalAdapted_ = []
        self.hammingTotalAdaptedFirst_ = []
        self.hammingBindingAdapted_ = []
        self.hammingBindingAdaptedFirst_ = []
        self.hammingRoutingAdapted_ = []
        self.hammingRoutingAdaptedFirst_ = []
        self.epsilon_ = []
        self.epsilonFirst_ = []
        self.epsilon2_ = []
        self.epsilon2First_ = []
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
        self.hammingTotalAdapted_ == [] or
        self.hammingTotalAdaptedFirst_ == [] or
        self.hammingBindingAdapted_ == [] or
        self.hammingBindingAdaptedFirst_ == [] or
        self.hammingRoutingAdapted_ == [] or
        self.hammingRoutingAdaptedFirst_ == [] or
        self.epsilon_ == [] or
        self.epsilonFirst_ == [] or
        self.epsilon2_ == [] or
        self.epsilon2First_ == [] or
        self.epsilonFirstReachOne_ == [] or
        self.relation_ == [] or
        self.relationFirst_ == [])
        if isEmpty == 1:
            print("warning, empty instance")
        return isEmpty

    # This method keeps in a list the currently three biggest values
    def maximizeValue(self, values, candidateValue, candidateCase): 
        def SortFun(e):
            return float(e[0])

        # If answer is valid
        if(candidateValue  != '-1'):
            for value in values:
                # If that case is already in the top 3 for another design point
                if value[1] == candidateCase:
                    # Replace value in list, if candidateValue is better
                    if float(value[0]) < float(candidateValue):
                        value[0] = candidateValue
                        values.sort(reverse = True, key=SortFun)
                    return # look for the next value
            # Initialize vector with first three values
            if(len(values) < 3):
                values.append([candidateValue, candidateCase])
                values.sort(reverse = True, key=SortFun)
            # If better value has been found, keep it
            # Reorder list and delete weakest one
            elif(float(values[2][0]) <= float(candidateValue)):
                values.append([candidateValue, candidateCase])
                values.sort(reverse = True, key=SortFun)
                # Only allow to have more than 3 entries, if they have the same value
                if(float(values[2][0]) != float(values[len(values)-1][0])):
                    while len(values) > 3:
                        values.pop()
    
    # This method keeps in a list the currently three smallest values
    def minimizeValue(self, values, candidateValue, candidateCase): 
        def SortFun(e):
            return float(e[0])

         # If answer is valid
        if(candidateValue  != '-1'):
            for value in values:
                # If that case is already in the top 3 for another design point
                if value[1] == candidateCase:
                    # Replace value in list, if candidateValue is better
                    if float(value[0]) > float(candidateValue):
                        value[0] = candidateValue
                        values.sort(key=SortFun)
                    return # look for the next value
            # Initialize vector with first three values       
            if(len(values) < 3):
                values.append([candidateValue, candidateCase])
                values.sort(key=SortFun)
            # If better value has been found, keep it
            # Reorder list and delete weakest one
            elif(float(values[2][0]) >= float(candidateValue)):
                values.append([candidateValue, candidateCase])
                values.sort(key=SortFun)
                # Only allow to have more than 3 entries, if they have the same value
                if(float(values[2][0]) != float(values[len(values)-1][0])):
                    while len(values) > 3:
                        values.pop()
                        
            
    def bestRelation(self, candidateEpsilon, candidateHamming, candidateCase):
        self.maximizeValue(self.relation_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)

    def bestRelationFirst(self, candidateEpsilon, candidateHamming, candidateCase):
        self.maximizeValue(self.relationFirst_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)
        

# Function to format a line with multiple results
def formatOutputMultiple(text, results, outputfile):
    outputfile.write(text)
    for i in range(len(results)):
        outputfile.write('**' + str(i+1) + '.** ' + results[i][0] + ' ' + results[i][1] + '  \n')


# Function to format multiple lines output
def formatOutputNEntries(text, results, outputfile):
    outputfile.write(text)
    for i in range(len(results)):
        outputfile.write(results[i][0] + ' ' + results[i][1] + '  \n')


# Try to access (and count) case in dictionary, if there is no such key, initialize it
# If entry contains default value -1 or 900, skip it
def updateDictionaryMultiple(dictionary, results):
    for i in range(len(results)):
        if(results[i][0] != '-1' and results[i][0] != '900'):
            try: 
                dictionary[results[i][1]] = dictionary[results[i][1]] + 1
            except:
                dictionary[results[i][1]] = 1


# Function to format dictionary output
def outputDictionary(dictionary, outputfile):
    outputfile.write('|Case|Count||\n')
    outputfile.write('|:---:|:---:|:---:|\n')
    for i in sorted(dictionary) :
        outputfile.write('|' + i + '|' + str(dictionary[i]) + '|    |\n')


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
    dictionaryHammingTotalAdaptedFirst = {}
    dictionaryHammingTotalAdapted = {}
    dictionaryHammingBindingAdaptedFirst = {}
    dictionaryHammingBindingAdapted = {}
    dictionaryHammingRoutingAdaptedFirst = {}
    dictionaryHammingRoutingAdapted = {}
    dictionaryEpsilonFirst = {}
    dictionaryEpsilon = {}
    dictionaryEpsilon2First = {}
    dictionaryEpsilon2 = {}
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

            # Write data to output file
            formatOutputMultiple('## First solution time\n', results.timeFirstSolution_, outputfile)
            formatOutputMultiple('## Complete search time\n', results.completeSearchTime_, outputfile)

            formatOutputMultiple('## Hamming total, only first solution\n', results.hammingTotalFirst_, outputfile)
            formatOutputMultiple('## Hamming total \n', results.hammingTotal_, outputfile)

            formatOutputMultiple('## Hamming binding, only first solution\n', results.hammingBindingFirst_, outputfile)
            formatOutputMultiple('## Hamming binding \n', results.hammingBinding_, outputfile)

            formatOutputMultiple('## Hamming routing, only first solution\n', results.hammingRoutingFirst_, outputfile)
            formatOutputMultiple('## Hamming routing \n', results.hammingRouting_, outputfile)

            formatOutputMultiple('## Hamming total adapted, only first solution\n', results.hammingTotalAdaptedFirst_, outputfile)
            formatOutputMultiple('## Hamming total adapted\n', results.hammingTotalAdapted_, outputfile)

            formatOutputMultiple('## Hamming binding adapted, only first solution\n', results.hammingBindingAdaptedFirst_, outputfile)
            formatOutputMultiple('## Hamming binding adapted\n', results.hammingBindingAdapted_, outputfile)

            formatOutputMultiple('## Hamming routing adapted, only first solution\n', results.hammingRoutingAdaptedFirst_, outputfile)
            formatOutputMultiple('## Hamming routing adapted\n', results.hammingRoutingAdapted_, outputfile)

            formatOutputMultiple('## Epsilon dominance, only first solution\n', results.epsilonFirst_, outputfile)
            formatOutputMultiple('## Epsilon dominance\n', results.epsilon_, outputfile)

            formatOutputMultiple('## Epsilon dominance 2, only first solution\n', results.epsilon2First_, outputfile)
            formatOutputMultiple('## Epsilon dominance 2\n', results.epsilon2_, outputfile)

            formatOutputMultiple('## Time Epsilon dominance = 1 has been reached first\n', results.epsilonFirstReachOne_, outputfile)

            formatOutputMultiple('## Epsilon-Hamming relation, only first solution\n', results.relationFirst_, outputfile)
            formatOutputMultiple('## Epsilon-Hamming relation\n', results.relation_, outputfile)

            # Count the occurring cases per criteria
            updateDictionaryMultiple(dictionaryTimeFirstSolution,results.timeFirstSolution_)
            updateDictionaryMultiple(dictionaryCompleteSearchTime,results.completeSearchTime_)
            updateDictionaryMultiple(dictionaryHammingTotalFirst,results.hammingTotalFirst_)
            updateDictionaryMultiple(dictionaryHammingTotal,results.hammingTotal_)
            updateDictionaryMultiple(dictionaryHammingBindingFirst,results.hammingBindingFirst_)
            updateDictionaryMultiple(dictionaryHammingBinding,results.hammingBinding_)
            updateDictionaryMultiple(dictionaryHammingRoutingFirst,results.hammingRoutingFirst_)
            updateDictionaryMultiple(dictionaryHammingRouting,results.hammingRouting_)
            updateDictionaryMultiple(dictionaryHammingTotalAdaptedFirst,results.hammingTotalAdaptedFirst_)
            updateDictionaryMultiple(dictionaryHammingTotalAdapted,results.hammingTotalAdapted_)
            updateDictionaryMultiple(dictionaryHammingBindingAdaptedFirst,results.hammingBindingAdaptedFirst_)
            updateDictionaryMultiple(dictionaryHammingBindingAdapted,results.hammingBindingAdapted_)
            updateDictionaryMultiple(dictionaryHammingRoutingAdaptedFirst,results.hammingRoutingAdaptedFirst_)
            updateDictionaryMultiple(dictionaryHammingRoutingAdapted,results.hammingRoutingAdapted_)
            updateDictionaryMultiple(dictionaryEpsilonFirst,results.epsilonFirst_)
            updateDictionaryMultiple(dictionaryEpsilon,results.epsilon_)
            updateDictionaryMultiple(dictionaryEpsilon2First,results.epsilon2First_)
            updateDictionaryMultiple(dictionaryEpsilon2,results.epsilon2_)
            updateDictionaryMultiple(dictionaryEpsilonFirstReachOne,results.epsilonFirstReachOne_)
            updateDictionaryMultiple(dictionaryRelationFirst,results.relationFirst_)
            updateDictionaryMultiple(dictionaryRelation,results.relation_)

    # Output summarized top 3 evaluation in another document
    with open(OUTPUT_FILE_2, 'w') as outputfile:
        outputfile.write('## First solution time\n')
        outputDictionary(dictionaryTimeFirstSolution, outputfile)
        outputfile.write('## Complete search time\n')
        outputDictionary(dictionaryCompleteSearchTime, outputfile)
        outputfile.write('## Hamming total, only first solution\n')
        outputDictionary(dictionaryHammingTotalFirst, outputfile)
        outputfile.write('## Hamming total \n')
        outputDictionary(dictionaryHammingTotal, outputfile)
        outputfile.write('## Hamming binding, only first solution\n')
        outputDictionary(dictionaryHammingBindingFirst, outputfile)
        outputfile.write('## Hamming binding \n')
        outputDictionary(dictionaryHammingBinding, outputfile)
        outputfile.write('## Hamming routing, only first solution\n')
        outputDictionary(dictionaryHammingRoutingFirst, outputfile)
        outputfile.write('## Hamming routing \n')
        outputDictionary(dictionaryHammingRouting, outputfile)
        outputfile.write('## Hamming total adapted, only first solution\n')
        outputDictionary(dictionaryHammingTotalAdaptedFirst, outputfile)
        outputfile.write('## Hamming total adapted\n')
        outputDictionary(dictionaryHammingTotalAdapted, outputfile)
        outputfile.write('## Hamming binding adapted, only first solution\n')
        outputDictionary(dictionaryHammingBindingAdaptedFirst, outputfile)
        outputfile.write('## Hamming binding adapted\n')
        outputDictionary(dictionaryHammingBindingAdapted, outputfile)
        outputfile.write('## Hamming routing adapted, only first solution\n')
        outputDictionary(dictionaryHammingRoutingAdaptedFirst, outputfile)
        outputfile.write('## Hamming routing adapted\n')
        outputDictionary(dictionaryHammingRoutingAdapted, outputfile)
        outputfile.write('## Epsilon dominance, only first solution\n')
        outputDictionary(dictionaryEpsilonFirst, outputfile)
        outputfile.write('## Epsilon dominance\n')
        outputDictionary(dictionaryEpsilon, outputfile)
        outputfile.write('## Epsilon dominance 2, only first solution\n')
        outputDictionary(dictionaryEpsilon2First, outputfile)
        outputfile.write('## Epsilon dominance 2\n')
        outputDictionary(dictionaryEpsilon2, outputfile)
        outputfile.write('## Time Epsilon dominance = 1 has been reached first\n')
        outputDictionary(dictionaryEpsilonFirstReachOne, outputfile)
        outputfile.write('## Epsilon-Hamming relation, only first solution\n')
        outputDictionary(dictionaryRelationFirst, outputfile)
        outputfile.write('## Epsilon-Hamming relation\n')
        outputDictionary(dictionaryRelation, outputfile)



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
            result.minimizeValue(result.timeFirstSolution_, terms[1], case)
            # Minimize time to complete the search or Timeout
            result.minimizeValue(result.completeSearchTime_, terms[2].rstrip(), case)

        with open(resultFilePath, 'r') as inputFile:
            if inputFile.closed:
                print("file can not be opened: " + resultFilePath)
                return

            # Skip the first line, where the header is
            inputFile.readline()
            line = inputFile.readline()
            terms = line.split(' ')
            if len(terms) == 10:
                # Maximize the value of each criteria for the first entry in the input file
                result.maximizeValue(result.hammingTotalFirst_, terms[2], case)
                result.maximizeValue(result.hammingBindingFirst_, terms[3], case)
                result.maximizeValue(result.hammingRoutingFirst_, terms[4], case)
                result.maximizeValue(result.hammingTotalAdaptedFirst_, terms[5], case)
                result.maximizeValue(result.hammingRoutingAdaptedFirst_, terms[6], case)
                result.maximizeValue(result.hammingBindingAdaptedFirst_, terms[7], case)
                result.maximizeValue(result.epsilonFirst_, terms[8], case)
                result.minimizeValue(result.epsilon2First_, terms[9].rstrip(), case)
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
                result.maximizeValue(result.hammingTotal_, terms[2], case)
                result.maximizeValue(result.hammingBinding_, terms[3], case)
                result.maximizeValue(result.hammingRouting_, terms[4], case)
                result.maximizeValue(result.hammingTotalAdapted_, terms[5], case)
                result.maximizeValue(result.hammingRoutingAdapted_, terms[6], case)
                result.maximizeValue(result.hammingBindingAdapted_, terms[7], case)
                result.maximizeValue(result.epsilon_, terms[8], case)
                result.minimizeValue(result.epsilon2_, terms[9].rstrip(), case)
                
                if float(terms[8]) == 1.0 :
                    result.minimizeValue(result.epsilonFirstReachOne_, terms[1], case)
                
                result.bestRelation(terms[2], terms[8], case)

    return result
            

if __name__ == '__main__':
        main(WORKDIR, OUTPUT_FILE)