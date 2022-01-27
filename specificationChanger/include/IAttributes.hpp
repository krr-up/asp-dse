#pragma once
#include <string>
#include <map>
using namespace std;

namespace DSE {
	/**
	 *
	 * @brief Interface for assigning attributes.
	 * 
	 */
	class IAttributes {
	public:

		/**
		 * @brief Standard constructor
		 */
		IAttributes();
		/**
		 * @brief Standard Destructor
		 */
		virtual ~IAttributes();
		
		/**
		 * @brief Gets the attribute value for a specific attribute.
		 * 
		 * @param name a string representing the name of the attribute.
		 * @return The value of the attribute.
		 */
		string getAttribute(string name) const;
		/**
		 * @brief Sets the value of an attribute.
		 * 
		 * If the attribute already exists, the value is not saved!
		 * 
		 * @param name a string representing the name of the attribute.
		 * @param value a string representing the new value the attribute.
		 */
		void setAttribute(string name, string value) const;
		/**
		 * @brief Change the value of an attribute which already exists.
		 * 
		 * @param name a string representing the name of the attribute.
		 * @param value a string representing the new value the attribute.
		 */
		void changeAttribute(string name, string value) const;
		/**
		 * @brief Gets a map of all attributes.
		 * 
		 * @return a pointer the map of attributes.
		 */
		map<string, string> *getAttributes() const;
		/**
		 * @brief Removes an attribute.
		 * 
		 * @param name a string representing the name of the attribute to be removed.
		 */
		void removeAttribute(string name) const;
	
	protected:
		map<string, string> *attributes; // The map of attributes.
	
	};
}