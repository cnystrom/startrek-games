'                                                                 
'   Name:  SBLIB2.BAS                                           
'                                                                 
'   Type:  Library Module                                           
'                                                                 
'   Version:  1.00                   Date:  14 November 1989
'                                                                 
'   Programmer:  Christopher C. Nystrom                           
'                                                                 
'   Langauge:    MicroSoft QuickBASIC 4.5                        
'                                                                 
'   Function:    Provides a library of procedures for STAR BATTLES that use
'                SHARED variables.
'                                                                 

DECLARE SUB Initialize ()

'$INCLUDE: 'STARBAT.INC'

REM $DYNAMIC
DEFSNG A-H, M-Z
FUNCTION DAMAGECALC% (a%)

   SHARED damge%()
   SHARED debug%
   SHARED status%()

   tot% = 0
   d% = 0
 
   FOR i = 1 TO controltot
      IF status%(a%, i) > -1 THEN
         tot% = tot% + 1
         d% = d% + damge%(a%, i)
      END IF
   NEXT i
 
   IF tot% <> 0 THEN
      DAMAGECALC% = INT(d% / tot%)
   ELSE
      IF debug% = 1 THEN STOP
   END IF
 
END FUNCTION

'
'   Name:  DEVICENUM%                                                    
'                                                               
'   Type:  Function                                                    
'                                                               
'   Version:  1.00                   Date:  11 November 1989                  
'                                                               
'   Programmer:  Christopher C. Nystrom                         
'                                                               
'   Langauge:    MicroSoft QuickBASIC 4.0                       
'                                                               
'
FUNCTION DEVICENUM% (shipNum%, a%, b%)
 
   SHARED control%()

   c% = 0
   FOR i = a% TO b%
      IF control%(shipNum%, i) > -1 THEN c% = c% + 1
   NEXT i
   DEVICENUM% = c%

END FUNCTION

'                                                           
'   Name:  DEVICEUP%                                               
'                                                           
'   Type:  Function                                                
'                                                           
'   Version:  1.00                   Date:  11 November 1989             
'                                                           
'   Programmer:  Christopher C. Nystrom                     
'                                                           
'   Langauge:    MicroSoft QuickBASIC 4.0                   
'                                                           
'
FUNCTION DEVICEUP% (shipNum%, a%, b%)

   SHARED control%()

   c% = 0
   FOR i = a% TO b%
      IF control%(shipNum%, i) = 4 THEN c% = c% + 1
   NEXT i
   DEVICEUP% = c%

END FUNCTION

SUB EndGame
  
   SHARED playerName$()
   SHARED ship() AS ships
   SHARED totPlayerNum%
   SHARED totshipnum%

   CLS
   IF totPlayerNum% > 0 THEN
      LOCATE 2, 25
      PRINT "Game Over"
      PRINT
      PRINT "   Player", , "Total Points"
      PRINT
   END IF

   flag% = 0
   points% = 0
   FOR i = 1 TO totshipnum%
      IF ship(i).player = 0 THEN
         flag% = 1
         points% = points% + ship(i).score
      END IF
   NEXT i
   IF flag% = 1 THEN PRINT " Computer", , "  "; points%
  
   FOR i = 1 TO totPlayerNum%
      PRINT " "; playerName$(i), ;
      IF LEN(playerName$(i)) < 13 THEN PRINT , ;
      points% = 0
      FOR j = 1 TO totshipnum%
         IF ship(j).player = i THEN points% = points% + ship(j).score
      NEXT j
      PRINT "  "; points%
   NEXT i

END SUB

SUB GetPlayerNames
  
   SHARED totFleetNum%
   SHARED playerName$()

   FOR i = 1 TO totFleetNum%
      BEEP
      PRINT " Name of Player #"; i;
      INPUT playerName$(i)
   NEXT i

END SUB

