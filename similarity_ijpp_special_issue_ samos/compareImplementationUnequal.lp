% Compare the implementations of new and legacy configuration

% #show unequal/2.

%%%%%%%%%%%
% BINDING %
%%%%%%%%%%%%
% Unequal, if a map only exists in one specification or a task was bound to different resources
unequal(child,bind(M,T,R)) :- bind(M,T,R), map(M,T,R), not legacy(map(M,T,R)).
unequal(parent,bind(M,T,R)) :- legacy(bind(M,T,R)), not map(M,T,R), legacy(map(M,T,R)).
unequal(both,bind(M1,T,R1)) :- bind(M1,T,R1), legacy(bind(M2,T,R2)), map(M2,T,R2), legacy(map(M2,T,R2)),  R1!=R2.
%NOTE This differentiation can be used to avoid counting unequally bound tasks twice


%%%%%%%%%%%
% ROUTING %
%%%%%%%%%%%
% Unequal, if communication only exists in one specification or it is routed on different resources
unequal(child,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), not legacy(comm(C,A)), comm(C,A).
unequal(parent,reached(C,L,R1,R2)) :- not comm(C,A), legacy(comm(C,A)), legacy(reached(C,L,R1,R2)).
unequal(both,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), comm(C,A), legacy(comm(C,A)).

% Unequal, if communication only exists in one specification or hop number is different
unequal(child,hops(C,N)) :- hops(C,N), not legacy(comm(C,A)), comm(C,A).
unequal(parent,hops(C,N)) :- not comm(C,A), legacy(comm(C,A)), legacy(hops(C,N)).
unequal(both,hops(C,N)) :- hops(C,N), legacy(hops(C,N')), N!=N'.


% %%%%%%%%%%%%%%
% % SCHEDULING %
% %%%%%%%%%%%%%%
% Unequal, if a task / communication only exists in one specification or there is a different priority order
unequal(child,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(task(TC1,A)), task(TC1,A).
unequal(child,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(task(TC2,A)), task(TC2,A).
unequal(child,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(comm(TC1,A)), comm(TC1,A).
unequal(child,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(comm(TC2,A)), comm(TC2,A).
unequal(parent,priority(TC1,TC2)) :- not task(TC1,A), legacy(task(TC1,A)), legacy(priority(TC1,TC2)).
unequal(parent,priority(TC1,TC2)) :- not task(TC2,A), legacy(task(TC2,A)), legacy(priority(TC1,TC2)).
unequal(parent,priority(TC1,TC2)) :- not comm(TC1,A), legacy(comm(TC1,A)), legacy(priority(TC1,TC2)).
unequal(parent,priority(TC1,TC2)) :- not comm(TC2,A), legacy(comm(TC2,A)), legacy(priority(TC1,TC2)).
unequal(both,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(priority(TC1,TC2)), task(TC1,A1), task(TC2,A2), legacy(task(TC1,A1)), legacy(task(TC2,A2)).
unequal(both,priority(TC1,TC2)) :- not priority(TC1,TC2), legacy(priority(TC1,TC2)), task(TC1,A1), task(TC2,A2), legacy(task(TC1,A1)), legacy(task(TC2,A2)).
unequal(both,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(priority(TC1,TC2)), comm(TC1,A1), comm(TC2,A2), legacy(comm(TC1,A1)), legacy(comm(TC2,A2)).
unequal(both,priority(TC1,TC2)) :- not priority(TC1,TC2), legacy(priority(TC1,TC2)), comm(TC1,A1), comm(TC2,A2), legacy(comm(TC1,A1)), legacy(comm(TC2,A2)).
