%TODO Works for all synthesis steps except for scheduling

% For all synthesis steps at once
% :~ equal(_,X). [-1@1, X]

% For different options of the synthesis step
:~ equal(_,bind(M,T,R)), binding == true. [-1@1, bind(M,T,R)]
:~ equal(_,reached(C,L,R1,R2)), routing == true. [-1@1, reached(C,L,R1,R2)]
:~ equal(hops(C,N)), routing == true. [-1@1, hops(C,N)]
:~ equal(_,priority(TC1,TC2)), scheduling == true. [-1@1, priority(TC1,TC2)]
