% For all synthesis steps at once
% #heuristic unequal(_,X). [heuristicValue, heuristicModifier]

% For different options of the synthesis step
#heuristic unequal(_,bind(M,T,R)) : step(S), S == binding. [heuristicValue, heuristicModifier]
#heuristic unequal(_,reached(C,L,R1,R2)) : step(S), S == routing. [heuristicValue, heuristicModifier]
#heuristic unequal(_,hops(C,N)) : step(S), S == routing. [heuristicValue, heuristicModifier]
#heuristic unequal(_,priority(TC1,TC2)) : step(S), S == scheduling. [heuristicValue, heuristicModifier]
