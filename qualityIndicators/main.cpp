#include <iostream>
#include <fstream>
#include <dirent.h>
#include <cstring>
#include <vector>
#include <algorithm>

#include "entropy.cpp"


using namespace std;

/* Input will be read from a folder containing several fronts (Pareto-optimal vs. containing all results)
 * Input will be read into an vector<vector<vector<int>>> -> Vector of fronts which consist of an vector of entries containing a vector with a timestamp and three objective values
 *
 * Input file with time, latency, energy, cost
 * Output file with time, epsilon dominance
 */

/* Extract the specific design points (values for time, latency, energy, cost) from fronts given as input files */
void initialiseVector(vector<vector<double>> & front, string nameFileIn);
/* All fronts from a given vector of fronts are concatenated except for redundant entries which are only added once */
vector<vector<double>> concatnateVectors(const vector<vector<vector<double>>> & fronts);
/* Remove dominated entries from given vector of design points */
vector<vector<double>> paretoFilter(const vector<vector<double>> & frontsVector);
/* Calculates epsilon-dominance of a front compared to a reference front */
double epsilonDominance(const vector<vector<double>> refFront, vector<vector<double>> front);


int main (int argc,char* argv[]) {
    string pathDirIn, pathDirOut, pathFileIn, pathFileOut;
    double epsilon, ent;
    double timeMin = 0;
    double timeMax = 0;
    double epsMax = 0;
    double epsMin = numeric_limits<double>::max();
    vector<string> pathsOut, pathsIn;                       /* Vector containing paths to input / output values */
    vector<vector<vector<double>>> fronts;                  /* Will contain the fronts of all adapted DSEs per configuration */
    vector<vector<double>> front;                           /* Front of one DSE */
    vector<vector<double>> frontReference;                  /* Reference front for the epsilon dominance calculation */

    pathDirIn = "instances";
    pathDirOut = "results";

    /* Get input (design points of one front per file) */
    cout << "Reading input fronts from " << pathDirIn << "\n";

    struct dirent *file;
    DIR *dir = opendir(&pathDirIn[0]);
    while((file = readdir(dir)))
    {
        if (strcmp(".",file->d_name)==0)  continue;
        if (strcmp("..",file->d_name)==0)  continue;
        pathFileIn = pathDirIn + "/" + file->d_name;
        pathFileOut = pathDirOut + "/" + file->d_name;
        pathsIn.push_back(pathFileIn);
        pathsOut.push_back(pathFileOut);

        initialiseVector(front, pathFileIn);
                
        fronts.push_back(front);
        front.clear();

        cout << fronts.at(0).size() << " lines with " << fronts.at(0).at(0).size() << " entries have been read.\n";
    }
    closedir(dir);

    cout << fronts.size() << " files have been read.\n\n";

    /* Create reference vector */
    front = concatnateVectors(fronts);
    frontReference = paretoFilter(front);

    cout << "Reference front: \n";

    for (int i = 0; i < frontReference.size(); i++)
    {
        cout << "  ";
        for (int j = 0; j < frontReference.at(i).size(); j++)
        {
            cout << frontReference.at(i).at(j) << " ";
        }
        cout << "\n";
    }
    cout << "\n";

    /* Calculation of the epsilon-dominance and the entropy
     * - For every design point in every front
     * - Values with time stamps are saved in files 
     * - (Output: timestamp epsilon-dominance entropy)
     * - Maximum epsilon-dominance is evaluated
     */
    
    for(int i = 0; i < fronts.size(); i++) {
        cout << "Calculation of epsilon-dominance and entropy for " << pathsIn.at(i) << "\n";
        front.clear();
        ofstream fileOut(pathsOut.at(i), ofstream::out);

        for(int j = 0; j < fronts.at(i).size(); j++)
        {
            front.push_back(fronts.at(i).at(j));
            epsilon = epsilonDominance(frontReference, front);
            if(epsilon > epsMax)
                epsMax = epsilon;
            if(epsilon < epsMin)
                epsMin = epsilon;
            
            ent = entropy(front,10);
            
            fileOut << front.at(j).at(0) << " " << epsilon << " " << ent << "\n";
        }

        fileOut.close();
    
        cout << "result was written to " << pathsOut.at(i) << " per timestamp.\n";
    }

    /* Configuration of the gnuplot_script */
    //TODO

    return 0;
}

void initialiseVector(vector<vector<double>> & front, string nameFileIn)
{
    vector<double> values;                                  /* Vector containing input values (time, latency, energy, cost) */
    double time, latency, energy, cost;
    int count = 0;
    string line, entry;
    ifstream fileIn (nameFileIn);
    cout << "file " << nameFileIn << " found \n";

    /* Get values from file */
    if (fileIn.is_open())
    {
        while ( getline(fileIn,line) )
        {
            string delimiter = " ";
            size_t pos = 0;
            while ((pos = line.find(delimiter)) != string::npos) {
                entry = line.substr(0, pos);
                line.erase(0, pos + delimiter.length());
                switch (count)
                {
                case 0:
                    time = stod(entry);
                    values.push_back(time);
                    count++;
                    break;
                case 1:
                    latency = stod(entry);
                    values.push_back(latency);
                    count++;
                    break;
                case 2:
                    energy = stod(entry);
                    values.push_back(energy);
                    count++;
                    break;
                default:
                    break;
                }
            }
            if((pos = line.find(delimiter)) == string::npos && count == 3)
            {
                entry = line;
                cost = stod(entry);
                values.push_back(cost);
                count=0;
            }
            front.push_back(values);
            values.clear();
        }
    }
    fileIn.close();

    return;
}

vector<vector<double>> concatnateVectors(const vector<vector<vector<double>>> & fronts)
{
    vector<vector<double>> fronts_;

    for ( int i = 0; i < fronts.size(); i++)
    {
        for (int j = 0; j < fronts.at(i).size(); j++)
        {
            if(find(fronts_.begin(), fronts_.end(), fronts.at(i).at(j)) == fronts_.end()) 
            fronts_.push_back(fronts.at(i).at(j));
        }
        
    }
    
    return fronts_;
}

/* Given a vector of fronts (frontsVector), it creates a new vector containing the concatenated list of all fronts but all dominated entries are removed */
vector<vector<double>> paretoFilter(const vector<vector<double>> & frontsVector)
{
    vector<vector<double>> ref_;

    for (auto i = 0; i < frontsVector.size(); i++) 
    {
        auto dominated_ = false;
        for (auto j = i+1; j < frontsVector.size(); j++) 
        {
            if (frontsVector[i][1] >= frontsVector[j][1] && frontsVector[i][2] >= frontsVector[j][2] && 
                    frontsVector[i][3] >= frontsVector[j][3]) 
            {
                dominated_ = true;
                break;
            }
        }

        if (!dominated_) 
        {
            ref_.emplace_back(frontsVector[i]);
        }
    }
	
    return ref_;
}

/* Returns the epsilonDominance of a front (front) compared to a reference front (ref_front) */
double epsilonDominance(const vector<vector<double>> refFront, vector<vector<double>> front)
{
    double max_ = 0;
    for (auto z2_ : refFront) 
    {
	double min_ = numeric_limits<double>::infinity();
        for (auto z1_ : front)
        {
            double maxObjective_ = 0;
            maxObjective_ = max<double>((double) z1_[1] / (double) z2_[1], (double) z1_[2] / (double) z2_[2]);
            maxObjective_ = max<double>(maxObjective_, (double) z1_[3] / (double) z2_[3]);
            min_ = min<double>(min_, maxObjective_);
	}
            max_ = max<double>(max_, min_);
    }
	
    return max_;
}
