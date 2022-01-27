#pragma once
#include <string>
#include <map>
#include <list>
#include <fstream>
#include <iostream>
#include "task.hpp"
#include "resource.hpp"
#include "mapping.hpp"
#include "router.hpp"
#include "message.hpp"
#include "link.hpp"
#include "dependency.hpp"
#include "helper.hpp"
#include "applicationGraph.hpp"
#include "architectureGraph.hpp"
#include "specificationGraph.hpp"

using namespace std;

namespace DSE
{
	class SpecificationGraph;
}

class LoadSaveOperations {

public:

	/* Load specification in object structure */
	static void loadSpecASP(DSE::SpecificationGraph *specification, list<string> lines);
	/* Load lines from file */
	static bool loadSpecASPByFile(DSE::SpecificationGraph *specification, string filename);
	/* Write lines in file */
	static bool saveSpecASPInFile(DSE::SpecificationGraph *specification, string filename);	
	/* Saves specification from object structure as lines */
	static void saveSpecASP(DSE::SpecificationGraph *specification, list<string>* lines);
};