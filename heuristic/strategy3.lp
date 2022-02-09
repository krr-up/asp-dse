% Binding
% Only force an equal binding when processor was not deleted
:- unequal(_,bind(M,T,R)), equalProc(R), binding == true.

% Routing
:- unequal(_,reached(C,L,R1,R2)), equalComm(comm(C,A)), equalLink(link(L,R1,R2)), routing == true.
:- unequal(_,hops(C,N)), equalComm(comm(C,A)), routing == true.

% Scheduling
:- unequal(_,priority(TC1,TC2)), equalTask(task(TC1,A1)), equalTask(task(TC2,A2)), scheduling == true.
:- unequal(_,priority(TC1,TC2)), equalComm(comm(TC1,A1)), equalComm(comm(TC2,A2)), scheduling == true.
