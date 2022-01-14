% For all synthesis steps at once
% :- unequal(_,X).

% For different options of the synthesis step
:- unequal(_,bind(M,T,P)), step(S), S == binding.
:- unequal(_,reached(C,L,R1,R2)), step(S), S == routing.
:- unequal(_,hops(C,N)), step(S), S == routing.
:- unequal(_,priority(TC1,TC2)), step(S), S == scheduling.
