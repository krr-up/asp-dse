%% Hamming distance is counting all differences between child and parent implementation
%% In implementation of unequal(both,bind(M,T,R)) a different binding of T is recorded as one difference instead of two different mappings
% Binding step
hammingBindingDistanceAdapted(H) :- H=#count{ M : unequal(_,bind(M,T,R)) }.
hammingBindingDistance(H) :- H1=#count{ M : unequal(child,bind(M,T,R)) }, H2=#count{ M : unequal(parent,bind(M,T,R)) }, H3=#count{ M : unequal(both,bind(M,T,R)) }, H = 2*H1 + 2*H2 + 2*H3. 

% Routing step
hammingRoutingDistanceAdapted(H) :- H=#count{ (C,L) : unequal(_,reached(C,L,R1,R2)) }.
hammingRoutingDistance(H) :- H1=#count{ (C,L) : unequal(child,reached(C,L,R1,R2)) }, H2=#count{ (C,L) : unequal(parent,reached(C,L,R1,R2)) }, H3=#count{ (C,L) : unequal(both,reached(C,L,R1,R2)) }, H = 2*H1 + 2*H2 + 2*H3.

% Get the numbers towards the distances are normalized 
numberMap(N) :- N=#count{ M1 : map(M1,T,R); M2 : legacy(map(M2,T,R)) }.
numberLinksComm(N) :- N=#count{ (C1,A1,L1) : comm(C1,A1), link(L1,_,_); (C2,A2,L2) : legacy(comm(C2,A2)), legacy(link(L2,_,_)) }.

#show hammingBindingDistance/1.
#show hammingBindingDistanceAdapted/1.
#show hammingRoutingDistance/1.
#show hammingRoutingDistanceAdapted/1.

#show numberMap/1.
#show numberLinksComm/1.
