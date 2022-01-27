#pragma once
#include "element.hpp"
#include "node.hpp"

namespace DSE {
	class Node;
	class Edge : public Element {
	
	public:
	    Edge(string id, string configuration, Node *sourceNode, Node *destNode);
		Edge(Node *sourceNode, Node *destNode);
	    Node *sourceNode() const;
	    Node *destNode() const;
		Node *getOpposite(Node *) const;
		
		enum EdgeType { Dependency, Link, Other };
	    
	protected:	
		Node *source, *dest;
	};
}
