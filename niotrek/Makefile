#
CC =  gcc
BIN = niotrek.nio
#LIB = -lnsl -lm -lsocket
LIB = -lnsl -lm 
CFLAGS = -I../nio_lib -I../new_rpc -O -Wall -g -DDEBUG -DUNIX
OBJS= ../nio_lib/nio_lib.o ../new_rpc/msg_lib.o ../new_rpc/new_rpc.o ../new_rpc/sock_lib.o

all: $(BIN)

niotrek.nio:	niotrek.o $(OBJS)
		$(CC) -o $@ niotrek.o $(OBJS)  $(LIB)

install:
		cp *.nio $(HOME)/nio
		rm -rf $(HOME)/nio/niotrek
		mkdir $(HOME)/nio/niotrek
		cp *.jpg $(HOME)/nio/niotrek

clean:
		rm -f *.o *.nio core

