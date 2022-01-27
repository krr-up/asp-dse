#include "../include/link.hpp"

using namespace DSE;

Link::Link(Node *sourceNode, Node *destNode) : Edge(sourceNode, destNode) {
}

Link::Link(string id, string configuration, Node *sourceNode, Node *destNode) : Edge(id, configuration, sourceNode, destNode) {
}

Link::~Link() {
	
}