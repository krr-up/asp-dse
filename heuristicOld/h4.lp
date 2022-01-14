%% Integrity constraints %%

% Prevent that the same task is bound on different processors and force this way equal bindings
:- bind(M1,T,R1), legacy(bind(M2,T,R2)), equalProc(processor(R2,_,_,_)), R1!=R2.


% Prevent that a communication is routed over different resource and force this way equal routing decisions
% When considering that equalBind was forced:
%   No need to look at p->r and r->p, because a message can leave / arrive to a processor only one way and equalBind is forced
%   r->r case: Only checking outgoing routing direction is enough, because there is no way to arrive to a wrong router without leaving the right path at a certain point and in each routing path a router is being seen at most once 
%:- reached(C,L1,R1,R1'), legacy(reached(C,L2,R2,R2')), send(T1,C), read(T2,C), equalBind(bind(_,T1,_)), equalBind(bind(_,T2,_)), R1=R2, R1'!=R2'.


% Prevent that two tasks are executed in a different order and force this way equal execution order
% There are no useful integrity constraints, because an equal priority term is forced by its definition and the previous integrity constraints.
