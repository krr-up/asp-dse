#const heuristicModifier = level.
#const heuristicValue = 20.

% can be all, binding, routing, scheduling
#const synthesisStep = scheduling.

% Translation which steps includes given synthesisStep
step(S) :- synthesisStep==binding, S=binding.
step(S) :- synthesisStep==routing, S=routing.
step(S) :- synthesisStep==scheduling, S=scheduling.
step(S) :- synthesisStep==all, S=binding.
step(S) :- synthesisStep==all, S=routing.
step(S) :- synthesisStep==all, S=scheduling.
