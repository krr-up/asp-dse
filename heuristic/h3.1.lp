%% New heuristic %%

% Decide on equal binding
#heuristic bind(M,T,R) : legacy(bind(M,T,R)), equalMap(map(M,T,R)). [25,true]

% In case that an equal binding can not be set, use a common processor
#heuristic bind(M,T,R2) : legacy(bind(_,T,R1)), missingProc(processor(R1,_,_,_)), equalProc(processor(R2,_,_,_)), map(M,T,R2). [24,true]


% Decide on equal routing
#heuristic reached(C,L,P,R) : legacy(reached(C,L,P,R)), equalComm(comm(C,A)), send(T,C), legacy(bind(M,T,P)), equalMap(map(M,T,P)). [15,true]
#heuristic reached(C,L,R,P) : legacy(reached(C,L,R,P)), equalComm(comm(C,A)), read(T,C), legacy(bind(M,T,P)), equalMap(map(M,T,P)). [15,true]
#heuristic reached(C,L,R1,R2) : legacy(reached(C,L,R1,R2)), equalComm(comm(C,A)), router(R1,_,_,_), router(R2,_,_,_). [15,true]

% In case of notEquallyComm parts of the routing path might be reused and others definitely not (depending on binding decisions for the communicating tasks) %TODO recheck false case
#heuristic reached(C,L,P,R) : legacy(reached(C,L,P,R)), notEquallyComm(comm(C,A)), send(T1,C), legacy(send(T2,C)), legacy(bind(_,T2,P)), map(_,T1,P). [14,true]
#heuristic reached(C,L,R,P) : legacy(reached(C,L,R,P)), notEquallyComm(comm(C,A)), read(T1,C), legacy(read(T2,C)), legacy(bind(_,T2,P)), map(_,T1,P). [14,true]
#heuristic reached(C,L,P,R) : legacy(reached(C,L,P,R)), notEquallyComm(comm(C,A)), send(T1,C), legacy(send(T2,C)), legacy(bind(_,T2,P)), not map(_,T1,P). [14,false]
#heuristic reached(C,L,R,P) : legacy(reached(C,L,R,P)), notEquallyComm(comm(C,A)), read(T1,C), legacy(read(T2,C)), legacy(bind(_,T2,P)), not map(_,T1,P). [14,false]
% Further, it is not clear if the same communication path using the router structure is the best
% It depends on the location of the processors in the communication (before and now)
% If both processors are in the same position, the same communication path is probably a good decision
#heuristic reached(C,L,R1,R2) : legacy(reached(C,L,R1,R2)), notEquallyComm(comm(C,A)), send(T1,C), legacy(send(T2,C)), legacy(bind(_,T2,P2)), map(_,T1,P1), processor(P2,X,Y,Z), processor(P1,X,Y,Z), read(T1',C), legacy(read(T2',C)), legacy(bind(_,T2',P2')), map(_,T1',P1'), processor(P2',X',Y',Z'), processor(P1',X',Y',Z'). [14,true]


% Decide on equal execution order
#heuristic priority(T1,T2) : legacy(priority(T1,T2)), task(T1,_), task(T2,_), map(_,T1,P), map(_,T2,P), not depends_trans(T2,T1), not depends_trans(T1,T2). [10,true]
#heuristic priority(C1,C2) : legacy(priority(C1,C2)), comm(C1,_), comm(C2,_), legacy(reached(C1,L,R1,R2)), legacy(reached(C2,L,R1,R2)), link(L,R1,R2), not depends_trans(C1,C2), not depends_trans(C2,C1). [10,true]