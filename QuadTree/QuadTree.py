# script (python)
'''
Created on 09.12.2016

@author: kn165
'''
from math import sqrt
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
import matplotlib
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import time, signal
import sys
# from pareto_propagator_simple import QuadTree
import platform
from warnings import warn
from LinkedList import LinkedList


def implies(a, b):
	return ~a | b

class QuadTree:
	def __init__(self, vector, decisions=['e1','e2','e3'], dimensions=2, children=[]):
		self.vector = vector[:] 
		self.decision = decisions[:]
		self.dimensions=dimensions
		self.vgl = 0
		self.number_of_children = 2**dimensions
		self.parent = None
		if len(children) != 0 :
				self.children = children[:]
				if len(children) != self.number_of_children:
					warn("Dimensions and Length of children do not fit! This may lead to run time errors.")
		else:
			self.children = []
			for _ in range(0, self.number_of_children):
				self.children.append(None)

	def __str__(self):
		return str(self.vector) #+ str(self.decision)

	def getvgl(self):
		return self.vgl

	def print_tree_indented(self):
		self.print_tree_indented_internal(self)
		print(self.vgl)

	def print_tree_indented_internal(self, tree : 'QuadTree', level=0, index=-1):
		if tree == None: 
            # print '--' * level + str(i) + "None" 
			return
		for i in range(int(self.number_of_children/2)):
			self.print_tree_indented_internal(tree.children[i], level+1,i)
		print('--' * level +str(index) + str(tree))
		for i in range(int(self.number_of_children/2), self.number_of_children):
			self.print_tree_indented_internal(tree.children[i], level+1,i)

	def to_unordered_list(self)->list:
		un_list = []
		un_list.append(self.vector)
		for i in range(self.number_of_children):
			if self.children[i] != None:
				un_list+=self.children[i].to_unordered_list()
		return un_list
		
	def test_isdominated(self, newVector:list): #k
		#can't detect if newVector (a) dominates another vector (b) when a_i <= b_i and a_j < b_j
		#doesn't matter, because this will be checked later  
		return_value = 0
		self.vgl += 1
		for dim in range(self.dimensions):
			if newVector[dim] >= self.vector[dim]:
				return_value |= 1 << (self.dimensions - dim - 1)
		return return_value
	
	def test_dominates(self, newVector): #k*
		#this test evaluates a 'newVector' better than existing vectors
		#i.e. the new vector [2,3,4] would dominate the already inserted vector [2,3,4]
		#this is unnecessary and should be avoided
		#BUT: at this point such vectors should already be detected by the test_isdominated test
		return_value = 0
		self.vgl += 1
		for dim in range(self.dimensions):
			if newVector[dim] > self.vector[dim]:
				return_value |= 1 << (self.dimensions - dim - 1)
		return return_value
	
	def dominates_new(self, insert, newVector, newModel, current:'QuadTree', ancestorsAlive):
		"""Checks and updates the QuadTree, i.e. dominated items are getting deleted.
		The 'ancestorsAlive' parameter provides the information that one (or more) predecessor node was already dominated by 'newVector' (ancestorsAlive=False) or not (ancestorsAlive=True).
		In the former case (ancestorsAlive=False), the 'current' node is added to the returned reinsert list.
		Otherwise, i.e. ancestorsAlive=True, the 'current' node is treated as the new root. 
		
		The 'insert' parameter determines, whether 'newVector' and 'newModel' should be considered to be inserted into the 'current' subtree (insert=True) or not (insert=False). 
		"""
		k_succ = current.test_dominates(newVector)
		reinsert = []	#initialize reinsert list
		if k_succ == 0:
			#root is obviously dominated
			#check all children if they are also dominated
			x = [l_succ for l_succ in range(1, current.number_of_children-1) if (current.children[l_succ] != None)]
			for l_succ in x:
				#insert=False -> it will be inserted here
				#ancestorsAlive=False -> 'current' is dominated and thus, not Pareto optimal anymore 
				reinsert += current.dominates_new(False, newVector, newModel, current.children[l_succ], False)
				current.children[l_succ] = None
			if ancestorsAlive and insert:
				current.vector = newVector
				current.decision = newModel
				for subtree in reinsert:
					current.insert_subtree(subtree)
				return []
			elif ancestorsAlive and not insert:
				if len(reinsert)>= 1:
					tmp = reinsert.pop()
					current.vector = tmp.vector
					current.decision = tmp.decision
					while len(reinsert) > 0:
						current.insert_subtree(reinsert.pop())
					return []
				else:
					#reinsert is empty. subtree has to be deleted
					current.parent.children[current.parent.children.index(current)] = None
					del current
					return []
			elif not ancestorsAlive and insert:
				#shouldn't happen
				pass
			else: #not ancestorsAlive and not insert
				return reinsert
		else: #k_succ != 0 
			#current is not dominated but incomparable to 'newVector'
			#k_succ children plus l_succ children with l > k AND (k IMP l) & (number of children - 1) = number of children - 1 ( i.e. all ones, i.e. -1) may be dominated by 'newVector' 
			
			if ancestorsAlive:
				#if 'newVector' shall be inserted in this subtree, insert it further into the k_succ subtree
				if current.children[k_succ] != None:
					reinsert += current.dominates_new(insert, newVector, newModel, current.children[k_succ], True)
					
				elif insert:
					#no vector at position k_succ, so 'newVector' has to be inserted at position k_succ
					current.children[k_succ] = QuadTree(newVector, newModel, len(newVector))
					current.children[k_succ].parent = current
				
				x = [l_succ for l_succ in range(k_succ + 1, current.number_of_children - 1) if (current.children[l_succ] != None) & (implies(k_succ, l_succ) == -1)]
				for l_succ in x:
					#'newVector' won't be inserted into an l_succ (insert=False)
					#ancestorsAlive is inherited
					reinsert += current.dominates_new(False, newVector, newModel, current.children[l_succ], ancestorsAlive)
					pass
			else: #ancestors are not alive -> all children have to be reinserted
				x = [l_succ for l_succ in range(1, current.number_of_children-1) if (current.children[l_succ] != None)]
				for l_succ in x:
					reinsert += current.dominates_new(False, newVector, newModel, current.children[l_succ], False)
					current.children[l_succ] = None
				reinsert.append(current)
			return reinsert
				
	def isdominated(self, newVector, root:'QuadTree'):
		# 		if(root == None):
		# 			print "None reached in is dominated"
		# 			return False
		k_successor = root.test_isdominated(newVector)
		#at this point, we don't care if 'newVector' dominates the currentVector
		#we only check if newVector is dominated by the tree
		#this is the case if k_succ = number_of_children - 1 (e.g. 0b111 = 0x7 for 3 objectives)
		
        # print "Checking if", newVector, "is dominated by", root.vector, "k_successor:", k_successor
		
		if k_successor == 0:
			return False
		elif k_successor == root.number_of_children - 1:
			# print newVector, "is dominated by node:", root.vector 
			return True
		else:
			#newVector is incomparable to current node
			#'newVector' may be dominated by k_succ subtree or l_succ subtree with: l < k AND (l IMP k) & (number of children - 1) = number of children - 1, i.e. all ones, i.e. -1
			if (root.isdominated(newVector, root.children[k_successor]) if root.children[k_successor] != None else False):
				return True
			x = [l_succ for l_succ in range(1, k_successor) if (root.children[l_succ] != None) & (implies(l_succ, k_successor) == -1)]
			for l_succ in x:
				if root.isdominated(newVector, root.children[l_succ]):
					return True
			return False	
	def insert(self, newVector, variables):
		#depricated; use insert_new
		#returns
		#			n if it dominates n vectors
		#			-1 if it is dominated by at least one vector
		#			0 if it has been added/was incomparable
		k_successor = self.test_isdominated(newVector)
	
		if k_successor == 0:
			#new vector dominates current root
			# print newVector, "dominates current root:", self.vector 
			return 1
		elif k_successor == self.number_of_children-1:
			#new value is dominated by current root, break
			# print newVector, "is dominated by current root:", self.vector 
			return -1
		else:
			#new value is incomparable 
			child = self.children[k_successor]
			if child == None:
				#space is free, add child
				# print "Add child at ", k_successor, " with value: ", newVector
				self.children[k_successor] = QuadTree(newVector, variables, self.dimensions)
				return 0
			else:
				#space is occupied, insert new value further below
				return child.insert(newVector, variables)
			
	def insert_subtree(self, subtree):
		#subtree is incomparable to self and children of self
		vector = subtree.vector
		k_succ = self.test_dominates(vector)
		if self.children[k_succ] == None:
			self.children[k_succ] = subtree
			subtree.parent = self
		else:
			self.children[k_succ].insert_subtree(subtree)
	def insert_new(self, newVector, variables):
		#returns
		#			n if it dominates n vectors
		#			-1 if it is dominated by at least one vector
		#			0 if it has been added/was incomparable
		
		#first, check if 'newVector' is dominated by an element of the tree
		if(self.isdominated(newVector, self)):
			return -1
		
		#second, determine the vectors that has to be deleted and reinserted, respectively
		
		self.dominates_new(True, newVector, variables, self, True)

