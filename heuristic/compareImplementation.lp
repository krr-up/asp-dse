% Compare the implementations of new and legacy configuration

#show equal/2.
#show unequal/2.

%%%%%%%%%%%
% BINDING %
%%%%%%%%%%%%
% Binding is either equally existing or equally not existing
equal(exist,bind(M,T,R)) :- bind(M,T,R), legacy(bind(M,T,R)).
equal(notExist,bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), map(M,T,R).
equal(notExist,bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), legacy(map(M,T,R)).
% Unequal, if binding only exists in one implementation
unequal(child,bind(M,T,R)) :- bind(M,T,R), not legacy(bind(M,T,R)).
unequal(parent,bind(M,T,R)) :- not bind(M,T,R), legacy(bind(M,T,R)).
%NOTE This differentiation can be used to avoid counting unequally bound tasks twice


%%%%%%%%%%%
% ROUTING %
%%%%%%%%%%%
% Routing is either equally existing or equally not existing
equal(exist,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), legacy(reached(C,L,R1,R2)).
equal(notExist,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2).
equal(notExist,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)), legacy(comm(C,A)), legacy(link(L,R1,R2)).

% Unequal, if routing only exists in one implementation
unequal(child,reached(C,L,R1,R2)) :- reached(C,L,R1,R2), not legacy(reached(C,L,R1,R2)).
unequal(parent,reached(C,L,R1,R2)) :- not reached(C,L,R1,R2), legacy(reached(C,L,R1,R2)).

% Equal, if same number of hops for a communication
equal(hops(C,N)) :- hops(C,N), legacy(hops(C,N)).

% Unequal, if hop number is only existing in one implementation 
unequal(child,hops(C,N)) :- hops(C,N), not legacy(hops(C,N)).
unequal(parent,hops(C,N)) :- not hops(C,N), legacy(hops(C,N)).


% %%%%%%%%%%%%%%
% % SCHEDULING %
% %%%%%%%%%%%%%%
% A priority is either equally existing or equally not existing
equal(exist,priority(TC1,TC2)) :- priority(TC1,TC2), legacy(priority(TC1,TC2)).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), task(TC1,A), task(TC2,A).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), comm(TC1,A), comm(TC2,A).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), legacy(task(TC1,A)), legacy(task(TC2,A)).
equal(notExist,priority(TC1,TC2)) :- not priority(TC1,TC2), not legacy(priority(TC1,TC2)), legacy(comm(TC1,A)), legacy(comm(TC2,A)).

% Unequal, if a priority only exists in one implementation
unequal(child,priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(priority(TC1,TC2)).
unequal(parent,priority(TC1,TC2)) :- not priority(TC1,TC2), legacy(priority(TC1,TC2)).
