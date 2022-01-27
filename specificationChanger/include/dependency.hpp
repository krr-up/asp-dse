#pragma once
#include "edge.hpp"
#include "node.hpp"
#include "task.hpp"

using namespace std;

namespace DSE {
	class Node;
	class Dependency : public Edge {
		
	public:
		Dependency(Node *sourceNode, Node *destNode);
		Dependency(string id, string configuration, Node *sourceNode, Node *destNode);
		~Dependency();
	};
}
