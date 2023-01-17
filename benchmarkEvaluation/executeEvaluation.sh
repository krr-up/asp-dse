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
python3 HEPlot.py 1
python3 HEPlot.py 2
python3 HEPlot.py 3

echo "###############################################################"
echo "Evaluate the Top 3 methods in different categories"
python3 evaluateTop.py

echo "###############################################################"
echo "Evaluate the Flop 3 methods in different categories"
python3 evaluateFlop.py

echo "###############################################################"
echo "Evaluate the Ranking and the average rank of the cases in different categories"
python3 evaluateRank.py

echo "###############################################################"
echo "Generate Markdown files to summarize evaluation results"
python3 markdownGenerator.py 1
python3 markdownGenerator.py 2
python3 markdownGenerator.py 3
python3 markdownGenerator.py 4
python3 markdownGenerator.py 5
python3 markdownGenerator.py 6
