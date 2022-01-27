#pragma once
#include "task.hpp"
#include "edge.hpp"
#include <stdio.h>
#include <math.h>

namespace DSE
{
	class Message : public Task
	{
	public:
		Message(string id, string configuration);

		~Message();

		Task* getSender() {
			return static_cast<Task*>(incomingEdges().front()->getOpposite(this));
		}

		Task* getReceiver() {
			return static_cast<Task*>(outgoingEdges().front()->getOpposite(this));
		}
	};
}
