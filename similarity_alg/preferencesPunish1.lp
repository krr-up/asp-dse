_preference(similarity,sum).

% Binding
_preference(similarity,(4,1,(M,T,R,1)),1,for(atom(unequal(child,bind(M,T,R)))), (1,unequal(child,bind(M,T,R))))   :- map(M,T,R).
_preference(similarity,(4,2,(M,T,R,1)),1,for(atom(unequal(parent,bind(M,T,R)))), (1,unequal(parent,bind(M,T,R)))) :- legacy(map(M,T,R)).
_preference(similarity,(4,3,(M,T,R,1)),1,for(atom(unequal(both,bind(M,T,R)))), (1,unequal(both,bind(M,T,R))))     :- map(M,T,R),legacy(map(M,T,R)).
_holds(atom(unequal(child,bind(M,T,R))),0) :- unequal(child,bind(M,T,R)), binding == true.
_holds(atom(unequal(parent,bind(M,T,R))),0) :- unequal(parent,bind(M,T,R)), binding == true.
_holds(atom(unequal(both,bind(M,T,R))),0) :- unequal(both,bind(M,T,R)), binding == true.

% Routing
_preference(similarity,(4,4,(C,L,R1,R2,1)),1,for(atom(unequal(child,reached(C,L,R1,R2)))), (1,unequal(child,reached(C,L,R1,R2))))   :- comm(C,_), link(L,R1,R2).
_preference(similarity,(4,5,(C,L,R1,R2,1)),1,for(atom(unequal(parent,reached(C,L,R1,R2)))), (1,unequal(parent,reached(C,L,R1,R2)))) :- legacy(comm(C,_)), legacy(link(L,R1,R2)).
_preference(similarity,(4,6,(C,L,R1,R2,1)),1,for(atom(unequal(both,reached(C,L,R1,R2)))), (1,unequal(both,reached(C,L,R1,R2))))     :- comm(C,_), link(L,R1,R2), 
                                                                                                                                       legacy(comm(C)), legacy(link(L,R1,R2)).
_holds(atom(unequal(child,reached(C,L,R1,R2))),0) :- unequal(child,reached(C,L,R1,R2)), routing == true.
_holds(atom(unequal(parent,reached(C,L,R1,R2))),0) :- unequal(parent,reached(C,L,R1,R2)), routing == true.
_holds(atom(unequal(both,reached(C,L,R1,R2))),0) :- unequal(both,reached(C,L,R1,R2)), routing == true.

% Hops
_preference(similarity,(4,7,(C,N,1)),1,for(atom(unequal(child,hops(C,N)))), (1,unequal(child,hops(C,N))))   :- N=1..Max, Max=#count{link(L,R1,R2):link(L,R1,R2)}, comm(C,_).
_preference(similarity,(4,8,(C,N,1)),1,for(atom(unequal(parent,hops(C,N)))), (1,unequal(parent,hops(C,N)))) :- N=1..Max, Max=#count{legacy(link(L,R1,R2)):legacy(link(L,R1,R2))}, comm(C,_).
_preference(similarity,(4,9,(C,N,1)),1,for(atom(unequal(both,hops(C,N)))), (1,unequal(both,hops(C,N))))     :- N=1..Max, Max=#count{link(L,R1,R2):legacy(link(L,R1,R2)); link(L,R1,R2):link(L,R1,R2)}, comm(C,_).
_holds(atom(unequal(child,hops(C,N))),0) :- unequal(child,hops(C,N)), routing == true.
_holds(atom(unequal(parent,hops(C,N))),0) :- unequal(parent,hops(C,N)), routing == true.
_holds(atom(unequal(both,hops(C,N))),0) :- unequal(both,hops(C,N)), routing == true.
