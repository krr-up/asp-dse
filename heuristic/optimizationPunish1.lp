% TODO It works for all single cases, but all cases together ignores unequal(_,priority(TC1,TC2))

% For all synthesis steps at once
%:~ unequal(_,X). [1@1, X]

% For different options of the synthesis step
:~ unequal(_,bind(M,T,R)), step(S), S == binding. [1@1, bind(M,T,R)]
:~ unequal(_,reached(C,L,R1,R2)), step(S), S == routing. [1@1, reached(C,L,R1,R2)]
:~ unequal(_,hops(C,N)), step(S), S == routing. [1@1, hops(C,N)]
:~ unequal(_,priority(TC1,TC2)), step(S), S == scheduling. [1@1, priority(TC1,TC2)]
