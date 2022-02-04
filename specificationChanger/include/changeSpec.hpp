#pragma once
#include "specificationGraph.hpp"
#include "applicationGraph.hpp"
#include "task.hpp"
#include "resource.hpp"
#include "mapping.hpp"
#include <iostream>
#include <map>
#include <string>
#include <algorithm>
#include <vector>

using namespace std;
using namespace DSE;

class ChangeSpecOperations {
    public:
        /* Exchange the given tasks (improve characteristics) */
        static void exchange_tasks(DSE::SpecificationGraph *specification, vector<Task *> task_list, int percentage);
        /* Exchange the given processors (improve characteristics) */
        static void exchange_processors(DSE::SpecificationGraph *specification, vector<Resource *> processor_list, int percentage);
        /* Add a successor each to the given tasks */
        static void add_tasks(DSE::SpecificationGraph *specification, vector<Task *> task_list, int percentage);
        /* Add a neighbour (in z direction) each to the given processors */
        static void add_processors(DSE::SpecificationGraph *specification, vector<Resource *> processor_list, int percentage);
        /* Delete the given tasks */
        static void delete_tasks(DSE::SpecificationGraph *specification, vector<Task *> task_list, int percentage);
        /* Delete the given processors, router structure remains */
        static void delete_processors(DSE::SpecificationGraph *specification, vector<Resource *> processor_list, int percentage);
        /* Do random selected changes on the given tasks */
        static void combined_changes_tasks(DSE::SpecificationGraph *specification, vector<Task *> task_list, int percentage);
        /* Do random selected changes on the the given processors */
        static void combined_changes_processors(DSE::SpecificationGraph *specification, vector<Resource *> processor_list, int percentage);

        /* Select randomly a certain percentage of tasks */
        static vector<Task *> select_tasks(DSE::SpecificationGraph *specification);
        /* Select randomly a certain percentage of processors */
        static vector<Resource *> select_processors(DSE::SpecificationGraph *specification);
};