% TODO It works for all single cases, but all cases together ignores not equal(_,priority(TC1,TC2))

% Option binding
:~ not equal(_,bind(M,T,R)), map(M,T,R), binding == true. [1@1, bind(M,T,R)]
:~ not equal(_,bind(M,T,R)), legacy(bind(M,T,R)), binding == true. [1@1, bind(M,T,R)]

% Option routing
:~ not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true. [1@1, reached(C,L,R1,R2)]
:~ not equal(_,reached(C,L,R1,R2)), legacy(reached(C,L,R1,R2)), routing == true. [1@1, reached(C,L,R1,R2)]
:~ not equal(hops(C,_)), comm(C,A), routing == true. [1@1,comm(C,A)]
:~ not equal(hops(C,N)), legacy(hops(C,N)), routing == true. [1@1, hops(C,N)]

% Option scheduling 
%TODO problematic, because not for every task and communication a priority term is set -> but actually should be contained in equal(notExist,_)
% :~ not equal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), scheduling == true. [1@1, priority(T1,T2)]
% :~ not equal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), scheduling == true. [1@1, priority(C1,C2)]
:~ not equal(_,priority(TC1,TC2)), legacy(priority(TC1,TC2)), scheduling == true. [1@1, priority(TC1,TC2)]
