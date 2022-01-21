% Constants for selecting desired heuristic
#const heuristicModifier = true.
#const heuristicValue = 20.

% Constants for selecting desired synthesis steps
#const binding = true.
#const routing = true.
#const scheduling = false.

%NOTE These constants could extended by a heuristicModifier and -Value per synsthesis step
% to support a different heuristic per synthesis step
% e.g. Keep same bindings but choose a new routing path -> use case: failure of a router
