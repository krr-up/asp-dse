#include "changeSpec.hpp"

/* Exchange the given tasks (improve characteristics) */
void ChangeSpecOperations::exchange_tasks(DSE::SpecificationGraph *specification, map<int, Task *> task_list) {
    string task_id;
    string executionTime, dynamicEnergy;

    cout << "Going to exchange selected tasks\n";
    for (auto task : task_list) {
        task_id = task.second->getID();
        for (auto mapping : specification->getMappings()) {
            if (mapping.second->getTask()->getID() == task_id) {
                executionTime = mapping.second->getAttribute("executionTime");
                executionTime = to_string(stoi(executionTime) / 2);
                dynamicEnergy = mapping.second->getAttribute("dynamicEnergy");
                dynamicEnergy = to_string(stoi(dynamicEnergy) / 2);

                mapping.second->changeAttribute("executionTime", executionTime);
                mapping.second->changeAttribute("dynamicEnergy", dynamicEnergy);
            }
        }
    }
}

/* Exchange the given processors (improve characteristics) */
void ChangeSpecOperations::exchange_processors(DSE::SpecificationGraph *specification,
                                               map<int, Resource *> processor_list) {
    string resourceCost, staticPower;

    cout << "Going to exchange selected processors\n";
    for (auto processor : processor_list) {
        resourceCost = processor.second->getAttribute("resourceCost");
        resourceCost = to_string(stoi(resourceCost) / 2);
        staticPower = processor.second->getAttribute("staticPower");
        staticPower = to_string(stoi(staticPower) / 2);

        processor.second->changeAttribute("resourceCost", resourceCost);
        processor.second->changeAttribute("staticPower", staticPower);
    }
}

/* Add a successor each to the given tasks */
void ChangeSpecOperations::add_tasks(DSE::SpecificationGraph *specification, map<int, Task *> task_list) {
    string task_name, message_name;
    string configuration, application_num;
    ApplicationGraph *application;

    cout << "Going to add a successor to selected tasks\n";
    /* Get current configuration */
    // configuration = specification->getConfiguration();
    // configuration = configuration.substr(configuration.find("(") + 1);
    // configuration.erase(configuration.length() - 1);
    configuration= "";

    for (auto task : task_list) {
        /* Get application name and count number of tasks in all applications */
        application_num = "";

        for (auto appl : specification->getApplicationGraphs()) {
            for (auto t : appl.second->getTasks()) {
                if (application_num != "") {
                    continue;
                } else if (task.second->getID() == t.second->getID()) {
                    application = appl.second;
                    application_num = application->getID();
                }
            }
        }

        /* Create new task */
        auto t_num = application->getTasks().size() + 1;
        task_name = "t" + to_string(t_num);

        // Check if task name already in application exists
        bool condition = true;
        while (condition) {
            condition = false;
            for (auto t : application->getTasks())
                if (t.second->getID() == task_name) {
                    task_name = "t" + to_string(t_num++);
                    condition = true;
                }
        }

        auto task_new = new Task(task_name, configuration);
        application->addTask(task_name, task_new);

        cout << "ADDED: task " << task_name << "\n";

        /* Create new message */
        auto m_num = application->getMessages().size() + 1;
        message_name = "c" + to_string(m_num);

        // Check if message name already in application exists
        condition = true;
        while (condition) {
            condition = false;
            for (auto m : application->getMessages())
                if (m.second->getID() == message_name) {
                    message_name = "c" + to_string(m_num++);
                    condition = true;
                }
        }
        auto message_new = new Message(message_name, configuration);
        application->addMessage(message_name, message_new);

        /* Create new and remove old connections and messages */
        /* (task was originally connected to task2 over a message
         * -> now task_new is being connected to task2 via message_new2) */
        for (auto edge_out : task.second->outgoingEdges()) {
            string task2_name = "";
            task2_name = task2_name + edge_out->getOpposite(task.second)->getID();

            m_num = application->getMessages().size() + 1;
            string message_name2 = "c" + to_string(m_num);

            // Check if message name already in application exists
            condition = true;
            while (condition) {
                condition = false;
                for (auto m : application->getMessages())
                    if (m.second->getID() == message_name2) {
                        message_name2 = "c" + to_string(m_num++);
                        condition = true;
                    }
            }

            auto message_new2 = new Message(message_name2, configuration);
            application->addMessage(message_name2, message_new2);

            string dependency_name2 = "s" + message_name2;
            application->addEdge(dependency_name2, new Dependency(task_new, message_new2));
            application->getEdges().at(dependency_name2)->setID(dependency_name2);
            for (auto t : application->getTasks()) {
                if (t.second->getID() == task2_name) {
                    dependency_name2 = "r" + message_name2;
                    application->addEdge(dependency_name2,  new Dependency(message_new2, t.second));
                    application->getEdges().at(dependency_name2)->setID(dependency_name2);
                    for (auto e : t.second->incomingEdges()) {
                        if (e->getOpposite(t.second)->getID().find(task.second->getID()) != string::npos) {
                            application->removeEdge(e->getID());
                        }
                    }
                }
            }
            application->removeMessage(edge_out->getOpposite(task.second)->getID());
            application->removeEdge(edge_out->getID());
        }

        string dependency_name = "s" + message_name;
        application->addEdge(dependency_name, new Dependency(task.second, message_new));
        application->getEdges().at(dependency_name)->setID(dependency_name);
        dependency_name = "r" + message_name;
        application->addEdge(dependency_name, new Dependency(message_new, task_new));
        application->getEdges().at(dependency_name)->setID(dependency_name);

        /* Add new mappings (to randomly selected processors) with characteristics */
        map<int, Resource *> map_processors = select_processors(specification, 20);
        string ID, task_num, processor_num;

        task_num = "";
        task_num = task_num + task_new->getID();

        for (auto processor : map_processors) {
            processor_num = "";
            processor_num = processor_num + processor.second->getID();

            ID = "m" + task_num + "x" + application_num + "x" + processor_num;
            auto mapping = new Mapping(ID, configuration, task_new, processor.second);
            specification->addMapping(ID, mapping);
            mapping->setAttribute("executionTime", to_string(100));
            mapping->setAttribute("dynamicEnergy", to_string(1000));
        }
    }
}

