#pragma once
#include <list>
#include <map>
#include "resource.hpp"
#include "router.hpp"
#include "link.hpp"
#include <iostream>

using namespace std;

namespace DSE {
    class ArchitectureGraph : public Element
        {
        private:
            map<string, Resource*> resources;
            map<string, Link*> edges;
        public:
            ArchitectureGraph(string id, string configuration);
            ~ArchitectureGraph();

            map<string, Resource*> getResources() const{
                return resources;
            }
            map<string, Link*> getEdges() const{
                return edges;
            }

            void addResource(string name, Resource* resource);
            void addEdge(string name, Link* edge);

            void removeResource(string name);
            void removeEdge(string name);
    };
}