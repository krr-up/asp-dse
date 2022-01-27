#include "../include/message.hpp"

using namespace DSE;

Message::Message(string id, string configuration) : Task(id, configuration) {
	this->nodeType = Node::NodeType::Message;
}

Message::~Message() {}