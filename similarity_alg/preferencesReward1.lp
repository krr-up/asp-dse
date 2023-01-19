_preference(similarity,sum).

% Binding
_preference(similarity,(4,1,(M,T,R,-1)),1,for(atom(equal(exist,bind(M,T,R)))), (-1,equal(exist,bind(M,T,R))))    :- map(M,T,R), legacy(map(M,T,R)).
_preference(similarity,(4,2,(M,T,R,-1)),1,for(atom(equal(notExist,bind(M,T,R)))), (-1,equal(notExist,bind(M,T,R)))) :- map(M,T,R), not legacy(map(M,T,R)).
_preference(similarity,(4,3,(M,T,R,-1)),1,for(atom(equal(notExist,bind(M,T,R)))), (-1,equal(notExist,bind(M,T,R)))) :- not map(M,T,R), legacy(map(M,T,R)).
_holds(atom(equal(exist,bind(M,T,R))),0) :- equal(exist,bind(M,T,R)), binding == true.
_holds(atom(equal(notExist,bind(M,T,R))),0) :- equal(notExist,bind(M,T,R)), binding == true.

% Routing
_preference(similarity,(4,4,(C,L,R1,R2,-1)),1,for(atom(equal(exist,reached(C,L,R1,R2)))), (-1,equal(exist,reached(C,L,R1,R2)))) :- comm(C,A), link(L,R1,R2),
                                                                                                                                   legacy(comm(C,A)), legacy(link(L,R1,R2)).
_preference(similarity,(4,5,(C,L,R1,R2,-1)),1,for(atom(equal(notExist,reached(C,L,R1,R2)))), (-1,equal(notExist,reached(C,L,R1,R2)))) :- comm(C,A), link(L,R1,R2).
_preference(similarity,(4,6,(C,L,R1,R2,-1)),1,for(atom(equal(notExist,reached(C,L,R1,R2)))), (-1,equal(notExist,reached(C,L,R1,R2)))) :- legacy(comm(C,A)), legacy(link(L,R1,R2)).
_holds(atom(equal(exist,reached(C,L,R1,R2))),0) :- equal(exist,reached(C,L,R1,R2)), routing == true.
_holds(atom(equal(notExist,reached(C,L,R1,R2))),0) :- equal(notExist,reached(C,L,R1,R2)), routing == true.



