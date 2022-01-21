% For all synthesis steps at once
% :- unequal(_,X).

% For different options of the synthesis step
:- unequal(_,bind(M,T,R)), binding == true.
:- unequal(_,reached(C,L,R1,R2)), routing == true.
:- unequal(_,hops(C,N)), routing == true.
:- unequal(_,priority(TC1,TC2)), scheduling == true.
