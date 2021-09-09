#const x=2.
#const y=2.
#const z=1.

% Architecture / Platform
% Number of Resources
resources(x,y,z).

router(ID,X,Y,Z) :- ID=@getId(r,(NR,)), resources(NX,NY,NZ), X=1..NX, Y=1..NY, Z=1..NZ, NR=X+NX*(Y-1)+NX*NY*(Z-1).
processor(ID,X,Y,Z) :- router(N,X,Y,Z), ID=@getId(p,(NR,)), NR=X+NX*(Y-1)+NX*NY*(Z-1), resources(NX,NY,NZ).
router(ID) :- router(ID,_,_,_).
processor(ID) :- processor(ID,_,_,_).

link(LID,RID,PID) :- router(RID,X,Y,Z), processor(PID,X,Y,Z), LID=@getId(l,(RID,PID)).
link(LID,RID1,RID2) :- router(RID1,X,Y,Z), router(RID2,X+1,Y,Z), LID=@getId(l,(RID1,RID2)).
link(LID,RID1,RID2) :- router(RID1,X,Y,Z), router(RID2,X,Y+1,Z), LID=@getId(l,(RID1,RID2)).
link(LID,RID1,RID2) :- router(RID1,X,Y,Z), router(RID2,X,Y,Z+1), LID=@getId(l,(RID1,RID2)).

link(LID2,Y,X) :- link(LID1,X,Y), LID2=@getId(l,(Y,X)).

#show link/3.
#show router/4.
#show processor/4.