#pragma once
#include <list>
#include <map>
#include "task.hpp"
#include "message.hpp"
#include "dependency.hpp"
#include <iostream>

using namespace std;

namespace DSE {
    class ApplicationGraph : public Element
    {
        private:
            map<string, Task*> tasks;
            map<string, Message*> messages;
            list<Dependency*> edges;
            
        public:
            ApplicationGraph(string id, string configuration);
            ~ApplicationGraph();

            map<string, Task*> getTasks() const{
                return tasks;
            }
            map<string, Message*> getMessages() const{
                return messages;
            }
            list<Dependency*> getEdges() const{
                return edges;
            }

            void addTask(string name, Task* task);
            void addMessage(string name, Message* message);
            void addEdge(Dependency* edge);

            void removeTask(string name);
            void removeMessage(string name);
            void removeEdge(Dependency* edge);
    };
}