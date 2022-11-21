# This script takes one input argument deciding on the filetype being generated
# 1 - Status information only (Ordered according to instances)
# 2 - Status information only (Ordered according to cases)
# 3 - Resulting pictures only (Ordered according to instances)
# 4 - Resulting pictures only (Ordered according to cases)
# 5 - Resulting pictures with uniformed scaling only (Ordered according to instances)
# 6 - Resulting pictures with uniformed scaling only (Ordered according to cases)

from curses import echo
import os
import sys

from natsort import natsorted

WORKDIR = './results'
OUTPUTDIR = './results/mdfiles'
MDFILE = './plots.md'

FILETYPE1 = 'status.md'
FILETYPE2 = 'statusV2.md'
FILETYPE3 = 'plots.md'
FILETYPE4 = 'plotsV2.md'
FILETYPE5 = 'plotsUniformed.md'
FILETYPE6 = 'plotsUniformedV2.md'
FILETYPE1_SUMMARIZED = 'statusSummarized.md'
FILETYPE2_SUMMARIZED = 'statusSummarizedV2.md'

def getStatData(workdir,instance,case):
    inputFilePath = workdir + "/" + instance + "/asp-dse-ed-v1.0.0-" + case + "/" + "statInfo.txt"
    with open(inputFilePath, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return
        for line in inputFile:
            terms = line.split(' ')
            return [terms[0], terms[1], terms[2], terms[3].split(' \ ')[0]]


def resetCount(statusCount):
    statusCount["Unsatisfiable"] = 0
    statusCount["GroundTimeout"] = 0
    statusCount["SolveTimeout"] = 0
    statusCount["SatisfiableTimeout"] = 0
    statusCount["SatisfiableNoTimeout"] = 0


def printSummarizedStati(_section, statusCount, fileType):
    outputPath = OUTPUTDIR + '/' +  fileType

    row = []
    with open(outputPath, 'a') as summarizedOutputfile:
        row.append('|' + _section + '|' + str(statusCount["SatisfiableNoTimeout"]) + '|' + str(statusCount["SatisfiableTimeout"]) + '|' + str(statusCount["SolveTimeout"]) + '|' + str(statusCount["GroundTimeout"]) + '|' + str(statusCount["Unsatisfiable"]))
        summarizedOutputfile.write(''.join(row) + '|\n')


def generateMarkdown(workdir, outputfile, type):
    # Count DSE stati
    statusCount = {}

    instances = {entry.name for entry in os.scandir(workdir) if "." not in entry.name and "mdfiles" not in entry.name}
    instances = natsorted(instances)
    defaultInstance = workdir + "/" + instances[0]

    cases = { entry.name.split("-", 4)[4] for entry in os.scandir(defaultInstance) if ".txt" not in entry.name }
    cases = natsorted(cases)

    if type == '5' or type == '6':
        condition = False
        i=0
        while condition == False:
            defaultCase = defaultInstance + "/asp-dse-ed-v1.0.0-" + cases[i] + "/uniformScaling"
            try: 
                os.scandir(defaultCase)
                condition = True
            except:
                i = i + 1 

    else:
        defaultCase = defaultInstance + "/asp-dse-ed-v1.0.0-" + cases[0]

    pngFiles = {entry.name for entry in os.scandir(defaultCase) if entry.name.endswith('.png')}
    pngFiles = natsorted(pngFiles)

    if type == '1':
        outputPath = OUTPUTDIR + '/' +  FILETYPE1_SUMMARIZED
        with open(outputPath, 'w') as summarizedOutputfile:
            summarizedOutputfile.write(''.join(['|Instance|SatisfiableNoTimeout|SatisfiableTimeout|SolveTimeout|GroundTimeout|Unsatisfiable|']) + '\n')
            summarizedOutputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|:---:|']) + '\n')
    if type == '2':
        outputPath = OUTPUTDIR + '/' +  FILETYPE2_SUMMARIZED
        with open(outputPath, 'w') as summarizedOutputfile:
            summarizedOutputfile.write(''.join(['|Case|SatisfiableNoTimeout|SatisfiableTimeout|SolveTimeout|GroundTimeout|Unsatisfiable|']) + '\n')
            summarizedOutputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|:---:|']) + '\n')

    section = ''
    subsection = ''
    with open(outputfile, 'w') as outputfile:
        if type == '1' or type == '3' or type == '5':           

            for _section in instances: 
                # Reset counter per section
                resetCount(statusCount)
                # Write markdown (sub)header if section/subsection changed since last loop iteration
                if _section != section:
                    section = _section
                    # For each entry in instances, compose a section
                    outputfile.write('# {}\n\n'.format(section))

                # Output status information only (Ordered according to instances)
                if type == '1':
                    # First row contains head of status table
                    outputfile.write(''.join(['|Case|Status|Time first solution|Timeout|Number design points|    |']) + '\n')
                    outputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|:---:|']) + '\n')

                    # Rows afterwards are made from cases and corresponding information
                    row = []
                    for case in cases:
                        statData = getStatData(WORKDIR,_section,case)
                        if(statData[0] == "Unsatisfiable"):
                            row.append('|' + case + '|' + "<span style=\"color: red;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            statusCount["Unsatisfiable"] = statusCount["Unsatisfiable"]+1
                        elif(statData[0] == "SolveTimeout" or statData[0] == "GroundTimeout"):
                            row.append('|' + case + '|' + "<span style=\"color: orange;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            if statData[0] == "SolveTimeout":
                                statusCount["SolveTimeout"] = statusCount["SolveTimeout"]+1
                            else:
                               statusCount["GroundTimeout"] = statusCount["GroundTimeout"]+1
                        elif(statData[0] == "SatisfiableTimeout" or statData[0] == "SatisfiableNoTimeout"):
                            row.append('|' + case + '|' + "<span style=\"color: green;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            if statData[0] == "SatisfiableTimeout":
                                statusCount["SatisfiableTimeout"] = statusCount["SatisfiableTimeout"]+1
                            else:
                               statusCount["SatisfiableNoTimeout"] = statusCount["SatisfiableNoTimeout"]+1

                    outputfile.write(''.join(row) + '|\n')

                    printSummarizedStati(_section, statusCount, FILETYPE1_SUMMARIZED)

                # Output resulting pictures only (Ordered according to instances)
                elif type == '3' or type == '5':
                    outputfile.write('|instance|' + '|'.join(pngFiles) + '|\n')
                    outputfile.write('|:---:|' + '|'.join([':---:']*len(pngFiles)) + '|\n')
                
                    for _subsection in cases:
                        if _subsection != subsection:
                            subsection = _subsection
                        
                        # For each subsection create a new row, check if pngFiles are available and add them 
                        row = []
                        for pngFile in pngFiles:
                            if type == '3':
                                filePath = "./results/" + section + "/asp-dse-ed-v1.0.0-" + subsection + "/" + pngFile
                                if os.path.isfile(filePath):
                                    filePath = "../" + section + "/asp-dse-ed-v1.0.0-" + subsection + "/" + pngFile
                                    row.append("![](" + filePath + ")")
                                else:
                                    row.append('N/A')
                            elif type == '5':
                                filePath = "./results/" + section + "/asp-dse-ed-v1.0.0-" + subsection + "/uniformScaling/" + pngFile
                                if os.path.isfile(filePath):
                                    filePath = "../" + section + "/asp-dse-ed-v1.0.0-" + subsection + "/uniformScaling/" + pngFile
                                    row.append("![](" + filePath + ")")
                                else:
                                    row.append('N/A')
                        outputfile.write('|' + subsection + '|' + '|'.join(row) + '|\n')

        elif type == '2' or type == '4' or type == '6':
            for _section in cases: 
                # Reset counter per section
                resetCount(statusCount)

                # Write markdown (sub)header if section/subsection changed since last loop iteration
                if _section != section:
                    section = _section
                    # For each entry in cases, compose a section
                    outputfile.write('# {}\n\n'.format(section))

                # Output status information only (Ordered according to cases)
                if type == '2':
                    # First row contains head of status table
                    outputfile.write(''.join(['|Instance|Status|Time first solution|Timeout|Number design points|    |']) + '\n')
                    outputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|:---:|']) + '\n')

                    # Rows afterwards are made from instances and corresponding information
                    row = []
                    for instance in instances:
                        statData = getStatData(WORKDIR,instance,_section)
                        if(statData[0] == "Unsatisfiable"):
                            row.append('|' + instance + '|' + "<span style=\"color: red;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            statusCount["Unsatisfiable"] = statusCount["Unsatisfiable"]+1
                        elif(statData[0] == "SolveTimeout" or statData[0] == "GroundTimeout"):
                            row.append('|' + instance + '|' + "<span style=\"color: orange;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            if statData[0] == "SolveTimeout":
                                statusCount["SolveTimeout"] = statusCount["SolveTimeout"]+1
                            else:
                               statusCount["GroundTimeout"] = statusCount["GroundTimeout"]+1
                        elif(statData[0] == "SatisfiableTimeout" or statData[0] == "SatisfiableNoTimeout"):
                            row.append('|' + instance + '|' + "<span style=\"color: green;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2] + '|' + statData[3])
                            if statData[0] == "SatisfiableTimeout":
                                statusCount["SatisfiableTimeout"] = statusCount["SatisfiableTimeout"]+1
                            else:
                               statusCount["SatisfiableNoTimeout"] = statusCount["SatisfiableNoTimeout"]+1
                            
                    outputfile.write(''.join(row) + '|\n')

                    printSummarizedStati(_section, statusCount, FILETYPE2_SUMMARIZED)

                # Output resulting pictures only (Ordered according to cases)
                elif type == '4' or type == '6':
                    outputfile.write('|instance|' + '|'.join(pngFiles) + '|\n')
                    outputfile.write('|:---:|' + '|'.join([':---:']*len(pngFiles)) + '|\n')

                    for _subsection in instances:
                        if _subsection != subsection:
                            subsection = _subsection
                        
                        # For each subsection create a new row, check if pngFiles are available and add them 
                        row = []
                        for pngFile in pngFiles:
                            if type == '4':
                                filePath = "./results/" + subsection + "/asp-dse-ed-v1.0.0-" + section + "/" + pngFile
                                if os.path.isfile(filePath):
                                    filePath = "../" + subsection + "/asp-dse-ed-v1.0.0-" + section + "/" + pngFile
                                    row.append("![](" + filePath + ")")
                                else:
                                    row.append('N/A')
                            elif type == '6':
                                filePath = "./results/" + subsection + "/asp-dse-ed-v1.0.0-" + section + "/uniformScaling/" + pngFile
                                if os.path.isfile(filePath):
                                    filePath = "../" + subsection + "/asp-dse-ed-v1.0.0-" + section + "/uniformScaling/" + pngFile
                                    row.append("![](" + filePath + ")")
                                else:
                                    row.append('N/A')
                        outputfile.write('|' + subsection + '|' + '|'.join(row) + '|\n')

            outputfile.write('\n')


def main():
    # Read the input parameter defining the output filetype
    try:
        type = sys.argv[1]
        print("Filetype", type, "has been chosen.")
        if type == '1':
           outputfile = OUTPUTDIR + '/' + FILETYPE1
        elif type == '2':
            outputfile = OUTPUTDIR + '/' + FILETYPE2
        elif type == '3':
            outputfile = OUTPUTDIR + '/' + FILETYPE3
        elif type == '4':
            outputfile = OUTPUTDIR + '/' + FILETYPE4
        elif type == '5':
            outputfile = OUTPUTDIR + '/' + FILETYPE5
        elif type == '6':
            outputfile = OUTPUTDIR + '/' + FILETYPE6
        else:
            print("The input parameter didn't match any case")
            sys.exit()
    except:
        print("This script is missing one input parameter\n")
        sys.exit()    

    generateMarkdown(WORKDIR, outputfile, type)

if __name__ == '__main__':
    main()
