_preference(similarity,sum).
% Binding
_preference(similarity,(4,1,(M,T,R,1)),1,for(atom(equal(exist,bind(M,T,R)))), (1,equal(exist,bind(M,T,R)))) :- equal(exist,bind(M,T,R)).
_holds(atom(equal(exist,bind(M,T,R))),0) :- not equal(_,bind(M,T,R)), legacy(map(M,T,R)), binding == true.
_preference(similarity,(4,2,(M,T,R,1)),1,for(atom(equal(exist,bind(M,T,R)))), (1,equal(exist,bind(M,T,R)))) :- equal(exist,bind(M,T,R)).
_holds(atom(equal(exist,bind(M,T,R))),0) :- not equal(_,bind(M,T,R)), map(M,T,R), binding == true.

% Routing
_preference(similarity,(4,3,(C,L,R1,R2,1)),1,for(atom(equal(exist,reached(C,L,R1,R2)))), (1,equal(exist,reached(C,L,R1,R2)))) :- equal(exist,reached(C,L,R1,R2)).
_holds(atom(equal(exist,reached(C,L,R1,R2))),0) :- not equal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true.
_preference(similarity,(4,4,(C,L,R1,R2,1)),1,for(atom(equal(exist,reached(C,L,R1,R2)))), (1,equal(exist,reached(C,L,R1,R2)))) :- equal(exist,reached(C,L,R1,R2)).
_holds(atom(equal(exist,reached(C,L,R1,R2))),0) :- not equal(_,reached(C,L,R1,R2)), legacy(comm(C,A)), legacy(link(L,R1,R2)), routing == true.

% Hops
_preference(similarity,(4,5,(C,N,1)),1,for(atom(equal(hops(C,N)))), (1,equal(hops(C,N)))) :- equal(hops(C,N)).
_holds(atom(equal(hops(C,N))),0) :- not equal(hops(C,N)), comm(C,A), legacy(hops(C,N)), routing == true.
_preference(similarity,(4,6,(C,N,1)),1,for(atom(equal(hops(C,N)))), (1,equal(hops(C,N)))) :- equal(hops(C,N)).
_holds(atom(equal(hops(C,N))),0) :- not equal(hops(C,N)), legacy(comm(C,A)), hops(C,N), routing == true.

% Scheduling
_preference(similarity,(4,7,(TC1,TC2,1)),1,for(atom(equal(exist,priority(TC1,TC2)))), (1,equal(exist,priority(TC1,TC2)))) :- equal(exist,priority(TC1,TC2)).
_holds(atom(equal(exist,priority(TC1,TC2))),0) :- not equal(_,priority(TC1,TC2)), task(TC1,A1), task(TC2,A2), scheduling == true.
_preference(similarity,(4,8,(TC1,TC2,1)),1,for(atom(equal(exist,priority(TC1,TC2)))), (1,equal(exist,priority(TC1,TC2)))) :- equal(exist,priority(TC1,TC2)).
_holds(atom(equal(exist,priority(TC1,TC2))),0) :- not equal(_,priority(TC1,TC2)), comm(TC1,A1), comm(TC2,A2), scheduling == true.
_preference(similarity,(4,9,(TC1,TC2,1)),1,for(atom(equal(exist,priority(TC1,TC2)))), (1,equal(exist,priority(TC1,TC2)))) :- equal(exist,priority(TC1,TC2)).
_holds(atom(equal(exist,priority(TC1,TC2))),0) :- not equal(_,priority(TC1,TC2)), legacy(task(TC1,A1)), legacy(task(TC2,A2)), scheduling == true.
_preference(similarity,(4,10,(TC1,TC2,1)),1,for(atom(equal(exist,priority(TC1,TC2)))), (1,equal(exist,priority(TC1,TC2)))) :- equal(exist,priority(TC1,TC2)).
_holds(atom(equal(exist,priority(TC1,TC2))),0) :- not equal(_,priority(TC1,TC2)), legacy(comm(TC1,A1)), legacy(comm(TC2,A2)), scheduling == true.

%TODO binding step + hops are counted twice when mapping occurs in child and parent
% routing and scheduling not counted correctly
