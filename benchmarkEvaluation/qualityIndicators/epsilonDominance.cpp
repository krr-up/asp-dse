// #include "Python.h"
#include "epsilonDominance.h"

#include <fstream>
#include <dirent.h>
#include <cstring>
#include <algorithm>

using namespace std;

void welcome(){
    cout << "Hello world!" << endl;
}

arrayStruct initializeVector(char* nameDirIn)
{
    string pathDirIn = (string) nameDirIn;
    string pathFileIn;
    vector<string> pathsIn;                 /* Vector containing paths to input values */
    vector<vector<double>> front;           /* Vector containing the front of one DSE */
    vector<double*>* frontReference;        /* Reference front for the epsilon dominance calculation */
    vector<vector<vector<double>>> fronts;  /* Vector containing the fronts of all DSEs per instance */
    vector<double> values;                  /* Vector containing input values (solutionNumber, time, latency, energy, cost) */
    double solutionNumber, time, latency, energy, cost;
    int count = 0;
    string line, entry;

    // int dpCount = 0; // For checking the resulting vectors (Count all design points)

    /* Open current directory */
    cout << "\nCurrent directory: " << pathDirIn << "\n";

    struct dirent *file;
    DIR *dir = opendir(&pathDirIn[0]);
    while((file = readdir(dir)))
    {
        if (strcmp(".",file->d_name)==0)  continue;
        if (strcmp("..",file->d_name)==0)  continue;

        pathFileIn = pathDirIn + "/" + file->d_name + "/designPoints.txt";
        // cout << "Current file: " << pathFileIn << endl;
        pathsIn.push_back(pathFileIn);

        /* Open curent file */
        ifstream fileIn (pathFileIn);
        if (fileIn.is_open())
        {
            while ( getline(fileIn,line) )
            {
                /* Ignore header line */
                if (line.find("cost") != string::npos) continue;

                /* Get input values (design points of one front per file in subdirectories) */
                string delimiter = " ";
                size_t pos = 0;
                while ((pos = line.find(delimiter)) != string::npos) {
                    entry = line.substr(0, pos);
                    line.erase(0, pos + delimiter.length());
                    switch (count)
                    {
                    case 0:
                        solutionNumber = stod(entry);
                        values.push_back(solutionNumber);
                        count++;
                        break;
                    case 1:
                        time = stod(entry);
                        values.push_back(time);
                        count++;
                        break;
                    case 2:
                        cost = stod(entry);
                        values.push_back(cost);
                        count++;
                        break;
                    case 3:
                        latency = stod(entry);
                        values.push_back(latency);
                        count++;
                        break;
                    default:
                        break;
                    }
                    if((pos = line.find(delimiter)) == string::npos && count == 4)
                    {
                        entry = line;
                        energy = stod(entry);
                        values.push_back(energy);
                        count=0;
                    }
                }

                /* Check read values */
                // cout << "results: " << solutionNumber << " " << time << " " << cost << " " << latency << " " << energy << endl;
                front.push_back(values);
                values.clear();
            }
        }
        fileIn.close();
        
        fronts.push_back(front);
        front.clear();

        /* Check that fronts contains all the results per instance */
        /* 
        cout << fronts.at(dpCount).size() << " lines "; 
        if (fronts.at(dpCount).size() > 0)
            cout << "with " << fronts.at(dpCount).at(0).size() << " entries have been read." << endl;
        else
            cout << "with 0 entries have been read." << endl;
        dpCount++; 
        */
    }
    closedir(dir);

    cout << fronts.size() << " files have been read.\n";

    /* Create reference vector */
    front = concatenateVectors(fronts);
    frontReference = paretoFilter(front);

    /* For checking the resulting reference front */
    /*
    cout << "Reference front: \n";

    for (int i = 0; i < frontReference->size(); i++)
    {
        cout << "  ";
        for (int j = 0; j < 3; j++)
        {
            cout << frontReference->at(i)[j] << " ";
        }
        cout << "\n";
    }
    cout << "\n";
    */
    
    arrayStruct refStruct;
    refStruct.size = frontReference->size();
    refStruct.content = frontReference->data();

    return refStruct;

   /* 
    ** Instead of using a vector and converting it to an array to return it to Python, a PyObject / PyList can be used
    ** The handling of the PyObject is easier
    ** The use of C++ functions allows the reusability of this code (not only in Python projects)
    ** In Python use of ctypes.py_object needed
    ** In Makefile use of  -I/usr/include/python3.9 in CFLAGS is needed

    PyGILState_STATE gstate = PyGILState_Ensure();

    PyObject* result = PyList_New(0);
    PyList_Append(result, PyFloat_FromDouble(111.0));
    PyList_Append(result, PyFloat_FromDouble(222.0));

    PyGILState_Release(gstate);
    return result;
    */
}

