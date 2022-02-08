_preference(similarity,sum).

% Binding
_preference(similarity,(4,1,(M,T,R,-1)),1,for(atom(equal(exist,bind(M,T,R)))), (-1,equal(exist,bind(M,T,R)))) :- equal(exist,bind(M,T,R)).
_holds(atom(equal(exist,bind(M,T,R))),0) :- equal(exist,bind(M,T,R)), binding == true.
_preference(similarity,(4,2,(M,T,R,-1)),1,for(atom(equal(notExist,bind(M,T,R)))), (-1,equal(notExist,bind(M,T,R)))) :- equal(notExist,bind(M,T,R)).
_holds(atom(equal(notExist,bind(M,T,R))),0) :- equal(notExist,bind(M,T,R)), binding == true.

% Routing
_preference(similarity,(4,3,(C,L,R1,R2,-1)),1,for(atom(equal(exist,reached(C,L,R1,R2)))), (-1,equal(exist,reached(C,L,R1,R2)))) :- equal(exist,reached(C,L,R1,R2)).
_holds(atom(equal(exist,reached(C,L,R1,R2))),0) :- equal(exist,reached(C,L,R1,R2)), routing == true.
_preference(similarity,(4,4,(C,L,R1,R2,-1)),1,for(atom(equal(notExist,reached(C,L,R1,R2)))), (-1,equal(notExist,reached(C,L,R1,R2)))) :- equal(notExist,reached(C,L,R1,R2)).
_holds(atom(equal(notExist,reached(C,L,R1,R2))),0) :- equal(notExist,reached(C,L,R1,R2)), routing == true.

% Hops
_preference(similarity,(4,5,(C,N,-1)),1,for(atom(equal(hops(C,N)))), (-1,equal(hops(C,N)))) :- equal(hops(C,N)).
_holds(atom(equal(hops(C,N))),0) :- equal(hops(C,N)), routing == true.

% Scheduling
_preference(similarity,(4,6,(TC1,TC2,-1)),1,for(atom(equal(exist,priority(TC1,TC2)))), (-1,equal(exist,priority(TC1,TC2)))) :- equal(exist,priority(TC1,TC2)).
_holds(atom(equal(exist,priority(TC1,TC2))),0) :- equal(exist,priority(TC1,TC2)), scheduling == true.
_preference(similarity,(4,7,(TC1,TC2,-1)),1,for(atom(equal(notExist,priority(TC1,TC2)))), (-1,equal(notExist,priority(TC1,TC2)))) :- equal(notExist,priority(TC1,TC2)).
_holds(atom(equal(notExist,priority(TC1,TC2))),0) :- equal(notExist,priority(TC1,TC2)), scheduling == true.