DEFINT A-H, M-Z
SUB Initialize

   SHARED c%()
   SHARED control%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
   SHARED message$()
   SHARED playerName$()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totPlayerNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
  
   COLOR white, blue, blue
   CLS
   LOCATE 2, 2
   INPUT "How many players"; totPlayerNum%

   REDIM playerName$(totPlayerNum%)
   FOR i = 1 TO totPlayerNum%
      PRINT
      PRINT " Player number"; i; "name";
      INPUT playerName$(i)
   NEXT i
  
   m1.action = 2
   m1.edgeline = 2
   m1.fgd = white
   m1.bgd1 = blue
   m1.bgd2 = black
   m1.numCol = 1
   m1.edgeline = 3
   m1.row = 10
   m1.col = 30
   m1Title$ = "Player"
   m1.returnCode = 0

   REDIM m1Text$(1 TO totPlayerNum% + 1)
   m1Text$(1) = "Computer"
   FOR i = 1 TO totPlayerNum%
      m1Text$(i + 1) = playerName$(i)
   NEXT i

   FOR i = 1 TO totFleetNum%
      CLS
      LOCATE 2, 2
      PRINT "Select player to control "; TRIM$(fleet(i).fleetName); "."
      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, lightblue, lightblue
      fleet(i).controller = m1.returnCode - 1
      FOR j = 1 TO totshipnum%
         IF ship(j).fleet = i THEN ship(j).player = fleet(i).controller
      NEXT j
   NEXT i

   REDIM c%(2, 10)
   c%(1, 1) = -1
   c%(1, 2) = -1
   c%(1, 4) = 1
   c%(1, 5) = 1
   c%(1, 6) = 1
   c%(1, 8) = -1
   c%(1, 9) = -1
   c%(1, 10) = -1
   c%(2, 2) = 1
   c%(2, 3) = 1
   c%(2, 4) = 1
   c%(2, 6) = -1
   c%(2, 7) = -1
   c%(2, 8) = -1
   c%(2, 10) = 1

END SUB

DEFSNG A-H, M-Z
SUB QuadTable (q1%, q2%, xoffset%, yoffset%)

   SHARED location$()
   SHARED q%()

   FOR k = 1 TO LEN(location$(q1%, q2%)) / 2
      temp$ = MID$(location$(q1%, q2%), k * 2 - 1, 2)
      CALL SectorDecode(temp$, objnum%, xsect%, ysect%)
      q%(xsect% + xoffset%, ysect% + yoffset%) = objnum%
   NEXT k

END SUB

SUB SBLoad (a$)

   SHARED c%()
   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
   SHARED message$()
   SHARED playerName$()
   SHARED progMode%
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totPlayerNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType

   turn% = 1

   BEEP
   LOCATE 22, 2
   INPUT "Input Scenario Filename"; a$
   LOCATE 22, 2
   PRINT "                                      "

   IF a$ = "" THEN END

   IF LEN(a$) > 8 THEN a$ = LEFT$(a$, 8)
   fileName$ = a$ + ".DAT"
   LOCATE 22, 2
   PRINT "Loading: "; fileName$

   OPEN fileName$ FOR BINARY AS #1

   GET #1, , a%
   IF a% <> 1 THEN STOP

   GET #1, , stardate%
   GET #1, , quadsize%
   GET #1, , totFleetNum%
   GET #1, , totshipnum%
  
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   REDIM location$(quadsize%, quadsize%)
   REDIM fleet(totFleetNum%) AS fleets
   REDIM ship(totshipnum%) AS ships
   REDIM status%(totshipnum%, controltot)
   REDIM control%(totshipnum%, controltot)
   REDIM damge%(totshipnum%, controltot)
   REDIM distance%(totshipnum%, totshipnum%)
   REDIM direction%(totshipnum%, totshipnum%)
   REDIM message$(totshipnum%)
  
   FOR i = 1 TO quadsize%
      FOR j = 1 TO quadsize%
         GET #1, , a%
         location$(i, j) = STRING$(a%, " ")
         GET #1, , location$(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         GET #1, , status%(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         GET #1, , control%(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         GET #1, , damge%(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         GET #1, , distance%(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         GET #1, , direction%(i, j)
      NEXT j
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totFleetNum%
      GET #1, , fleet(i)
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   FOR i = 1 TO totshipnum%
      GET #1, , ship(i)
   NEXT i
 
   GET #1, , check%
   IF check% <> 9999 THEN STOP

   CLOSE #1

   IF debug% = 1 THEN IF totshipnum% = 0 THEN STOP

   IF progMode% <> 3 THEN CALL Initialize

END SUB

SUB SBSave

   SHARED control%()
   SHARED damge%()
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%

   CLS
   LOCATE 22, 2
   INPUT "Input Scenario Filename"; a$
   LOCATE 22, 2
   PRINT "                                    "

   IF a$ = "" THEN EXIT SUB
   
   IF LEN(a$) > 8 THEN a$ = LEFT$(a$, 8)
   fileName$ = a$ + ".DAT"

   a% = 1                                      ' Version Number.
   check% = 9999

   OPEN fileName$ FOR BINARY AS #1

   PUT #1, , a%
   PUT #1, , stardate%
   PUT #1, , quadsize%
   PUT #1, , totFleetNum%
   PUT #1, , totshipnum%
   PUT #1, , check%

   FOR i = 1 TO quadsize%
      FOR j = 1 TO quadsize%
         a% = LEN(location$(i, j))
         PUT #1, , a%
         PUT #1, , location$(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
  
   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         PUT #1, , status%(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
  
   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         PUT #1, , control%(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
  
   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         PUT #1, , damge%(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
  
   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         PUT #1, , distance%(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
  
   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         PUT #1, , direction%(i, j)
      NEXT j
   NEXT i
   PUT #1, , check%
 
   FOR i = 1 TO totFleetNum%
      PUT #1, , fleet(i)
   NEXT i
   PUT #1, , check%

   FOR i = 1 TO totshipnum%
      PUT #1, , ship(i)
   NEXT i
   PUT #1, , check%
  
   CLOSE #1

