#pragma once
#include <map>
#include "architectureGraph.hpp"
#include "applicationGraph.hpp"
#include "mapping.hpp"

namespace DSE {
    class SpecificationGraph : public Element
    {
        private:
            ArchitectureGraph* _architectureGraph;
            map<string, ApplicationGraph*> _applicationGraphs;
            map<string, Mapping*> mappings;
            int _period;

        public:
            SpecificationGraph(string id, string configuration, int period);
            ~SpecificationGraph();

            ArchitectureGraph* getArchitectureGraph() const { return _architectureGraph; }
            void setArchitectureGraph(ArchitectureGraph* architectureGraph) { _architectureGraph = architectureGraph; }

            map<string, ApplicationGraph*> getApplicationGraphs() const { return _applicationGraphs; }
            void addApplicationGraph(string name, ApplicationGraph* applicationgraph);
            void removeApplicationGraph(string name);

            map<string, Mapping*> getMappings() const{
                return mappings;
            }
            void addMapping(string name, Mapping* mapping);
            void removeMapping(string name);

            int getPeriod() const { return _period; }
        
            void setPeriod(int period) { _period = period; }
    };
}