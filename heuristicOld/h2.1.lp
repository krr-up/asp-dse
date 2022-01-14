%% Old heuristic %%

% Decide on equal binding
#heuristic equalBind(bind(M,T,R)). [25,true]


% Decide on equal routing
#heuristic equalReached(reached(C,L,R1,R2)). [15,true]


% Decide on equal execution order
#heuristic equalPriority(priority(TC1,TC2)). [5,true]