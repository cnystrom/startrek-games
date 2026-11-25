'                                
'   Name:  SBLIB.BAS          
'                                
'   Type:  Library Module          
'                                
'   Version:  0.10                   Date:  21 January 1990
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
SUB AddMsg2 (i, a$)

   tempPath$ = ENVIRON$("TMP")
   fileName$ = tempPath$ + TRIM$(STR$(i)) + ".TMP"
   OPEN fileName$ FOR APPEND AS #1
      PRINT #1, a$
   CLOSE #1

END SUB

SUB CseSpd (a1%, b1%, x1%, y1%, cse%, vel%, a2%, b2%, x2%, y2%)

   DIM c%(2, 10)
  
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
  
   a = ((a1 - 1) * 10) + x1           ' Convert to Single Plane
   b = ((b1 - 1) * 10) + y1           '   vice Quad/Sect.

   cs! = cse / 45 + 1
   cs2 = INT(cs!)
   cs3 = INT(cs! + 1)
   x! = c%(1, cs2) + (c%(1, cs3) - c%(1, cs2)) * (cs! - cs2)
   y! = c%(2, cs2) + (c%(2, cs3) - c%(2, cs2)) * (cs! - cs2)

   x! = (x! * vel) + a
   y! = (y! * vel) + b

'   x = a + x
'   y = b + y
              
   a2 = INT(x! / 10) + 1
   b2 = INT(y! / 10) + 1
  
   x2 = CINT(x! - ((a2 - 1) * 10))
   IF x2 = 0 THEN
      a2 = a2 - 1
      x2 = 10
   END IF
  
   y2 = CINT(y! - ((b2 - 1) * 10))
   IF y2 = 0 THEN
      b2 = b2 - 1
      y2 = 10
   END IF

END SUB

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
      dam% = INT(d% / tot%)
      IF dam% = 0 AND d% > 0 THEN dam% = 1
      DAMAGECALC% = dam%
   ELSE
      IF debug% = 1 THEN STOP
   END IF
 
END FUNCTION

FUNCTION DEVICE$ (a%)

   IF a% = generator1 THEN
      DEVICE$ = "Generator #1"

   ELSEIF a% = generator2 THEN
      DEVICE$ = "Generator #2"

   ELSEIF a% = generator3 THEN
      DEVICE$ = "Generator #3"

   ELSEIF a% = generator4 THEN
      DEVICE$ = "Generator #4"
  
   ELSEIF a% = impulsengine1 THEN
      DEVICE$ = "Impulse Engine #1"

   ELSEIF a% = impulsengine2 THEN
      DEVICE$ = "Impulse Engine #2"

   ELSEIF a% = impulsengine3 THEN
      DEVICE$ = "Impulse Engine #3"

   ELSEIF a% = impulsengine4 THEN
      DEVICE$ = "Impulse Engine #4"
  
   ELSEIF a% = thruster1 THEN
      DEVICE$ = "Thruster #1"

   ELSEIF a% = thruster2 THEN
      DEVICE$ = "Thruster #2"

   ELSEIF a% = switchboard THEN
      DEVICE$ = "Switchboard"

   ELSEIF a% = shield1 THEN
      DEVICE$ = "Shield #1"

   ELSEIF a% = shield2 THEN
      DEVICE$ = "Shield #2"

   ELSEIF a% = shield3 THEN
      DEVICE$ = "Shield #3"

   ELSEIF a% = shield4 THEN
      DEVICE$ = "Shield #4"

   ELSEIF a% = scanner THEN
      DEVICE$ = "Scanner"

   ELSEIF a% = srsensor THEN
      DEVICE$ = "Short Range Sensor"

   ELSEIF a% = lrsensor THEN
      DEVICE$ = "Long Range Sensor"

   ELSEIF a% = director1 THEN
      DEVICE$ = "Director #1"
 
   ELSEIF a% = director2 THEN
      DEVICE$ = "Director #2"

   ELSEIF a% = director3 THEN
      DEVICE$ = "Director #3"

   ELSEIF a% = director4 THEN
      DEVICE$ = "Director #4"

   ELSEIF a% = esmdev THEN
      DEVICE$ = "ESM Device"

   ELSEIF a% = phaser1 THEN
      DEVICE$ = "Phaser #1"

   ELSEIF a% = phaser2 THEN
      DEVICE$ = "Phaser #2"

   ELSEIF a% = phaser3 THEN
      DEVICE$ = "Phaser #3"

   ELSEIF a% = phaser4 THEN
      DEVICE$ = "Phaser #4"

   ELSEIF a% = torp1 THEN
      DEVICE$ = "Torpedo #1"

   ELSEIF a% = torp2 THEN
      DEVICE$ = "Torpedo #2"

   ELSEIF a% = torp3 THEN
      DEVICE$ = "Torpedo #3"

   ELSEIF a% = torp4 THEN
      DEVICE$ = "Torpedo #4"

   ELSEIF a% = mag1 THEN
      DEVICE$ = "Magazine #1"

   ELSEIF a% = mag2 THEN
      DEVICE$ = "Magazine #2"

   ELSEIF a% = mag3 THEN
      DEVICE$ = "Magazine #3"

   ELSEIF a% = mag4 THEN
      DEVICE$ = "Magazine #4"

   ELSEIF a% = dccentral THEN
      DEVICE$ = "Damage Control Central"

   ELSEIF a% = computer THEN
      DEVICE$ = "Library Computer"

   ELSEIF a% = lifesupport THEN
      DEVICE$ = "Life Support"

   ELSEIF a% = shipdock THEN
      DEVICE$ = "Ship Dock"

   END IF

