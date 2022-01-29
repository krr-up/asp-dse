#include <iostream>

#include "../include/changeSpec.hpp"
#include "../include/loadsave.hpp"
#include "../include/specificationGraph.hpp"
// #include <dirent.h>
#include <filesystem>
#include <string>

using namespace DSE;

/* Main takes three parameters
 * \param option a string (then converted to int) representing the selected option about the kind of change
 *        it can either be  0   exchange elements (change charateristics)
 *                          1   add elements
 *                          2   delete elements
 *                          3   decide randomly for every element to be changed
 * \param perc_tasks a string (then converted to int) representing the percentage of tasks to be changed
 * \param perc_processors a string (then converted to int) representing the percentage of processors to be changed
 * \param instances_num a string (then converted to int) representing the number of modified instances to generate
 * \param seed a string (then converted to int) representing the random seed
 */

int main(int argc, char *argv[]) {
    /* Get parameters */
    int option, perc_tasks, perc_processors, instances_num, seed;

    if (argc == 6) {
        option = stoi(argv[1]);
        perc_tasks = stoi(argv[2]);
        perc_processors = stoi(argv[3]);
        instances_num = stoi(argv[4]);
        seed = stoi(argv[5]);

        if ((perc_tasks < 0) || (perc_tasks > 100)) {
            cout << "The second input (perc_task) has to be between or equal to 0 and 100\n";
            return 1;
        }
        if ((perc_processors < 0) || (perc_processors > 100)) {
            cout << "The third input (perc_processors) has to be between or equal to 0 and 100\n";
            return 1;
        }
    } else {
        std::cout << "Wrong number of main parameters\n";
        return 1;
    }

    bool status;

    // string path_in = "../instanceGenerator/benchmarks_format_2021_11";
    string path_in = "../test/";
    string file_in, file_out, file_name;

    if (!std::filesystem::exists(path_in)) {
        std::cerr << "Path " << path_in << " does not exist." << std::endl;
        exit(1);
    }

    for (const auto &file : std::filesystem::directory_iterator(path_in)) {
        /* Set random seed */
        srand(seed);

        /* Get all child instances from the directory */
        file_in = file.path().generic_string();
        file_name = file.path().filename().generic_string();
        if (file.is_directory()) continue;
        if (file_name.find("_p") != string::npos) continue;
        if (file_name.find("m") != string::npos) continue;

        std::cout << file << std::endl;
        /* Create several modified versions of current child instance */
        for (int i = 0; i < instances_num; i++) {
            std::cout
                << "##################################################################################################"
                   "###########################\n";
            file_name = file.path().generic_string();
            file_out = file_name.insert(file_name.rfind("."), "_m" + to_string(i));

            std::cout << "file_in: " << file_in << " and file_out: " << file_out << "\n";

            /* Create a specificationGraph object */
            SpecificationGraph *specification = new SpecificationGraph("0", "", 0);

            /* Read out all elements from a specification and fill information in the object structure */
            std::cout << "Read out all elements from the specification\n";
            status = LoadSaveOperations::loadSpecASPByFile(specification, file_in);

            if (!status) {
                std::cout << "An error occurred during loadSpecASPByFile";
            }

            /* Make the random changes */
            std::cout << "Select randomly an amount of elements depending on task percentage: " << perc_tasks
                      << "%, processor percentage: " << perc_processors << "% and random seed: " << seed
                      << " and make random changes\n";
            std::map<int, Task *> task_list = ChangeSpecOperations::select_tasks(specification, perc_tasks);

            std::map<int, Resource *> processor_list =
                ChangeSpecOperations::select_processors(specification, perc_processors);

            switch (option) {
                case 0:
                    ChangeSpecOperations::exchange_tasks(specification, task_list);
                    ChangeSpecOperations::exchange_processors(specification, processor_list);
                    break;
                case 1:
                    ChangeSpecOperations::add_tasks(specification, task_list);
                    ChangeSpecOperations::add_processors(specification, processor_list);
                    break;
                case 2:
                    ChangeSpecOperations::delete_tasks(specification, task_list);
                    ChangeSpecOperations::delete_processors(specification, processor_list);
                    break;
                case 3:
                    ChangeSpecOperations::combined_changes_tasks(specification, task_list);
                    ChangeSpecOperations::combined_changes_processors(specification, processor_list);
                    break;
                default:
                    cout << "Wrong option was set\n";
                    break;
            }
                /* Print out new specification */
                std::cout << "Save the new specification\n";
                status = LoadSaveOperations::saveSpecASPInFile(specification, file_out);

                if (!status) {
                    std::cout << "An error occurred during saveSpecASPInFile";
                }
        }
    }
    return 0;
}