% Option binding
:~ not unequal(_,bind(M,T,R)), map(M,T,R), binding == true. [-1@1, bind(M,T,R)]

% Option routing
:~ not unequal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true. [-1@1, reached(C,L,R1,R2)]
:~ not unequal(_,hops(C,_)), comm(C,A), routing == true. [-1@1,comm(C,A)]

% Option scheduling 
:~ not unequal(_,priority(T1,T2)), task(T1,A1), task(T2,A2), scheduling == true. [-1@1, priority(T1,T2)]
:~ not unequal(_,priority(C1,C2)), comm(C1,A1), comm(C2,A2), scheduling == true. [-1@1, priority(C1,C2)]
