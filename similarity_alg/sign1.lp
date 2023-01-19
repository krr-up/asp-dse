% For different options of the synthesis step
#heuristic equal(_,bind(M,T,R)) : binding == true. [1, sign]
#heuristic equal(_,reached(C,L,R1,R2)) : routing == true. [1,sign]
#heuristic equal(hops(C,N)) : routing == true. [1,sign]
#heuristic equal(_,priority(TC1,TC2)) : scheduling == true. [1,sign]
