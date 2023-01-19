% For different options of the synthesis step
#heuristic unequal(_,bind(M,T,R)) : binding == true. [-1,sign]
#heuristic unequal(_,reached(C,L,R1,R2)) : routing == true. [-1,sign]
#heuristic unequal(_,hops(C,N)) : routing == true. [-1,sign]
#heuristic unequal(_,priority(TC1,TC2)) : scheduling == true. [-1,sign]
