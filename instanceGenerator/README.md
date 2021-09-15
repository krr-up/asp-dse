# Instance Generator
ASP-based generator for randomly generating DSE instances.
It generates applications (`generate_application.lp`), a hardware platform (`generate_architecture.lp`), and mapping options and other properties (`properties.lp`). 
As applications, it generates series-parallel task-graphs. 
To direct the generator the patterns and number of independent application, you *must* supply `pattern/3` atoms. 

For example,
```
pattern(1,1,1).
pattern(3,2,2).
```
would result in two independent applications. 
Application `a1` would consist of one series and one parallel pattern, whereas application `a2` would consist of three series and two parallel patterns.

The properties of the elements (task, processors, mapping, etc.) is steered by constants in ASP that can be supplied by the `-c` switch of clingo, i.e., `-c key=value`. 

More info:
[Systematic Test Case Instance Generation for the Assessment of System-level Design Space Exploration Approaches](http://dx.doi.org/10.15496/publikation-25685)


## Usage
```
clingo generate_architecture.lp generate_application.lp callback_python.py properties.lp --out-ifs=.\n --out-atomf='%s.' <patterns.lp> (-c key=value)
```
Where `<patterns.lp>` contains the requested patterns and number of applications.

Possible switches for `-c`:

|key        | default |description                                           |
|-----------|---------|------------------------------------------------------|
| seed      |  100    | Seed for the random number generator.
| comm_delay|  2      | Delay per hop
| map_min   |  2      | Minimum number of mapping options per task.
| map_max   |  4      | Maximum number of mapping options per task.
| power_min |  20     | Minimum static power consumption of a resource.
| power_max |  50     | Maximum static power consumption of a resource.
| cost_min  |  20     | Minimum cost of a resource.
| cost_max  |  50     | Maximum cost of a resource.
| instr_nr  |  4      | Number of instruction types.
| instr_min |  25     | Minimum number of instructions per type and task.
| instr_max |  250    | Maximum number of instructions per type and task.
| ipc_min   |  1      | Minimum instructions per cycle.
| ipc_max   |  4      | Maximum instructions per cycle.
| epi_min   |  2      | Minimum energy per instruction.
| epi_max   |  5      | Maximum energy per instruction.
  