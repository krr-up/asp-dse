#const heuristicModifier = true.
#const heuristicValue = 20.

% can be all, binding, routing, scheduling
#const synthesisStep = all.

% Translation which steps includes given synthesisStep
step(S) :- synthesisStep==binding, S=binding.
step(S) :- synthesisStep==routing, S=routing.
step(S) :- synthesisStep==scheduling, S=scheduling.
step(S) :- synthesisStep==all, S=binding.
step(S) :- synthesisStep==all, S=routing.
step(S) :- synthesisStep==all, S=scheduling.

%NOTE These constants could extended by a heuristicModifier and -Value per synsthesis step
% to support a different heuristic per synthesis step
% e.g. Keep same bindings but choose a new routing path -> use case: failure of a router

