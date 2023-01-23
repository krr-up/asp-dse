# This script takes the results calculated by the script 'calculateIndicators.py' and creates various plots from them
# This script takes one input argument deciding on the plottype being generated
# 1 -   Plot HammingTotal and Epsilon dominance (Smaller 1) over time
#       Plot HammingTotal and Epsilon dominance (Greater 1) over time
#       Plot avgHammingTotal, maxHammingTotal and Epsilon dominance (Smaller 1) over time
# 2 -   Plot hamming distance types over time
#       Plot adapted hamming distance types over time
# 3 -   Plot HammingTotal and Epsilon dominance (Smaller 1) with uniform time scaling and timeout marker

import os
import sys
from natsort import natsorted
import matplotlib as mpl
import matplotlib.pyplot as plt
import csv

OUTPUT_HE_FILE_NAME_PNG = 'HEPlot.png'      # Plot HammingTotal and Epsilon dominance (Smaller 1) over time
OUTPUT_HE_FILE_NAME_SVG = 'HEPlot.svg'
OUTPUT_HE2_FILE_NAME_PNG = 'HE2Plot.png'    # Plot HammingTotal and Epsilon dominance (Larger 1) over time
OUTPUT_HE2_FILE_NAME_SVG = 'HE2Plot.svg'
OUTPUT_HEAvg_FILE_NAME_PNG = 'HEAveragePlot.png'    # Plot AveragedHammingTotal, MaximumHammingTotal and Epsilon dominance (Larger 1) over time
OUTPUT_HEAvg_FILE_NAME_SVG = 'HEAveragePlot.svg'
OUTPUT_HE_UNIFORM_FILE_NAME_PNG = 'HEUniformPlot.png'     # Plot HammingTotal and Epsilon dominance (Smaller 1) with uniform time scaling and timeout marker
OUTPUT_HE_UNIFORM_FILE_NAME_SVG = 'HEUniformPlot.svg'
OUTPUT_HTYPE_UNIFORM_FILE_NAME_PNG = 'HTypeUniformPlot.png'     # Plot HammingTotal and Epsilon dominance (Smaller 1) with uniform time scaling and timeout marker 
OUTPUT_HTYPE_UNIFORM_FILE_NAME_SVG = 'HTypeUniformPlot.svg'
OUTPUT_HTYPE_FILE_NAME_PNG = 'HTypePlot.png'            # Plot hamming distance types over time
OUTPUT_HTYPE_FILE_NAME_SVG = 'HTypePlot.svg'
OUTPUT_HATYPE_FILE_NAME_PNG = 'HAdaptedTypePlot.png'    # Plot adapted hamming distance types over time
OUTPUT_HATYPE_FILE_NAME_SVG = 'HAdaptedTypePlot.svg'
OUTPUT_AVGHTYPE_FILE_NAME_PNG = 'AverageHTypePlot.png'    # Plot averaged hamming distance types over time
OUTPUT_AVGHTYPE_FILE_NAME_SVG = 'AverageHTypePlot.svg'
OUTPUT_MAXHTYPE_FILE_NAME_PNG = 'MaxHTypePlot.png'    # Plot maximum hamming distance types over time
OUTPUT_MAXHTYPE_FILE_NAME_SVG = 'MaxHTypePlot.svg'

INPUT_BASE_DIR = './results'
INPUT_FILE_NAME = 'results.txt'
INPUT_FILE_NAME_AVG = 'resultsHammingAverage.txt'
INPUT_FILE_NAME_MAX = 'resultsHammingMax.txt'
STATUS_FILE_NAME = 'statInfo.txt'

