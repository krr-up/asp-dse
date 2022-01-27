#include "../include/task.hpp"
#include "../include/message.hpp"

using namespace DSE;

Task::Task(string id, string configuration) : Node(id, configuration){
	setType(Node::NodeType::Task);
}

Task::~Task() {}

list<Task*> DSE::Task::getSuccessors() {
	list<Task*> tasks;
	for(auto edge : outgoingEdges()) {
		auto task = edge->getOpposite(this);
		if(!dynamic_cast<DSE::Message*>(task)) {
			tasks.push_back(static_cast<Task*>(task));
		}else {
			//Messages only have one outgoing edge by definition
			task = task->outgoingEdges().front()->getOpposite(task);
			tasks.push_back(static_cast<Task*>(task));
		}
	}
	
	return tasks;
}

void Task::setType(NodeType nodeType) {
	this->nodeType = nodeType;
	string nodeType_;
	switch (nodeType)
	{
	case Node::NodeType::Task:
		nodeType_ = "Task";
		break;
	case Node::NodeType::Message:
		nodeType_ = "Message";
		break;
	default:
		nodeType_ = "Error";
		break;
	}

	/*
	string toolTip = "<b>" + nodeType_ + ": </b>" + getID();

	for (auto it = getAttributes()->begin(); 
         it != getAttributes()->end(); ++it){
		toolTip.append("<br>" + it->first + " = " + it->second);
	}
	*/
}