#const seed = 100.
#const comm_delay = 2. %delay per hop
#const map_min = 2.
#const map_max = 4.
#const power_min = 20.
#const power_max = 50.
#const cost_min = 20.
#const cost_max = 50.
#const instr_nr = 4. %number of instruction types
#const instr_min = 25. %instructions per type per task
#const instr_max = 250.
#const ipc_min = 1. %instructions per cycle
#const ipc_max = 4.
#const epi_min = 2. %energy per instruction
#const epi_max = 5.

N{map(ID,T,R):processor(R),ID=@getId(m,(T,R))}N:-task(T,A), N=@getValue(map_min, map_max, seed,(T,A)).

:- map(ID, T, R), instructions(T,TYPE,_), not ipc(R,TYPE,_).

% Latency last point of execution in first iteration (makespan)
%period(period).
0 { instructions(TID,TYPE,N):N=@getValue(instr_min,instr_max,seed,(TID,A,TYPE)) } 1 :- task(TID,A), TYPE=1..instr_nr.
% each task contains at least 1 instruction type (e.g. int or float)
:- 0 #count {TYPE,(TID,A):instructions(TID,TYPE,_)} 0, task(TID,A).
% each instruction type exists at least one time
instruction_exist(TYPE) :- instructions(_,TYPE,_).
:- not instruction_exist(TYPE), TYPE=1..instr_nr.

0 { ipc(RID,TYPE,N):N=@getValue(ipc_min,ipc_max,seed,(RID,TYPE)) } 1 :- processor(RID), TYPE=1..instr_nr.
% no processor speaks all instructions
:- instr_nr #count {TYPE,(RID):ipc(RID,TYPE,_)} , processor(RID), instr_nr > 1.
%energy per instruction for supported instruction types
epi(R,TYPE,EPI) :- ipc(R, TYPE, _), EPI = @getValue(epi_min,epi_max,seed,(R,TYPE)).

%execution time for a mapping is calculated as the sum of all instructions per task divided 
%by the ipc of the processor, i.e. \forall m=(t,r): \sum_{type=0..i}(instructions(t,i) / ipc(r,i))
executionTime(MID,TIME) :- map(MID, T, R), 
		TIME=#sum{CYCLES,TYPE:instructions(T,TYPE,INS), ipc(R,TYPE,IPC), CYCLES=INS/IPC}.

%dynamic Energy per mapping		
dynamicEnergy(MID,E) :- map(MID, T, R), 
		E=#sum{ENERGY,TYPE:instructions(T,TYPE,INS), epi(R,TYPE,EPI), ENERGY=INS*EPI}.		

staticPower(R,P) :- processor(R), P=@getValue(power_min, power_max, seed, (R)).
staticPower(R,P) :- router(R), P=@getValue(power_min, power_max, seed, (R)).
routingEnergy(P) :- P=@getValue(power_min, power_max, seed, ()).

resourceCost(R,C) :-processor(R), C=@getValue(cost_min, cost_max, seed, (R)).
resourceCost(R,C) :-router(R), C=@getValue(cost_min, cost_max, seed, (R)).


routingDelay(comm_delay).

#show map/3.
#show instructions/3.
#show ipc/3.
#show epi/3.
#show executionTime/2.
#show routingDelay/1.
#show routingEnergy/1.
#show dynamicEnergy/2.
#show staticPower/2.
#show resourceCost/2.