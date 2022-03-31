% Compare the implementations of new and legacy configuration

% #show equal/2.
% #show equal/1.

%%%%%%%%%%%
% BINDING %
%%%%%%%%%%%%
% Binding is either equally existing or equally not existing
equal(exist,bind(M,T,R)) :- bind(M,T,R), legacy(bind(M,T,R)).
equal(notExist,bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), map(M,T,R).
equal(notExist,bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), legacy(map(M,T,R)).


%%%%%%%%%%%
% ROUTING %
%%%%%%%%%%%
% Routing is either equally existing or equally not existing
equal(exist,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), legacy(reached(C,L,R1,R2)).
equal(notExist,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2).
equal(notExist,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), legacy(comm(C,A)), legacy(link(L,R1,R2)).

% Equal, if same number of hops for a communication
equal(hops(C,N)) :- hops(C,N), legacy(hops(C,N)).


% %%%%%%%%%%%%%%
% % SCHEDULING %
% %%%%%%%%%%%%%%
% A priority is either equally existing or equally not existing
equal(exist,priority(TC1,TC2)) :- priority(TC1,TC2), legacy(priority(TC1,TC2)).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), task(TC1,A1), task(TC2,A2).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), comm(TC1,A1), comm(TC2,A2).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), legacy(task(TC1,A1)), legacy(task(TC2,A2)).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), legacy(comm(TC1,A1)), legacy(comm(TC2,A2)).
