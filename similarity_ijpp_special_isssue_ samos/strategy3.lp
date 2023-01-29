% Binding
% Only force an equal binding when processor was not deleted
:- unequal(both,bind(M,T,R)), binding == true.

% Routing
:- unequal(both,reached(C,L,R1,R2)), send(T1,C), read(T2,C), bind(M1,T1,P1), bind(M2,T2,P2), legacy(bind(M1,T1,P1)), legacy(bind(M2,T2,P2)), routing == true.

% Scheduling
:- unequal(both,priority(TC1,TC2)), scheduling == true.
