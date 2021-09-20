
# Solution Checker

Given a system specification, a design space exploration (DSE) is run to obtain possible system implementations. The *Solution Checker* presents a tool which is used to check if these implementations are valid solutions and if their characteristics have been calculated correctly. 

## Execution of the tool

	clingo encoding/* [IMPLEMENTATION] [SPECIFICATION]
The tool checks if a given implementation is valid concerning a given specification.

## Additional scripts

 - **scripts/getFront.sh** : Given the output of a DSE (input file), it extracts the resulting Pareto optimal front (output file) 
 - **scripts/selectImpl.sh** : Given a Pareto optimal front (input file), it extracts a certain implementation (output file)
 (further information about the execution of these scripts can be found in the respective file)
 