/* Add a neighbour (in z direction) each to the given processors */
void ChangeSpecOperations::add_processors(DSE::SpecificationGraph *specification, map<int, Resource *> processor_list) {
    string name, configuration;
    string posX, posY, posZ;
    string resourceCost, staticPower;
    list<Resource *> processors;

    cout << "Going to add a neighbour to selected processors\n";
    /* Get current configuration */
    // configuration = specification->getConfiguration();
    // configuration = configuration.substr(configuration.find("(") + 1);
    // configuration.erase(configuration.length() - 1);
    configuration = "";
    for (auto processor : processor_list) {
        /* Get name of new processor */
        processors.clear();
        for (auto processor : specification->getArchitectureGraph()->getResources()) {
            if (processor.second->getType() == Node::NodeType::Router) continue;
            processors.push_back(processor.second);
        }

        auto p_num = processors.size() + 1;
        name = "p" + to_string(p_num);
        // Check if processor name already in application exists
        bool condition = true;
        while (condition) {
            condition = false;
            for (auto p : processors)
                if (p->getID() == name) {
                    name = "p" + to_string(p_num++);
                    condition = true;
                }
        }

        auto res_new = new Resource(name, configuration);
        specification->getArchitectureGraph()->addResource(name, res_new);

        cout << "ADDED: processor " << name << "\n";

        /* Set values to new processor (adjacent to selected processor) */
        posX = processor.second->getAttribute("posX");
        posY = processor.second->getAttribute("posY");
        posZ = to_string(stoi(processor.second->getAttribute("posZ")) + 1);
        resourceCost = to_string(30);  // processor.second->getAttribute("resourceCost");
        staticPower = to_string(30);   // processor.second->getAttribute("staticPower");

        res_new->setAttribute("posX", posX);
        res_new->setAttribute("posY", posY);
        res_new->setAttribute("posZ", posZ);
        res_new->setAttribute("resourceCost", resourceCost);
        res_new->setAttribute("staticPower", staticPower);

        /* Create corresponding router */
        name = "r" + to_string(processors.size() + 1);
        auto res2 = new Router(name, configuration);
        specification->getArchitectureGraph()->addResource(name, res2);

        res2->setAttribute("posX", posX);
        res2->setAttribute("posY", posY);
        res2->setAttribute("posZ", posZ);
        res2->setAttribute("resourceCost", resourceCost);
        res2->setAttribute("staticPower", staticPower);
        /* TODO possibly copy staticPower, resourceCost from adjacent router */

        /* Create corresponding links */
        auto l_num = specification->getArchitectureGraph()->getEdges().size() + 1;
        auto link_name = "l" + to_string(l_num);

        // Check if link name already in application exists
        condition = true;
        while (condition) {
            condition = false;
            for (auto l : specification->getArchitectureGraph()->getEdges())
                if (l.second->getID() == link_name) {
                    link_name = "l" + to_string(l_num++);
                    condition = true;
                }
        }

        auto link_new = new Link(link_name, configuration, res_new, res2);
        specification->getArchitectureGraph()->addEdge(link_name, link_new);
        
        l_num = specification->getArchitectureGraph()->getEdges().size() + 1;
        link_name = "l" + to_string(l_num);

        // Check if link name already in application exists
        condition = true;
        while (condition) {
            condition = false;
            for (auto l : specification->getArchitectureGraph()->getEdges())
                if (l.second->getID() == link_name) {
                    link_name = "l" + to_string(l_num++);
                    condition = true;
                }
        }
        
        link_new = new Link(link_name, configuration, res2, res_new);
        specification->getArchitectureGraph()->addEdge(link_name, link_new);

        for (auto link : specification->getArchitectureGraph()->getEdges()) {
            if (processor.second->getID() == link.second->sourceNode()->getID()) {
                auto router = link.second->destNode();

                l_num = specification->getArchitectureGraph()->getEdges().size() + 1;
                link_name = "l" + to_string(l_num);
                // Check if link name already in application exists
                condition = true;
                while (condition) {
                    condition = false;
                    for (auto l : specification->getArchitectureGraph()->getEdges())
                        if (l.second->getID() == link_name) {
                            link_name = "l" + to_string(l_num++);
                            condition = true;
                        }
                }
                link_new = new Link(name, configuration, res2, router);
                specification->getArchitectureGraph()->addEdge(name, link_new);

                l_num = specification->getArchitectureGraph()->getEdges().size() + 1;
                link_name = "l" + to_string(l_num);
                // Check if link name already in application exists
                condition = true;
                while (condition) {
                    condition = false;
                    for (auto l : specification->getArchitectureGraph()->getEdges())
                        if (l.second->getID() == link_name) {
                            link_name = "l" + to_string(l_num++);
                            condition = true;
                        }
                }
                auto link_new = new Link(name, configuration, res2, router);
                specification->getArchitectureGraph()->addEdge(name, link_new);

                break;
            }
        }

        /* Add new mappings (randomly selected tasks) */
        map<int, Task *> map_tasks = select_tasks(specification, 5);
        string ID, task_num, processor_num, application_num;

        processor_num = "";
        processor_num = processor_num + res_new->getID();
        
        for (auto task : map_tasks) {
            task_num = "";
            task_num = task_num + task.second->getID();

            for(auto application : specification->getApplicationGraphs())
            {
                for(auto t : application.second->getTasks())
                {
                    if(t.second->getID() == task_num)
                        application_num = application.second->getID();
                }
            }

            ID = "m" + task_num + "x" + application_num + "x" + processor_num;
            auto mapping = new Mapping(ID, configuration, task.second, res_new);
            specification->addMapping(ID, mapping);
            mapping->setAttribute("executionTime", to_string(100));
            mapping->setAttribute("dynamicEnergy", to_string(1000));
        }
    }
}

