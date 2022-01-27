#include "../include/router.hpp"

using namespace DSE;

Router::Router(string id, string configuration) : Resource(id, configuration) {
	setType(NodeType::Router);
}

Router::~Router() {
	
}