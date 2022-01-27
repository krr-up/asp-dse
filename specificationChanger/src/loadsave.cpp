#include "../include/loadsave.hpp"

#include <sstream>
#include <string>
#include <vector>
using namespace DSE;

string configuration = "";

std::vector<std::string> getArguments(std::string string) {
    std::vector<std::string> arguments;
    auto index = string.find_first_of('('), arg_start = index + 1;
    int open = 0;
    if (index != -1) {
        open = 1;
    }
    while (open > 0) {
        auto comma = string.find_first_of(',', index + 1);
        auto paranthesisOpen = string.find_first_of('(', index + 1);
        auto paranthesisClose = string.find_first_of(')', index + 1);
        if (paranthesisClose == -1) {
            return arguments;  // ERROR
        }
        if (comma == -1) {
            comma = string.size();
        }
        if (paranthesisOpen == -1) {
            paranthesisOpen = string.size();
        }
        if (comma < paranthesisOpen && comma < paranthesisClose && open == 1) {
            arguments.push_back(string.substr(arg_start, comma - arg_start));
            arg_start = comma + 1;
        } else if (paranthesisOpen < comma && paranthesisOpen < paranthesisClose) {
            open++;
        } else if (paranthesisClose < comma && paranthesisClose < paranthesisOpen) {
            if (--open == 0) {
                auto tmp = string.substr(arg_start, paranthesisClose - arg_start);
                if (!tmp.empty()) arguments.push_back(tmp);
            }
        }
        // index = qMin(comma, qMin(paranthesisClose, paranthesisOpen));
        index = std::min(comma, std::min(paranthesisClose, paranthesisOpen));
    }

    return arguments;
}

std::string getArgument(std::string string, int pos) { return getArguments(string).at(pos); }

std::string getName(std::string string) {
    auto index = string.find_first_of('(');
    if (index == -1) return string;
    auto ret = string.substr(0, index);
    return ret;
}

std::vector<std::string> split(std::string string, char sep) {
    std::vector<std::string> strings;
    std::istringstream f(string);
    std::string s;
    while (std::getline(f, s, sep)) {
        if (!s.empty()) strings.push_back(s);
    }
    return strings;
}