# *********************************************
# *********************************************
# ************Helper Functions*****************
# *********************************************
# *********************************************

if __name__ == "__main__":
	insertions = 0
	vgl = 0
	def distance(A, B):
		return sqrt((A[0] - B[0]) ** 2 + (A[1] - B[1]) ** 2 + (A[2] - B[2]) ** 2)
	def generateFront(optimal, nadir, steps):
		if len(optimal) != len(nadir):
			return []
		front = []
		
		xOpt = [optimal[0], nadir[1], nadir[2]]
		yOpt = [nadir[0], optimal[1], nadir[2]]
		zOpt = [nadir[0], nadir[1], optimal[2]]
		
		step_x = (nadir[0] - optimal[0]) / float(steps)
		step_y = (nadir[1] - optimal[1]) / float(steps)
		step_z = (nadir[2] - optimal[2]) / float(steps)
		
		xSource = xOpt[0]
		ySource = yOpt[1]
		zSource = zOpt[2]
		
		for i in range(steps + 1):
			xCur = xSource
			yCur = ySource
			zCur = zSource
			for _ in range(steps + 1 - i):
				
				front.append([xCur, yCur, zCur])
				yCur -= step_y
				zCur += step_z
				
			xSource -= step_x
			zSource += step_z
			
		return front

	def generateFrontSphere(dimen, r, steps):
		front = []
		angles = []
		step = 80.0 / steps
		for i in range(steps + 1):
			angles.append((2*np.pi*(5 + i * step))/360)
		#print angles
		if dimen == 2:
			for a in range(steps+1):
					x1 = r * np.cos(angles[a])
					x2 = r * np.sin(angles[a])
					front.append([x1,x2])
		if dimen == 3:
			for a in range(steps+1):
				for b in range(steps+1):
					x1 = r * np.cos(angles[a])
					x2 = r * np.sin(angles[a]) * np.cos(angles[b])
					x3 = r * np.sin(angles[a]) * np.sin(angles[b])
					front.append([x1,x2,x3])
		elif dimen == 4:
			for a in range(steps+1):
				for b in range(steps+1):
					for c in range(steps+1):
						x1 = r * np.cos(angles[a])
						x2 = r * np.sin(angles[a]) * np.cos(angles[b])
						x3 = r * np.sin(angles[a]) * np.sin(angles[b]) * np.cos(angles[c])
						x4 = r * np.sin(angles[a]) * np.sin(angles[b]) * np.sin(angles[c])
						front.append([x1,x2,x3,x4])
		elif dimen == 5:
			for a in range(steps+1):
				for b in range(steps+1):
					for c in range(steps+1):
						for d in range(steps+1):
							x1 = r * np.cos(angles[a])
							x2 = r * np.sin(angles[a]) * np.cos(angles[b])
							x3 = r * np.sin(angles[a]) * np.sin(angles[b]) * np.cos(angles[c])
							x4 = r * np.sin(angles[a]) * np.sin(angles[b]) * np.sin(angles[c]) * np.cos(angles[d])
							x5 = r * np.sin(angles[a]) * np.sin(angles[b]) * np.sin(angles[c]) * np.sin(angles[d])
							front.append([x1,x2,x3,x4,x5])
		return front
		
	def fig(x:list, y:list, z:list):    
		fig = plt.figure()
		ax = Axes3D(fig)
		ax.set_xlabel('X')
		ax.set_ylabel('Y')
		ax.set_zlabel('Z')
		ax.view_init(elev=30, azim=45)
		
		ax.scatter(x, y, z, c='m')
		plt.show()

	def is_dominated(vector1, vector2):
		global vgl
		vgl += 1
		dominated, worse, better = -2, False, False
		for i in range(0, len(vector1)):
			if vector1[i] > vector2[i]:
				worse = True
			elif vector1[i] < vector2[i]:
				better = True
		
		if worse and better:
			dominated = 0
		elif worse:
			dominated = 1
		elif better:
			dominated = -1
				
		return dominated

	def check_pareto(newVector, archive, quadtree):
		#Only tests if the current partial assignement is already dominated
		if quadtree: #Archive is a QuadTree
			if archive == None:
				return True
			
			if archive.isdominated(newVector, archive):
				return False
			return True
		else: #Archive is a list
			if archive.isEmpty():
				return True
			else:
				removeme = False
				#Check if current model is dominated by current front
				for point in archive:
	#                     print point[1], point[0]
					frontVec = point
					dominated = is_dominated(frontVec, newVector) 
					# check if it is dominated: -2 indifferent, -1 frontVec dominated current model, 0 incomparable, 1 current model dominates frontVec
					if dominated <= -1:
						removeme = True
						break
					elif dominated == 0:
						continue
					else:  # dominated > 0:
						# new model still dominates frontVec. Can break
						break
				if removeme:
					return False
		return True   

	def check(vec, archive, quadtree):
		#checks the completed solution and inserts it
		global _archive
		global insertions
		
		insertions += 1
		if quadtree:
			# at this point, it is clear that that the new found point is not dominated
			if archive == None:
				_archive = QuadTree(vec, [], len(vec))
			else:
				_archive.insert_new(vec, [])
			return True    
		else:
			if archive.isEmpty():
				_archive.append(vec)
			else:
				k=0
				remove = []
				for point in _archive:
					frontVec = point
					dominated = is_dominated(frontVec, vec)
					
					if dominated == 0:
						k+=1
						continue
					else:  # dominated == 1:
						remove.append(point)
						continue
				for elem in remove:
					_archive.remove(elem)
				
				_archive.append(vec)
			return True
	def handler(signum, frame):
		raise Exception("Timeout")
	def run(quadtree):
		global time
		global vectors
		global _archive
		global front
		global ordered
		if quadtree == True:
			_archive = None 
		else:
			_archive = LinkedList()
		
		
		t0 = time.clock()
		for vector in vectors:
			for decision in vector:
				val = check_pareto(decision, _archive, quadtree)
				if val == False:
					break
			else:
				final_vec = vector[-1]
				check(final_vec, _archive, quadtree)
		
		_time = time.clock() - t0
				
		if quadtree:
			#_archive.print_tree_indented()
			archive = _archive.to_unordered_list()
			print(len(archive))
		else:
			print(len(_archive))
			archive = _archive
		
	#     x = map(lambda x: x[0], archive)
	#     y = map(lambda x: x[1], archive)
	#     if len(archive[0]) > 2:
	#         z = map(lambda x: x[2], archive)
	#     else:
	#         z = [0] * len(x)
	#     fig(x,y,z)
	#     print "Finished after ", _time, "seconds"
		return _time


	# *********************************************
	# *********************************************
	# *************Benchmark starts here***********
	# *********************************************
	# *********************************************

	# Arguments:
	# python QuadTree.py <nbr of dimensions> <nbr of steps> <nbr of hops> <partial solution step> <timeout> <i|o|u>
	m=3 
	steps=50
	hops=100
	dec_steps=0.1
	timeout = 3600
	ordered=0
	if len(sys.argv) > 1: m = int(sys.argv[1])
	if len(sys.argv) > 2: steps = int(sys.argv[2])
	if len(sys.argv) > 3: hops = int(sys.argv[3])
	if len(sys.argv) > 4: dec_steps = float(sys.argv[4])
	if len(sys.argv) > 5: timeout = int(sys.argv[5])
	if len(sys.argv) > 6: 
		if sys.argv[6] == "o": 
			ordered=1
		elif sys.argv[6] == "i":
			ordered=2
		else:
			ordered=0
	#front = generateFront([105, 121, 135], [160, 171, 190], 60)
	front = generateFrontSphere(m,100,steps)



	x = map(lambda x: x[0], front)
	y = map(lambda x: x[1], front)
	if len(front[0]) > 2:
		z = map(lambda x: x[2], front)
	else:
		z = [0] * len(front)

	# print(front)

	fig(list(x),list(y),list(z))
	print(time.asctime())
	if ordered == 2:
		steps_top = matplotlib.mlab.frange(3, 1.2, -dec_steps)
	else:
		steps_top = matplotlib.mlab.frange(1.2, 3, dec_steps)
	r = np.random.RandomState(172349062)
	r.shuffle(front)

	vectors = []
	for step_top in steps_top:
		stack = front[:]
		
		print("-", step_top)
		while stack:
			point = stack.pop()
			mu = [0] * len(point)
			for i in range(len(point)):
				mu[i] = point[i] / float(hops)
			
			factors = r.uniform(0.8, step_top, hops)
			
			_sum = [0] * len(point)
			decisions = []
			for factor in factors:
				for i in range(len(_sum)):
					_sum[i] += mu[i] * factor
				decisions.append(_sum[:])
			if(_sum[0] < point[0]):
				for i in range(len(_sum)):
					_sum[i] = point[i]
				decisions.append(_sum[:])
			vectors.append(decisions)

	print(m,steps,hops,dec_steps,len(front),len(vectors),timeout)

	#r.shuffle(vectors)

	x = map(lambda x: x[-1][0], vectors)
	y = map(lambda x: x[-1][1], vectors)
	if len(front[0]) > 2:
		z = map(lambda x: x[-1][2], vectors)
	else:
		z = [0] * len(vectors)

	# for i in range(len(x)):
	#     print z[i],y[i],x[i]

	fig(list(x),list(y),list(z))
	if ordered == 0:
		r.shuffle(vectors)
		
	# print vectors[1][4]
	runtimes_quadtree = []
	runtimes_list = []
	linux = platform.system() != "Windows"
	if linux: signal.signal(signal.SIGALRM, handler)
	for i in range(1):
		warn("QT"+str(i))
		insertions = 0
		if linux: signal.alarm(timeout)
		try:
			runtimes_quadtree.append(run(quadtree=True))
		except Exception as exc:
			print("QuadTree Error:", exc)
			break 
		print(insertions)
		print("vgl QT", _archive.getvgl())
	# _archive.print_tree_indented()
	for i in range(1):
		warn("List"+str(i))
		insertions = 0
		if linux: signal.alarm(timeout)
		# try:
		runtimes_list.append(run(quadtree=False))
		# except Exception as exc:
		#     print("List Error:", exc)
		#     break
		print(insertions)
		print ("vgl List", vgl)
	if linux: signal.alarm(10)    
	print("Run times Quad--Tree:", runtimes_quadtree)
	print("Mean:", np.mean(runtimes_quadtree), "Standard Deviation:", np.std(runtimes_quadtree))
	print("Run times List:", runtimes_list)
	print("Mean:", np.mean(runtimes_list), "Standard Deviation:", np.std(runtimes_list))