END FUNCTION

FUNCTION DEVICENUM% (shipNum%, a%, b%)
 
   SHARED status%()

   c% = 0
   FOR i = a% TO b%
      IF status%(shipNum%, i) > -1 THEN c% = c% + 1
   NEXT i
   DEVICENUM% = c%

END FUNCTION

FUNCTION DEVICEUP% (shipNum%, a%, b%)

   SHARED status%()

   c% = 0
   FOR i = a% TO b%
      IF status%(shipNum%, i) = 4 THEN c% = c% + 1
   NEXT i
   DEVICEUP% = c%

END FUNCTION

SUB DirDist (a1%, b1%, x1%, y1%, a2%, b2%, x2%, y2%, dir%, dist%)

   CONST PI = 3.141593
   CONST CONV = 57.29578              ' Radians * CONV = Degrees.

'   x1 = CINT(x1)
'   y1 = CINT(y1)
'   x2 = CINT(x2)
'   y2 = CINT(y2)

   a = ((a1 - 1) * 10) + x1           ' Convert to Single Plane
   b = ((b1 - 1) * 10) + y1           '   vice Quad/Sect.
   x3 = ((a2 - 1) * 10) + x2
   y3 = ((b2 - 1) * 10) + y2

   x = y3 - b                          ' Make first point Origin.
   y = a - x3
    
   IF x = 0 THEN
      IF y > 0 THEN
         d! = PI / 2
      ELSEIF y < 0 THEN
         d! = -PI / 2
      ELSE
         d! = 0
      END IF
   
   ELSEIF y = 0 THEN
      IF x < 0 THEN
         d! = PI
      ELSE
         d! = 0
      END IF
  
   ELSE
      IF x < 0 THEN
         IF y > 0 THEN
            d! = ATN(y / x) + PI
         ELSE
            d! = ATN(y / x) - PI
         END IF
      ELSE
         d! = ATN(y / x)
      END IF
  
   END IF

   d! = d! * CONV                   ' Convert Radians to Degrees.

   d! = 90 - d!                     ' Convert to bearing by rotating
   IF d! < 0 THEN d! = d! + 360    '    counter-clockwise 90 deg.
   IF d! = 360 THEN d! = 0
   dir% = CINT(d!)
   a3 = ABS(a - x3)
   b3 = ABS(b - y3)
   IF a3 > b3 THEN
      dist% = a3
   ELSE
      dist% = b3
   END IF

END SUB

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

   tempPath$ = ENVIRON$("TMP")
   fileName$ = tempPath$ + "CCN.TMP"
   OPEN fileName$ FOR APPEND AS #1
      PRINT #1, "CCN"
   CLOSE #1
   fileName$ = tempPath$ + "*.TMP"
   KILL fileName$
  
   LOCATE 20, 2
   PRINT "Play another game? (Y/N)"
   DO
      a$ = INKEY$
   LOOP WHILE a$ <> "y" AND a$ <> "Y" AND a$ <> "n" AND a$ <> "N"
   IF a$ = "y" OR a$ = "Y" THEN
      CLS
      LOCATE 2, 2
      PRINT "Preparing for new game..."
      RUN "SB"
   ELSE
      END
      FOR i = 1 TO totshipnum%
         OPEN "TMP.TMP" FOR APPEND AS #1
            PRINT #1, "CCN"
         CLOSE #1
         KILL "*.TMP"
       NEXT i
  
   END IF

