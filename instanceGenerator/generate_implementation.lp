

%%%%%%%%%%%%%%%%%
%% ALLOCATION  %%
%%%%%%%%%%%%%%%%%

allocated(R) :- bind(_,task(T,A),R), task(T,A).
allocated(R) :- reached(_,R,_).
allocated(R) :- reached(_,_,R).
allocated(link(R1,R2)) :- reached(_,R1,R2).

%%%%%%%%%%%%%%%
%%  BINDING  %%
%%%%%%%%%%%%%%%

%for the sake of binding, fifos are also tasks
1 { bind(M,task(T,A),R) : map(M,task(T,A),R) } 1 :- task(T,A).

%%%%%%%%%%%%%%%
%%  ROUTING  %%
%%%%%%%%%%%%%%%

%dimension order rounting
coord(X,Y,Z) :- router(_,X,Y,Z).
next(X,Y,Z,X',Y',Z',X+1,Y,Z) :- coord(X,Y,Z), coord(X',Y',Z'), coord(X+1,Y,Z), X < X'.
next(X,Y,Z,X',Y',Z',X-1,Y,Z) :- coord(X,Y,Z), coord(X',Y',Z'), coord(X-1,Y,Z), X > X'.
next(X,Y,Z,X,Y',Z',X,Y+1,Z) :- coord(X,Y,Z), coord(X,Y',Z'), coord(X,Y+1,Z), Y < Y'.
next(X,Y,Z,X,Y',Z',X,Y-1,Z) :- coord(X,Y,Z), coord(X,Y',Z'), coord(X,Y-1,Z), Y > Y'.
next(X,Y,Z,X,Y,Z',X,Y,Z+1) :- coord(X,Y,Z), coord(X,Y,Z'), coord(X,Y,Z+1), Z < Z'.
next(X,Y,Z,X,Y,Z',X,Y,Z-1) :- coord(X,Y,Z), coord(X,Y,Z'), coord(X,Y,Z-1), Z > Z'.
reached(C,processor(R),router(R);C,router(R'),processor(R')) :- bind(_,T,processor(R)), bind(_,T',processor(R')), R!=R', 
															    send(T,C), read(T',C).
reached(C,router(R),router(R')) :- reached(C,_,router(R)), router(R,X,Y,Z), router(R',X',Y',Z'),
                                   read(T,C), bind(_,T,processor(TR)), router(TR,TX,TY,TZ),
								   next(X,Y,Z,TX,TY,TZ,X',Y',Z').
hops(C,N) :- bind(_,T1,processor(R)), bind(_,T2,processor(R')), R!=R',
			 send(T1,C), read(T2,C),
			 processor(R,X,Y,Z), processor(R',X',Y',Z'),
			 N = |X-X'|+|Y-Y'|+|Z-Z'|+2.	
hops(comm(T,T',A),0) :- bind(_,T1,processor(R)), bind(_,T2,processor(R)),
						send(T1,comm(T,T',A)), read(T2,comm(T,T',A)).	

%%%%%%%%%%%%%%%%%%
%%  SCHEDULING  %%
%%%%%%%%%%%%%%%%%%
%tasks depend on each other if they are connected by a communication node that has an index offset of 0
depends(T1,T2) :- send(T1,C), read(T2,C).
depends(C1,C2) :- send(T1,C1), read(T2,C1), send(T2,C2).

depends_trans(T1,T2) :- depends(T1,T2).
depends_trans(T1,T3) :- depends_trans(T1,T2), depends(T2,T3).

% select a cycle
% 1 { cycle(task(T,A),task(U,A')) : task(U,A'), (U,A') != (T,A) } 1 :- task(T,A).
% 1 { cycle(task(T,A),task(U,A')) : task(T,A),  (U,A') != (T,A) } 1 :- task(U,A').

% make sure the cycle is connected
% reach(M) :- M = #min { task(T,A) : task(T,A) }.
% reach(U) :- reach(T), cycle(T,U).
% :- task(T,A), not reach(task(T,A)).

% select a start point
% 1 { start(task(T,A)) : task(T,A) } 1.

% prio(T1,T2) :- cycle(T1,T2), 
               % not depends_trans(T1,T2), not depends_trans(T2,T1),
			   % not start(T2).
			   
{prio(TA,TB)} :- TA=task(T1,A1),TB=task(T2,A2), not depends_trans(TA,TB), task(T1,A1), task(T2,A2),
											not depends_trans(TB,TA),T1<T2.
prio(TB,TA) :- not prio(TA,TB), not depends_trans(TA,TB), not depends_trans(TB,TA), task(T1,A1), task(T2,A2),
               TA=task(T1,A1),TB=task(T2,A2),T1<T2.
#edge (T1,T2) : prio(T1,T2).
			   
confl(comm(T1,T2,A),comm(T1',T2',A')) :- 1 { reached(comm(T1,T2,A),R1,R2) : 
										 reached(comm(T1,T2,A),R1,R2), reached(comm(T1',T2',A'),R1,R2)},
                                         comm(T1,T2,A), comm(T1',T2',A'), (T1,T2,A) != (T1',T2',A'), 
										 not depends_trans(comm(T1,T2,A),comm(T1',T2',A')),
										 not depends_trans(comm(T1',T2',A'),comm(T1,T2,A)).
{prio(C1,C2)} :- confl(C1,C2),
				 not depends_trans(C1,C2),
				 not depends_trans(C2,C1).
prio(C2,C1) :- confl(C1,C2), not prio(C1,C2),
			   not depends_trans(C1,C2),
			   not depends_trans(C2,C1).				

%all starting times are bigger than 0
%T>=0 --> -T<=0 --> 0-T<=0
&diff { 0-task(T,A) } <= 0 :- task(T,A).

%all tasks have to finish before their deadline
%T<=DL-e(T) --> T-0<=DL-e(T)
&diff { T-0 } <= V :- period(P), bind(M,T,R), executionTime(M,Time), V=P-Time.


%tasks bound onto the same resource have to be scheduled successively   
%T2-T1>=ET_T1 --> -T2+T1<=-ET_T1 --> T1-T2<=-ET_T1
seq(task(T1,A1),task(T2,A2),Time1) :- task(T1,A1), task(T2,A2), 
                                      prio(task(T1,A1),task(T2,A2)),
                                      executionTime(M1,Time1), executionTime(M2,Time2),
                                      bind(M1,task(T1,A1),R), bind(M2,task(T2,A2),R).
% seq(task(T2,A2),task(T1,A1),Time2) :- task(T1,A1), task(T2,A2), T1<T2, 
                                      % not seq(task(T1,A1),task(T2,A2),Time1),
                                      % executionTime(M1,Time1), executionTime(M2,Time2),
                                      % bind(M1,task(T1,A1),R), bind(M2,task(T2,A2),R).
&diff { T1-T2 } <= -Time :- seq(T1,T2,Time).
	
	

%communication scheduling
%Start hop
&diff { T-C } <= -Time :- send(T,C),
					      bind(M,T,_),
                          executionTime(M,Time).

%Middle hops			
&diff { C1-C2 } <= -S :- confl(C1,C2), prio(C1,C2), 
                         hops(C1,N), routingDelay(D), S=N*D.

%Last hop
&diff { C-T } <= -S :- read(T,C), hops(C,N), routingDelay(D), S=N*D.


#show bind/3.
#show reached/3.
% #show confl/2.
% #show depends_trans/2.
&show_assignment{}.
