%%% Check allocation    %%%
% All resources (processors, routers, links), which are used, are allocated
:- bind(_,_,P), not allocated(P).
:- reached(_,R,_), not allocated(R).
:- reached(_,_,R), not allocated(R).
:- reached(_,R1,R2), not allocated(link(R1,R2)).
% There are no allocated resources, which are not used
:- allocated(processor(P)), 0 { bind(_,_,processor(P)) } 0.
:- allocated(router(R)), 0 { reached(_,router(R),_) } 0.
:- allocated(router(R)), 0 { reached(_,_,router(R)) } 0.
:- allocated(link(R1,R2)), 0 { reached(_,R1,R2) } 0.


%%% Check binding   %%%
% Each task is bound exactly once
:- not 1 { bind(_,task(T,A),R) } 1, task(T,A).
%:- 1 #count{ 1: bind(_,task(T,A),R), bind(_,task(T,A),R'), R<R' }, task(T,A).
% Each task binding bases on a valid mapping
:- bind(M,T,P), not map(M,T,P).


%%% Check routing   %%%
% The routing path is complete (communicating tasks are connected)
% Each the sending and the reading task is connected to the routing path
:- send(task(T1,A),comm(T1,T2,A)), not reached(comm(T1,T2,A),R1,_), bind(_,task(T1,A),R1), bind(_,task(T2,A),R2), R1!=R2, T1!=T2.
:- read(task(T2,A),comm(T1,T2,A)), not reached(comm(T1,T2,A),_,R2), bind(_,task(T1,A),R1), bind(_,task(T2,A),R2), R1!=R2, T1!=T2.
% For one communication no resource is seen twice in the routing path
:- reached(comm(T1,T2,A),R,R1), reached(comm(T1,T2,A),R,R2), R1!=R2.
:- reached(comm(T1,T2,A),R1,R), reached(comm(T1,T2,A),R2,R), R1!=R2.
% If two communicating task are bound onto the same resource there is no routing path
:- comm(T1,T2,A), bind(M1,task(T1,A),P), bind(M2,task(T2,A),P), not 0 { reached(comm(T1,T2,A),_,_) } 0.

%TODO :- wenn comm, dann auch entsprechende Links (reached), die Ressourcen, auf die Tasks aus comm gebunden (bind) sind, verbinden 
% es kann nicht sein, dass ich eine comm habe, wo ich rekursiv die reached durchlaufe, aber nicht von T1 zu T2 komme / am Anfang kein send bzw. am Ende kein read steht
% (There is no reached without a visit -> integrity constraint already in encoding)
%TODO At each time step a resource at maximum sends or receives from one communication
%:- dl(comm(T1,T2,A),TIME), reached(comm(T1,T2,A),R1,_), dl(comm(T3,T4,A),TIME), reached(comm(T3,T4,A),R1,_), T1!=T3.
%:- dl(comm(T1,T2,A),TIME), reached(comm(T1,T2,A),_,R2), dl(comm(T3,T4,A),TIME), reached(comm(T3,T4,A),_,R2), T2!=T4.


%%% Check scheduling    %%%
% At each time step at maximum one task per resource is started
%:- dl(task(T1,A1),TIME), map(M1,task(T1,A1),P), dl(task(T2,A2),TIME), map(M2,task(T2,A2),P), T1!=T2.
% If two tasks are depending, the successor task is executed after the predecessor task
:- comm(T1,T2,A), dl(task(T1,A),TIME1), dl(task(T2,A),TIME2), TIME2<TIME1.
% A task has its execution slot on a resource in which no other task or communication on that resource is started
:- dl(task(T1,A),TIME1), end_time(task(T1,A),TIME2), bind(M1,task(T1,A1),P), bind(M2,task(T2,A2),P), dl(task(T2,A),TIME3), TIME3>=TIME1, TIME3<TIME2,  T1!=T2.
% A task is not sending before its execution finished
:- end_time(task(T1,A),TIME1), dl(comm(T1,T2,A),TIME2), TIME2<TIME1.
% A task is not starting before previous communication is finished
:- end_time(comm(T1,T2,A),TIME1), dl(task(T2,A),TIME2), TIME2<TIME1.
%TODO No communication on a resource is done when resource is busy with a task
%TODO NO router/link is used by two communications at the same time 

% 0 <= latency
:- latency(N1), N1 < 0.
% latency <= period
:- latency(N1), period(N2), N2 < N1.
% latency <= sum of execution times of all tasks (considering their actual binding) added the execution time for a maximal routing path (can be between every pair of two tasks except for the starting and ending task of the application -> maximal (t-1) times)
:- latency(N1), N2=N3+(N4-1)*N5 , N1>N2,
    N3=#sum {N,M: bind(M,T,P), executionTime(M,N)}, N4=#count {T,A: task(T,A)}, N5=#count {R,R': allocated(link(R,R'))}.