void LoadSaveOperations::loadSpecASP(DSE::SpecificationGraph *specification, list<string> lines) {
    Mapping::resetID();

    // Read the applications
    for (const string &line : lines) {
        /* Get configuration name */
        if (line.find("configuration") == 0) {
            string _name = "";
            for (int i = 0; i < line.find('.'); i++) {
                _name = _name + line.at(i);
            }
            configuration = _name;
            specification->setConfiguration(configuration);
            /*TODO this variable is taken for all following cases
             * because it should be equally set for all elements
             * in the specification
             * -> probably reading it out in each case and comparing
             * content could be needed for avoiding inconsistent values
             */
        }
    }

    specification->setArchitectureGraph(new ArchitectureGraph("0", configuration));

    for (const string &line : lines) {
        auto name = getName(line);
        auto arguments = getArguments(line);
        if (name == "application") {
            auto applicationGraph = new ApplicationGraph(arguments[0], configuration);
            specification->addApplicationGraph(arguments[0], applicationGraph);
        } else if (name == "router") {
            auto id = arguments[0];
            auto res = new Router(id, configuration);
            specification->getArchitectureGraph()->addResource(id, res);

            res->setAttribute("posX", arguments[1]);
            res->setAttribute("posY", arguments[2]);
            res->setAttribute("posZ", arguments[3]);
        } else if (name == "processor") {
            auto id = arguments[0];
            auto res = new Resource(id, configuration);
            specification->getArchitectureGraph()->addResource(id, res);

            res->setAttribute("posX", arguments[1]);
            res->setAttribute("posY", arguments[2]);
            res->setAttribute("posZ", arguments[3]);
        }
    }

    for (const string &line : lines) {
        auto name = getName(line);
        auto arguments = getArguments(line);
        if (name == "comm") {
            /* Get message name */
            auto id = arguments[0];
            auto application = arguments[1];

            auto applicationGraph = specification->getApplicationGraphs().at(application);
            applicationGraph->addMessage(id, new Message(id, configuration));
        } else if (name == "task") {
            /* Get task name */
            auto id = arguments[0];
            auto application = arguments[1];

            auto applicationGraph = specification->getApplicationGraphs().at(application);
            applicationGraph->addTask(id, new Task(id, configuration));
        } else if (name == "staticPower") {
            /* Get value of staticPower */
            auto id = arguments[0];
            auto power = arguments[1];
            Node *res = specification->getArchitectureGraph()->getResources().at(id);
            res->setAttribute("staticPower", power);
        } else if (name == "resourceCost") {
            /* Get value of resourceCost */
            auto id = arguments[0];
            auto cost = arguments[1];
            Node *res = specification->getArchitectureGraph()->getResources().at(id);
            res->setAttribute("resourceCost", cost);
        } else if (name == "link") {
            /* Get link name */
            auto id = arguments[0];
            auto res1_id = arguments[1];
            auto res2_id = arguments[2];

            Node *res1 = specification->getArchitectureGraph()->getResources().at(res1_id),
                 *res2 = specification->getArchitectureGraph()->getResources().at(res2_id);
            specification->getArchitectureGraph()->addEdge(new Link(id, configuration, res1, res2));
        } else if (name == "period") {
            int period = stoi(arguments[0]);
            specification->setPeriod(period);
        }
    }
    for (const string &line : lines) {
        auto name = getName(line);
        auto arguments = getArguments(line);
        if (name == "map") {
            /* Get mapping name */
            auto id = arguments[0];
            auto task_id = arguments[1];
            auto res_id = arguments[2];

            Task *task;
            for (const auto &application : specification->getApplicationGraphs()) {
                auto tasks = application.second->getTasks();
                if (tasks.find(task_id) != tasks.end()) {
                    task = tasks.at(task_id);
                    break;
                }
            }

            Resource *res = specification->getArchitectureGraph()->getResources().at(res_id);
            specification->addMapping(id, new Mapping(id, configuration, task, res));
        } else if (name == "send") {
            /* Get application name */
            auto task_id = arguments[0];
            auto comm_id = arguments[1];

            Task *task;
            Message *comm;
            ApplicationGraph *applicationGraph;
            for (const auto &application : specification->getApplicationGraphs()) {
                auto tasks = application.second->getTasks();
                if (tasks.find(task_id) != tasks.end()) {
                    task = tasks.at(task_id);
                    // Message has to be in the same application - otherwise, something is wrong
                    comm = application.second->getMessages().at(comm_id);
                    applicationGraph = application.second;
                    break;
                }
            }
            applicationGraph->addEdge(new Dependency(task, comm));
        } else if (name == "read") {
            /* Get application name */
            auto task_id = arguments[0];
            auto comm_id = arguments[1];

            Task *task;
            Message *comm;
            ApplicationGraph *applicationGraph;
            for (const auto &application : specification->getApplicationGraphs()) {
                auto tasks = application.second->getTasks();
                if (tasks.find(task_id) != tasks.end()) {
                    task = tasks.at(task_id);
                    // Message has to be in the same application - otherwise, something is wrong
                    comm = application.second->getMessages().at(comm_id);
                    applicationGraph = application.second;
                    break;
                }
            }
            applicationGraph->addEdge(new Dependency(comm, task));
        } else if (name == "routingDelay" || name == "routingEnergy") {
            int delay = stoi(arguments[0]);
            for (auto *link : specification->getArchitectureGraph()->getEdges()) {
                link->setAttribute(name, arguments[0]);
            }
            specification->getArchitectureGraph()->setAttribute(name, arguments[0]);
        }
        // else if (name == "routingEnergy") {
        //     int delay = stoi(arguments[0]);
        //     for (auto *link : specification->getArchitectureGraph()->getEdges()) {
        //         link->setAttribute("routingEnergy", arguments[0]);
        //     }
        // 	specification->getArchitectureGraph()->setAttribute(name, arguments[0]);
        // }
    }
    for (const string &line : lines) {
        auto name = getName(line);
        auto arguments = getArguments(line);
        if (name == "executionTime" || name == "dynamicEnergy") {
            auto id = arguments[0];
            auto value = arguments[1];
            Mapping *map = specification->getMappings().at(id);
            map->setAttribute(name, value);
        }
        // else if (line.find("dynamicEnergy") == 0) {
        // }
    }
}

bool LoadSaveOperations::loadSpecASPByFile(DSE::SpecificationGraph *specification, string filename) {
    ifstream file_in(filename);
    if (file_in.is_open()) {
        list<string> lines;
        string line;
        while (getline(file_in, line)) {
            lines.push_back(line);
        }
        file_in.close();
        loadSpecASP(specification, lines);
        return true;
    }
    cout << "Error: Cannot open file\n";
    return false;
}

