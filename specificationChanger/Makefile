CC = g++
STD= std=c++11
SOURCE_PATH = ./src
INCLUDE_PATH = ./include
OUTPUT_PATH = ./build
##############################################################################
compile: main.o applicationGraph.o architectureGraph.o changeSpec.o dependency.o edge.o element.o helper.o IAttributes.o link.o loadsave.o mapping.o message.o node.o resource.o router.o specificationGraph.o task.o
##############################################################################
build: $(OUTPUT_PATH)/*.o
	$(CC) -$(STD) -o $(OUTPUT_PATH)/$@ $^
##############################################################################
run: build
	$(OUTPUT_PATH)/build $(option) $(perc_task) $(perc_processor) $(seed)
##############################################################################
# Build object files
main.o: $(SOURCE_PATH)/main.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
applicationGraph.o: $(SOURCE_PATH)/applicationGraph.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
architectureGraph.o: $(SOURCE_PATH)/architectureGraph.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
changeSpec.o: $(SOURCE_PATH)/changeSpec.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
dependency.o: $(SOURCE_PATH)/dependency.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
edge.o: $(SOURCE_PATH)/edge.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
element.o: $(SOURCE_PATH)/element.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
helper.o: $(SOURCE_PATH)/helper.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
IAttributes.o: $(SOURCE_PATH)/IAttributes.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
link.o: $(SOURCE_PATH)/link.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
loadsave.o: $(SOURCE_PATH)/loadsave.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
mapping.o: $(SOURCE_PATH)/mapping.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
message.o: $(SOURCE_PATH)/message.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
node.o: $(SOURCE_PATH)/node.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
resource.o: $(SOURCE_PATH)/resource.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
router.o: $(SOURCE_PATH)/router.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
specificationGraph.o: $(SOURCE_PATH)/specificationGraph.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
task.o: $(SOURCE_PATH)/task.cpp
	$(CC) -$(STD) -c $^ -o $(OUTPUT_PATH)/$@
###	##########################################################################
# Cleanup the last build
clean:
	@echo "Graph project cleanup"
	rm -f $(OUTPUT_PATH)/*
	rm -f $(INCLUDE_PATH)/*.gch
##############################################################################
.PHONY: clean compile build run
##############################################################################
# EOF