#include "../include/node.hpp"

using namespace DSE;

Node::Node(string id, string configuration) : Element(id, configuration) {
	nodeType = Other;
}

void Node::addEdge(Edge *edge) {
	edgeList.push_back(edge);
}

void Node:: removeEdge(Edge *edge) {
     edgeList.remove(edge);
}

list<Edge *> *Node::edges() {
	return &edgeList;
}

list<Edge*> Node::outgoingEdges() {
	list<Edge*> outgoing;
	for (Edge *edge : edgeList) {
		if (edge->sourceNode() == this) {
			outgoing.push_back(edge);
		}
	}
	return outgoing;
}

list<Edge*> Node::incomingEdges() {
	list<Edge*> incoming;
	for (Edge *edge : edgeList) {
		if (edge->destNode() == this) {
			incoming.push_back(edge);
		}
	}
	return incoming;
}

void Node::setType(NodeType nodeType){
	this->nodeType = nodeType;
	string _nodeType;
	switch (nodeType) {
	case NodeType::Resource:
		_nodeType = "Resource";
		break;
	case NodeType::Router:
		_nodeType = "Router";
		break;
	case NodeType::Task:
		_nodeType = "Task";
		break;
	case NodeType::Message:
		_nodeType = "Message";
		break;
	case NodeType::Other:
		_nodeType = "Other";
		break;
	default:
		_nodeType = "Error";
		break;
	}

	/*
	string toolTip = "<b>" + _nodeType + ": </b>" + getID();
	
	for (auto it = getAttributes()->begin(); 
         it != getAttributes()->end(); ++it){
		toolTip.append("<br>" + it->first + " = " + it->second);
	}
	*/
}