_preference(similarity,sum).
% Binding
_preference(similarity,(4,1,(M,T,R,-1)),1,for(atom(unequal(both,bind(M,T,R)))), (-1,unequal(both,bind(M,T,R)))) :- unequal(_,bind(M,T,R)).
_holds(atom(unequal(both,bind(M,T,R))),0) :- not unequal(_,bind(M,T,R)), map(M,T,R), binding == true.

% Routing
_preference(similarity,(4,2,(C,L,R1,R2,-1)),1,for(atom(unequal(both,reached(C,L,R1,R2)))), (-1,unequal(both,reached(C,L,R1,R2)))) :- unequal(both,reached(C,L,R1,R2)).
_holds(atom(unequal(both,reached(C,L,R1,R2))),0) :- not unequal(_,reached(C,L,R1,R2)), comm(C,A), link(L,R1,R2), routing == true.

% Hops
_preference(similarity,(4,3,(C,N,-1)),1,for(atom(unequal(both,hops(C,N)))), (-1,unequal(both,hops(C,N)))) :- unequal(_,hops(C,N)).
_holds(atom(unequal(both,hops(C,N))),0) :- not unequal(_,hops(C,N)), comm(C,A), legacy(hops(C,N)), routing == true.

% Scheduling
_preference(similarity,(4,4,(TC1,TC2,-1)),1,for(atom(unequal(both,priority(TC1,TC2)))), (-1,unequal(both,priority(TC1,TC2)))) :- unequal(both,priority(TC1,TC2)).
_holds(atom(unequal(both,priority(TC1,TC2))),0) :- not unequal(_,priority(TC1,TC2)), task(TC1,A1), task(TC2,A2), scheduling == true.
_preference(similarity,(4,5,(TC1,TC2,-1)),1,for(atom(unequal(both,priority(TC1,TC2)))), (-1,unequal(both,priority(TC1,TC2)))) :- unequal(both,priority(TC1,TC2)).
_holds(atom(unequal(both,priority(TC1,TC2))),0) :- not unequal(_,priority(TC1,TC2)), comm(TC1,A1), comm(TC2,A2), scheduling == true.

%TODO Only counts equal(notExist,bind()) and equal(notExist,reached())
% hops + scheduling are not counted correctly
