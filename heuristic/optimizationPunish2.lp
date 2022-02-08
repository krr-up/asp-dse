% Option binding
:~ not equal(_,bind(M,T,R)), map(M,T,R), binding == true. [1@1, bind(M,T,R)]
:~ not equal(_,bind(M,T,R)), legacy(map(M,T,R)), binding == true. [1@1, bind(M,T,R)]

% Option routing
:~ not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true. [1@1, reached(C,L,R1,R2)]
:~ not equal(_,reached(C,L,R1,R2)), legacy(comm(C,A)), legacy(link(L,R1,R2)), routing == true. [1@1, reached(C,L,R1,R2)]
:~ not equal(hops(C,_)), comm(C,A), legacy(hops(C,N)), routing == true. [1@1,comm(C,A)]
:~ not equal(hops(C,_)), legacy(comm(C,A)), hops(C,N), routing == true. [1@1, hops(C,N)]

% Option scheduling 
:~ not equal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), scheduling == true. [1@1, priority(T1,T2)]
:~ not equal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), scheduling == true. [1@1, priority(C1,C2)]
:~ not equal(_,priority(T1,T2)), legacy(task(T1,A1)), legacy(task(T2,A2)), scheduling == true. [1@1, priority(T1,T2)]
:~ not equal(_,priority(C1,C2)), legacy(comm(C1,A1)), legacy(comm(C2,A2)), scheduling == true. [1@1, priority(C1,C2)]

%TODO some unequal terms in the implementation are counted twice (for child and for parent) (for example binding and hops)
