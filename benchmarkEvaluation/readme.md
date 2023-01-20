# Prerequisite
- Build library from epsilon dominance calculation by use of Makefile in **./qualityIndicators**
- Install Python package "natsort"

# Usage
## Execution script
- Execute **executeEvaluation.sh** to run all extraction and evaluation steps
- For running steps separately, see next chapter "Steps in detail"
- Afterwards, run **markdownGenerator.py** with the preferred input parameter (see next chapter "Steps in detail") to get summarized evaluation results

## Steps in detail
#### **extractStatusInformation.sh** : 
- Extracts status information for each DSE run (like solving status, time to first answer, full solving time/timeout, number of found design points)
- Information saved in **./results/path_to_case/statInfo.txt**

#### **extractContentInformation.py** :
- Extracts all design points (cost, latency, energy for each answer) as well as the corresponding solution numbers and timestamps for each DSE run
- Information saved in **./results/path_to_case/designPoints.txt**

#### **calculateIndicators.py** :
- For each answer (each child implementation) in each DSE run, it calculates the hamming similarity (compared to legacy implementation) and the epsilon dominance
- Currently evaluated child implementation saved in **./temp/answer.lp**
- Solution numbers, timestamps and results saved in **./results/path_to_case/results.txt**
- Further, it calculates the hamming similarity of the front in each time step (it only considers the nondominated design points)
- Maximum Hamming similarity of all points in the current front is saved in **./results/path_to_case/resultsHammingMax.txt**
- Average Hamming similarity over all points in the current front is saved in **./results/path_to_case/resultsHammingAverage.txt**

#### **HEPlot.py** :
- This script takes its input from **./results/path_to_case/results.txt**
- Various plots are generated and saved in **./results/path_to_case/**
- With input argument "1" : Plot HammingTotal and Epsilon dominance (2x) over time and save in **./results/path_to_case/HEPlot.\* and ./results/path_to_case/HE2Plot.\***
- With input argument "2" : Plot hamming distance types over time and save in **./results/path_to_case/HTypePlot.\* and ./results/path_to_case/HAdaptedTypePlot.\***
- With input argument "3" : Plot HammingTotal and Epsilon dominance (Smaller 1) with uniform time scaling and timeout marker and save in **./results/path_to_case/HEUniformPlot.\***

#### **evaluateTop.py** :
- Evaluates the extracted information and calculated results according to different criteria
- Takes its input from **./results/path_to_case/statInfo.txt** and **./results/path_to_case/results.txt**
- For each criteria the TOP 3 best cases are selected and printed to **./results/mdfiles/top.md** and **./results/mdfiles/topSummarized.md**

#### **evaluateFlop.py** :
- Evaluates the extracted information and calculated results according to different criteria
- Takes its input from **./results/path_to_case/statInfo.txt** and **./results/path_to_case/results.txt**
- For each criteria the FLOP 3 worst cases are selected and printed to **./results/mdfiles/flop.md** and **./results/mdfiles/flopSummarized.md**

#### **evaluateRank.py** :
- Evaluates the extracted information and calculated results according to different criteria
- Takes its input from **./results/path_to_case/statInfo.txt** and **./results/path_to_case/results.txt**
- For each criteria the ranking for all cases is evaluated and printed to **./results/mdfiles/ranks.md**
- Considering all instances, an average rank per case per category is calculated and printed to **./results/mdfiles/ranksAveraged.md** (ordered by case) and **./results/mdfiles/ranksAveragedOrdered.md** (ordered by rank)

#### **markdownGenerator.py**
- Generates a markdown file to present the summarized evaluation results
- With input argument "1" : Markdown file is ordered according to instances and contains status information per case (extracted from **./results/path_to_case/statInfo.txt**). It is saved as **./results/mdfile/status.md**, summarized in **./results/mdfile/statusSummarized.md** and average values in **./results/mdfile/statusAveraged.md**
- With input argument "2" : Markdown file is ordered according to cases and contains status information per instance (extracted from **./results/path_to_case/statInfo.txt**). It is saved as **./results/mdfile/statusV2.md**, summarized in **./results/mdfile/statusSummarizedV2.md** and average values in **./results/mdfile/statusAveragedV2.md**
- With input argument "3" : Markdown file is ordered according to instances and contains all plots per case (taken from **./results/path_to_case/*.png**). It is saved as **./results/mdfile/plots.md**
- With input argument "4" : Markdown file is ordered according to cases and contains all plots per instance (taken from **./results/path_to_case/*.png**). It is saved as **./results/mdfile/plotsV2.md**
- With input argument "5" : Markdown file is ordered according to instances and contains all plots with uniformed scaling per case (taken from **./results/path_to_case//uniformScaling/*.png**). It is saved as **./results/mdfile/plotsUniformed.md**
- With input argument "6" : Markdown file is ordered according to cases and contains all plots with uniformed scaling per instance (taken from **./results/path_to_case//uniformScaling/*.png**). It is saved as **./results/mdfile/plotsUniformedV2.md**
