#
#       strek95
#
#	This program is free software; you can redistribute it
#	and/or  modify it under  the terms of  the GNU General
#	Public  License as  published  by  the  Free  Software
#	Foundation;  either  version 2 of the License, or  (at
#	your option) any later version.
#

#CC	= mcc
#CC	= cc
#CC	= c89
#CC	= gcc
CC	= acc
CFLAGS	= -g 
#CFLAGS	= -O 
#CFLAGS	= -O -Wall -g
OBJS	= startrek.o ship.o space.o stardate.o klingon.o\
          standard.o posit.o galaxy.o damage.o devices.o\
          dc.o lrs.o nav.o shields.o srs.o torps.o phasers.o\
          computer.o galrec.o starbase.o scanners.o rank.o\
          shiptype.o score.o location.o sound.o rand.o disk_io.o\
	  end_game.o qnames.o instruct.o
LIBS	= -lm
PROGS	= startrek
INSTALL	= /etc/install
LBIN	= /usr/games

all:		$(PROGS) 

startrek:	$(OBJS)
		$(CC) $(LDFLAGS) -o startrek $(OBJS) $(LIBS)

clean:
		rm -f $(PROGS) *.o core startrek.0*

install:
		$(INSTALL) -f $(LBIN) -u bin -g bin -m 755 $(PROGS)
		strip $(LBIN)/$(PROGS)

archive:	clean
		./archive.sh strek95