/* Delete the given tasks */
void ChangeSpecOperations::delete_tasks(DSE::SpecificationGraph *specification, map<int, Task *> task_list) {
    string configuration, application_num;
    string message_new_name;
    ApplicationGraph *application;

    cout << "Going to delete selected tasks\n";
    // /* Get current configuration */
    // configuration = specification->getConfiguration();
    // configuration = configuration.substr(configuration.find("(") + 1);
    // configuration.erase(configuration.length() - 1);
    configuration = "";

    for (auto task : task_list) {
        /* Get current application */
        for (auto appl : specification->getApplicationGraphs()) {
            for (auto t : appl.second->getTasks()) {
                if (task.second->getID() == t.second->getID()) {
                    application = appl.second;
                    application_num = application->getID();
                }
            }
        }

        /* Get all predecessors messages and remove incoming edges of task */
        list<Node *> messages_pred;
        for (auto edge_in : task.second->incomingEdges()) {
            messages_pred.push_back(edge_in->getOpposite(task.second));
            application->removeEdge(((Dependency *)edge_in)->getID());
        }

        /* Get predecessors tasks of predecessors messages */
        /* Remove predecessors messages and corresponding edges */
        list<Node *> tasks_pred;
        for (auto message_pred : messages_pred) {
            for (auto edge : message_pred->incomingEdges()) {
                tasks_pred.push_back(edge->getOpposite(message_pred));
                application->removeEdge(((Dependency *)edge)->getID());
            }
            application->removeMessage(message_pred->getID());
        }

        /* Get all successors messages and remove outgoing edges of task */
        list<Node *> messages_succ;
        for (auto edge_out : task.second->outgoingEdges()) {
            messages_succ.push_back(edge_out->getOpposite(task.second));
            application->removeEdge(((Dependency *)edge_out)->getID());
        }

        /* Get successors tasks of successors messages */
        /* Remove successors messages and corresponding edges */
        list<Node *> tasks_succ;
        for (auto message_succ : messages_succ) {
            for (auto edge : message_succ->outgoingEdges()) {
                tasks_succ.push_back(edge->getOpposite(message_succ));
                application->removeEdge(((Dependency *)edge)->getID());
            }
            application->removeMessage(message_succ->getID());
        }

        /* Create new message and corresponding edges */
        for (auto task_pred : tasks_pred) {
            for (auto task_succ : tasks_succ) {

                auto m_num = application->getMessages().size() + 1;
                message_new_name = "c" + to_string(m_num);

                // Check if message name already in application exists
                bool condition = true;
                while (condition) {
                    condition = false;
                    for (auto m : application->getMessages())
                        if (m.second->getID() == message_new_name) {
                            message_new_name = "c" + to_string(m_num++);
                            condition = true;
                        }
                }

                auto message_new = new Message(message_new_name, configuration);
                application->addMessage(message_new_name, message_new);
                string dependency_new_name = "s" + message_new_name;
                application->addEdge(dependency_new_name, new Dependency(task_pred, message_new));
                application->getEdges().at(dependency_new_name)->setID(dependency_new_name);
                dependency_new_name = "r" + message_new_name;
                application->addEdge(dependency_new_name, new Dependency(message_new, task_succ));
                application->getEdges().at(dependency_new_name)->setID(dependency_new_name);
            }
        }

        /* Remove mappings of the task */
        list<Resource *> mapped_processors;
        for (auto mapping : specification->getMappings())
            if (task.second->getID() == mapping.second->getTask()->getID())
                specification->removeMapping(mapping.second->getID());

        /* remove task itself */
        application->removeTask(task.second->getID());
    }
}

