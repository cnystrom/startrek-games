'                                                  
'   STARBAT.BAS                 v0.10       
'                                                  
'   Christopher C. Nystrom      13 January 1990
'                                                  
'   MicroSoft QuickBASIC 4.5        
'                                                  
'
DECLARE SUB TorpedoSound ()

'$INCLUDE: 'STARBAT.INC'

progMode% = 0

SCREEN 0
COLOR white, black, black
CLS

FOR i = 1 TO 10
   r% = INTRND(23)
   DO
      c% = INTRND(79)
   LOOP WHILE c% = 65
   LOCATE r%, c%
   PRINT "*"
NEXT i

LOCATE 4, 10
PRINT "лллллл  ллллллл  лллллл  ллллл"
LOCATE 5, 10
PRINT "л          л     л    л  л    л"
LOCATE 6, 10
PRINT "лллллл     л     лллллл  ллллл"
LOCATE 7, 10
PRINT "     л     л     л    л  л    л"
LOCATE 8, 10
PRINT "лллллл     л     л    л  л    л"
PRINT
LOCATE 10, 5
PRINT "ллллл   лллллл  ллллллл  ллллллл  л      лллллл  лллллл"
LOCATE 11, 5
PRINT "л    л  л    л     л        л     л      л       л"
LOCATE 12, 5
PRINT "ллллл   лллллл     л        л     л      ллллл   лллллл"
LOCATE 13, 5
PRINT "л    л  л    л     л        л     л      л            л"
LOCATE 14, 5
PRINT "ллллл   л    л     л        л     ллллл  лллллл  лллллл"

LOCATE 16, 10
PRINT "(C) Chris Nystrom"
LOCATE 16, 40
PRINT "v 0.1"

LOCATE 18, 64
PRINT "O№O"

music$ = "eg4ea4 eg4ea4 d4c4e2 eg4ea4 eg4ea4 d4c4e2"
PLAY "MBL8T240o1" + music$

FOR i = 1 TO 6
   LOCATE i, 58 + i
   PRINT "<+>"
   DELAY (1)
   LOCATE i, 58 + i
   PRINT "   "
NEXT i
LOCATE 6, 64
PRINT "<+>"
CALL TorpedoSound

PLAY "MBL8T240o2" + music$

COLOR bright + red, black

FOR i = 7 TO 18
   LOCATE i, 65
   PRINT "o"
   LOCATE i, 65
   PRINT " "
NEXT i

COLOR blink + bright + red, black

LOCATE 18, 65
PRINT "А"

DELAY (5)

COLOR white, black
LOCATE 22, 2
PRINT "Do you want Instructions (y or n)?"
DO
   a$ = INKEY$
LOOP WHILE a$ <> "Y" AND a$ <> "y" AND a$ <> "N" AND a$ <> "n"

LOCATE 22, 2
PRINT SPACE$(60)

IF a$ = "Y" OR a$ = "y" THEN

   LOCATE 22, 2
   PRINT "Send output to printer (y or n)?"
   DO
      a$ = INKEY$
   LOOP WHILE a$ <> "Y" AND a$ <> "y" AND a$ <> "N" AND a$ <> "n"
  
   OPEN "SBINST.DOC" FOR INPUT AS #1
   CLS
   DO WHILE NOT EOF(1)
      IF CSRLIN = 23 THEN
         PAUSE
         CLS
      END IF
      LINE INPUT #1, lineBuffer$
      PRINT lineBuffer$
      IF a$ = "Y" OR a$ = "y" THEN LPRINT lineBuffer$
   LOOP
   CLOSE #1

END IF

LOCATE 22, 2
PRINT "Loading Star Battles Command Processor..."
CHAIN "SB"

