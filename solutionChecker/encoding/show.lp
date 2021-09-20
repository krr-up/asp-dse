#show solution_checked/3.
#show latency_check/2.
#show energy_check/2.
#show cost_check/2.

%#show sum/2.
%#show max_time_map/3.
%max_time_map(task(T,A), map(M,task(T,A),P), NUM) :- NUM=#max {N: task(T,A), map(M,task(T,A),P), executionTime(M,N)}, task(T,A), map(M,task(T,A),P), executionTime(M,NUM).
%sum(task(T,A),N2) :- pref(p1,max,N1), N2=#sum {NUM,T: }