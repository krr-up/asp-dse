
# Quality Indicators

- Calculation of the epsilon dominance and the entropy of given fronts per timestamp.

In `main.cpp` **pathDirOut** and **pathDirIn** needs to be set
 - In the directory **pathDirIn** are several files (each file containing the resulting front of a DSE)
		 - Content of input files: Each line contains the values of one design point consisting of time, latency, energy and cost (values are separated by spaces)
- In the directory **pathDirOut** there will be a file for each DSE (each input file from pathDirIn)
		- Content of output files: Each line contains the evaluation of one design point consisting of time, epsilon-dominance and entropy (values are separated by spaces)