bool LoadSaveOperations::saveSpecASPInFile(DSE::SpecificationGraph *specification, string filename) {
    ofstream file_out(filename);
    list<string> lines;

    saveSpecASP(specification, &lines);

    if (file_out.is_open()) {
        for (const auto &line : lines) {
            file_out << line << "\n";
        }
        file_out.close();
        return true;
    }
    cout << "Error: Cannot open file\n";
    return false;
}

void LoadSaveOperations::saveSpecASP(DSE::SpecificationGraph *specification, list<string> *lines) {
    /* Get configuration element */
    // lines->push_back(configuration + ".");

    /* Get application elements */
    for (auto application : specification->getApplicationGraphs()) {
        lines->push_back("application(" + application.first + ").");
    }

    /* Get task elements */
    for (auto application : specification->getApplicationGraphs()) {
        for (auto task : application.second->getTasks()) {
            lines->push_back("task(" + task.first + "," + application.second->getID() + ").");
        }
    }

    /* Get message elements */
    for (auto application : specification->getApplicationGraphs()) {
        for (auto message : application.second->getMessages()) {
            lines->push_back("comm(" + message.first + "," + application.second->getID() + ").");
        }
    }

    /* Get dependency elements (edges from applicationGraph) */
    string first = "";
    string second = "";
    for (auto application : specification->getApplicationGraphs()) {
        for (auto dependency : application.second->getEdges()) {
            if (dependency->sourceNode()->getType() == Node::NodeType::Task) {
                first = dependency->sourceNode()->getID();
                second = dependency->destNode()->getID();
                lines->push_back("send(" + first + "," + second + ").");
            } else if (dependency->sourceNode()->getType() == Node::NodeType::Message) {
                first = dependency->destNode()->getID();
                second = dependency->sourceNode()->getID();
                lines->push_back("read(" + first + "," + second + ").");
            }
        }
    }

    /* Get resource elements and its characteristics */
    auto architecture = specification->getArchitectureGraph();
    for (auto resource : architecture->getResources()) {
        string name = resource.first;
        // name.erase(name.length() - 1);
        string posX = resource.second->getAttribute("posX");
        string posY = resource.second->getAttribute("posY");
        string posZ = resource.second->getAttribute("posZ");
        if (resource.second->getType() == Node::NodeType::Resource) {
            lines->push_back("processor(" + name + "," + posX + "," + posY + "," + posZ + ").");
        } else {
            lines->push_back("router(" + name + "," + posX + "," + posY + "," + posZ + ").");
        }

        string resourceCost = resource.second->getAttribute("resourceCost");
        string staticPower = resource.second->getAttribute("staticPower");
        lines->push_back("resourceCost(" + resource.first + "," + resourceCost + ").");
        lines->push_back("staticPower(" + resource.first + "," + staticPower + ").");
    }

    /* Get link elements (edges from architectureGraph) */
    for (auto link : architecture->getEdges()) {
        lines->push_back("link(" + link->getID() + "," + link->sourceNode()->getID() + "," + link->destNode()->getID() +
                         ").");
    }

    /* Get mapping elements and its characteristics */
    for (auto mapping : specification->getMappings()) {
        string ID = mapping.second->getID();
        string TID = mapping.second->getTask()->getID();
        string RID = mapping.second->getResource()->getID();
        lines->push_back("map(" + ID + "," + TID + "," + RID + ").");

        string executionTime = mapping.second->getAttribute("executionTime");
        string dynamicEnergy = mapping.second->getAttribute("dynamicEnergy");
        lines->push_back("executionTime(" + ID + "," + executionTime + ").");
        lines->push_back("dynamicEnergy(" + ID + "," + dynamicEnergy + ").");
    }

    /* Get period element and routing characteristic */
    string conf = "";
    for (int i = 1; i < configuration.find(')') - configuration.find('('); i++) {
        conf = conf + configuration.at(configuration.rfind('(') + i);
    }
    lines->push_back("period(" + to_string(specification->getPeriod()) + ").");
    string routingDelay = architecture->getEdges().front()->getAttribute("routingDelay");
    string routingEnergy = architecture->getEdges().front()->getAttribute("routingEnergy");
    lines->push_back("routingDelay(" + routingDelay + ").");
    lines->push_back("routingEnergy(" + routingEnergy + ").");
}