END SUB

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
  
   COLOR white, lightblue, lightblue
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

   temp% = 0
   FOR i = 1 TO totFleetNum%
      CLS
      LOCATE 2, 2
      PRINT "Select player to control "; TRIM$(fleet(i).fleetName); "."
      m1.returnCode = temp%
      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, lightblue, lightblue
      temp% = m1.returnCode
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

REM $STATIC
SUB OwnCourse (i, cse%, flag%)

   SHARED ship() AS ships
   SHARED status%()
   
   flag% = 0

   IF ship(i).dock > 0 THEN
      dockship% = ship(i).dock
      cse% = ship(dockship%).course
      EXIT SUB
   END IF
     
   thrusterUp% = 0
   IF status%(i, thruster1) = 4 THEN thrusterUp% = 1
   IF status%(i, thruster2) = 4 THEN thrusterUp% = thrusterUp% + 1
  
   IF thrusterUp% = 0 THEN
      cse% = ship(i).course
      flag% = 1
      EXIT SUB
   END IF

   manueverability% = ship(i).manuever
   IF DEVICENUM(i, thruster1, thruster2) = 2 THEN
      IF thrusterUp% = 1 THEN
         manueverability% = manueverability% / 2
      END IF
   END IF
       
   cse% = ship(i).course
   head% = ship(i).heading

   IF cse% < 90 AND head% > cse% + 180 THEN cse% = cse% + 360
   IF head% < 90 AND cse% > head% + 180 THEN head% = head% + 360
   IF cse% > 270 AND head% < cse% - 180 THEN head% = head% + 360
   IF head% > 270 AND cse% < head% - 180 THEN cse% = cse% + 360
  
   temp% = ABS(cse% - head%)
   IF temp% < manueverability% THEN
      cse% = head%
   ELSE
      IF head% < cse% THEN
         cse% = cse% - manueverability%
      ELSE
         cse% = cse% + manueverability%
      END IF
   END IF

   IF cse% > 360 THEN cse% = cse% - 360

END SUB

SUB OwnPosit (i, a3, b3, x3, y3)

   SHARED ship() AS ships
   SHARED status%()

   a1 = ship(i).xquad
   b1 = ship(i).yquad
   x1 = ship(i).xsect
   y1 = ship(i).ysect

   CALL OwnCourse(i, cse, flag%)
       
   CALL OwnVelocity(i, vel, minVel%, flag%)
       
   CALL CseSpd(a1, b1, x1, y1, cse, vel, a3, b3, x3, y3)

END SUB

SUB OwnVelocity (i, vel%, minVel%, flag%)

   SHARED ship() AS ships
   SHARED status%()

   flag% = 0

   IF ship(i).dock > 0 THEN
      dockship% = ship(i).dock
      vel% = ship(dockship%).velocity
      EXIT SUB
   END IF
      
   dvel% = CINT(ship(i).velocity / 2)
   IF dvel% < 1 THEN dvel% = 1
   maxVel% = ship(i).velocity + dvel%
   IF maxVel% > ship(i).maxvelocity THEN maxVel% = ship(i).maxvelocity
   minVel% = ship(i).velocity - dvel%
   IF minVel% < 0 THEN minVel% = 0

   ordVel% = ship(i).ordspd
   IF ordVel% > maxVel% THEN ordVel% = maxVel%
   IF ordVel% < minVel% THEN ordVel% = minVel%

   engineNum% = DEVICENUM%(i, impulsengine1, impulsengine4)
   engineUp% = DEVICEUP%(i, impulsengine1, impulsengine4)

   IF engineNum% > 0 THEN
      availvel% = CINT(engineUp% / engineNum% * ship(i).maxvelocity)
   ELSE
      availvel% = 0
   END IF
   IF availvel% > maxVel% THEN availvel% = maxVel%
   IF availvel% < minVel% THEN availvel% = minVel%

   IF ordVel% <= availvel% THEN
      vel% = ordVel%
   ELSE
      vel% = availvel%
      IF availvel% = 0 THEN
         flag% = 1
      ELSEIF enginUp% = 0 THEN
         flag% = 2
      ELSE
         flag% = 3
      END IF
   END IF

END SUB

