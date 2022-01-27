#include "../include/architectureGraph.hpp"

using namespace DSE;

ArchitectureGraph::ArchitectureGraph(string id, string configuration) : Element(id, configuration) {}
ArchitectureGraph::~ArchitectureGraph() {}

void ArchitectureGraph::addResource(string name, Resource* resource) {
	this->resources.insert({name, resource}); //std::cout << "resource added" << std::endl;
}
void ArchitectureGraph::addEdge(Link* edge) {
	this->edges.push_back(edge); //std::cout << "edge added" << std::endl;
}

void ArchitectureGraph::removeResource(string name) {
    this->resources.erase(name); //std::cout << "resource removed" << std::endl;
}
void ArchitectureGraph::removeEdge(Link* edge) {
    this->edges.remove(edge); //std::cout << "edge removed" << std::endl;
}