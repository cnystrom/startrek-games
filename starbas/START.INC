ON KEY(10) GOSUB break               'Push F10 to break program execution.
KEY(10) ON
GOTO start
break:
   STOP
start:
'$INCLUDE: 'PE_CHAIN.BI'          ' QB64 port: CHAIN/COMMON emulation

RANDOMIZE (TIMER)

page% = 0

