_preference(similarity,sum).
_preference(similarity,(4,1,(M,T,R,Hamming)),1,for(atom(equal(exist,bind(M,T,R)))), (Hamming,equal(exist,bind(M,T,R)))) :- equal(exist,bind(M,T,R)), Hamming=1.
_holds(atom(equal(exist,bind(M,T,R))),0) :- not equal(exist,bind(M,T,R)), map(M,T,R).
_preference(similarity,(4,2,(M,T,R,Hamming)),1,for(atom(equal(notExist,bind(M,T,R)))), (Hamming,equal(notExist,bind(M,T,R)))) :- equal(notExist,bind(M,T,R)), Hamming=1.
_holds(atom(equal(notExist,bind(M,T,R))),0) :- not equal(notExist,bind(M,T,R)), legacy(map(M,T,R)).

% Throws an error when _holds is not satisfied (when all terms are equal)
%TODO the unequal occurences are counted twice (for child and for parent)
