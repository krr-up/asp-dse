%TODO Is not working for any synthesis step correctly yet

% Option binding
:~ not unequal(_,bind(M,T,R)), bind(M,T,R), step(S), S == binding. [-1@1, bind(M,T,R)]
:~ not unequal(_,bind(M,T,R)), legacy(bind(M,T,R)), step(S), S == binding. [-1@1, bind(M,T,R)]

% Option routing
:~ not unequal(_,reached(C,L,R1,R2)), reached(C,L,R1,R2), step(S), S == routing. [-1@1, reached(C,L,R1,R2)]
:~ not unequal(_,reached(C,L,R1,R2)), legacy(reached(C,L,R1,R2)), step(S), S == routing. [-1@1, reached(C,L,R1,R2)]
:~ not unequal(_,hops(C,N)), hops(C,N), step(S), S == routing. [-1@1,hops(C,N)]
:~ not unequal(_,hops(C,N)), legacy(hops(C,N)), step(S), S == routing. [-1@1, hops(C,N)]

% Option scheduling 
:~ not unequal(_,priority(TC1,TC2)), priority(TC1,TC2), step(S), S == scheduling. [-1@1, priority(TC1,TC2)]
:~ not unequal(_,priority(TC1,TC2)), legacy(priority(TC1,TC2)), step(S), S == scheduling. [-1@1, priority(TC1,TC2)]
