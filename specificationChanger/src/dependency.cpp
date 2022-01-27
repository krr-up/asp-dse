#include "../include/dependency.hpp"

using namespace DSE;

Dependency::Dependency(Node *sourceNode, Node *destNode) : Edge(sourceNode, destNode) {
    
}

Dependency::Dependency(string id, string configuration, Node *sourceNode, Node *destNode) : Edge(id, configuration, sourceNode, destNode) {
	
}

Dependency::~Dependency() {
	
}