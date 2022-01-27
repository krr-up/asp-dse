#pragma once
#include "element.hpp"

using namespace std;
namespace DSE {
	
	class Task;
	class Resource;

	class Mapping : public Element {
	public:
		Mapping(Task *task, Resource *res);
		Mapping(string id, string configuration, Task *task, Resource *res);

		Task *getTask() const {
			return _task;
		}
		Resource *getResource() const {
			return _resource;
		}

		static void resetID() {
			_nextID = 0;
		}
		
	private:
		Task *_task;
		Resource *_resource;
		static int _nextID;
	};
}