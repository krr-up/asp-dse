% Hamming distance is counting all differences between child and parent implementation
hamming(H) :- hammingBinding(H1), hammingRouting(H2), hammingScheduling(H3), H=H1+H2+H3.

%TODO Implementation correct but inefficient (count on atoms which need to be found during DSE)
hammingBinding(H) :- H=#count{ M : unequal(_,bind(M,T,R)) }, binding==true.
hammingBinding(0) :- binding==false.
hammingRouting(H) :- H1=#count{ (C,L) : unequal(_,reached(C,L,R1,R2)) }, H2=#count{ C : unequal(_,hops(C,N)) }, H=H1+H2, routing==true.
hammingRouting(0) :- routing==false.
hammingScheduling(H) :- H=#count{ (TC1,TC2) : unequal(_,priority(TC1,TC2)) }, scheduling==true.
hammingScheduling(0) :- scheduling==false.

#show hamming/1.