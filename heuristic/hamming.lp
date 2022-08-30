%% Hamming distance is counting all differences between child and parent implementation
%% In implementation of unequal(both,bind(M,T,R)) a different binding of T is recorded as one difference instead of two different mappings
% Binding step
hammingBindingDistanceAdapted(H) :- H=#count{ M : unequal(_,bind(M,T,R)) }.
hammingBindingDistance(H) :- H=#count{ M1 : map(M1,T1,R1), bind(M1,T1,R1), not legacy(bind(M1,T1,R1)); M2 : legacy(map(M2,T2,R2)), legacy(bind(M2,T2,R2)), not bind(M2,T2,R2) }.

% Routing step
hammingRoutingDistanceAdapted(H) :- H=#count{ (C,L) : unequal(_,reached(C,L,R1,R2)) }.
hammingRoutingDistance(H) :- H=#count{ (C1,A1,L1) : comm(C1,A1), link(L1,_,_), reached(C1,L1,_,_), not legacy(reached(C1,L1,_,_)); (C2,A2,L2) : legacy(comm(C2,A2)), legacy(link(L2,_,_)), legacy(reached(C2,L2,_,_)), not reached(C2,L2,_,_) }.

% Get the numbers towards the distances are normalized 
numberMap(N) :- N=#count{ M1 : map(M1,T,R); M2 : legacy(map(M2,T,R)) }.
numberLinksComm(N) :- N=#count{ (C1,A1,L1) : comm(C1,A1), link(L1,_,_); (C2,A2,L2) : legacy(comm(C2,A2)), legacy(link(L2,_,_)) }.

#show hammingBindingDistance/1.
#show hammingBindingDistanceAdapted/1.
#show hammingRoutingDistance/1.
#show hammingRoutingDistanceAdapted/1.

#show numberMap/1.
#show numberLinksComm/1.
