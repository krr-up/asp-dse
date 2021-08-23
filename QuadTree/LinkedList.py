'''
Created on 10.05.2017

@author: kn165
'''
from ListElement import ListElement

class LinkedList(object):
    '''
    Doubly linked List. Implemented as a multi list.<br>
    insert O(1), remove O(n), sort O(?)
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self.__head = ListElement(None)
        self.__tail = ListElement(None)
        self.__head.setSucc(self.__tail)
        self.__tail.setPred(self.__head)
        self.__size = 0
        self.__current = self.__head
    
    def getSize(self):
        return self.__size
    
    def __iter__(self):
        self.__current = self.__head
        return self
    
    def __len__(self):
        return self.__size
    def __next__(self):
        if self.__current.getSucc() != self.__tail:
            self.__current = self.__current.getSucc()
            return self.__current
        else:
            raise StopIteration()
    
    def getFirst(self):
        return self.__head.getSucc()
    
    def getLast(self):
        return self.__tail.getPred()
    
    def isEmpty(self):
        return self.__head.getSucc() == self.__tail
    
    def __str__(self):
        s = "[ "
        cur = self.__head.getSucc()
        while(cur != self.__tail):
            s += str(cur) + " "
            cur = cur.getSucc()
        s += "]"
        return s
    
    def _insert(self, elem):
        self.__size += 1
        elem.setPred(self.__tail.getPred())
        self.__tail.getPred().setSucc(elem)
        self.__tail.setPred(elem)
        elem.setSucc(self.__tail)
            
    def insert(self, value):
        self._insert(ListElement(value))
        
    def append(self, value):
        self._insert(ListElement(value))
        
    def remove(self, elem):
        elem.getPred().setSucc(elem.getSucc())
        elem.getSucc().setPred(elem.getPred())
        self.__size -= 1
        return True
#         cur = self.__head.getSucc()
#         while cur != self.__tail:
#             if cur.equals(elem):
#                 self.__size -= 1
#                 cur.getPred().setSucc(cur.getSucc())
#                 cur.getSucc().setPred(cur.getPred())
#                 return True
#             else:
#                 cur = cur.getSucc()
#         return False
    
    def sort(self):
        '''
        Sorts the list according to the priority of the {@link ListElement}s (not the value!).
        
        @return The number of comparisons.
        '''
        return 0
    
    def swap(self,e1,e2):
        '''
        Swaps two {@link ListElement}s
        @param e1 First {@link ListElement}
        @param e2 Second {@link ListElement}
        '''
        pass