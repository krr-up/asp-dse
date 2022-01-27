#pragma once
#include "resource.hpp"

namespace DSE
{
	/**
	 * \brief Class to represent a Router.
	 * 
	 * A router is used as a network element of the communication infrastructure. 
	 * Though it is inherited from Resource, a Task cannot be mapped to a Router.
	 */
	class Router : public Resource{
	
	public:
		Router(string id, string configuration);
		~Router();
	};
}
