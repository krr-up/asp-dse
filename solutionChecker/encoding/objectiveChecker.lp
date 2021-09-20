%%% Check all three criteria %%%
solution_checked(P1,P2,P3) :- latency_check(P1,P1'), energy_check(P2,P2'), cost_check(P3,P3'),
                                P1==P1', P2==P2', P3==P3'.

%%% Check latency (p1) %%%
latency_check(P1,P1') :- pref(p1,max,P1), latency(P1').

%%% Check energy consumption (p2)  %%%
energy_check(P2,P2') :- pref(p2,sum,P2), energy(P2').

%%% Check cost (p3) %%%
cost_check(P3,P3') :- pref(p3,sum,P3), cost(P3').