END SUB

DEFINT A-H, M-Z
'                                                               
'   Name:  TorpCalc                                                    
'                                                               
'   Type:  Subprogram                                                    
'                                                               
'   Version:  2.00                   Date:  4 June 1989                  
'                                                               
'   Programmer:  Christopher C. Nystrom                         
'                                                               
'   Langauge:    MicroSoft QuickBASIC 4.0                       
'                                                               
'   Use:   Computes recommended torpedo courses.                                                    
'                                                               
'
SUB TorpCalc (i%, j%, dir%, dist%, a%)

   SHARED ship() AS ships
   SHARED status%()

   a1 = ship(i).xquad
   b1 = ship(i).yquad
   x1 = ship(i).xsect
   y1 = ship(i).ysect
   cse = ship(i).course
   vel = ship(i).velocity
       
   thrusterup% = 0
   IF status%(i, thruster1) = 4 THEN
      thrusterup% = 1
   END IF

   IF status%(i, thruster2) = 4 THEN
      thrusterup% = thrusterup% + 1
   END IF

   IF thrusterup% > 0 THEN
    
      manueverability% = ship(i).manuever
      IF DEVICENUM(i, thruster1, thruster2) = 2 AND thrusterup% = 1 THEN
         manueverability% = manueverability% / 2
      END IF
        
      cse = ship(i).course
      head = ship(i).heading

      IF cse < 90 AND head > cse + 180 THEN
         cse = cse + 360
      END IF
         
      IF head < 90 AND cse > head + 180 THEN
         head = head + 360
      END IF

      IF cse > 270 AND head < cse - 180 THEN
         head = head + 360
      END IF

      IF head > 270 AND cse < head - 180 THEN
         cse = cse + 360
      END IF

      temp% = ABS(cse - head)
      IF temp% < manueverability% THEN
         cse = head
      ELSE
         IF head < cse THEN
            cse = cse - manueverability%
         ELSE
            cse = cse + manueverability%
         END IF
      END IF
      
      IF cse > 360 THEN cse = cse - 360

   END IF

   IF ship(i).ordspd <> ship(i).velocity THEN
      dvel% = CINT(ship(i).velocity / 2)
      IF dvel% < 1 THEN dvel% = 1
      IF ship(i).ordspd > ship(i).velocity THEN
         vel = ship(i).velocity + dvel%
         IF vel > ship(i).ordspd THEN
            vel = ship(i).ordspd
         END IF
      ELSE
         vel = ship(i).velocity - dvel%
         IF vel < ship(i).ordspd THEN
            vel = ship(i).ordspd
         END IF
      END IF
   END IF
 
   CALL CseSpd(a1, b1, x1, y1, cse, vel, a3, b3, x3, y3)

   IF a% = 1 THEN
      PRINT " "; TRIM$(ship(i).shipname); " projected location: ";
      PRINT a3; ","; b3; "  "; x3; ","; y3
   END IF

   IF j = 254 THEN EXIT SUB                                             '***
   a1 = ship(j).xquad
   b1 = ship(j).yquad
   x1 = ship(j).xsect
   y1 = ship(j).ysect
   cse = ship(j).course
   vel = ship(j).velocity
   CALL CseSpd(a1, b1, x1, y1, cse, vel, a2, b2, x2, y2)
                  
   IF a% = 1 THEN
      PRINT
      PRINT " "; TRIM$(ship(j).sidename); " "; TRIM$(ship(j).objname);
      PRINT " projected location: "; a2; ","; b2; "  "; x2; ","; y2
   END IF
 
   CALL DirDist(a3, b3, x3, y3, a2, b2, x2, y2, dir, dist)

END SUB

DEFSNG A-H, M-Z
'                                                               
'   Name:  TOTENERGY%                                                    
'                                                               
'   Type:  Function                                                    
'                                                               
'   Version:  1.00                   Date:  24 May 1989                   
'                                                               
'   Programmer:  Christopher C. Nystrom                         
'                                                               
'   Langauge:    MicroSoft QuickBASIC 4.0                       
'                                                               
'
FUNCTION TOTENERGY% (shipNum%)

  SHARED ship() AS ships

  te% = ship(shipNum%).energy + ship(shipNum%).shield1
  te% = te% + ship(shipNum%).shield2 + ship(shipNum%).shield3
  TOTENERGY% = te% + ship(shipNum%).shield4

END FUNCTION

