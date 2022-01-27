#include "../include/edge.hpp"

using namespace DSE;

static int id = 0;
static string configuration = "";

Edge::Edge(Node *sourceNode, Node *destNode) : Edge("edge" + to_string(id++), configuration, sourceNode, destNode) {
}

Edge::Edge(string id, string configuration, Node *sourceNode, Node *destNode) : Element(id, configuration) {
	
    source = sourceNode;
    dest = destNode;
    source->addEdge(this);
    dest->addEdge(this);
}

Node *Edge::sourceNode() const
{
    return source;
}

Node *Edge::destNode() const
{
    return dest;
}

Node * Edge::getOpposite(Node *node) const {
	if (source == node) {
		return dest;
	}
	else if (dest == node) {
		return source;
	}
	
	return nullptr;
}