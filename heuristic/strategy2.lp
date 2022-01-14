% Option binding
:- not equal(_,bind(M,T,P)), legacy(bind(M,T,P)), step(S), S == binding.
:- not equal(_,bind(M,T,P)), bind(M,T,P), step(S), S == binding.

% Option routing
:- not equal(_,reached(C,L,R1,R2)), reached(C,L,R1,R2), step(S), S == routing.
:- not equal(_,reached(C,L,R1,R2)), legacy(reached(C,L,R1,R2)), step(S), S == routing.
:- not equal(hops(C,N)), hops(C,N), step(S), S == routing.
:- not equal(hops(C,N)), legacy(hops(C,N)), step(S), S == routing.

% Option scheduling 
:- not equal(_,priority(TC1,TC2)), priority(TC1,TC2), step(S), S == scheduling.
:- not equal(_,priority(TC1,TC2)), legacy(priority(TC1,TC2)), step(S), S == scheduling.
