# Usage
## Execution script
- Execute **executeEvaluation.sh** to run all extraction and evaluation steps
- For running steps separately, see next chapter "Steps in detail"
- Afterwards, run **markdownGenerator.py** with the preferred input parameter (see next chapter "Steps in detail") to get summarized evaluation results

## Steps in detail
#### **extractStatusInformation.sh** : 
- Extracts status information for each DSE run (like solving status, time to first answer, full solving time/timeout)
- Information saved in **./results/path_to_case/statInfo.txt**

#### **extractContentInformation.py** :
- Extracts all design points (cost, latency, energy for each answer) and the corresponding timestamps for each DSE run
- Information saved in **./results/path_to_case/designPoints.txt**

#### **calculateIndicators.py** :
- For each answer (each child implementation) in each DSE run, it calculates the hamming similarity (compared to legacy implementation) and the epsilon dominance
- Currently evaluated child implementation saved in **./temp/answer.lp**
- Timestamps and results saved in **./results/path_to_case/results.txt**
- _TODO: Epsilon dominance_

#### **HEPlot.py** :
- _TODO: Create the plots "Hamming over time"_

#### **evaluateTop.py** :
- _TODO: Evaluate the "Top 3 Encodings" in different categories_

#### **markdownGenerator.py**
- Generates a markdown file to present the summarized evaluation results
- With input argument "1" : Markdown file contains status information per case (extracted from **./results/path_to_case/statInfo.txt**) and is saved as **./results/status.md**
- _TODO: Option: Show resulting pictures_
- _TODO: Option: Show Top 3 evaluations_
