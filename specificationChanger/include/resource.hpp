#pragma once
#include "node.hpp"

namespace DSE
{
	/**
	 * \brief Class to represent a resource.
	 * 
	 * A resource is used as a processing element or 
	 * a network element of the communication infrastructure. 
	 * A Task can be mapped to a processing resource.
	 */
	class Resource : public Node {
		
	public:
		Resource(string id, string configuration);
		~Resource();
	};
}
