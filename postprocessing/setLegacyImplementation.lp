% This ASP-program takes an implementation and changes it to a legacy implementation

% Surround every element from implementation with legacy term
legacy(bind(M,T,P)) :- bind(M,T,P).
legacy(reached(C,L,R1,R2)) :- reached(C,L,R1,R2).
legacy(hops(C,N)) :- hops(C,N).
legacy(dl(TC,N)) :- dl(TC,N).
legacy(pref(TERM1,TERM2,N)) :- pref(TERM1,TERM2,N).

% priority is not explicitly given and needs to be derived
legacy(priority(T1,T2)) :- task(T1,A1),task(T2,A2), T1 < T2, 
                            bind(_,T1,R), bind(_,T2,R),
                            not depends_trans(T2,T1), not depends_trans(T1,T2).
legacy(priority(C1,C2)) :- 1 #sum{ 1 : reached(C1,L,R1,R2), reached(C2,L,R1,R2)},
                            comm(C1,A), comm(C2,A'), C1 < C2,
                            not depends_trans(C1,C2), not depends_trans(C2,C1).
                        
#show legacy/1.