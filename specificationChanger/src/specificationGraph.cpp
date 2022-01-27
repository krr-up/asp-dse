#include "../include/specificationGraph.hpp"

using namespace DSE;

SpecificationGraph::SpecificationGraph(string id, string configuration, int period) : Element(id, configuration) {
	period = period;
}
SpecificationGraph::~SpecificationGraph() {}

void SpecificationGraph::addApplicationGraph(string name, ApplicationGraph* applicationGraph) {
	this->_applicationGraphs.insert({name, applicationGraph}); //std::cout << "applicationGraph added" << std::endl;
}

void SpecificationGraph::removeApplicationGraph(string name) {
    this->mappings.erase(name); //std::cout << "applicationGraph removed" << std::endl;
}

void SpecificationGraph::addMapping(string name, Mapping* mapping) {
	this->mappings.insert({name, mapping}); //std::cout << "mapping added" << std::endl;
}

void SpecificationGraph::removeMapping(string name) {
    this->mappings.erase(name); //std::cout << "mapping removed" << std::endl;
}