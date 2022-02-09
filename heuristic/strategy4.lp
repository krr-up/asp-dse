% Option binding
:- not equal(_,bind(M,T,R)), map(M,T,R), equalProc(R), binding == true.

% Option routing
:- not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), equalComm(comm(C,A)), equalLink(link(L,R1,R2)), routing == true.
:- not equal(hops(C,_)), comm(C,A), equalComm(comm(C,A)), routing == true.

% Option scheduling 
:- not equal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), equalTask(task(TC1,A1)), equalTask(task(TC2,A2)), scheduling == true.
:- not equal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), equalComm(comm(TC1,A1)), equalComm(comm(TC2,A2)), scheduling == true.
