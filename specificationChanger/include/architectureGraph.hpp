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
            list<Link*> edges;
        public:
            ArchitectureGraph(string id, string configuration);
            ~ArchitectureGraph();

            map<string, Resource*> getResources() const{
                return resources;
            }
            list<Link*> getEdges() const{
                return edges;
            }

            void addResource(string name, Resource* resource);
            void addEdge(Link* edge);

            void removeResource(string name);
            void removeEdge(Link* edge);
    };
}