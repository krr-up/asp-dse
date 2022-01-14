%% Concept from old heuristic adapted to false assignment %%

% Decide on equal binding
#heuristic notEquallyBind(B1,B2). [25,false]


% Decide on equal routing
#heuristic notEquallyReached(C1,C2). [15,false]

% Decide on equal execution order
#heuristic notEqualPriority(P). [5,false]