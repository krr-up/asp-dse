% TODO It works for all single cases, but all cases together ignores unequal(_,priority(TC1,TC2))

% For all synthesis steps at once
%:~ unequal(_,X). [1@1, X]

% For different options of the synthesis step
:~ unequal(_,bind(M,T,R)), binding == true. [1@1, bind(M,T,R)]
:~ unequal(_,reached(C,L,R1,R2)), routing == true. [1@1, reached(C,L,R1,R2)]
:~ unequal(_,hops(C,N)), routing == true. [1@1, hops(C,N)]
:~ unequal(_,priority(TC1,TC2)), scheduling == true. [1@1, priority(TC1,TC2)]