/* Delete the given processors, router structure remains */
void ChangeSpecOperations::delete_processors(DSE::SpecificationGraph *specification,
                                             map<int, Resource *> processor_list) {
    Node *router;
    list<Node *> resources;
    string name, configuration;

    cout << "Going to delete selected processors\n";
    // /* Get current configuration */
    // configuration = specification->getConfiguration();
    // configuration = configuration.substr(configuration.find("(") + 1);
    // configuration.erase(configuration.length() - 1);
    configuration = "";

    for (auto processor : processor_list) {
        resources.clear();
        /* Get router connected to processor and remove the links */
        auto edges = specification->getArchitectureGraph()->getEdges();
        for (auto link : edges) {
            if (processor.second->getID() == link.second->sourceNode()->getID()) {
                router = link.second->destNode();
                specification->getArchitectureGraph()->removeEdge(link.second->getID());
            }
            if (processor.second->getID() == link.second->destNode()->getID()) {
                specification->getArchitectureGraph()->removeEdge(link.second->getID());
            }
        }

        /* Remove mappings to the processor */
        list<Task *> mapped_tasks;
        for (auto mapping : specification->getMappings()) {
            if (processor.second->getID() == mapping.second->getResource()->getID()) {
                specification->removeMapping(mapping.second->getID());
                mapped_tasks.push_back(mapping.second->getTask());
            }
        }

        /* Remove processor */
        specification->getArchitectureGraph()->removeResource(processor.second->getID());

        /* Check if all tasks still have available mapping options */
        for (auto mapped_task : mapped_tasks) {
            auto mapped = specification->getMappings().size();
            for (auto mapping : specification->getMappings()) {
                if (mapped_task->getID() == mapping.second->getTask()->getID())
                    break;
                else if (mapped == 1)
                    cout << "ERROR: One task (" << mapped_task->getID() << ")  is now without any mapping option\n";
                else
                    mapped--;
            }
        }
    }
}

