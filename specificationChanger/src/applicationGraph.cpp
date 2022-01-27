#include "../include/applicationGraph.hpp"

using namespace DSE;

ApplicationGraph::ApplicationGraph(string id, string configuration) : Element(id, configuration) {}
ApplicationGraph::~ApplicationGraph() {}

void ApplicationGraph::addTask(string name, Task* task) {
	this->tasks.insert({name, task}); ///std::cout << "task added" << std::endl;
}
void ApplicationGraph::addMessage(string name, Message* message) {
	this->messages.insert({name, message}); //std::cout << "message added" << std::endl;
}
void ApplicationGraph::addEdge(Dependency* edge) {
	this->edges.push_back(edge); //std::cout << "edge added" << std::endl;
}

void ApplicationGraph::removeTask(string name) {
    this->tasks.erase(name); //std::cout << "task removed" << std::endl;
}
void ApplicationGraph::removeMessage(string name) {
    this->messages.erase(name); //std::cout << "message removed" << std::endl;
    }
void ApplicationGraph::removeEdge(Dependency* edge) {
    this->edges.remove(edge); //std::cout << "edge removed" << std::endl;
}