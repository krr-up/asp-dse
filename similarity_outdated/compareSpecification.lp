%%
% Compare the specifications of new and legacy configuration
%%

% Missing tasks in new configuration with regard to legacy configuration
missingTask(task(T,A)) :- not task(T,A), legacy(task(T,A)), application(A).
% Added tasks in new configuration with regard to legacy configuration
addedTask(task(T,A)) :- task(T,A), not legacy(task(T,A)), application(A).
% Equal tasks in both configurations
equalTask(task(T,A)) :- task(T,A), legacy(task(T,A)), application(A).

% Missing communications in new configuration with regard to legacy configuration
missingComm(comm(C,A)) :- not comm(C,A), legacy(comm(C,A)).
% Added communications in new configuration with regard to legacy configuration
addedComm(comm(C,A)) :- comm(C,A), not legacy(comm(C,A)).
% Equal communications in both configurations
equalComm(comm(C,A)) :- send(T1,C), read(T2,C), legacy(send(T1,C)), legacy(read(T2,C)), comm(C,A).
% Equal communication name but sending or reading task is not the same
notEquallyComm(comm(C,A)) :- send(T1,C), legacy(send(T2,C)), comm(C,A), legacy(comm(C,A)), T1 != T2.
notEquallyComm(comm(C,A)) :- read(T1,C), legacy(read(T2,C)), comm(C,A), legacy(comm(C,A)), T1 != T2.

% Missing processors in new configuration with regard to legacy configuration
missingProc(processor(P,X,Y,Z)) :- not processor(P,X,Y,Z), legacy(processor(P,X,Y,Z)).
% Added processors in new configuration with regard to legacy configuration
addedProc(processor(P,X,Y,Z)) :- processor(P,X,Y,Z), not legacy(processor(P,X,Y,Z)).
% Equal processors in both configurations
equalProc(processor(P,X,Y,Z)) :- processor(P,X,Y,Z), legacy(processor(P,X,Y,Z)).

% Missing routers in new configuration with regard to legacy configuration
missingRouter(router(R,X,Y,Z)) :- not router(R,X,Y,Z), legacy(router(R,X,Y,Z)).
% Added routers in new configuration with regard to legacy configuration
addedRouter(router(R,X,Y,Z)) :- router(R,X,Y,Z), not legacy(router(R,X,Y,Z)).
% Equal routers in both configurations
equalRouter(router(R,X,Y,Z)) :- router(R,X,Y,Z), legacy(router(R,X,Y,Z)).

% Missing links in new configuration with regard to legacy configuration
missingLink(link(L,R1,R2)) :- not link(L,R1,R2), legacy(link(L,R1,R2)).
% Added links in new configuration with regard to legacy configuration
addedLink(link(L,R1,R2)) :- link(L,R1,R2), not legacy(link(L,R1,R2)).
% Equal links in both configurations
equalLink(link(L,R1,R2)) :- link(L,R1,R2), legacy(link(L,R1,R2)).

% Missing mappings in new configuration with regard to legacy configuration
missingMap(map(M,T,P)):- not map(_,T,P), legacy(map(M,T,P)).
% Added mappings in new configuration with regard to legacy configuration
addedMap(map(M,T,P)):- map(M,T,P), not legacy(map(_,T,P)).
% Equal mappings in both configurations
equalMap(map(M,T,P)):- map(M,T,P), legacy(map(M,T,P)).

%NOTE Not all terms might be used in heuristics -> to optimize the grounding those should be removed for the experiments version