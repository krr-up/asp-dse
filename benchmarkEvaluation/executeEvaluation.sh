#!/bin/bash

# This script runs all possible steps for the evaluation of the experiments

echo "###############################################################"
echo "Extract status information"
./extractStatusInformation.sh

echo "###############################################################"
echo "Extract the design points"
python3 extractContentInformation.py

echo "###############################################################"
echo "Calculate the Indicators: Hamming similarity & Epsilon dominance"
# processOutput.txt contains the resulting reference fronts per instance
python3 -u calculateIndicators.py > results/processOutput.txt 2> results/processErrors.txt

echo "###############################################################"
echo "Create the plots: Hamming similarity & epsilon dominance over time"
python3 HEPlot.py

echo "###############################################################"
echo "Evaluate the Top 3 methods in different categories and create top.md"
python3 evaluateTop.py
