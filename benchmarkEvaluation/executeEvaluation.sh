#!/bin/bash

echo "Extract status information"
./extractStatusInformation.sh

echo "Extract the design points"
python3 extractContentInformation.py

echo "Calculate the Indicators: Hamming similarity & Epsilon dominance"
python3 calculateIndicators.py

# echo "Create the plots: Hamming similarity & epsilon dominance over time"
# python3 HEPlot.py

# echo "Evaluate the Top 3 methods in different categories"
# python3 evaluateTop.py
