% This ASP-program takes an specification and changes it to a legacy specification

% Surround every element from specification with legacy term
legacy(application(A)) :- application(A).
legacy(period(N)) :- period(N).
legacy(link(L,R1,R2)) :- link(L,R1,R2).
legacy(processor(P,X,Y,Z)) :- processor(P,X,Y,Z).
legacy(router(R,X,Y,Z)) :- router(R,X,Y,Z).
legacy(task(T,A)) :- task(T,A).
legacy(send(T,C)) :- send(T,C).
legacy(read(T,C)) :- read(T,C).
legacy(comm(C,A)) :- comm(C,A).
legacy(map(M,T,P)) :- map(M,T,P).
legacy(executionTime(M,N)) :- executionTime(M,N).
legacy(routingDelay(N)) :- routingDelay(N).
legacy(dynamicEnergy(M,N)) :- dynamicEnergy(M,N).
legacy(routingEnergy(N)) :- routingEnergy(N).
legacy(staticPower(P,N)) :- staticPower(P,N).
legacy(resourceCost(P,N)) :- resourceCost(P,N).


#show legacy/1.