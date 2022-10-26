#include <iostream>
#include <vector>

using namespace std;

typedef struct arrayStruct {
    int size;
    double** content;
} arrayStruct;

extern "C" {
    void welcome();
    /* Extract the specific design points (values for time, latency, energy, cost) from fronts given as input files */
    arrayStruct initializeVector(char* nameDirIn);
    /* Free the memory which was allocated for the returnStruct in function initializeVector */
    void freeVector(arrayStruct structToBeFree);
    /* All fronts from a given vector of fronts are concatenated except for redundant entries which are only added once */
    vector<vector<double>> concatenateVectors(const vector<vector<vector<double>>> & fronts);
    /* Remove dominated entries from given vector of design points */
    vector<double*>* paretoFilter(const vector<vector<double>> & frontsVector);
    /* Calculates epsilon-dominance of a front compared to a reference front */
    double epsilonDominance(const arrayStruct refFront, arrayStruct front);
}