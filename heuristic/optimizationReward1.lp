%TODO Works for all synthesis steps except for scheduling

% For all synthesis steps at once
% :~ equal(_,X). [-1@1, X]

% For different options of the synthesis step
:~ equal(_,bind(M,T,R)), step(S), S == binding. [-1@1, bind(M,T,R)]
:~ equal(_,reached(C,L,R1,R2)), step(S), S == routing. [-1@1, reached(C,L,R1,R2)]
:~ equal(hops(C,N)), step(S), S == routing. [-1@1, hops(C,N)]
:~ equal(_,priority(TC1,TC2)), step(S), S == scheduling. [-1@1, priority(TC1,TC2)]
