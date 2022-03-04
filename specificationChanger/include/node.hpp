#pragma once
#include <list>
#include "element.hpp"
#include "edge.hpp"

using namespace std;

namespace DSE {
	class Edge;
	class Node : public Element {
	
	public:
		Node(string id, string configuration);
	
		/**
		 *\brief Adds a given Edge to the Node.
		 *\param edge The Edge to be added.
		 */
		void addEdge(Edge *edge);
		/**
		 *\brief Remove a given Edge from the Node.
		 *\param edge The Edge to be removed.
		 */
		void removeEdge(Edge *edge);
		
		/**
		 *\brief Returns all edges associated to this Node. 
		 */
		list<Edge *> *edges();
		
		/**
		 *\brief Returns a List of all outgoing edges associated to this Node.
		 */
		list<Edge *> outgoingEdges();
		/**
		 *\brief Returns a List of all incoming edges associated to this Node.
		 */
		list<Edge *> incomingEdges();

		/**
		 * \brief An enumeration of types, a Node can be.
		 */
		enum NodeType { Resource, Router, Task, Message, Other };

		/**
		 * \brief Return the Type of the specific Node.
		 * 
		 * \return the type of the node of type NodeType.
		 */
		NodeType getType() const { return nodeType; }

		/**
		 * \brief Set the Type of the specific node
		 * 
		 * \param Enumeration node type
		 */
		virtual void setType(NodeType);

	protected:
		list<Edge *> edgeList;

		NodeType nodeType;
	};
}
