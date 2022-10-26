# build an library named epsilonDominance.so from epsilonDominance.cpp
CC = g++
CFLAGS = -c -fPIC
LFLAGS = -shared
TARGET = epsilonDominance

all: $(TARGET).so

$(TARGET).so: $(TARGET).o
	$(CC) $(LFLAGS) -o $(TARGET).so $(TARGET).o

$(TARGET).o: $(TARGET).cpp
	$(CC) $(CFLAGS) -o $(TARGET).o $(TARGET).cpp

clean:
	$(RM) $(TARGET).o 
	$(RM) $(TARGET).so 