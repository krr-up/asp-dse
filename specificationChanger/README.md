
# SpecificationChanger

- Contains data structures representing the **specification graph** (consisting of an application graph and an architecture graph) and its elements

  

## Offers the possibility to:

-  **Load** the elements from specifications given in `path_in`

-  **Modify** the specification graph by either exchanging, adding or deleting a percentage of tasks (in the application graph) and of processors (in the architecture graph). The kind of change can be set manually or randomly. It is randomly decided which elements are changed.

-  **Save** a modified version of the specification in `path_in` (with **_m** for differentiation)

## How to use:

 - Build CMake project
 - Then run: `./alterSpec [MODIFY OPTION] [PERCENT TASKS] [PERCENT PROCESSORS] [NUMBER OF GENERATED MODIFIED SPECIFICATIONS] [RANDOM SEED]`
 -  Modify option:
		  **0** exchange elements (change charateristics);
		  **1** add elements;
		  **2** delete elements;
		  **3** decide randomly for every element to be changed
