% Compare the implementations of new and legacy configuration

% #show unequal/2.

%%%%%%%%%%%
% BINDING %
%%%%%%%%%%%%
% Unequal, if a map only exists in one specification or a task was bound to different resources
unequal(child,bind(M,T,R)) :- bind(M,T,R), map(M,T,R), not legacy(map(M,T,R)).
unequal(parent,bind(M,T,R)) :- legacy(bind(M,T,R)), not map(M,T,R), legacy(map(M,T,R)).
unequal(both,bind(M,T,R)) :- bind(M,T,R), not legacy(bind(M,T,R)), map(M,T,R), legacy(map(M,T,R)).
unequal(both,bind(M,T,R)) :- not bind(M,T,R), legacy(bind(M,T,R)), map(M,T,R), legacy(map(M,T,R)).


%%%%%%%%%%%
% ROUTING %
%%%%%%%%%%%
% Unequal, if communication only exists in one specification or it is routed on different resources
unequal(child,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), not legacy(comm(C,A)), comm(C,A).
unequal(parent,reached(C,L,R1,R2)) :- not comm(C,A), legacy(comm(C,A)), legacy(reached(C,L,R1,R2)).
unequal(both,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), comm(C,A), legacy(comm(C,A)).
unequal(both,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), legacy(reached(C,L,R1,R2)), comm(C,A), legacy(comm(C,A)).

