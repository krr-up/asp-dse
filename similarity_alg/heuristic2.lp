% For all synthesis steps at once
% #heuristic unequal(_,X). [heuristicValue, heuristicModifier]

% For different options of the synthesis step
#heuristic unequal(_,bind(M,T,R)) : binding == true. [heuristicValue, heuristicModifier]
#heuristic unequal(_,reached(C,L,R1,R2)) : routing == true. [heuristicValue, heuristicModifier]
#heuristic unequal(_,hops(C,N)) : routing == true. [heuristicValue, heuristicModifier]
#heuristic unequal(_,priority(TC1,TC2)) : scheduling == true. [heuristicValue, heuristicModifier]
