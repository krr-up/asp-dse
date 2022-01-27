#include "../include/mapping.hpp"

using namespace DSE;

int Mapping::_nextID = 0;
static string configuration = "";

Mapping::Mapping(Task *task, Resource *res) : Element(string("m").append(to_string(_nextID++)), configuration) {
	_task = task;
	_resource = res;
}

Mapping::Mapping(string id, string configuration, Task *task, Resource *res) : Element(id, configuration){
	_task = task;
	_resource = res;
}

