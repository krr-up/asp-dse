:- bind(M1,T,R1), legacy(bind(M2,T,R2)), equalProc(processor(R2,_,_,_)), R1!=R2.

#const heuristicModifier = level.
#const heuristicValue = 20.
#heuristic bind(M,T,R). [heuristicValue, heuristicModifier]

#heuristic equalBind(bind(M,T,R)). 		[heuristicValue, heuristicModifier]
#heuristic bind(M,T,R) : legacy(bind(M,T,R)), equalMap(map(M,T,R)). [heuristicValue, heuristicModifier]
