%%% Latency %%%
latency(L) :-  L=#max {NUM: end_time(task(T,A),NUM)}.
% Minimal case is execution of one task
end_time(task(T,A),N) :- executionTime(BIND,N), bind(BIND,task(T,A),processor(R)).
% No routingDelay is added, when sequential tasks are bound on the same resource
end_time(task(T',A),N) :- end_time(task(T,A),N1), comm(T,T',A), bind(BIND,task(T,A),processor(R)), bind(BIND',task(T',A),processor(R)),
                    executionTime(BIND',N2), N=N1+N2.
% If there is a routing path, for each part a routingDelay is added
end_time(task(T',A),N) :- end_time(task(T,A),N1), comm(T,T',A), bind(BIND,task(T,A),processor(R)), bind(BIND',task(T',A),processor(R')), R!=R',
                    N2=#sum {NUM,R2: reached(comm(T,T',A),R1,R2), routingDelay(NUM)}, executionTime(BIND',N3),
                    N=N1+N2+N3.
%
end_time(comm(T1,T2,A),N) :- dl(comm(T1,T2,A),TIME1), TIME2=#sum {NUM,R2: reached(comm(T1,T2,A),R1,R2), routingDelay(NUM)}, N=TIME1+TIME2.

%%% Energy consumption %%%
% Energy consumption consists of static and dynamic energy consumed
energy(E) :- energy_static(S), energy_dynamic(D), E=S+D.
% Static energy is summed up for all allocated resources
energy_static(S) :- S=#sum {NUM,R:staticPower(R,NUM), allocated(R)}.
% Dynamic energy was assigned to each binding as well as each communication edge used and is summed up
energy_dynamic(D) :- D=#sum {NUM1,COMM,R1,R2: routingEnergy(NUM1), reached(COMM,R1,R2); NUM2,BIND:dynamicEnergy(BIND,NUM2), bind(BIND,T,R)}.

%%% Cost %%%
% Cost is the sum of the costs of all allocated resources
cost(C) :- C=#sum {NUM,R:resourceCost(R,NUM), allocated(R)}.