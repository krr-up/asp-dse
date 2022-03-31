% Option binding
:- not equal(_,bind(M,T,R)), map(M,T,R), legacy(bind(_,T,R')), processor(R',_,_,_), binding == true.

% Option routing
:- not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), send(T1,C), read(T2,C), equal(exist,bind(M1,T1,P1)), equal(exist,bind(M2,T2,P2)), routing == true.

% Option scheduling 
:- not equal(_,priority(T1,T2)), priority(T1,T2), scheduling == true.
:- not equal(_,priority(T1,T2)), legacy(priority(T1,T2)), scheduling == true.
