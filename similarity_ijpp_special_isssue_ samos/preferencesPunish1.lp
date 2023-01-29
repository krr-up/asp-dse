_preference(similarity,sum).

% Binding
_preference(similarity,(4,1,(M,T,R,1)),1,for(atom(unequal(child,bind(M,T,R)))), (1,unequal(child,bind(M,T,R)))) :- unequal(child,bind(M,T,R)).
_holds(atom(unequal(child,bind(M,T,R))),0) :- unequal(child,bind(M,T,R)), binding == true.
_preference(similarity,(4,2,(M,T,R,1)),1,for(atom(unequal(parent,bind(M,T,R)))), (1,unequal(parent,bind(M,T,R)))) :- unequal(parent,bind(M,T,R)).
_holds(atom(unequal(parent,bind(M,T,R))),0) :- unequal(parent,bind(M,T,R)), binding == true.
_preference(similarity,(4,3,(M,T,R,1)),1,for(atom(unequal(both,bind(M,T,R)))), (1,unequal(both,bind(M,T,R)))) :- unequal(both,bind(M,T,R)).
_holds(atom(unequal(both,bind(M,T,R))),0) :- unequal(both,bind(M,T,R)), binding == true.

% Routing
_preference(similarity,(4,4,(C,L,R1,R2,1)),1,for(atom(unequal(child,reached(C,L,R1,R2)))), (1,unequal(child,reached(C,L,R1,R2)))) :- unequal(child,reached(C,L,R1,R2)).
_holds(atom(unequal(child,reached(C,L,R1,R2))),0) :- unequal(child,reached(C,L,R1,R2)), routing == true.
_preference(similarity,(4,5,(C,L,R1,R2,1)),1,for(atom(unequal(parent,reached(C,L,R1,R2)))), (1,unequal(parent,reached(C,L,R1,R2)))) :- unequal(parent,reached(C,L,R1,R2)).
_holds(atom(unequal(parent,reached(C,L,R1,R2))),0) :- unequal(parent,reached(C,L,R1,R2)), routing == true.
_preference(similarity,(4,6,(C,L,R1,R2,1)),1,for(atom(unequal(both,reached(C,L,R1,R2)))), (1,unequal(both,reached(C,L,R1,R2)))) :- unequal(both,reached(C,L,R1,R2)).
_holds(atom(unequal(both,reached(C,L,R1,R2))),0) :- unequal(both,reached(C,L,R1,R2)), routing == true.

% Hops
_preference(similarity,(4,7,(C,N,1)),1,for(atom(unequal(child,hops(C,N)))), (1,unequal(child,hops(C,N)))) :- unequal(child,hops(C,N)).
_holds(atom(unequal(child,hops(C,N))),0) :- unequal(child,hops(C,N)), routing == true.
_preference(similarity,(4,8,(C,N,1)),1,for(atom(unequal(parent,hops(C,N)))), (1,unequal(parent,hops(C,N)))) :- unequal(parent,hops(C,N)).
_holds(atom(unequal(parent,hops(C,N))),0) :- unequal(parent,hops(C,N)), routing == true.
_preference(similarity,(4,9,(C,N,1)),1,for(atom(unequal(both,hops(C,N)))), (1,unequal(both,hops(C,N)))) :- unequal(both,hops(C,N)).
_holds(atom(unequal(both,hops(C,N))),0) :- unequal(both,hops(C,N)), routing == true.

% Scheduling
_preference(similarity,(4,10,(TC1,TC2,1)),1,for(atom(unequal(child,priority(TC1,TC2)))), (1,unequal(child,priority(TC1,TC2)))) :- unequal(child,priority(TC1,TC2)).
_holds(atom(unequal(child,priority(TC1,TC2))),0) :- unequal(child,priority(TC1,TC2)), scheduling == true.
_preference(similarity,(4,11,(TC1,TC2,1)),1,for(atom(unequal(parent,priority(TC1,TC2)))), (1,unequal(parent,priority(TC1,TC2)))) :- unequal(parent,priority(TC1,TC2)).
_holds(atom(unequal(parent,priority(TC1,TC2))),0) :- unequal(parent,priority(TC1,TC2)), scheduling == true.
_preference(similarity,(4,12,(TC1,TC2,1)),1,for(atom(unequal(both,priority(TC1,TC2)))), (1,unequal(both,priority(TC1,TC2)))) :- unequal(both,priority(TC1,TC2)).
_holds(atom(unequal(both,priority(TC1,TC2))),0) :- unequal(both,priority(TC1,TC2)), scheduling == true.
