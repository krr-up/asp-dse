'''
Created on 10.05.2017

@author: kn165
'''

class ListElement(object):
    '''
    Element implementation for a {@link LinkedList}. Each element has a
    successor, a predecessor and a value.
     
    @param __value
                The integer __value of the Element.
    '''


    def __init__(self, value):
        '''
        Constructor
        '''
        self.__value = value
        self.__pred = None
        self.__succ = None
    
    def __str__(self):
        return str(self.__value)
    
    def __len__(self):
        return len(self.__value)
    
    def __getitem__(self,indices):
        return self.__value[indices]
    
    def getValue(self):
        return self.__value
    
    def setValue(self, value):
        self.__value = value
        
    def getPred(self):
        return self.__pred
    
    def setPred(self, pred):
        self.__pred = pred
        
    def getSucc(self):
        return self.__succ
    
    def setSucc(self, succ):
        self.__succ = succ

    def equals(self, elem):
        return (elem.getValue() == self.getValue()) 