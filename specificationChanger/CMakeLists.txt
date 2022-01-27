project(alterSpec CXX)

cmake_minimum_required(VERSION 3.12)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

set(CMAKE_SOURCE_DIR src)

set(SOURCES 
src/main.cpp src/applicationGraph.cpp src/architectureGraph.cpp src/changeSpec.cpp src/dependency.cpp src/edge.cpp src/element.cpp src/helper.cpp src/IAttributes.cpp src/link.cpp src/loadsave.cpp src/mapping.cpp src/message.cpp src/node.cpp src/resource.cpp src/router.cpp src/specificationGraph.cpp src/task.cpp
)

include_directories(include)

add_executable(alterSpec ${SOURCES})
