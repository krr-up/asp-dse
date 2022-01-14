%TODO Doesn't work:
%   ° #heuristic not equal(_,X) .. because of the not position
%   ° #heuristic bind(M,T,R) : not equal(_,bind(M,T,R)), .. because of the bind(M,T,R) which has to be set in the body without having the priority for the term in the head

% Option binding
% #heuristic bind(M,T,R) : not equal(_,bind(M,T,R)), map(M,T,R), step(S), S == binding. [heuristicValue, heuristicModifier]

% % Option routing
% #heuristic reached(C,L,R1,R2) : not equal(_,reached(C,L,R1,R2)), reached(C,L,R1,R2), step(S), S == routing. [heuristicValue, heuristicModifier]
% #heuristic hops(C,N) : not equal(hops(C,N)), hops(C,N), step(S), S == routing. [heuristicValue, heuristicModifier]

% % Option scheduling 
% #heuristic priority(TC1,TC2) : not equal(_,priority(TC1,TC2)), priority(TC1,TC2), step(S), S == scheduling. [heuristicValue, heuristicModifier]

%NOTE I can just at look at the "not equal" part from child perspective 
