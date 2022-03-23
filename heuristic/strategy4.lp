% Option binding
:- not equal(_,bind(M,T,R)), map(M,T,R), legacy(bind(_,T,R')), equalProc(processor(R',_,_,_)), binding == true.

% Option routing
:- not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), send(T1,C), read(T2,C), equal(exist,bind(M1,T1,P1)), equal(exist,bind(M2,T2,P2)), routing == true.

% Option scheduling 
:- not equal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), equalTask(task(TC1,A1)), equalTask(task(TC2,A2)), scheduling == true.
:- not equal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), equalComm(comm(TC1,A1)), equalComm(comm(TC2,A2)), scheduling == true.
