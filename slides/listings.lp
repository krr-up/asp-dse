equal(bind(M,T,R)) :- bind(M,T,R), legacy(bind(M,T,R)).
equal(bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), map(M,T,R).
equal(bind(M,T,R)) :- not bind(M,T,R), not legacy(bind(M,T,R)), 			legacy(map(M,T,R)).

unequal(bind(M,T,R)) :- bind(M,T,R), not legacy(bind(M,T,R)).
unequal(bind(M,T,R)) :- not bind(M,T,R), legacy(bind(M,T,R)).

equalBind(bind(M,T,R)) :- bind(M,T,R), legacy(bind(M,T,R)).

missingBind(bind(M,T,R)) :- not bind(_,T,_), legacy(bind(M,T,R)).
addedBind(bind(M,T,R)) :- bind(M,T,R), not legacy(bind(_,T,_)).
notEquallyBind(bind(M1,T,R1),legacy(bind(M2,T,R2))) :- 				bind(M1,T,R1), legacy(bind(M2,T,R2)), R1!=R2.

:- unequal(bind(M,T,R)).
:- not equal(bind(M,T,R)).

:- unequal(bind(M,T,R)), equalProc(R).

:~ unequal(bind(M,T,R)). [1@1, bind(M,T,R)]
:~ not equal(bind(M,T,R)). [1@1, bind(M,T,R)]

:~ equal(bind(M,T,R)). [-1@1, bind(M,T,R)]
:~ not unequal(bind(M,T,R)). [-1@1, bind(M,T,R)]
	
#const modifier = level.
#const value = 10.
#heuristic equal(bind(M,T,R)). [value, modifier]
#heuristic unequal(bind(M,T,R)). [value, modifier]
