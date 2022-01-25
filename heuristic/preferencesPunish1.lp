_preference(similarity,sum).
_preference(similarity,(4,1,(M,T,R,Hamming)),1,for(atom(unequal(child,bind(M,T,R)))), (Hamming,unequal(child,bind(M,T,R)))) :- unequal(child,bind(M,T,R)), Hamming=1.
_holds(atom(unequal(child,bind(M,T,R))),0) :- unequal(child,bind(M,T,R)), map(M,T,R).
_preference(similarity,(4,2,(M,T,R,Hamming)),1,for(atom(unequal(parent,bind(M,T,R)))), (Hamming,unequal(parent,bind(M,T,R)))) :- unequal(parent,bind(M,T,R)), Hamming=1.
_holds(atom(unequal(parent,bind(M,T,R))),0) :- unequal(parent,bind(M,T,R)), legacy(bind(M,T,R)).

% Throws an error when _holds is not satisfied (when all terms are equal)