% For all synthesis steps at once
% #heuristic equal(_,X). [heuristicValue, heuristicModifier]

% For different options of the synthesis step
#heuristic equal(_,bind(M,T,R)) : binding == true. [heuristicValue, heuristicModifier]
#heuristic equal(_,reached(C,L,R1,R2)) : routing == true. [heuristicValue, heuristicModifier]
#heuristic equal(hops(C,N)) : routing == true. [heuristicValue, heuristicModifier]
#heuristic equal(_,priority(TC1,TC2)) : scheduling == true. [heuristicValue, heuristicModifier]
