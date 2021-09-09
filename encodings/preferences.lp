_preference(p1,max).
_preference(p1,(1,1,(M,T,A,R,Time)),1,for(atom(bind(M,T,R))),(T,Time,bind(M,T))) :- map(M,T,R), executionTime(M,Time), task(T,A).
_holds(atom(bind(M,T,R)),0) :- bind(M,T,R), map(M,T,R), executionTime(M,Time).

_preference(p2,sum).
_preference(p2,(2,1,(A,P,R,M,T)),1,for(atom(bind(M,T,R))),(P,bind(M,T,R))) :- map(M,T,R), dynamicEnergy(M,P), task(T,A).
_holds(atom(bind(M,T,R)),0) :- bind(M,T,R), map(M,T,R), dynamicEnergy(M,P).
_preference(p2,(2,2,(P,R)),1,for(atom(allocated(R))),(P,allocated(R))) :- staticPower(R,P).
_holds(atom(allocated(R)),0) :- allocated(R), staticPower(R,P).
_preference(p2,(2,3,(P,R1,R2)),1,for(atom(reached(C,L,R1,R2))),(P,reached(C,L,R1,R2))) :- link(L,R1,R2), comm(C,A), routingEnergy(P).
_holds(atom(reached(C,L,R1,R2)),0) :- reached(C,L,R1,R2), link(L,R1,R2), comm(C,A), routingEnergy(P).

_preference(p3,sum).
_preference(p3,(3,1,(C,R)),1,for(atom(allocated(R))),(C,allocated(R))) :- resourceCost(R,C).
_holds(atom(allocated(R)),0) :- allocated(R), resourceCost(R,C).