#include "../include/resource.hpp"

using namespace DSE;

Resource::Resource(string id, string configuration) : Node(id, configuration) {
	this->nodeType = Node::NodeType::Resource;
}

Resource::~Resource() {
	
}