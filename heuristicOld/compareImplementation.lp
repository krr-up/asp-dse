% Compare the implementations of new and legacy configuration

#show notEqualPriority/1.
#show missingPriority/1.
#show addedPriority/1.
%%%%%%%%%%%
% BINDING %
%%%%%%%%%%%

% Equally decided bindings in both configurations
equalBind(bind(M,T,R)) :- bind(M,T,R), legacy(bind(_,T,R)).
% Not equally decided binding for equal tasks in both configurations
notEquallyBind(bind(M1,T,R1),legacy(bind(M2,T,R2))) :- bind(M1,T,R1), legacy(bind(M2,T,R2)), R1!=R2.
% Missing binding in new configuration with regard to legacy configuration
missingBind(bind(M,T,R)) :- legacy(bind(M,T,R)), missingTask(task(T,A)).
% Added binding in new configuration with regard to legacy configuration
addedBind(bind(M,T,R)) :- bind(M,T,R), addedTask(task(T,A)).

%%%%%%%%%%%
% ROUTING %
%%%%%%%%%%%

% Equally decided routing in both configurations
equalReached(reached(C,L,R1,R2)) :- reached(C,L,R1,R2), legacy(reached(C,L,R1,R2)).
% Not equally decided routing for equal communication in both configurations
notEquallyReached(reached(C,L1,R1,R2),legacy(reached(C,L2,R1',R2'))) :- not equalReached(reached(C,L1,R1,R2)), reached(C,L1,R1,R2), legacy(reached(C,L2,R1',R2')), L1!=L2.
% Missing routing in new configuration with regard to legacy configuration
missingReached(reached(C,L,R1,R2)) :- legacy(reached(C,L,R1,R2)), not reached(C,_,_,_).
% Added routing in new configuration with regard to legacy configuration
addedReached(reached(C,L,R1,R2)) :- not legacy(reached(C,_,_,_)), reached(C,L,R1,R2).

% Equal number of hops for equal communications in both configurations
equalHops(hops(C,N)) :- hops(C,N), legacy(hops(C,N)).
% Unequal number of hops for equal communications in both configurations
differentHops(hops(C,N1),legacy(hops(C,N2))) :- hops(C,N1), legacy(hops(C,N2)), N1!=N2.

%%%%%%%%%%%%%%
% SCHEDULING %
%%%%%%%%%%%%%%
% Equal element execution order (tasks or communications) in both configurations
equalPriority(priority(TC1,TC2)) :- priority(TC1,TC2), legacy(priority(TC1,TC2)).
% Unequal element execution order (tasks or communications) due to the occurrence of at least one unequal task between the configurations -> therefore priority can either be missing in or added in new configuration with regard to legacy configuration
missingPriority(priority(T1,T2)) :- legacy(priority(T1,T2)), missingTask(task(T1,A1)).
missingPriority(priority(T1,T2)) :- legacy(priority(T1,T2)), missingTask(task(T2,A2)).
missingPriority(priority(C1,C2)) :- legacy(priority(C1,C2)), missingComm(comm(C1,A1)).
missingPriority(priority(C1,C2)) :- legacy(priority(C1,C2)), missingComm(comm(C2,A2)).
addedPriority(priority(T1,T2)) :- priority(T1,T2), addedTask(task(T1,A1)).
addedPriority(priority(T1,T2)) :- priority(T1,T2), addedTask(task(T2,A2)).
addedPriority(priority(C1,C2)) :- priority(C1,C2), addedComm(comm(C1,A1)).
addedPriority(priority(C1,C2)) :- priority(C1,C2), addedComm(comm(C2,A2)).
% Unequal element execution order of tasks due to a different binding 
notEqualPriority(legacy(priority(T1,T2))):- legacy(priority(T1,T2)), notEquallyBind(bind(M1,T1,R1),legacy(bind(M2,T1,R2))), not missingPriority(priority(T1,T2)), not addedPriority(priority(T1,T2)).
notEqualPriority(legacy(priority(T1,T2))):- legacy(priority(T1,T2)), notEquallyBind(bind(M1,T2,R1),legacy(bind(M2,T2,R2))), not missingPriority(priority(T1,T2)), not addedPriority(priority(T1,T2)).
notEqualPriority(priority(T1,T2)):- priority(T1,T2), notEquallyBind(bind(M1,T1,R1),legacy(bind(M2,T1,R2))), not missingPriority(priority(T1,T2)), not addedPriority(priority(T1,T2)).
notEqualPriority(priority(T1,T2)):- priority(T1,T2), notEquallyBind(bind(M1,T2,R1),legacy(bind(M2,T2,R2))), not missingPriority(priority(T1,T2)), not addedPriority(priority(T1,T2)).
% Unequal element execution order of communications due to a different routing 
notEqualPriority(legacy(priority(C1,C2))):- legacy(priority(C1,C2)), notEquallyReached(reached(C1,L1,R1,R2),legacy(reached(C1,L2,R1',R2'))), not missingPriority(priority(C1,C2)), not addedPriority(priority(C1,C2)).
notEqualPriority(legacy(priority(C1,C2))):- legacy(priority(C1,C2)), notEquallyReached(reached(C2,L1,R1,R2),legacy(reached(C2,L2,R1',R2'))), not missingPriority(priority(C1,C2)), not addedPriority(priority(C1,C2)).
notEqualPriority(priority(C1,C2)):- priority(C1,C2), notEquallyReached(reached(C1,L1,R1,R2),legacy(reached(C1,L2,R1',R2'))), not missingPriority(priority(C1,C2)), not addedPriority(priority(C1,C2)).
notEqualPriority(priority(C1,C2)):- priority(C1,C2), notEquallyReached(reached(C2,L1,R1,R2),legacy(reached(C2,L2,R1',R2'))), not missingPriority(priority(C1,C2)), not addedPriority(priority(C1,C2)).
% or quite general:
%notEqualPriority(priority(TC1,TC2)) :- priority(TC1,TC2), not legacy(priority(TC1,TC2)).
%notEqualPriority(legacy(priority(TC1,TC2))) :- not priority(TC1,TC2), legacy(priority(TC1,TC2)).

%NOTE Not all terms might be used in heuristics -> to optimize the grounding those should be removed for the experiments version

%NOTE The comparison of the priority terms only works fully when a rule to derive priority is given -> Its usage may not make sense in the experiments because it increase the grounding size (we lose advantages from improved encoding)
priority(T1,T2) :- task(T1,A1),task(T2,A2), T1 < T2, 
                            bind(_,T1,R), bind(_,T2,R),
                            not depends_trans(T2,T1), not depends_trans(T1,T2).
priority(C1,C2) :- 1 #sum{ 1 : reached(C1,L,R1,R2), reached(C2,L,R1,R2)},
                            comm(C1,A), comm(C2,A'), C1 < C2,
                            not depends_trans(C1,C2), not depends_trans(C2,C1).

#show priority/2.