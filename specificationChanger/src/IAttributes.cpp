#include "IAttributes.hpp"

using namespace DSE;

IAttributes::IAttributes() {
	attributes = new map<string, string>();
}

IAttributes::~IAttributes() {
	attributes->clear();
	delete attributes;
}

string IAttributes::getAttribute(string name) const {
	return attributes->at(name);
}

void IAttributes::setAttribute(string name, string value) const {
	attributes->insert({name, value});
}

void IAttributes::changeAttribute(string name, string value) const {
	attributes->at(name) = value;
}

map<string, string> *IAttributes::getAttributes() const {
	return attributes;
}

void IAttributes::removeAttribute(string name) const {
	attributes->erase(name);
}
