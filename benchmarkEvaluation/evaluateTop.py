# This script evaluates the results from the DSE runs.
# Per each instance, for different criteria the script filters the Top 3 cases

# TODO Calculate arithmetic mean value for each case over all instances

import os
from natsort import natsorted

WORKDIR = './results'
STATUS_FILE = 'statInfo.txt'
RESULT_FILE = 'results.txt'
OUTPUT_FILE = './results/mdfiles/top.md'

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
        self.relation_ = []
        self.relationFirst_ = []

    def Empty(self):
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
        self.relation_ == [] or
        self.relationFirst_ == [])
        if isEmpty == 1:
            print("warning, empty instance")
        return isEmpty

    # This method keeps in a list the currently three biggest values
    def MaximizeValue(self, values, candidateValue, candidateCase): 
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
                values.pop()
    
    # This method keeps in a list the currently three smallest values
    def MinimizeValue(self, values, candidateValue, candidateCase): 
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
                values.pop()
            
    def BestRelation(self, candidateEpsilon, candidateHamming, candidateCase):
        self.MaximizeValue(self.relation_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)

    def BestRelationFirst(self, candidateEpsilon, candidateHamming, candidateCase):
        self.MaximizeValue(self.relationFirst_, str(float(candidateEpsilon)*float(candidateHamming)), candidateCase)


# Function to format a single result line
def FormatOutputMultiple(text, result, outputfile):
    outputfile.write(text)
    outputfile.write('**1.** ' + result[0] + ' ' + result[1] + '  \n')
        
# Function to format a multiple result line
def FormatOutputMultiple(text, results, outputfile):
    outputfile.write(text)
    outputfile.write('**1.** ' + results[0][0] + ' ' + results[0][1] + '  \n')
    outputfile.write('**2.** ' + results[1][0] + ' ' + results[1][1] + '  \n')
    outputfile.write('**3.** ' + results[2][0] + ' ' + results[2][1] + '  \n')

def main(workdir, outputfile): 
    instances = {entry.name for entry in os.scandir(workdir) if "." not in entry.name and "mdfiles" not in entry.name}
    instances = natsorted(instances)

    with open(outputfile, 'w') as outputfile:
        for instance in instances:             
            # Evaluate results for certain instance
            filePath = workdir + '/' + instance
            results = EvaluateResults(filePath) # Search through all cases for best hamming and epsilon values

            # For each entry in instances, compose a section in output file
            outputfile.write('\n\n####################################################################\n')
            outputfile.write('# ' + instance + '\n\n')
            filePath = workdir + '/' + instance

            if(results.Empty()):
                continue

            # Write data to output file
            FormatOutputMultiple('## First solution time\n', results.timeFirstSolution_, outputfile)
            FormatOutputMultiple('## First Complete search time\n', results.completeSearchTime_, outputfile)

            FormatOutputMultiple('## Hamming total, only first solution\n', results.hammingTotalFirst_, outputfile)
            FormatOutputMultiple('## Hamming total \n', results.hammingTotal_, outputfile)

            FormatOutputMultiple('## Hamming binding, only first solution\n', results.hammingBindingFirst_, outputfile)
            FormatOutputMultiple('## Hamming binding \n', results.hammingBinding_, outputfile)

            FormatOutputMultiple('## Hamming routing, only first solution\n', results.hammingRoutingFirst_, outputfile)
            FormatOutputMultiple('## Hamming routing \n', results.hammingRouting_, outputfile)

            FormatOutputMultiple('## Hamming total adapted, only first solution\n', results.hammingTotalAdaptedFirst_, outputfile)
            FormatOutputMultiple('## Hamming total adapted\n', results.hammingTotalAdapted_, outputfile)

            FormatOutputMultiple('## Hamming binding adapted, only first solution\n', results.hammingBindingAdaptedFirst_, outputfile)
            FormatOutputMultiple('## Hamming binding adapted\n', results.hammingBindingAdapted_, outputfile)

            FormatOutputMultiple('## Hamming routing adapted, only first solution\n', results.hammingRoutingAdaptedFirst_, outputfile)
            FormatOutputMultiple('## Hamming routing adapted\n', results.hammingRoutingAdapted_, outputfile)

            FormatOutputMultiple('## Epsilon dominance, only first solution\n', results.epsilonFirst_, outputfile)
            FormatOutputMultiple('## Epsilon dominance\n', results.epsilon_, outputfile)

            FormatOutputMultiple('## Epsilon dominance 2, only first solution\n', results.epsilon2First_, outputfile)
            FormatOutputMultiple('## eEpsilon dominance 2\n', results.epsilon2_, outputfile)

            FormatOutputMultiple('## Epsilon-Hamming relation, only first solution\n', results.relationFirst_, outputfile)
            FormatOutputMultiple('## Epsilon-Hamming relation\n', results.relation_, outputfile)


# Iterate through all cases to find best hamming distances and best epsilon dominances
def EvaluateResults(casesPath):
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
            result.MinimizeValue(result.timeFirstSolution_, terms[1], case)
            # Minimize time to complete the search or Timeout
            result.MinimizeValue(result.completeSearchTime_, terms[2].rstrip(), case)

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
                result.MaximizeValue(result.hammingTotalFirst_, terms[2], case)
                result.MaximizeValue(result.hammingBindingFirst_, terms[3], case)
                result.MaximizeValue(result.hammingRoutingFirst_, terms[4], case)
                result.MaximizeValue(result.hammingTotalAdaptedFirst_, terms[5], case)
                result.MaximizeValue(result.hammingRoutingAdaptedFirst_, terms[6], case)
                result.MaximizeValue(result.hammingBindingAdaptedFirst_, terms[7], case)
                result.MaximizeValue(result.epsilonFirst_, terms[8], case)
                result.MaximizeValue(result.epsilon2First_, terms[9].rstrip(), case)
                result.BestRelationFirst(terms[2], terms[8], case)

            caseErrorSup = False
            for line in inputFile:
                terms = line.split(' ')
                if len(terms) != 10:
                    if not caseErrorSup:
                        caseErrorSup = True
                        print("warning, not enough arguments in file: " + resultFilePath)
                    continue

                # Maximize the value of each criteria for all entries in the input file
                result.MaximizeValue(result.hammingTotal_, terms[2], case)
                result.MaximizeValue(result.hammingBinding_, terms[3], case)
                result.MaximizeValue(result.hammingRouting_, terms[4], case)
                result.MaximizeValue(result.hammingTotalAdapted_, terms[5], case)
                result.MaximizeValue(result.hammingRoutingAdapted_, terms[6], case)
                result.MaximizeValue(result.hammingBindingAdapted_, terms[7], case)
                result.MaximizeValue(result.epsilon_, terms[8], case)
                result.MaximizeValue(result.epsilon2_, terms[9].rstrip(), case)
                result.BestRelation(terms[2], terms[8], case)

    return result
            

if __name__ == '__main__':
        main(WORKDIR, OUTPUT_FILE)