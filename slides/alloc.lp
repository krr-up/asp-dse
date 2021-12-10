task(t1). task(t2).
proc_type(dsp). proc_type(uC).

map(m0, t1, dsp).
map(m1, t1, uC).
map(m2, t2, dsp).

upper_bound(TYPE,N) :- proc_type(TYPE), N=#count{M:map(M,_,TYPE)}.

lower_bound(dsp, 0). lower_bound(uC, 0). % TODO

1{quant_alloc(TYPE,LOWER..UPPER)}1 :- proc_type(TYPE), upper_bound(TYPE,UPPER), lower_bound(TYPE,LOWER).
instance(TYPE,1..N) :- quant_alloc(TYPE,N).

1{bind_type(M,T,X) : map(M,T,X)}1 :- task(T).
1{bind(M,T,X,N) : instance(X,N),bind_type(M,T,X)}1 :- task(T).

:- instance(TYPE,N), not bind(_,_,TYPE,N).