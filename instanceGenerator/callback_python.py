#script(python)
import numpy as np
from clingo import *
r=None
def getId(basestr,args):
	return Function(str(basestr) + 'x'.join(map(str,args.arguments)))
def getValue(min,max,seed,args):
	global r
	if r==None:
		r=np.random.RandomState(seed.number)
	t=r.randint(min.number,max.number+1)
	return Number(int(t))
#end.
