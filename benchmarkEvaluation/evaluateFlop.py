# This script evaluates the results from the DSE runs.
# Per each instance, for different criteria the script filters the Top 3 cases
# TODO Calculate arithmetic mean value for each case over all instances

import os
from natsort import natsorted

WORKDIR = './results'
STATUS_FILE = 'statInfo.txt'
RESULT_FILE = 'results.txt'
OUTPUT_FILE = './results/mdfiles/flop.md'
OUTPUT_FILE_2 = './results/mdfiles/flopSummarized.md'

class Results():
    def __init__(self):
        self.hammingTotal_ = []
        self.hammingTotalFirst_ = []
        self.hammingBinding_ = []
        self.hammingBindingFirst_ = []
        self.hammingRouting_ = []
        self.hammingRoutingFirst_ = []
        self.epsilon_ = []
        self.epsilonFirst_ = []
        self.relation_ = []
        self.relationFirst_ = []

    def empty(self):
        isEmpty = (self.hammingTotal_ == [] or
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
            elif(float(values[2][0]) < float(candidateValue)):
                values.append([candidateValue, candidateCase])
                values.sort(reverse = True, key=SortFun)
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
            elif(float(values[2][0]) > float(candidateValue)):
                values.append([candidateValue, candidateCase])
                values.sort(key=SortFun)
                if(float(values[2][0]) != float(values[len(values)-1][0])):
                    while len(values) > 3:
                        values.pop()
            
    def bestRelation(self, candidateEpsilon, candidateHamming, candidateCase):
        self.minimizeValue(self.relation_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)

    def bestRelationFirst(self, candidateEpsilon, candidateHamming, candidateCase):
        self.minimizeValue(self.relationFirst_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)
        

# Function to format a multiple result line
def formatOutputMultiple(text, results, outputfile):
    outputfile.write(text)
    for i in range(len(results)):
        outputfile.write('**' + str(i+1) + '.** ' + results[i][0] + ' ' + results[i][1] + '  \n')


# Try to access (and count) case in dictionary, if there is no such key, initialize it
# If entry contains default value -1 or 900, skip it
def updateDictionaryMultiple(dictionary, results):
    if(results[0][0] != '-1' and results[0][0] != '900'):
        try:
            dictionary[results[0][1]] = dictionary[results[0][1]] + 1
        except:
            dictionary[results[0][1]] = 1  
    if(results[1][0] != '-1' and results[1][0] != '900'):
        try:
            dictionary[results[1][1]] = dictionary[results[1][1]] + 1
        except:
            dictionary[results[1][1]] = 1 
    if(results[2][0] != '-1' and results[2][0] != '900'): 
        try:
            dictionary[results[2][1]] = dictionary[results[2][1]] + 1
        except:
            dictionary[results[2][1]] = 1  


def outputDictionary(dictionary, outputfile):
    outputfile.write('|Case|Count||\n')
    outputfile.write('|:---:|:---:|:---:|\n')
    for i in sorted(dictionary) :
        outputfile.write('|' + i + '|' + str(dictionary[i]) + '|    |\n')


def main(workdir, outputfile): 
    instances = {entry.name for entry in os.scandir(workdir) if "." not in entry.name and "mdfiles" not in entry.name}
    instances = natsorted(instances)

    # Create dictionaries to count all occurrences of cases for each criteria
    dictionaryHammingTotalFirst = {}
    dictionaryHammingTotal = {}
    dictionaryHammingBindingFirst = {}
    dictionaryHammingBinding = {}
    dictionaryHammingRoutingFirst = {}
    dictionaryHammingRouting = {}
    dictionaryEpsilonFirst = {}
    dictionaryEpsilon = {}
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
            formatOutputMultiple('## Hamming total, only first solution\n', results.hammingTotalFirst_, outputfile)
            formatOutputMultiple('## Hamming total \n', results.hammingTotal_, outputfile)

            formatOutputMultiple('## Hamming binding, only first solution\n', results.hammingBindingFirst_, outputfile)
            formatOutputMultiple('## Hamming binding \n', results.hammingBinding_, outputfile)

            formatOutputMultiple('## Hamming routing, only first solution\n', results.hammingRoutingFirst_, outputfile)
            formatOutputMultiple('## Hamming routing \n', results.hammingRouting_, outputfile)

            formatOutputMultiple('## Epsilon dominance, only first solution\n', results.epsilonFirst_, outputfile)
            formatOutputMultiple('## Epsilon dominance\n', results.epsilon_, outputfile)

            formatOutputMultiple('## Epsilon-Hamming relation, only first solution\n', results.relationFirst_, outputfile)
            formatOutputMultiple('## Epsilon-Hamming relation\n', results.relation_, outputfile)

            # Count the occurring cases per criteria
            updateDictionaryMultiple(dictionaryHammingTotalFirst,results.hammingTotalFirst_)
            updateDictionaryMultiple(dictionaryHammingTotal,results.hammingTotal_)
            updateDictionaryMultiple(dictionaryHammingBindingFirst,results.hammingBindingFirst_)
            updateDictionaryMultiple(dictionaryHammingBinding,results.hammingBinding_)
            updateDictionaryMultiple(dictionaryHammingRoutingFirst,results.hammingRoutingFirst_)
            updateDictionaryMultiple(dictionaryHammingRouting,results.hammingRouting_)
            updateDictionaryMultiple(dictionaryEpsilonFirst,results.epsilonFirst_)
            updateDictionaryMultiple(dictionaryEpsilon,results.epsilon_)
            updateDictionaryMultiple(dictionaryRelationFirst,results.relationFirst_)
            updateDictionaryMultiple(dictionaryRelation,results.relation_)

    # Output summarized top 3 evaluation in another document
    with open(OUTPUT_FILE_2, 'w') as outputfile:
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
        outputfile.write('## Epsilon dominance, only first solution\n')
        outputDictionary(dictionaryEpsilonFirst, outputfile)
        outputfile.write('## Epsilon dominance\n')
        outputDictionary(dictionaryEpsilon, outputfile)
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
                result.minimizeValue(result.hammingTotalFirst_, terms[2], case)
                result.minimizeValue(result.hammingBindingFirst_, terms[3], case)
                result.minimizeValue(result.hammingRoutingFirst_, terms[4], case)
                result.minimizeValue(result.epsilonFirst_, terms[8], case)
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
                result.minimizeValue(result.hammingTotal_, terms[2], case)
                result.minimizeValue(result.hammingBinding_, terms[3], case)
                result.minimizeValue(result.hammingRouting_, terms[4], case)
                result.minimizeValue(result.epsilon_, terms[8], case)
                result.bestRelation(terms[2], terms[8], case)

    return result
            

if __name__ == '__main__':
        main(WORKDIR, OUTPUT_FILE)