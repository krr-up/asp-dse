% Option binding
:- not equal(_,bind(M,T,R)), map(M,T,R), binding == true.
:- not equal(_,bind(M,T,R)), legacy(bind(M,T,R)), binding == true.

% Option routing
:- not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true.
:- not equal(_,reached(C,L,R1,R2)), legacy(reached(C,L,R1,R2)), routing == true.
:- not equal(hops(C,_)), comm(C,A), routing == true.
:- not equal(hops(C,N)), legacy(hops(C,N)), routing == true.

% Option scheduling 
% TODO not equal(_,priority(TC1,TC2)), priority(TC1,TC2), scheduling == true would work but it contains a term which has to be set during DSE
% The solution which independent from the DSE decisions (below) are to restricting, because not for every task and communication a priority term is set -> but actually should be contained in equal(notExist,_)
% :- not equal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), scheduling == true.
% :- not equal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), scheduling == true.
:- not equal(_,priority(TC1,TC2)), legacy(priority(TC1,TC2)), scheduling == true.
