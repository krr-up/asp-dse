% For all synthesis steps at once
% #heuristic equal(_,X). [heuristicValue, heuristicModifier]

% For different options of the synthesis step
#heuristic equal(_,bind(M,T,R)) : step(S), S == binding. [heuristicValue, heuristicModifier]
#heuristic equal(_,reached(C,L,R1,R2)) : step(S), S == routing. [heuristicValue, heuristicModifier]
#heuristic equal(_,hops(C,N)) : step(S), S == routing. [heuristicValue, heuristicModifier]
#heuristic equal(_,priority(TC1,TC2)) : step(S), S == scheduling. [heuristicValue, heuristicModifier]