REM $DYNAMIC
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
 
   tempPath$ = ENVIRON$("TMP")
   fileName$ = tempPath$ + "CCN.TMP"
   OPEN fileName$ FOR APPEND AS #1
      PRINT #1, "CCN"
   CLOSE #1
   fileName$ = tempPath$ + "*.TMP"
   KILL fileName$
     
   path$ = "A:\" + SPACE$(69)
   LOCATE 22, 2
   PRINT "Path: ";
   CALL FieldEditor(path$, 0)
   LOCATE 22, 2
   PRINT SPACE$(79);
 
   DO
      path$ = TRIM$(path$)

      BEEP
      LOCATE 22, 2
      INPUT "Input Scenario Filename"; a$
      LOCATE 22, 2
      PRINT "                                      "

      IF a$ = "" THEN EXIT SUB

      IF LEN(a$) > 8 THEN a$ = LEFT$(a$, 8)
      fileName$ = path$ + a$ + ".DAT"
      LOCATE 22, 2
      PRINT "Loading: "; fileName$

      OPEN fileName$ FOR APPEND AS #1
      CLOSE #1

      OPEN fileName$ FOR BINARY AS #1

      GET #1, , a%
      IF a% <> 1 THEN
         CLOSE #1
         KILL fileName$
         LOCATE 22, 2
         PRINT " File "; fileName$; " does not exist."
         PAUSE
         LOCATE 22, 2
         PRINT SPACE$(76)
      END IF

   LOOP WHILE a% <> 1

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

SUB SectorDecode (x$, objnum%, xsect%, ysect%)

   objnum% = ASC(LEFT$(x$, 1))
  
   a% = ASC(RIGHT$(x$, 1))
   xsect% = INT(a% / 10) + 1
   ysect% = INT(a% - ((xsect% - 1) * 10))
  
   IF ysect% = 0 THEN
      xsect% = xsect% - 1
      ysect% = 10
   END IF

END SUB

FUNCTION SectorEncode$ (a%, b!, c!)

   SectorEncode$ = CHR$(a%) + CHR$(CINT(b! - 1) * 10 + CINT(c!))

END FUNCTION

FUNCTION TOTENERGY% (shipNum%)

  SHARED ship() AS ships

  te% = ship(shipNum%).energy + ship(shipNum%).shield1
  te% = te% + ship(shipNum%).shield2 + ship(shipNum%).shield3
  TOTENERGY% = te% + ship(shipNum%).shield4

END FUNCTION

FUNCTION TYPESHIP$ (a%)

   IF a% = freighter THEN
      shiptype$ = "Freighter"

   ELSEIF a% = fueler THEN
      shiptype$ = "Fueler"

   ELSEIF a% = patrol THEN
      shiptype$ = "Patrol"

   ELSEIF a% = frigate THEN
      shiptype$ = "Frigate"

   ELSEIF a% = destroyer THEN
      shiptype$ = "Destroyer"

   ELSEIF a% = lcruiser THEN
      shiptype$ = "Light Cruiser"

   ELSEIF a% = hcruiser THEN
      shiptype$ = "Heavy Cruiser"

   ELSEIF a% = bcruiser THEN
      shiptype$ = "Battle Cruiser"

   ELSEIF a% = battleship THEN
      shiptype$ = "Battleship"

   ELSEIF a% = dreadnought THEN
      shiptype$ = "Dreadnought"

   ELSEIF a% = deathstar THEN
      shiptype$ = "Death Star"

   ELSEIF a% = station THEN
      shiptype$ = "Space Station"

   ELSEIF a% = monitor THEN
      shiptype$ = "Monitor"

   ELSEIF a% = transport THEN
      shiptype$ = "Transport"

   ELSEIF a% = tanker THEN
      shiptype$ = "Tanker"

   ELSEIF a% = outpost THEN
      shiptype$ = "Space Outpost"

   ELSEIF a% = barge THEN
      shiptype$ = "Barge"

   ELSEIF a% = corvette THEN
      shiptype$ = "Corvette"

   ELSEIF a% = torpcraft THEN
      shiptype$ = "Torpedo Craft"

   ELSEIF a% = spacedock THEN
      shiptype$ = "Space Dock"

   ELSEIF a% = sensor THEN
      shiptype$ = "Sensor Ship"

   ELSEIF a% = repair THEN
      shiptype$ = "Repair Ship"

   ELSE
      shiptype$ = ""

   END IF

   TYPESHIP$ = shiptype$

END FUNCTION