# Plot HammingTotal and Epsilon dominance over time
def plot_HE_type(outputFilePath, time, hammingTotal, avgHammingTotal, maxHammingTotal, epsilonSmallerOne, epsilonLargerOne):
    # Hamming distance - Epsilon dominance (Smaller than one) plot
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    ax1.plot(time, hammingTotal, c='r', marker='x',linewidth=0.5,linestyle='--')
    ax2.plot(time, epsilonSmallerOne, c='b', marker='x',linewidth=0.5,linestyle='--')
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance", color = 'r')
    ax2.set_ylabel("Epsilon dominance", color = 'b')
    plt.grid()
    plt.title("Hamming distance and epsilon dominance over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HE_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HE_FILE_NAME_PNG, bbox_inches='tight')
    fig.clf()
    plt.close()

    # Hamming distance - Epsilon dominance (Larger than one) plot
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    ax1.plot(time, hammingTotal, c='r', marker='x',linewidth=0.5,linestyle='--')
    ax2.plot(time, epsilonLargerOne, c='b', marker='x',linewidth=0.5,linestyle='--')
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance", color = 'r')
    ax2.set_ylabel("Epsilon dominance", color = 'b')
    plt.grid()
    plt.title("Hamming distance and epsilon dominance over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HE2_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HE2_FILE_NAME_PNG, bbox_inches='tight')
    fig.clf()
    plt.close()

    # Average hamming distance - maximum hamming distance - Epsilon dominance (smaller than one) plot
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()

    ax1.plot(time, avgHammingTotal, c='r', marker='x',linewidth=0.5,linestyle='--')
    ax1.plot(time, maxHammingTotal, c='g', marker='x',linewidth=0.5,linestyle='--')
    ax2.plot(time, epsilonSmallerOne, c='b', marker='x',linewidth=0.5,linestyle='--')
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Average Hamming Distance", color = 'r')
    plt.text(-0.2, 0.5, "Maximum Hamming Distance", color = 'g', rotation='vertical', verticalalignment='center', transform=ax1.transAxes)
    ax2.set_ylabel("Epsilon dominance", color = 'b')
    plt.grid()
    plt.title("Hamming distance and epsilon dominance over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HEAvg_FILE_NAME_PNG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HEAvg_FILE_NAME_SVG, bbox_inches='tight')
    fig.clf()
    plt.close()

# Plot hamming distance types over time
def plot_HType_type(outputFilePath, time, hammingTotal, hammingBinding, hammingRouting,
                    hammingTotalAdapted, hammingBindingAdapted, hammingRoutingAdapted,
                    avgHammingTotal, avgHammingBinding, avgHammingRouting,
                    maxHammingTotal, maxHammingBinding, maxHammingRouting):
    # Hamming distances
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax1.plot(time, hammingTotal, c='r', marker='s',linewidth=0.5,linestyle='--',label="HTotal")
    ax1.plot(time, hammingBinding, c='g', marker='o',linewidth=0.5,linestyle='--',label="HBind")
    ax1.plot(time, hammingRouting, c='b', marker='x',linewidth=0.5,linestyle='--',label="HRout")
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance")
    ax1.legend()
    plt.grid()
    plt.title("Hamming distances over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HTYPE_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HTYPE_FILE_NAME_PNG, bbox_inches='tight')
    plt.clf()
    plt.close()

    # Adapted Hamming distances
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax1.plot(time, hammingTotalAdapted, c='r', marker='s',linewidth=0.5,linestyle='--',label="HTotalAdapted")
    ax1.plot(time, hammingBindingAdapted, c='g', marker='o',linewidth=0.5,linestyle='--',label="HBindAdapted")
    ax1.plot(time, hammingRoutingAdapted, c='b', marker='x',linewidth=0.5,linestyle='--',label="HRoutAdapted")
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance")
    ax1.legend()
    plt.grid()
    plt.title("Adapted hamming distances over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HATYPE_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HATYPE_FILE_NAME_PNG, bbox_inches='tight')
    plt.clf()
    plt.close()

    # Average Hamming distances of design points in the current best front
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax1.plot(time, avgHammingTotal, c='r', marker='s',linewidth=0.5,linestyle='--',label="Average Hamming Total")
    ax1.plot(time, avgHammingBinding, c='g', marker='o',linewidth=0.5,linestyle='--',label="Average Hamming Binding")
    ax1.plot(time, avgHammingRouting, c='b', marker='x',linewidth=0.5,linestyle='--',label="Average Hamming Routing")
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance")
    ax1.legend()
    plt.grid()
    plt.title("Average hamming distances over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_AVGHTYPE_FILE_NAME_SVG , bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_AVGHTYPE_FILE_NAME_PNG , bbox_inches='tight')
    plt.clf()
    plt.close()

    # Max Hamming distances of design points in the current best front
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax1.plot(time, maxHammingTotal, c='r', marker='s',linewidth=0.5,linestyle='--',label="Maximum Hamming Total")
    ax1.plot(time, maxHammingBinding, c='g', marker='o',linewidth=0.5,linestyle='--',label="Maximum Hamming Binding")
    ax1.plot(time, maxHammingRouting, c='b', marker='x',linewidth=0.5,linestyle='--',label="Maximum Hamming Routing")
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance")
    ax1.legend()
    plt.grid()
    plt.title("Maximum hamming distances over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_MAXHTYPE_FILE_NAME_SVG , bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_MAXHTYPE_FILE_NAME_PNG , bbox_inches='tight')
    plt.clf()
    plt.close()

# Plot HammingTotal and Epsilon dominance (Smaller 1) with uniform time scaling and timeout marker
def plot_HEUniform_type(outputFilePath, time, hammingTotal, hammingBinding, hammingRouting, epsilonSmallerOne, timeout):
    # Hamming distance - Epsilon dominance (Smaller than one) plot
    outputFilePath = outputFilePath + "uniformScaling/"

    if not os.path.exists(outputFilePath):
        os.makedirs(outputFilePath)

    plt.ioff()
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    ax1.plot(time, hammingTotal, c='r', marker='x',linewidth=0.5,linestyle='--')
    ax2.plot(time, epsilonSmallerOne, c='b', marker='x',linewidth=0.5,linestyle='--')
    plt.axvline(x = timeout, color = 'k', label = 'Timeout')
    plt.xlim([0,950])
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance", color = 'r')
    ax2.set_ylabel("Epsilon dominance", color = 'b')
    plt.grid()
    plt.title("Hamming distance and epsilon dominance over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HE_UNIFORM_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HE_UNIFORM_FILE_NAME_PNG, bbox_inches='tight')
    fig.clf()
    plt.close()

    # Hamming distances
    plt.ioff()
    fig, ax1 = plt.subplots()
    ax1.plot(time, hammingTotal, c='r', marker='s',linewidth=0.5,linestyle='--',label="HTotal")
    ax1.plot(time, hammingBinding, c='g', marker='o',linewidth=0.5,linestyle='--',label="HBind")
    ax1.plot(time, hammingRouting, c='b', marker='x',linewidth=0.5,linestyle='--',label="HRout")
    plt.axvline(x = timeout, color = 'k', label = 'Timeout')
    plt.xlim([0,950])
    ax1.set_xlabel("Seconds")
    ax1.set_ylabel("Hamming Distance")
    ax1.legend()
    plt.grid()
    plt.title("Hamming distances over time")
    fig.canvas.start_event_loop(sys.float_info.min)  # workaround for Exception in Tkinter callback
    plt.savefig(outputFilePath + OUTPUT_HTYPE_UNIFORM_FILE_NAME_SVG, bbox_inches='tight')
    plt.savefig(outputFilePath + OUTPUT_HTYPE_UNIFORM_FILE_NAME_PNG, bbox_inches='tight')
    plt.clf()
    plt.close()


def plot(outputFilePath, inputFilePath, statusFilePath, type):
    time = []
    hammingTotal = []
    avgHammingTotal = []
    maxHammingTotal = []
    hammingBinding = []
    avgHammingBinding = []
    maxHammingBinding = []
    hammingRouting = []
    avgHammingRouting = []
    maxHammingRouting = []
    hammingTotalAdapted = []
    hammingBindingAdapted = []
    hammingRoutingAdapted = []
    epsilonSmallerOne = []
    epsilonLargerOne = []
    timeout = []

    # Read all input values from results
    with open(inputFilePath + INPUT_FILE_NAME, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        reader = csv.reader(inputFile, delimiter=' ',)
        line_count = 0
        for row in reader:
            # Skip header
            if line_count == 0:
                line_count += 1
            else:
                try:
                    time.append(float(row[1]))
                    hammingTotal.append(float(row[2]))
                    hammingBinding.append(float(row[3]))
                    hammingRouting.append(float(row[4]))
                    hammingTotalAdapted.append(float(row[5]))
                    hammingBindingAdapted.append(float(row[6]))
                    hammingRoutingAdapted.append(float(row[7]))
                    epsilonSmallerOne.append(float(row[8]))
                    epsilonLargerOne.append(float(row[9]))
                except:
                    print("error reading on file: " + inputFilePath)
                    return

        if len(time) == 0:
            return

    # Average values res
    with open(inputFilePath + INPUT_FILE_NAME_AVG, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        reader = csv.reader(inputFile, delimiter=' ', )
        line_count = 0
        for row in reader:
            # Skip header
            if line_count == 0:
                line_count += 1
            else:
                try:
                    avgHammingTotal.append(float(row[2]))
                    avgHammingBinding.append(float(row[3]))
                    avgHammingRouting.append(float(row[4]))
                except:
                    print("error reading on file: " + inputFilePath)
                    return
                        # Don't print empty images

    # Max values res
    with open(inputFilePath + INPUT_FILE_NAME_MAX, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        reader = csv.reader(inputFile, delimiter=' ', )
        line_count = 0
        for row in reader:
            # Skip header
            if line_count == 0:
                line_count += 1
            else:
                try:
                    maxHammingTotal.append(float(row[2]))
                    maxHammingBinding.append(float(row[3]))
                    maxHammingRouting.append(float(row[4]))
                except:
                    print("error reading on file: " + inputFilePath)
                    return
                    # Don't print empty images

        # Read searching time / timeout from status information
    with open(statusFilePath + STATUS_FILE_NAME, 'r') as inputFile:
        if inputFile.closed:
            print("file can not be opened: " + inputFilePath)
            return

        reader = csv.reader(inputFile, delimiter=' ',)
        line_count = 0
        for row in reader:
            try:
                timeout.append(float(row[2]))
            except:
                print("error reading on file: " + inputFilePath)
                return

        # Select which plot type shall be generated
        if type == '1':
            plot_HE_type(outputFilePath, time, hammingTotal, avgHammingTotal, maxHammingTotal, epsilonSmallerOne, epsilonLargerOne)
        elif type == '2':
            plot_HType_type(outputFilePath, time, hammingTotal, hammingBinding, hammingRouting,
                            hammingTotalAdapted, hammingBindingAdapted, hammingRoutingAdapted,
                            avgHammingTotal, avgHammingBinding, avgHammingRouting,
                            maxHammingTotal, maxHammingBinding, maxHammingRouting)
        elif type == '3':
            plot_HEUniform_type(outputFilePath, time, hammingTotal, hammingBinding, hammingRouting, epsilonSmallerOne, timeout)
        else:
            print("The input parameter didn't match any case")
            sys.exit()


def main():

    # Read the input parameter defining the output filetype
    try:
        type = sys.argv[1]
        print("Plottype", type, "has been chosen.")

    except:
        print("This script is missing one input parameter\n")
        sys.exit()    

    instances = {entry.name for entry in os.scandir(INPUT_BASE_DIR) if entry.is_dir()}
    instances = natsorted(instances)

    for instances in instances:
        casesPath = INPUT_BASE_DIR + '/' + instances
        cases = { entry.name for entry in os.scandir(casesPath ) if entry.is_dir()}
        cases = natsorted(cases)

        for case in cases:
            statusFilePath = casesPath + '/' + case + '/'
            inputFilePath = casesPath + '/' + case + '/'
            outputFilePath = casesPath + '/' + case + '/'

            plot(outputFilePath, inputFilePath, statusFilePath, type)

    exit(0)


if __name__ == '__main__':
    main()