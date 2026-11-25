ON KEY(10) GOSUB break               'Push F10 to break program execution.
KEY(10) ON
GOTO start
break:
   STOP
start:

RANDOMIZE (TIMER)

page% = 0

