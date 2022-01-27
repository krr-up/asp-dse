#pragma once
#include "edge.hpp"
#include "IAttributes.hpp"
#include "node.hpp"

namespace DSE
{
	class Link : public Edge {
	
	public:
		Link(Node *sourceNode, Node *destNode);
		Link(string id, string configuration, Node *sourceNode, Node *destNode);
		~Link();
	};
}
