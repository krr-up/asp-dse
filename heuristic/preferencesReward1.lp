_preference(similarity,sum).
_preference(similarity,(4,1,(M,T,R,Hamming)),1,for(atom(equal(exist,bind(M,T,R)))), (Hamming,equal(exist,bind(M,T,R)))) :- equal(exist,bind(M,T,R)), Hamming=-1.
_holds(atom(equal(exist,bind(M,T,R))),0) :- equal(exist,bind(M,T,R)).
_preference(similarity,(4,2,(M,T,R,Hamming)),1,for(atom(equal(notExist,bind(M,T,R)))), (Hamming,equal(notExist,bind(M,T,R)))) :- equal(notExist,bind(M,T,R)), Hamming=-1.
_holds(atom(equal(notExist,bind(M,T,R))),0) :- equal(notExist,bind(M,T,R)).
