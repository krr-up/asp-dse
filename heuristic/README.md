Similarity information, based on the 

 - **Comparison of the implementations**
	 - 
	 - equally existing parts: `equal(exist,_)`
	 - equally not existing parts: `equal(notExist,_)`
	 - unequally existing in child implementation `unequal(child,_)`
	 - unequally existing in parent implementation `unequal(parent,_)`
	 - unequally existing in both implementations `unequal(both,_)`

, can be used in

 - **Strategies**
	 - 
	 - Prevent unequal design decisions

 - **Heuristics**
	 - 
	 - Prefer equal / unequal design decisions
	 - Desired heuristic can be selected via constants **heuristicModifier** and **heuristicValue**

 - **Optimization / Preferences**
	 - 
	 - Hamming Distance
	 - Punish unequal design decisions
	 - Reward equal design decisions

Further, it is possible to
 - **Select the desired synthesis steps**
	 - 
	 - For selecting one or several steps, set constants **binding**, **routing**, **scheduling** to **true**