/* Do random selected changes on the given tasks */
void ChangeSpecOperations::combined_changes_tasks(DSE::SpecificationGraph *specification, map<int, Task *> task_list) {
    int selection;
    int exchanged = 0;
    int added = 0;
    int deleted = 0;
    map<int, Task *> exchange_list;
    map<int, Task *> add_list;
    map<int, Task *> delete_list;

    for (auto task : task_list) {
        selection = rand() % 3;
        switch (selection) {
            case 0: /* Exchange option */
                exchange_list.insert(task);
                exchanged++;
                break;
            case 1: /* Add option */
                add_list.insert(task);
                added++;
                break;
            case 2: /* Delete option */
                delete_list.insert(task);
                deleted++;
                break;
            default:
                break;
        }
    }

    if (!exchange_list.empty()) exchange_tasks(specification, exchange_list);
    if (!add_list.empty()) add_tasks(specification, add_list);
    if (!delete_list.empty()) delete_tasks(specification, delete_list);

    cout << exchanged << " exchanged, " << added << " added and " << deleted << " deleted tasks\n";
}

/* Do random selected changes on the the given processors */
void ChangeSpecOperations::combined_changes_processors(DSE::SpecificationGraph *specification,
                                                       map<int, Resource *> processor_list) {
    int selection;
    int exchanged = 0;
    int added = 0;
    int deleted = 0;
    map<int, Resource *> exchange_list;
    map<int, Resource *> add_list;
    map<int, Resource *> delete_list;

    for (auto processor : processor_list) {
        selection = rand() % 3;
        switch (selection) {
            case 0: /* Exchange option */
                exchange_list.insert(processor);
                exchanged++;
                break;
            case 1: /* Add option */
                add_list.insert(processor);
                added++;
                break;
            case 2: /* Delete option */
                delete_list.insert(processor);
                deleted++;
                break;
            default:
                break;
        }
    }

    if (!exchange_list.empty()) exchange_processors(specification, exchange_list);
    if (!add_list.empty()) add_processors(specification, add_list);
    if (!delete_list.empty()) delete_processors(specification, delete_list);

    cout << exchanged << " exchanged, " << added << " added and " << deleted << " deleted processors\n";
}

/* Select randomly a certain percentage of tasks */
map<int, Task *> ChangeSpecOperations::select_tasks(DSE::SpecificationGraph *specification, int percentage) {
    list<Task *> tasks;
    map<int, Task *> sel_tasks;
    /* Get all tasks contained in specification */
    for (auto application : specification->getApplicationGraphs()) {
        for (auto task : application.second->getTasks()) {
            tasks.push_back(task.second);
        }
    }

    /* Select randomly percentage of the tasks */
    double selected = 0.0;
    int selection;

    while (selected < percentage) {
        selection = rand() % tasks.size();
        if (sel_tasks.find(selection) == sel_tasks.end()) {
            auto it = tasks.begin();
            for (int i = 0; i < selection; i++) {
                it++;
            }
            Task *element = *it;
            sel_tasks.insert({selection, element});
            selected = selected + 100.00 / tasks.size();
            std::cout << "from " << tasks.size() << " tasks: " << selection << " was selected which means "
                 << element->getID() << " (" << selected << "%)\n";
        }
    }

    return sel_tasks;
}

/* Select randomly a certain percentage of processors */
map<int, Resource *> ChangeSpecOperations::select_processors(DSE::SpecificationGraph *specification, int percentage) {
    list<Resource *> processors;
    map<int, Resource *> sel_processors;
    for (auto processor : specification->getArchitectureGraph()->getResources()) {
        if (processor.second->getType() == Node::NodeType::Router) continue;
        processors.push_back(processor.second);
    }

    /* Select randomly percentage of the processors */
    double selected = 0.0;
    int selection;

    while (selected < percentage) {
        selection = rand() % processors.size();
        if (sel_processors.find(selection) == sel_processors.end()) {
            auto it = processors.begin();
            for (int i = 0; i < selection; i++) {
                it++;
            }
            Resource *element = *it;
            sel_processors.insert({selection, element});
            selected = selected + 100.00 / processors.size();
            cout << "from " << processors.size() << " processors: " << selection << " was selected which means "
                 << element->getID() << " (" << selected << "%)\n";
        }
    }

    return sel_processors;
}