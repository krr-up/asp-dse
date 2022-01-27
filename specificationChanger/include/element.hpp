#pragma once
#include "IAttributes.hpp"

namespace DSE {
	/**
	 *
	 * @brief Base class for all elements of a specification.
	 *
	 * This class defines all common properties of Elements of a specification.
	 */
	class Element : public IAttributes {

	public:

		/**
		 * @brief Standard constructor for every element. 
		 *
		 * Each elements is characterized by a unique ID and a configuration.
		 *
		 * @param id a string representing a unique identifier of the element.
		 * @param configuration a string representing the configuration the element belongs to
		 */
		Element(string id, string configuration);
		
		/**
		 * @brief Sets the ID.
		 * 
		 * @param id a string representing the new identifier
		 */
		void setID(string id) {
			_id = id;
		}
		/**
		 * @brief Gets the id.
		 * 
		 * @return a string representing the identifier of the element
		 */
		string getID() const {
			return _id;
		}

		/**
		 * @brief Sets the configuration.
		 * 
		 * @param configuration a string representing the new configuration
		 */
		void setConfiguration(string configuration) {
			_configuration = configuration;
		}
		/**
		 * @brief Gets the configuration.
		 * 
		 * @return a string representing the configuration of the element
		 */
		string getConfiguration() const {
			return _configuration;
		}

	protected:
		string _id;				// The identifier of the element
		string _configuration;	// The configuration the element belongs to
	private:

	};
}