void freeVector(arrayStruct structToBeFree)
{
    for(int i = 0; i < structToBeFree.size; i++)
    {
        free(structToBeFree.content[i]);
    }
    free(structToBeFree.content);
}

/* Given a vector of fronts (frontsVector), it creates a new vector containing the concatenated list of all relevant values but all redundant entries are removed */
vector<vector<double>> concatenateVectors(const vector<vector<vector<double>>> & fronts)
{
    vector<vector<double>> fronts_;
    vector<double> values;

    for ( int i = 0; i < fronts.size(); i++)
    {
        for (int j = 0; j < fronts.at(i).size(); j++)
        {
            /* Get the relevant values for the reference vector: cost, latency, energy */
            if(fronts.at(i).at(j).at(2) != -1 && fronts.at(i).at(j).at(3) != -1 && fronts.at(i).at(j).at(4) != -1)
            {
                values.push_back(fronts.at(i).at(j).at(2));
                values.push_back(fronts.at(i).at(j).at(3));
                values.push_back(fronts.at(i).at(j).at(4));

                if(find(fronts_.begin(), fronts_.end(), values) == fronts_.end()) 
                    fronts_.push_back(values);

                values.clear();
            }
        }
    }
    
    cout << "Size of concatenated front: " << fronts_.size() << endl;
    return fronts_;
}

/* Given a vector of fronts (frontsVector), it creates a new vector containing all entries except for the dominated entries which are removed */
vector<double*>* paretoFilter(const vector<vector<double>> & frontsVector)
{
    vector<double*>* ref_ = new vector<double*>();

    for (auto i = 0; i < frontsVector.size(); i++) 
    {
        auto dominated_ = false;
        for (auto j = 0; j < frontsVector.size(); j++) 
        {
            if(i==j)
                continue;
            if (frontsVector[i][0] >= frontsVector[j][0] && frontsVector[i][1] >= frontsVector[j][1] && 
                    frontsVector[i][2] >= frontsVector[j][2]) 
            {
                dominated_ = true;
                break;
            }
        }

        if (!dominated_) 
        {
            vector<double>* tempFront = new vector<double>(frontsVector[i]);
            ref_->emplace_back(tempFront->data());
        }
    }

    cout << "Size of reference front: " << ref_->size() << endl;
    return ref_;
}

/* Returns the epsilonDominance of a front (front) compared to a reference front (ref_front) */
double epsilonDominance(const arrayStruct refFront, arrayStruct front)
{
    double max_ = 0;
    for (int i = 0; i < front.size; i++) 
    {
        auto z2_ = front.content[i];
        double min_ = numeric_limits<double>::infinity();
        for (int j = 0; j < refFront.size; j++)
        {
            auto z1_ = refFront.content[j];
            double maxObjective_ = 0;
            maxObjective_ = max<double>((double) z1_[0] / (double) z2_[0], (double) z1_[1] / (double) z2_[1]);
            maxObjective_ = max<double>(maxObjective_, (double) z1_[2] / (double) z2_[2]);
            min_ = min<double>(min_, maxObjective_);
        }
        max_ = max<double>(max_, min_);
    }
    	
    return max_;
}
