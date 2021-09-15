%patterns(2,3,1).

application(X) :- patterns(_,_,X).

series(P,A) :- patterns(NS,NP,A), P=1..NS.
parallel(P,A) :- patterns(NS,NP,A), P=NS+1..NP+NS.

pattern(P,A) :- series(P,A).
pattern(P,A) :- parallel(P,A).

%Parallel pattern has 4 children (may be terminal)
1{contains(P1,P2,N,A) : pattern(P2,A), P1!=P2; contains(P1,term(N),N,A)}1 :- parallel(P1,A), N=1..4.

%Series pattern has 3 children (may be terminal)
1{contains(P1,P2,N,A) : pattern(P2,A), P1!=P2; contains(P1,term(N),N,A)}1 :- series(P1,A), N=1..3.

:- contains(P1,P2,X,A), contains(P1,P2,Y,A), X!=Y.

contains(P1,P2,A) :- contains(P1,P2,_,A).

%A pattern must not be contained in 2 different patterns
:- contains(P1,P2,A), contains(P3,P2,A), pattern(P2,A), P1!=P3.

1{start(P,A) : pattern(P,A)}1 :- patterns(_,_,A).
reachable(P,A) :- start(P,A).
reachable(P2,A) :- contains(P1,P2,A), reachable(P1,A).
:- not reachable(P,A), pattern(P,A).

contains_trans(P1, P2, A) :- contains(P1, P2, A), pattern(P2,A).
contains_trans(P1, P3, A) :- contains_trans(P1,P2,A), contains(P2, P3, A), pattern(P3, A).
:- contains_trans(P, P, A).


patternedge(P1,P2,A) :- contains(PX,P1,1,A), pattern(P1,A), contains(PX,P2,3,A), pattern(P2,A).
patternedge(P1,P2,A) :- contains(PX,P1,3,A), pattern(P1,A), contains(PX,P2,2,A), pattern(P2,A).

patternedge(P1,P2,A) :- contains(PX,P1,1,A), pattern(P1,A), contains(PX,P2,4,A), pattern(P2,A).
patternedge(P1,P2,A) :- contains(PX,P1,4,A), pattern(P1,A), contains(PX,P2,2,A), pattern(P2,A).

patternedge(term(P1,N),P2,A) :- contains(P1,term(N),N,A), contains(P1,P2,2,A), pattern(P2,A), N=3..4.
patternedge(term(P1,1),P2,A) :- contains(P1,term(1),1,A), contains(P1,P2,N,A), pattern(P2,A), N=3..4.
patternedge(P2,term(P1,N),A) :- contains(P1,P2,1,A), contains(P1,term(N),N,A), pattern(P2,A), N=3..4.
patternedge(P2,term(P1,2),A) :- contains(P1,P2,N,A), contains(P1,term(2),2,A), pattern(P2,A), N=3..4.

patternedge(P1,P3,A) :- patternedge(P1,P2,A), contains(P2,P3,1,A), pattern(P3,A).
patternedge(P3,P2,A) :- patternedge(P1,P2,A), contains(P1,P3,2,A), pattern(P3,A).


edge(X,Y,A) :- contains(P,term(1),1,A), contains(P,term(N),N,A), X=4*(P - 1) + 1, Y=4*(P - 1) + N, N=3..4.
edge(X,Y,A) :- contains(P,term(N),N,A), contains(P,term(2),2,A), X=4*(P - 1) + N, Y=4*(P - 1) + 2, N=3..4.

edge(X,Y,A) :- patternedge(P1,P2,A), contains(P1,term(2),2,A), contains(P2,term(1),1,A), X=4*(P1 - 1) + 2, Y=4*(P2 - 1) + 1.
edge(X,Y,A) :- patternedge(term(P1,N),P2,A), contains(P1,term(N),N,A), contains(P2,term(1),1,A), X=4*(P1 - 1) + N, Y=4*(P2 - 1) + 1.
edge(X,Y,A) :- patternedge(P2,term(P1,N),A), contains(P1,term(N),N,A), contains(P2,term(2),2,A), X=4*(P2 - 1) + 2, Y=4*(P1 - 1) + N.

send(task(X,A), comm(task(X,A),task(Y,A),A)) :- edge(X,Y,A).
read(task(Y,A), comm(task(X,A),task(Y,A),A)) :- edge(X,Y,A).
comm(task(X,A),task(Y,A),A) :- send(task(X,A), comm(task(X,A),task(Y,A),A)).

task(X,A) :- edge(X,_,A).
task(X,A) :- edge(_,X,A).

#show comm/3.
#show task/2.
#show edge/3.
#show read/2.
#show send/2.
#show application/1.
%#show patternedge/3.