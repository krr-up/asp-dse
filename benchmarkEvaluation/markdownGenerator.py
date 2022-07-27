# This script takes one input argument deciding on the filetype being generated
# 1 - Status information only
# 2 - Resulting pictures only
# 3 - Combining information from filetype 1 and 2

import os
import sys

from natsort import natsorted

WORKDIR = './results'
OUTPUTDIR = './results/mdfiles'
MDFILE = './plots.md'

FILETYPE1 = 'status.md'
FILETYPE2 = 'results.md'
FILETYPE3 = 'combined.md'

MD_IMG_FMT = '![{subsection}]({filepath} "{subsection}")' 
# _________________________________________________________________'


def getStatData(workdir,instance,case):
    inputFilePath = workdir + "/" + instance + "/asp-dse-ed-v1.0.0-" + case + "/" + "statInfo.txt"
    with open(inputFilePath, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return
        for line in inputFile:
            terms = line.split(' ')
            return [terms[0], terms[1], terms[2].split(' \ ')[0]]

def generateMarkdown(workdir, outputfile):
    instances = {entry.name for entry in os.scandir(workdir) if "." not in entry.name and "mdfiles" not in entry.name}
    instances = natsorted(instances)
    defaultInstance = workdir + "/" + instances[0]

    cases = { entry.name.split("-", 4)[4] for entry in os.scandir(defaultInstance) if ".txt" not in entry.name }
    cases = natsorted(cases)

    epsfiles = {entry.name for entry in os.scandir(workdir) if entry.name.endswith('.png')}
    epsfiles = natsorted(epsfiles)

    section = ''
    with open(outputfile, 'w') as outputfile:
        for _section in instances: 
            # write markdown (sub)header if section/subsection changed since last loop iteration
            if _section != section:
                section = _section
                # for each entry in instances, compose a section
                outputfile.write('# {}\n\n'.format(section))

            # Output status information only
            if type == '1':
                # First row contains head of status table
                outputfile.write(''.join(['|Case|Status|Time first solution|Timeout|    |']) + '\n')
                outputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|']) + '\n')

                # Rows afterwards are made from cases
                row = []
                for case in cases:
                    statData = getStatData(WORKDIR,_section,case)
                    if(statData[0] == "Unsatisfiable"):
                        row.append('|' + case + '|' + "<span style=\"color: red;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2])
                    elif(statData[0] == "SolveTimeout" or statData[0] == "GroundTimeout"):
                        row.append('|' + case + '|' + "<span style=\"color: orange;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2])
                    elif(statData[0] == "SatisfiableTimeout" or statData[0] == "SatisfiableNoTimeout"):
                        row.append('|' + case + '|' + "<span style=\"color: green;\">" + statData[0] + "</span>" + '|' + statData[1] + '|' + statData[2])
                    
                outputfile.write(''.join(row) + '|\n')

            # Output resulting pictures only
            # TODO
            elif type == '2':
                # Rows are made from cases
                row = []
                for case in cases:
                    filepath = os.path.join(workdir, epsfiles[0])
                    filepath_md = os.path.join(workdir, epsfiles[0]).replace(os.sep, '/')

                    if os.path.isfile(filepath):
                        row.append(case)
                        row.append(MD_IMG_FMT.format(subsection = section, filepath = filepath_md))
                    else:
                        row.append('N/A')

                    outputfile.write(''.join(row) + '\n')

            # Output status information and resulting pictures
            # TODO
            elif type == '3':
                # First row contains head of status table
                outputfile.write(''.join(['|Case|Status|Time first solution|Timeout|    |']) + '\n')
                outputfile.write(''.join(['|:---:|:---:|:---:|:---:|:---:|']) + '\n')

                # Rows afterwards are made from cases
                row = []
                for case in cases:
                    filepath = os.path.join(workdir, epsfiles[0])
                    filepath_md = os.path.join(workdir, epsfiles[0]).replace(os.sep, '/')
                    statData = getStatData(WORKDIR,_section,case)

                    row.append('|' + case + '|' + statData[0] + '|' + statData[1] + '|' + statData[2] + '|')
                    if os.path.isfile(filepath):
                        row.append(MD_IMG_FMT.format(subsection = section, filepath = filepath_md))
                    else:
                        row.append('N/A')

                    outputfile.write(''.join(row) + '|\n')

            outputfile.write('\n')

if __name__ == '__main__':
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
        else:
            print("The input parameter didn't match any case")
            sys.exit()
    except:
        print("This script is missing one input parameter\n")
        sys.exit()    

    generateMarkdown(WORKDIR, outputfile)
