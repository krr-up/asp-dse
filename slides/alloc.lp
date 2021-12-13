task(t1). task(t2).
proc_type(dsp). proc_type(uC).

map(m0, t1, dsp).
map(m1, t1, uC).
map(m2, t2, dsp).

upper_bound(TYPE,N) :- proc_type(TYPE), N=#count{M:map(M,_,TYPE)}.

lower_bound(dsp, 0). lower_bound(uC, 0). % TODO

1{quant_alloc(TYPE,LOWER..UPPER)}1 :- proc_type(TYPE), upper_bound(TYPE,UPPER), lower_bound(TYPE,LOWER).
instance(TYPE,1..N) :- quant_alloc(TYPE,N).

1 { selected_mapping(T,M,X) : map(M,T,X) } 1 :- task(T).
:- selected_mapping(T,M,X), not bind(T,X,_).

1{ bind(T,X,L..U) : lower_bound(X,L), upper_bound(X,U) }1 :- task(T).
:- bind(T,X,N), not instance(X,N).
:- bind(T,X,N), not map(_,T,X).
:- instance(TYPE,N), not bind(_,TYPE,N).