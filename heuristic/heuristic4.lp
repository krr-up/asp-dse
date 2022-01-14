%TODO Doesn't work: See heuristic2.lp

% % Option binding
% #heuristic bind(M,T,R) : not unequal(_,bind(M,T,R)), bind(M,T,R), step(S), S == binding. [heuristicValue, heuristicModifier]
% #heuristic bind(M,T,R) : not unequal(_,bind(M,T,R)), legacy(bind(M,T,P)), step(S), S == binding. [heuristicValue, heuristicModifier]

% % Option routing
% #heuristic reached(C,L,R1,R2) : not unequal(_,reached(C,L,R1,R2)), reached(C,L,R1,R2), step(S), S == routing. [heuristicValue, heuristicModifier]
% #heuristic reached(C,L,R1,R2) : not unequal(_,reached(C,L,R1,R2)), legacy(reached(C,L,R1,R2)), step(S), S == routing. [heuristicValue, heuristicModifier]
% #heuristic hops(C,N) : not unequal(hops(C,N)), hops(C,N), step(S), S == routing. [heuristicValue, heuristicModifier]
% #heuristic hops(C,N) : not unequal(hops(C,N)), legacy(hops(C,N)), step(S), S == routing. [heuristicValue, heuristicModifier]

% % Option scheduling 
% #heuristic priority(TC1,TC2) : not equal(_,priority(TC1,TC2)), priority(TC1,TC2), step(S), S == scheduling. [heuristicValue, heuristicModifier]
% #heuristic priority(TC1,TC2) : not equal(_,priority(TC1,TC2)), legacy(priority(TC1,TC2)), step(S), S == scheduling. [heuristicValue, heuristicModifier]
