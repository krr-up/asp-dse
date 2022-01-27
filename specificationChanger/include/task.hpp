#pragma once
#include "node.hpp"

namespace DSE {
	/**
	 * \brief Class to represent a Task. Specializes a Node such that a Task is part of an application.
	 */
	class Task : public Node 
	{
	public:
		/**
	     * \brief Standard constructor for the Task class. 
	     * \note When using this function, the task is not assigned to a function! This can be done by calling setFunction().
	     * \param id a string representing the identifier of the task. 
		 * \param configuration a string representing the configuration the task belongs to
	     */
	    Task(string id, string configuration);

		~Task();
	
		/**
		 * \brief Get a List of Successor Tasks. Messages are ignored.
		 * \return A list of tasks.
		 */
		list<Task*> getSuccessors();

		void setType(NodeType) override;
	};
}
