task(t1). task(t2).
processingType(dsp). processingType(uC).

map(m0, t1, dsp).
map(m1, t1, uC).
map(m2, t2, dsp).

upperBound(TYPE,N) :- processingType(TYPE), N=#count{M:map(M,_,TYPE)}.

lowerBound(dsp, 0). lowerBound(uC, 0). % TODO

1{quantAlloc(TYPE,LOWER..UPPER)}1 :- processingType(TYPE), upperBound(TYPE,UPPER), lowerBound(TYPE,LOWER).
instance(TYPE,1..N) :- quantAlloc(TYPE,N).

1{ bind(T,X,L..U) : lowerBound(X,L), upperBound(X,U) }1 :- task(T).
:- bind(T,X,N), not instance(X,N).
:- bind(T,X,N), not map(_,T,X).
:- instance(TYPE,N), not bind(_,TYPE,N).

1 { selectedMapping(T,M,X) : map(M,T,X) } 1 :- task(T).
:- selectedMapping(T,M,X), not bind(T,X,_).