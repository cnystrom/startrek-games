'
'   Name:  SB.BAS
'
'   Type:  Library Module
'
'   Version:  0.10                   Date:  22 January 1990
'
'   Programmer:  Christopher C. Nystrom
'
'   Langauge:    MicroSoft QuickBASIC 4.5
'
'   Function:    Routines for STAR BATTLES to get the player's moves.
'
DECLARE SUB ElectronicSounds ()
DECLARE SUB WhoopSiren ()
DECLARE SUB TorpedoSound ()
DECLARE SUB PhaserSound ()
DECLARE SUB GeneratorOnSound ()
DECLARE SUB GeneratorOffSound ()
DECLARE SUB MachinerySound ()
DECLARE SUB SRSound ()
DECLARE SUB LRSound ()
DECLARE SUB ScannerSound ()
DECLARE SUB ShieldDownSound ()
DECLARE SUB ShieldUpSound ()

DECLARE SUB ProcessMoves ()

DECLARE FUNCTION SensorDecode$ (x1%, y1%)

DECLARE SUB SelectEngineering (shipNum%)
DECLARE SUB SelectSensor (shipNum%)
DECLARE SUB SelectShield (shipNum%)
DECLARE SUB SelectWeapons (shipNum%)
DECLARE SUB ChooseShip (fleetNum%)
DECLARE SUB ChooseFleet (playerNum%)
DECLARE SUB ChoosePlayer ()
DECLARE SUB Locator (shipNum%, a%, b%)
DECLARE SUB CreateScreen (shipNum%)
DECLARE SUB CreateQuadrants (shipNum%)
DECLARE SUB DeviceOp (shipNum%, a%, b%)
DECLARE SUB GetMoves (shipNum%)
DECLARE SUB DeviceStatus (shipNum%, a%, b%)
DECLARE SUB TorpCalc2 (shipNum%, b%)

'$INCLUDE: 'STARBAT.INC'

'DO
   CALL ChoosePlayer
'   CALL ProcessMoves
'LOOP

CLS
LOCATE 2, 2
PRINT "Loading Moves Processor..."
CHAIN "SB2"

REM $DYNAMIC
SUB ChooseFleet (playerNum%)

   SHARED control%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
    
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
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

   selectSave% = 0
   DO

      CLS
      LOCATE 2, 2
      PRINT "Player Name: ";
      IF playerNum% = 0 THEN
         PRINT "Computer"
      ELSE
         PRINT playerName$(playerNum%)
      END IF

      m1.action = 2
      m1.edgeline = 2
      m1.fgd = white
      m1.bgd1 = blue
      m1.bgd2 = black
      m1.numCol = 1
      m1.edgeline = 3
      m1.row = 10
      m1.col = 30
      m1Title$ = "Fleet"
      m1.returnCode = selectSave%

      totFleet% = 0
      FOR i = 1 TO totFleetNum%
         IF fleet(i).controller = playerNum% THEN totFleet% = totFleet% + 1
      NEXT i
     
      IF totFleet% = 0 THEN
         PRINT
         PRINT " "; playerName$(playerNum%); " does not control any ships."
         PAUSE
         EXIT SUB
     
      ELSEIF totFleet% = 1 THEN
         FOR i = 1 TO totFleetNum%
            IF fleet(i).controller = playerNum% THEN
               fleetNum% = i
               EXIT FOR
            END IF
         NEXT i
         CALL ChooseShip(fleetNum%)
         EXIT SUB

      ELSE
         REDIM m1Text$(1 TO totFleet% + 1)
         REDIM temp%(totFleet%)
         counter% = 1
         FOR i = 1 TO totFleetNum%
            IF fleet(i).controller = playerNum% THEN
                m1Text$(counter%) = fleet(i).fleetName
                temp%(counter%) = i
                counter% = counter% + 1
            END IF
         NEXT i
         m1Text$(totFleet% + 1) = "Quit"

         CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
         COLOR white, blue, lightblue

         IF m1.returnCode = totFleet% + 1 OR m1.returnCode = 0 THEN EXIT SUB
         selectSave% = m1.returnCode
         fleetNum% = temp%(m1.returnCode)
         CALL ChooseShip(fleetNum%)

      END IF
  
   LOOP

END SUB

SUB ChoosePlayer
  
   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
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
  
   COLOR white, blue, lightblue

   selectSave% = 0
   DO

      CLS
      LOCATE 2, 2
      PRINT "Star Battles"

      m1.action = 2
      m1.edgeline = 2
      m1.fgd = white
      m1.bgd1 = blue
      m1.bgd2 = black
      m1.numCol = 1
      m1.edgeline = 3
      m1.row = 10
      m1.col = 30
      m1.center = 1
      m1Title$ = "Player Menu"
      m1.returnCode = selectSave%

      flag% = 0
      FOR i = 1 TO totFleetNum%
         IF fleet(i).controller = 0 THEN flag% = 1
      NEXT i

      IF debug% = 1 AND flag% = 1 THEN
         REDIM m1Text$(1 TO totPlayerNum% + 5)
         m1Text$(1) = "Computer"
      ELSE
         REDIM m1Text$(1 TO totPlayerNum% + 4)
      END IF

      FOR i = 1 TO totPlayerNum%
         IF debug% = 1 AND flag% = 1 THEN
            m1Text$(i + 1) = playerName$(i)
         ELSE
            m1Text$(i) = playerName$(i)
         END IF
      NEXT i
     
      IF debug% = 1 AND flag% = 1 THEN
         temp% = totPlayerNum% + 2
      ELSE
         temp% = totPlayerNum% + 1
      END IF
     
      m1Text$(temp%) = "End Turn"
      m1Text$(temp% + 1) = "Save Game"
      m1Text$(temp% + 2) = "Load Game"
      m1Text$(temp% + 3) = "Quit Game"

      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, blue, lightblue

      selectSave% = m1.returnCode
      IF debug% = 1 AND flag% = 1 THEN m1.returnCode = m1.returnCode - 1

      IF m1.returnCode = totPlayerNum% + 1 THEN
         IF totshipnum% > 0 THEN
            EXIT DO
         ELSE
            LOCATE 22, 2
            PRINT "No Scenario Loaded"
            PAUSE
         END IF
 
      ELSEIF m1.returnCode = totPlayerNum% + 2 THEN
         IF totshipnum% > 0 THEN
            CALL SBSave
         ELSE
            LOCATE 22, 2
            PRINT "No Scenario Loaded"
            PAUSE
         END IF

      ELSEIF m1.returnCode = totPlayerNum% + 3 THEN
         CALL SBLoad(a$)
         selectSave% = 0

      ELSEIF (m1.returnCode = totPlayerNum% + 4) OR (debug% = 0 AND m1.returnCode = 0) THEN
         CLS
         LOCATE 2, 2
         PRINT "Are you sure you want to quit? (Y/N)"
         DO
            a$ = INKEY$
            IF a$ = "Y" OR a$ = "y" THEN
               IF progMode% = 0 THEN CALL EndGame
               END
            END IF
         LOOP WHILE a$ <> "N" AND a$ <> "n"

      ELSE
         playerNum% = m1.returnCode
         CALL ChooseFleet(playerNum%)
        
      END IF

   LOOP

END SUB

SUB ChooseShip (fleetNum%)
 
   SHARED control%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED fleet() AS fleets
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
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
 
   REDIM redirect%(22)
   pointer = 1
   FOR i = 1 TO totshipnum%
      IF ship(i).fleet = fleetNum% THEN
         IF pointer < 23 THEN
            redirect%(pointer) = i
            pointer = pointer + 1
         END IF
      END IF
   NEXT i

   selectSave% = 0
   DO
     
      CLS
      LOCATE 2, 2
      PRINT "Fleet: "; TRIM$(fleet(fleetNum%).fleetName)
      LOCATE 4, 2
      PRINT "Turn:"; turn%
    
      IF pointer - 1 = 0 THEN
         LOCATE 10, 25
         PRINT "No Vessals Available"
         PAUSE
         EXIT SUB
     
      ELSEIF pointer - 1 = 1 THEN
         shipNum% = redirect%(pointer - 1)
         CALL GetMoves(shipNum%)
         EXIT SUB

      ELSE
         m1.row = 13 - CINT(pointer / 2)
         m1.col = 30
         m1Title$ = "Ship"
         m1.returnCode = selectSave%

         REDIM m1Text$(1 TO pointer)
         FOR i = 1 TO pointer - 1
            m1Text$(i) = ship(redirect%(i)).shipname
         NEXT i
         m1Text$(pointer) = "Quit"
        
         CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
         COLOR white, blue, lightblue
        
         IF m1.returnCode = 0 OR m1.returnCode = pointer THEN EXIT SUB
         selectSave% = m1.returnCode
         shipNum% = redirect%(m1.returnCode)
         CALL GetMoves(shipNum%)
     
      END IF

   LOOP

END SUB

SUB CreateQuadrants (shipNum%)
 
   SHARED location$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships

   REDIM q%(30, 30)
  
      'Top-Left Corner
      IF ship(shipNum%).xquad <> 1 THEN               'If not in top row.
         IF ship(shipNum%).yquad <> 1 THEN            'If not in left column.
            q1% = ship(shipNum%).xquad - 1
            q2% = ship(shipNum%).yquad - 1
            CALL QuadTable(q1%, q2%, 0, 0)
         END IF

      'Top-Center
         q1% = ship(shipNum%).xquad - 1
         q2% = ship(shipNum%).yquad
         CALL QuadTable(q1%, q2%, 0, 10)

      'Top-Right Corner
         IF ship(shipNum%).yquad <> quadsize% THEN    'If not in right column.
            xoffset% = 0
            yoffset% = 20
            q1% = ship(shipNum%).xquad - 1
            q2% = ship(shipNum%).yquad + 1
            CALL QuadTable(q1%, q2%, 0, 20)
         END IF
      END IF

      'Left-Center
      IF ship(shipNum%).yquad <> 1 THEN               'If not in left column.
         q1% = ship(shipNum%).xquad
         q2% = ship(shipNum%).yquad - 1
         CALL QuadTable(q1%, q2%, 10, 0)
      END IF

      'Center
      q1% = ship(shipNum%).xquad
      q2% = ship(shipNum%).yquad
      CALL QuadTable(q1%, q2%, 10, 10)

      'Right-Center
      IF ship(shipNum%).yquad <> quadsize% THEN       'If not in right column.
         q1% = ship(shipNum%).xquad
         q2% = ship(shipNum%).yquad + 1
         CALL QuadTable(q1%, q2%, 10, 20)
      END IF

      'Lower-Left Corner
      IF ship(shipNum%).xquad <> quadsize% THEN       'If not in bottom row.
         IF ship(shipNum%).yquad <> 1 THEN            'If not in left column.
            q1% = ship(shipNum%).xquad + 1
            q2% = ship(shipNum%).yquad - 1
            CALL QuadTable(q1%, q2%, 20, 0)
         END IF

      'Lower-Center
         q1% = ship(shipNum%).xquad + 1
         q2% = ship(shipNum%).yquad
         CALL QuadTable(q1%, q2%, 20, 10)

      'Lower-Right Corner
         IF ship(shipNum%).yquad <> quadsize% THEN    'If not in right column.
            q1% = ship(shipNum%).xquad + 1
            q2% = ship(shipNum%).yquad + 1
            CALL QuadTable(q1%, q2%, 20, 20)
         END IF
      END IF
     
      q1% = ship(shipNum%).xquad
      q2% = ship(shipNum%).yquad

END SUB

SUB CreateScreen (shipNum%)

   SHARED location$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships

   COLOR brightwhite, black
                          
   REDIM q%(30, 30)
   CALL CreateQuadrants(shipNum%)

   row% = 2
   FOR k = ship(shipNum%).xsect TO ship(shipNum%).xsect + 20
      LOCATE row%, 2
      FOR l = ship(shipNum%).ysect TO ship(shipNum%).ysect + 20
         IF q%(k, l) = 0 THEN
            PRINT "   ";
         ELSEIF q%(k, l) = 254 THEN
            PRINT " ° ";
         ELSEIF q%(k, l) = 255 THEN
            PRINT " * ";
         ELSE
            PRINT ship(q%(k, l)).image;
         END IF
      NEXT l
      PRINT
      row% = row% + 1
   NEXT k

   COLOR white, lightblue

END SUB

SUB DeviceOp (shipNum%, a%, b%)

   SHARED control%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED status%()
   SHARED totshipnum%
   SHARED m1 AS MenuType

   LOCATE 22, 2
   name$ = DEVICE$(a%)

   IF control%(shipNum%, a%) = -1 THEN
      PRINT "Executive Officer reports:"
      PRINT "   '"; name$; " not avialable on this class ship, sir.'";
      PAUSE
      LOCATE 22, 2
      PRINT SPACE$(75)
      LOCATE 23, 2
      PRINT SPACE$(75);

   ELSEIF control%(shipNum%, a%) = 0 THEN
      PRINT "Executive Officer reports:"
      PRINT "   '"; name$; " has been destroyed, sir.'"
      PAUSE
      LOCATE 22, 2
      PRINT SPACE$(75)
      LOCATE 23, 2
      PRINT SPACE$(75);

   ELSEIF control%(shipNum%, a%) = 1 THEN
      PRINT "Executive Officer reports:"
      PRINT "   '"; name$; " is damaged and inoperable, sir.'"
      PAUSE
      LOCATE 22, 2
      PRINT SPACE$(75)
      LOCATE 23, 2
      PRINT SPACE$(75);

   ELSE
  
      IF a% <= thruster2 THEN
         IF control%(shipNum%, a%) = 2 THEN
            control%(shipNum%, a%) = 3
            CALL GeneratorOnSound
         ELSE
            control%(shipNum%, a%) = 2
            CALL GeneratorOffSound
         END IF

      ELSEIF a% = switchboard THEN
        
         control%(shipNum%, a%) = 4
      
         COLOR white, blue, lightblue
         CLS
        
         LOCATE 2, 35
         PRINT "Switchboard"

         x% = DEVICENUM(shipNum%, scanner, esmdev)

         REDIM dnum%(x%)
         temp = 1
         FOR i = scanner TO esmdev
            IF control%(shipNum%, i) > -1 THEN
               dnum%(temp) = i
               temp = temp + 1
            END IF
         NEXT i

         REDIM m1Text$(1 TO x% + 1)
         i = 1
         FOR j = scanner TO esmdev
            IF control%(shipNum%, j) > -1 THEN
               m1Text$(i) = DEVICE$(j)
               i = i + 1
            END IF
         NEXT j
         m1Text$(x% + 1) = "Quit"
             
         m1.row = 5
         m1.col = 1
         m1.edgeline = 3
         m1Title$ = "Sensors"
         m1.returnCode = 0

         DO

             row% = 6

             FOR i = scanner TO esmdev
                IF control%(shipNum%, i) > -1 THEN
                   LOCATE row%, 25
                   PRINT SPACE$(54)
                   LOCATE row%, 25
                   CALL DeviceStatus(shipNum%, i, -1)
                   row% = row% + 1
                END IF
             NEXT i

             CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
             COLOR white, blue, lightblue
     
             selection% = m1.returnCode
             IF selection% = 0 THEN selection% = x% + 1

             IF selection% <> x% + 1 THEN
 
                b% = dnum%(selection%)
                IF control%(shipNum%, b%) = 2 THEN
                   control%(shipNum%, b%) = 3
                ELSE
                   control%(shipNum%, b%) = 2
                END IF
          
             END IF

         LOOP WHILE selection% <> x% + 1

         'm1.edgeline = -1
         COLOR white, blue, lightblue
         CLS

      ELSEIF a% = shipdock THEN

         CLS
         LOCATE 2, 35
         PRINT "Docking"
         LOCATE 4, 2
         PRINT TRIM$(ship(shipNum%).shipname);

         IF ship(shipNum%).dock < 0 THEN
            PRINT " already docked."

         ELSEIF ship(shipNum%).dock = 1000 THEN
            PRINT " cannot redock."

         ELSEIF ship(shipNum%).dock > 0 THEN
            ship(ship(shipNum%).dock).dock = 1000
            ship(shipNum%).dock = 1000
            PRINT " completed seperation."

         ELSE
  
'        Find another ship
  
            REDIM q%(30, 30)

            CALL CreateQuadrants(shipNum%)

            s1% = CINT(ship(shipNum%).xsect) + 10
            s2% = CINT(ship(shipNum%).ysect) + 10
            cse1 = ship(shipNum%).course
            vel1 = ship(shipNum%).velocity
  
            FOR i = s1% - 1 TO s1% + 1
               FOR j = s2% - 1 TO s2% + 1
                  IF i <> s1% OR j <> s2% THEN
                     IF q%(i, j) > 0 AND q%(i, j) < 250 THEN
                        dockship% = q%(i, j)
                        docked% = 1

'                    Is dock available?

                        IF ship(dockship%).dock <> 0 THEN
                           docked% = 0
                        END IF

'                    Are ships within docking parameters?
  
                        IF ship(dockship%).shiptype <> station THEN
                           cse2 = ship(dockship%).course
                           IF cse1 > 350 AND cse2 < 10 THEN cse2 = cse2 + 360
                           IF cse1 < 10 AND cse2 > 350 THEN cse2 = cse2 - 360

                           IF cse1 > cse2 + 10 AND cse1 < cse2 - 10 THEN
                              docked% = 0
                           END IF
                        END IF

                        vel2 = ship(dockship%).velocity
                        IF vel1 > vel2 + 1 AND vel1 < vel2 - 1 THEN
                           docked% = 0
                        END IF

                        IF control%(dockship%, shield1) = 4 THEN
                           docked% = 0
                        END IF

                        IF control%(dockship%, shield2) = 4 THEN
                           docked% = 0
                        END IF

                        IF control%(dockship%, shield3) = 4 THEN
                           docked% = 0
                        END IF

                        IF control%(dockship%, shield4) = 4 THEN
                           docked% = 0
                        END IF

'                    If so dock.

                        IF docked% = 1 THEN

                           ship(dockship%).dock = shipNum% * -1
                           ship(shipNum%).dock = dockship% * -1

'                       Match course and speed.

                           ship(shipNum%).course = ship(dockship%).course
                           ship(shipNum%).velocity = ship(dockship%).velocity

'                       Lower shields.
  
                           ship(shipNum%).shield1 = 0
                           ship(shipNum%).shield2 = 0
                           ship(shipNum%).shield3 = 0
                           ship(shipNum%).shield4 = 0
                       
                           FOR l = shield1 TO shield4
                              IF control%(shipNum%, l) > 2 THEN
                                 control%(shipNum%, l) = 2
                              END IF
                           NEXT l

                           PRINT " shields lowered for docking."
                           SOUND 40, 10
                           PAUSE
                           EXIT SUB

                        END IF

                     END IF
  
                  END IF
  
               NEXT j

            NEXT i
            PRINT " Docking not possible at this time."

         END IF
         PAUSE

      ELSEIF a% >= shield1 AND a% <= shield4 THEN

         LOCATE 14, 2
         PRINT "Number of units to "; name$;
         INPUT c%
         LOCATE 14, 2
         PRINT SPACE$(75)
         LOCATE 16, 2
         PRINT SPACE$(75)
         LOCATE 17, 2
         PRINT SPACE$(75)
         LOCATE 16, 2
        
         d% = ship(shipNum%).maxshields

         IF c% > ship(shipNum%).energy + b% THEN
            PRINT " Engineering Officer reports:"
            PRINT "    'I don't have "; c%; " units of energy for "; name$; ", sir!'"

         ELSEIF c% > d% THEN
            PRINT " Science Officer reports: 'Maximum amount of energy that can be put "
            PRINT "    into a shield for this class of vessal is"; d%; " units, sir.'"

         ELSEIF c% >= 0 THEN
            ship(shipNum%).energy = ship(shipNum%).energy + b% - c%
            b% = c%
            IF c% > 0 THEN
               control%(shipNum%, a%) = 4
               CALL ShieldUpSound
            ELSE
               control%(shipNum%, a%) = 2
               CALL ShieldDownSound
            END IF

         END IF

      ELSEIF a% = scanner THEN
      
         IF control%(shipNum%, scanner) < 4 THEN
            PRINT "Science Officer reports: 'Scanner not available, sir.'"
            PAUSE
            EXIT SUB
         END IF

         CALL Locator(shipNum%, a%, b%)
      
         LOCATE 2, 2
         PRINT "Scinece Officer reports:"
         PRINT "   'Scanning ";

         IF b% = 254 THEN
            PRINT "debris.'"
            PRINT "   'Nothing there execept space debris, sir.'"
            
         ELSEIF b% = 255 THEN
            PRINT "star.'"
            PRINT "   'Appears to be an ordinary star, Captain.'"
            
         ELSEIF b% > 0 THEN
            PRINT TRIM$(ship(b%).sidename); " ";
            PRINT TRIM$(ship(b%).objname); " ";
            IF ship(shipNum%).side = ship(b%).side THEN
               PRINT TRIM$(ship(b%).shipname); " ";
            END IF
            PRINT "at quadrant ";
            PRINT TRIM$(STR$(ship(b%).xquad)); ",";
            PRINT TRIM$(STR$(ship(b%).yquad)); " "; "sector ";
            PRINT TRIM$(STR$(CINT(ship(b%).xsect))); ",";
            PRINT TRIM$(STR$(CINT(ship(b%).ysect))); ".'"
            PRINT
            PRINT " Direction: "; PAD$(direction%(shipNum%, b%), 3),
            PRINT " Distance: "; distance%(shipNum%, b%)
            PRINT
            PRINT " Course: "; PAD$(ship(b%).course, 3), ,
            PRINT " Velocity: "; ship(b%).velocity
            PRINT
            PRINT " Total Energy: "; TOTENERGY%(b%)
            PRINT
        
            IF status%(b%, shield1) > -1 THEN
               IF status%(b%, shield1) = 4 THEN
                  PRINT " Shield #1 is up."
               ELSE
                  PRINT " Shield #1 is down."
               END IF
            END IF

            IF status%(b%, shield2) > -1 THEN
               IF status%(b%, shield2) = 4 THEN
                  PRINT " Shield #2 is up."
               ELSE
                  PRINT " Shield #2 is down."
               END IF
            END IF

            IF status%(b%, shield3) > -1 THEN
               IF status%(b%, shield3) = 4 THEN
                  PRINT " Shield #3 is up."
               ELSE
                  PRINT " Shield #3 is down."
               END IF
            END IF

            IF status%(b%, shield4) > -1 THEN
               IF status%(b%, shield4) = 4 THEN
                  PRINT " Shield #4 is up."
               ELSE
                  PRINT " Shield #4 is down."
               END IF
            END IF

            PRINT
            PRINT " Damage Percentage is: "; DAMAGECALC%(b%); "%"
       
         ELSE
            PRINT "space.'"
            PRINT "   'Doesn't seem to be anything out there, Captain.'"
         END IF

         PAUSE

      ELSEIF a% = srsensor THEN
     
         IF control%(shipNum%, srsensor) < 4 THEN
            PRINT " Science Officer reports: ";
            PRINT "'Short Range Sensor not available, sir.'"
            PAUSE
            EXIT SUB
         END IF

         CLS
         PRINT
         PRINT TAB(15); "Short Range Sensor scan for quadrant ";

         q1% = ship(shipNum%).xquad
         q2% = ship(shipNum%).yquad
         line$ = STRING$(31, "-")

         PRINT q1%; ","; q2%
         CALL SRSound
         LOCATE 4, 1
         PRINT TAB(20); line$
         FOR i = -2 TO 2
            PRINT TAB(20);
            FOR j = -2 TO 2
               PRINT ": "; SensorDecode$(q1% + i, q2% + j); " ";
            NEXT j
            PRINT ":"
            PRINT TAB(20); line$
         NEXT i
         control%(shipNum%, a%) = 4
         PAUSE

      ELSEIF a% = lrsensor THEN
    
         IF control%(shipNum%, lrsensor) < 4 THEN
            PRINT " Science Officer reports: ";
            PRINT "'Long Range Sensor not available, sir.'"
            PAUSE
            EXIT SUB
         END IF

         CLS
         PRINT
         PRINT TAB(16); "Long Range Sensor scan for quadrant ";

         q1% = ship(shipNum%).xquad
         q2% = ship(shipNum%).yquad
         line$ = STRING$(43, "-")

         PRINT q1%; ","; q2%
         CALL LRSound
         PRINT
         PRINT TAB(16); line$
         FOR i = -3 TO 3
            PRINT TAB(16);
            FOR j = -3 TO 3
               PRINT ": "; SensorDecode$(q1% + i, q2% + j); " ";
            NEXT j
            PRINT ":"
            PRINT TAB(16); line$
         NEXT i
         control%(shipNum%, a%) = 4
         PAUSE

      ELSEIF a% >= director1 AND a% <= director4 THEN
    
         IF control%(shipNum%, a%) < 4 THEN
            PRINT " Science Officer reports: ";
            PRINT "'"; name$; " not available, sir.'"
            PAUSE
            EXIT SUB
         END IF

         CALL Locator(shipNum%, a%, b%)

      ELSEIF a% = esmdev THEN
     
         IF control%(shipNum%, esmdev) < 4 THEN
            PRINT " Science Officer reports: ";
            PRINT "'ESM device not available, sir.'"
            PAUSE
            EXIT SUB
         END IF

         CLS
         LOCATE 2, 25
         PRINT "Energy Surveillance Measures"
         PRINT
         PRINT , "Bearing", "Side", "Sensor"
         PRINT

         FOR i = 1 TO totshipnum%
  
            IF i <> shipNum% AND ship(i).shiptype <> 254 THEN
     
               dist = distance%(shipNum%, i)
     
               IF dist < 90 AND status%(i, lrsensor) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  d% = direction%(shipNum%, i) - 2 + INTRND(5)
                  IF d% < 0 THEN d% = 0
                  IF d% > 360 THEN d% = 360
                  PRINT , PAD$(d%, 3),
                  PRINT ship(i).sidename,
                  PRINT "Long Range Sensor"
               END IF
           
               IF dist < 60 AND status%(i, srsensor) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  d% = direction%(shipNum%, i) - 2 + INTRND(5)
                  IF d% < 0 THEN d% = 0
                  IF d% > 360 THEN d% = 360
                  PRINT , PAD$(d%, 3),
                  PRINT ship(i).sidename,
                  PRINT "Short Range Sensor"
               END IF
     
               IF dist < 30 AND status%(i, scanner) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  d% = direction%(shipNum%, i) - 2 + INTRND(5)
                  IF d% < 0 THEN d% = 0
                  IF d% > 360 THEN d% = 360
                  PRINT , PAD$(d%, 3),
                  PRINT ship(i).sidename,
                  PRINT "Scanner"
               END IF
     
               IF ship(i).target1 = shipNum% AND status%(i, director1) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  PRINT , PAD$(direction%(shipNum%, i), 3),
                  PRINT ship(i).sidename,
                  PRINT "Director"
               END IF
     
               IF ship(i).target2 = shipNum% AND status%(i, director2) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  PRINT , PAD$(direction%(shipNum%, i), 3),
                  PRINT ship(i).sidename,
                  PRINT "Director"
               END IF
     
               IF ship(i).target3 = shipNum% AND status%(i, director3) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  PRINT , PAD$(direction%(shipNum%, i), 3),
                  PRINT ship(i).sidename,
                  PRINT "Director"
               END IF
     
               IF ship(i).target4 = shipNum% AND status%(i, director4) = 4 THEN
                  IF CURSORLINE% = 1 THEN
                     LOCATE 2, 25
                     PRINT "Energy Surveillance Measures"
                     PRINT
                     PRINT , "Bearing", "Side", "Sensor"
                     PRINT
                  END IF
                  PRINT , PAD$(direction%(shipNum%, i), 3),
                  PRINT ship(i).sidename,
                  PRINT "Director"
               END IF
        
            END IF

         NEXT i

         PAUSE
         CLS

      ELSEIF a% >= phaser1 AND a% <= phaser4 THEN

         LOCATE 20, 2
         PRINT SPACE$(75)
         LOCATE 20, 2

         IF control%(shipNum%, a%) = 4 THEN
            PRINT " Weapons Officer reports: '"; DEVICE$(a%); " already fired, sir!'"

         ELSE
            control%(shipNum%, a%) = 4
            CALL PhaserSound

         END IF
  
      ELSEIF a% = computer THEN

         flag% = 1
         DO
                 
            CLS
            LOCATE 2, 33
            PRINT "Library Computer"
            PRINT
            IF flag% = 1 THEN CALL ElectronicSounds
            flag% = 0
            PRINT " Active and awaiting command..."
            m1.row = 7
            m1.col = 30
            m1.returnCode = 0

            REDIM m1Text$(1 TO 4)

            m1Text$(1) = "Dir/Dist Calculator"
            m1Text$(2) = "Location Calculator"
            m1Text$(3) = "Torpedo  Calculator"
            m1Text$(4) = "Quit"

            CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
                
            COLOR white, blue, lightblue
     
            selection% = m1.returnCode
            IF selection% = 0 THEN selection% = 4

            IF selection% = 1 THEN
       
               CLS
               PRINT
               PRINT " Direction/Distance Calculator"
               PRINT
               PRINT " "; TRIM$(ship(shipNum%).shipname); " is at Quadrant ";
               PRINT CINT(ship(shipNum%).xquad); ",";
               PRINT CINT(ship(shipNum%).yquad); " Sector ";
               PRINT CINT(ship(shipNum%).xsect); ",";
               PRINT CINT(ship(shipNum%).ysect); "."
               PRINT
               INPUT "   Input Initial Quadrant (A,B) "; a1, b1
               INPUT "   Input Initial Sector (X,Y) "; x1, y1
               PRINT
               INPUT "   Input  Final  Quadrant (A,B) "; a2, b2
               INPUT "   Input  Final  Sector (X,Y) "; x2, y2
               CALL DirDist(a1, b1, x1, y1, a2, b2, x2, y2, dir, dist)
               PRINT
               PRINT " Science Officer reports:"
               PRINT "    'Getting a read out now, Captain.'"
               PRINT
               PRINT " Direction = "; PAD$(CINT(dir), 3)
               PRINT " Distance  ="; CINT(dist)
               PAUSE
         
            ELSEIF selection% = 2 THEN
       
               CLS
               PRINT
               PRINT " Location Calculator"
               PRINT
               PRINT " "; TRIM$(ship(shipNum%).shipname); " is at Quadrant ";
               PRINT CINT(ship(shipNum%).xquad); ",";
               PRINT CINT(ship(shipNum%).yquad); " Sector ";
               PRINT CINT(ship(shipNum%).xsect); ",";
               PRINT CINT(ship(shipNum%).ysect); "."
               PRINT
               INPUT "   Input Initial Quadrant (A,B) "; a1, b1
               INPUT "   Input Initial Sector (X,Y) "; x1, y1
               PRINT
               INPUT "   Course (000-360) "; cse
               INPUT "   Velocity (0-10)  "; vel
               CALL CseSpd(a1, b1, x1, y1, cse, vel, a2, b2, x2, y2)
               PRINT
               PRINT " Science Officer reports:"
               PRINT "    'Getting a read out now, Captain.'"
               PRINT
               PRINT " Quadrant "; a2; ","; b2
               PRINT " Sector "; x2; ","; y2
               PAUSE

            ELSEIF selection% = 3 THEN
           
               CLS
               PRINT
               PRINT "   Torpedo Course Calculator"
               PRINT
               PRINT " Science Officer reports:"
              
               dirTot% = DEVICENUM%(shipNum%, director1, director4)
               IF dirTot% < 1 THEN
                  PRINT "   'This function is not availiable, sir.'"
              
               ELSE
                  PRINT "    'Getting a read out now, Captain.'"
                  PRINT
                 
                  CALL OwnPosit(shipNum%, a3, b3, x3, y3)
                 
                  PRINT " "; TRIM$(ship(shipNum%).shipname); " projected ";
                  PRINT "location:   Quadrant "; a3; ","; b3;
                  PRINT "  Sector "; x3; ","; y3
                  PRINT
                  LOCATE CSRLIN, 42
                  PRINT "Projected Projected  Torpedo"
                  PRINT "  Director", "        Target",
                  PRINT "Quadrant  Sector    Course   Distance"
                 
                  IF status%(shipNum%, director1) > -1 THEN
                     b% = ship(shipNum%).target1
                     PRINT
                     PRINT " Director #1",
                     CALL TorpCalc2(shipNum%, b%)
                  END IF
                
                  IF status%(shipNum%, director2) > -1 THEN
                     b% = ship(shipNum%).target2
                     PRINT
                     PRINT " Director #2",
                     CALL TorpCalc2(shipNum%, b%)
                  END IF
                
                  IF status%(shipNum%, director3) > -1 THEN
                     b% = ship(shipNum%).target3
                     PRINT
                     PRINT " Director #3",
                     CALL TorpCalc2(shipNum%, b%)
                  END IF
                
                  IF status%(shipNum%, director4) > -1 THEN
                     b% = ship(shipNum%).target4
                     PRINT
                     PRINT " Director #4",
                     CALL TorpCalc2(shipNum%, b%)
                  END IF

               END IF
               PAUSE

            END IF

         LOOP WHILE selection% <> 4

      ELSEIF a% >= torp1 AND a% <= torp4 THEN

         LOCATE 20, 2
         PRINT SPACE$(75)
         LOCATE 20, 2

         IF ship(shipNum%).torptot = 0 THEN
            PRINT "Weapons Officer reports: 'No torpedoes left, sir!'"
         ELSEIF control%(shipNum%, a%) = 4 THEN
            PRINT "Weapons Officer reports: 'Torpedo already fired, sir.'"
         ELSE
            INPUT "Weapons Officer asks: 'Torpedo Course, sir (001-360)'"; b%
            LOCATE 20, 2
            PRINT SPACE$(75)
            IF b% > 0 AND b% <= 360 THEN
               control%(shipNum%, a%) = 4
               ship(shipNum%).torptot = ship(shipNum%).torptot - 1
               CALL TorpedoSound
            ELSE
               LOCATE 20, 2
               PRINT " Weapons Officer reports: 'Invalid course, sir.'"
            END IF
         END IF

      END IF

   END IF

END SUB

SUB DeviceStatus (shipNum%, a%, b%)

   SHARED ship() AS ships
   SHARED control%()

   IF control%(shipNum%, a%) = 0 THEN
      PRINT "Destroyed."

   ELSEIF control%(shipNum%, a%) = 1 THEN
      PRINT "Damaged."

   ELSEIF control%(shipNum%, a%) = 2 THEN
   
      IF a% <= thruster2 THEN
         PRINT "Not Online."
   
      ELSEIF a% >= shield1 THEN
         PRINT "Not Energized."

      END IF

   ELSEIF control%(shipNum%, a%) = 3 THEN

      PRINT "Warming Up"

   ELSE
  
      IF a% <= switchboard THEN
         PRINT "Online.    "

      ELSEIF a% >= shield1 AND a% <= shield4 THEN
         PRINT TRIM$(STR$(b%)); " units.        "

      ELSEIF a% >= scanner AND a% <= lrsensor THEN
         PRINT "Energized.    "

      ELSEIF a% >= director1 AND a% <= director4 THEN

         IF b% < 0 THEN
            PRINT "Energized.    "

         ELSEIF b% = 0 THEN
            PRINT "No Target Designated."

         ELSEIF b% = 254 THEN
            PRINT "Debris"

         ELSEIF b% = 255 THEN
            PRINT "Star."

         ELSE
            PRINT TRIM$(ship(b%).sidename); " ";
            PRINT TRIM$(ship(b%).objname);
            PRINT " at quadrant ";
            PRINT TRIM$(STR$(ship(b%).xquad)); ",";
            PRINT TRIM$(STR$(ship(b%).yquad)); ", ";
            PRINT "sector ";
            PRINT TRIM$(STR$(CINT(ship(b%).xsect))); ",";
            PRINT TRIM$(STR$(CINT(ship(b%).ysect))); "."

         END IF

      ELSEIF a% = esmdev THEN
         PRINT "Energized.    "
   
      ELSEIF a% >= phaser1 AND a% <= phaser4 THEN
      
         PRINT "Fired.        "

      ELSEIF a% >= torp1 AND a% <= torp4 THEN
        
         PRINT "Fired "; TRIM$(PAD$(b%, 3)); "."

      END IF

   END IF

END SUB

SUB GetMoves (shipNum%)
  
   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
        
   CLS
   IF ship(shipNum%).shiptype = 254 THEN
      tempPath$ = ENVIRON$("TMP")
      fileName$ = tempPath$ + TRIM$(STR$(shipNum%)) + ".TMP"
      OPEN fileName$ FOR APPEND AS #1
      CLOSE #1
      flag2% = 0
      OPEN fileName$ FOR INPUT AS #1
         DO WHILE NOT EOF(1)
            IF CSRLIN = 23 THEN
               PAUSE
               CLS
            END IF
            LINE INPUT #1, lineBuffer$
            PRINT lineBuffer$
            flag2% = 1
         LOOP
      CLOSE #1
      IF flag2% = 0 THEN
         LOCATE 2, 2
         PRINT "This vessal has been destroyed."
      END IF
      PAUSE
      EXIT SUB
   ELSEIF ship(shipNum%).player = 0 AND debug% = 0 THEN
      LOCATE 2, 2
      PRINT "This ship has no life onboard."
      PAUSE
      EXIT SUB
   END IF
  
   flag% = 0
   selection% = 0
   DO
  
      CLS
      PRINT
      a$ = TRIM$(ship(shipNum%).sidename)
      a$ = a$ + " " + TRIM$(ship(shipNum%).objname)
      a$ = a$ + " " + TRIM$(ship(shipNum%).shipname)
      LOCATE 2, 40 - (LEN(a$) / 2)
      PRINT a$
      PRINT
      PRINT
      PRINT "   Stardate:    "; stardate%
      PRINT "   Condition:    ";
      IF ship(shipNum%).dock <> 0 AND ship(shipNum%).dock <> 1000 THEN
         PRINT "DOCKED"
      ELSEIF ship(shipNum%).condition = 0 THEN
         COLOR green, lightblue
         PRINT "GREEN"
      ELSEIF ship(shipNum%).condition = 1 THEN
         COLOR yellow, lightblue
         PRINT "YELLOW"
      ELSEIF ship(shipNum%).condition = 2 THEN
         COLOR red, lightblue
         PRINT "RED"
         IF flag% = 0 THEN flag% = 1
      ELSE
         IF debug% = 1 THEN STOP
      END IF
      COLOR white, lightblue
      PRINT "   Quadrant:     ";
      PRINT TRIM$(STR$(ship(shipNum%).xquad)); ",";
      PRINT TRIM$(STR$(ship(shipNum%).yquad))
      PRINT "   Sector:       ";
      PRINT TRIM$(STR$(CINT(ship(shipNum%).xsect))); ",";
      PRINT TRIM$(STR$(CINT(ship(shipNum%).ysect)))
      PRINT "   Course:       "; PAD$(ship(shipNum%).course, 3)
      PRINT "   Heading:      "; PAD$(ship(shipNum%).heading, 3)
      PRINT "   Velocity:    "; ship(shipNum%).velocity
      PRINT "   Ordered:     "; ship(shipNum%).ordspd
      PRINT "   Life Support:"; ship(shipNum%).lstimer
      PRINT "   Fuel:        "; ship(shipNum%).fuel
      PRINT "   Energy:      "; ship(shipNum%).energy
      PRINT "   Torpedoes:   "; ship(shipNum%).torptot
      IF status%(shipNum%, shield1) > -1 THEN
         PRINT "   Shield #1:    ";
         CALL DeviceStatus(shipNum%, shield1, ship(shipNum%).shield1)
      END IF
      IF status%(shipNum%, shield2) > -1 THEN
         PRINT "   Shield #2:    ";
         CALL DeviceStatus(shipNum%, shield2, ship(shipNum%).shield2)
      END IF
      IF status%(shipNum%, shield3) > -1 THEN
         PRINT "   Shield #3:    ";
         CALL DeviceStatus(shipNum%, shield3, ship(shipNum%).shield3)
      END IF
      IF status%(shipNum%, shield4) > -1 THEN
         PRINT "   Shield #4:    ";
         CALL DeviceStatus(shipNum%, shield4, ship(shipNum%).shield4)
      END IF
      PRINT "   Damage:      "; DAMAGECALC%(shipNum%); "%"
      PRINT "   Points:      "; ship(shipNum%).score
      IF flag% = 1 THEN
         CALL WhoopSiren
         flag% = 2
      END IF

      m1.row = 8
      m1.col = 48
      m1Title$ = "Command"
      m1.returnCode = selectSave%
      REDIM m1Text$(1 TO 10)
      m1Text$(1) = "Cargo Hold"
      m1Text$(2) = "Damage Control"
      m1Text$(3) = "Library Computer"
      m1Text$(4) = "Main Control"
      m1Text$(5) = "Messages"
      m1Text$(6) = "Navigation"
      m1Text$(7) = "Sensor Control"
      m1Text$(8) = "Shield Control"
      m1Text$(9) = "Weapons Control"
      m1Text$(10) = "Quit"
       
      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, blue, lightblue
      
      selection% = m1.returnCode
      IF selection% = 0 OR selection% = 10 THEN EXIT DO
      selectSave% = m1.returnCode

      SELECT CASE selection%

         CASE 1

            CLS
            LOCATE 2, 35
            PRINT "Cargo Hold"
      
            LOCATE 4, 2
            PRINT "Total Cargo Onboard:"
            PRINT
            PRINT "       Fuel: "; ship(shipNum%).fuel
            PRINT "     Energy: "; ship(shipNum%).energy
            PRINT "  Torpedoes: "; ship(shipNum%).torptot

            IF ship(shipNum%).dock <> 0 THEN
               
               LOCATE 16, 2
               PRINT "Will you give order to commence cargo transfer,";
               PRINT " sir? (Y/N)";
               DO
                  a$ = INKEY$
               LOOP WHILE a$ <> "Y" AND a$ <> "N"
               LOCATE 16, 2
               PRINT SPACE$(75)
              
               IF a$ = "Y" THEN
                 
                  dockship% = ABS(ship(shipNum%).dock)
                   
                  DO
                     LOCATE 16, 2
                     PRINT "Amount of fuel to be transfered";
                     INPUT f
                  LOOP WHILE f < 0 OR f > ship(shipNum%).fuel
                  IF ship(dockship%).fuel + f > ship(dockship%).maxfuel THEN
                     f = ship(dockship%).maxfuel - ship(dockship%).fuel
                  END IF
                  ship(shipNum%).fuel = ship(shipNum%).fuel - f
                  ship(dockship%).fuel = ship(dockship%).fuel + f
                  LOCATE 6, 14
                  PRINT SPACE$(20)
                  LOCATE 6, 14
                  PRINT ship(shipNum%).fuel
                 
                  DO
                     LOCATE 17, 2
                     PRINT "Amount of energy to be transfered";
                     INPUT e
                  LOOP WHILE e < 0 OR e > ship(shipNum%).energy
                  IF ship(dockship%).energy + e > ship(dockship%).maxenergy THEN
                     e = ship(dockship%).maxenergy - ship(dockship%).energy
                  END IF
                  ship(shipNum%).energy = ship(shipNum%).energy - e
                  ship(dockship%).energy = ship(dockship%).energy + e
                  LOCATE 7, 14
                  PRINT SPACE$(20)
                  LOCATE 7, 14
                  PRINT ship(shipNum%).energy
                
                  DO
                     LOCATE 18, 2
                     PRINT "Amount of torpedoes to be transfered";
                     INPUT t
                  LOOP WHILE t < 0 OR t > ship(shipNum%).torptot
                  IF ship(dockship%).torptot + t > ship(dockship%).maxtorp THEN
                     t = ship(dockship%).maxtorp - ship(dockship%).torptot
                  END IF
                  ship(shipNum%).torptot = ship(shipNum%).torptot - t
                  ship(dockship%).torptot = ship(dockship%).torptot + t
                  LOCATE 8, 14
                  PRINT SPACE$(20)
                  LOCATE 8, 14
                  PRINT ship(shipNum%).torptot
               
               END IF

            END IF
            
            PAUSE
              
         CASE 2

            CLS
           
            IF status%(shipNum%, dccentral) < 2 THEN
               LOCATE 2, 2
               PRINT "Damage Control report not available."
               PAUSE
            ELSE
               LOCATE 2, 25
               PRINT "Damage Control Central"
               PRINT
               PRINT " DEVICE", , "DAMAGE"
               PRINT
           
               FOR i = 1 TO controltot
                  IF control%(shipNum%, i) > -1 THEN
                     IF CURSORLINE% = 1 THEN
                        LOCATE 2, 25
                        PRINT "Damage Control Central"
                        PRINT
                        PRINT " DEVICE", , "DAMAGE"
                        PRINT
                     END IF
                     PRINT " "; DEVICE$(i); ,
                     IF POS(0) < 24 THEN PRINT , ;
                     d% = damge%(shipNum%, i)
                     IF d% < 10 THEN
                        PRINT "  "; d%; "%"
                     ELSEIF d% < 100 THEN
                        PRINT " "; d%; "%"
                     ELSE
                        PRINT d%; "%"
                     END IF
                  END IF
               NEXT i
               PAUSE

            END IF

         CASE 3

            CALL DeviceOp(shipNum%, computer, 0)
           
         CASE 4
             
            CALL SelectEngineering(shipNum%)

         CASE 5

            CLS
            tempPath$ = ENVIRON$("TMP")
            fileName$ = tempPath$ + TRIM$(STR$(shipNum%)) + ".TMP"
            OPEN fileName$ FOR APPEND AS #1
            CLOSE #1
 
            flag2% = 0
            OPEN fileName$ FOR INPUT AS #1
               DO WHILE NOT EOF(1)
                  IF CSRLIN = 23 THEN
                     PAUSE
                     CLS
                  END IF
                  LINE INPUT #1, lineBuffer$
                  PRINT lineBuffer$
                  flag2% = 1
               LOOP
            CLOSE #1
            IF flag2% = 0 THEN
               LOCATE 2, 2
               PRINT "No messages."
            END IF
            PAUSE

         CASE 6

            temp% = 0
            DO
                
               CLS
               LOCATE 2, 35
               PRINT "Navigation"

               REDIM m1Text$(1 TO 3)
              
               m1Text$(1) = "Manuever"
               m1Text$(2) = "Dock"
               m1Text$(3) = "Quit"
             
               m1.row = 7
               m1.col = 35
               m1.returnCode = temp%

               CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
               COLOR white, blue, lightblue
    
               selection% = m1.returnCode
               temp% = m1.returnCode

               IF selection% = 1 THEN

                  CLS
                  CALL DrawBox(1, 1, 23, 65)
                  LOCATE 1, 32 - (LEN(DEVICE$(scanner)) / 2)
                  PRINT DEVICE$(scanner)

                  IF control%(shipNum%, scanner) < 2 THEN
                     LOCATE 11, 20
                     PRINT DEVICE$(scanner); " not operable."
                  ELSE
                     CALL CreateScreen(shipNum%)
                  END IF

                  LOCATE 4, 67
                  PRINT "Quadrant"
                  LOCATE 5, 67
                  PRINT CINT(ship(shipNum%).xquad); ",";
                  PRINT CINT(ship(shipNum%).yquad)
                 
                  LOCATE 7, 67
                  PRINT "Sector"
                  LOCATE 8, 67
                  PRINT CINT(ship(shipNum%).xsect); ",";
                  PRINT CINT(ship(shipNum%).ysect)
                 
                  LOCATE 10, 67
                  PRINT "Course"
                  LOCATE 11, 69
                  PRINT PAD$(CINT(ship(shipNum%).course), 3)

                  LOCATE 13, 67
                  PRINT "Heading"
                  LOCATE 14, 69
                  PRINT PAD$(CINT(ship(shipNum%).heading), 3)
         
                  LOCATE 16, 67
                  PRINT "Velocity"
                  LOCATE 17, 69
                  PRINT ship(shipNum%).velocity

                  LOCATE 19, 67
                  PRINT "Ordered"
                  LOCATE 20, 69
                  PRINT ship(shipNum%).ordspd
                 
                  DO
                     LOCATE 14, 69
                     COLOR black, white
                     c1$ = PAD$(CINT(ship(shipNum%).heading), 3)
                     CALL FieldEditor(c1$, 1)
                     LOCATE 14, 67
                     COLOR white, blue
                     PRINT SPACE$(10)
                     IF c1$ = "" THEN
                        c1% = ship(shipNum%).heading
                     ELSE
                        c1% = VAL(c1$)
                     END IF
                     IF debug% = 1 AND c1% = 777 THEN STOP
                     IF debug% = 1 AND c1% = 999 THEN
                        ship(shipNum%).fuel = ship(shipNum%).maxfuel
                        ship(shipNum%).energy = ship(shipNum%).maxenergy
                        ship(shipNum%).torptot = ship(shipNum%).maxtorp
                        ship(shipNum%).lstimer = 10
                        FOR i = 1 TO controltot
                           damge%(shipNum%, i) = 0
                           IF status%(shipNum%, i) > -1 THEN
                              IF status%(shipNum%, i) < 2 THEN
                                 status%(shipNum%, i) = 2
                              END IF
                           END IF
                           IF control%(shipNum%, i) > -1 THEN
                              IF control%(shipNum%, i) < 2 THEN
                                 control%(shipNum%, i) = 2
                              END IF
                           END IF
                        NEXT i
                     END IF
                  LOOP WHILE c1% < 0 OR c1% > 360
           
                  IF c1% = 0 THEN c1% = 360
                  ship(shipNum%).heading = c1%
                  LOCATE 14, 69
                  PRINT PAD$(c1%, 3)

                  IF ship(shipNum%).maxvelocity > 0 THEN
                     DO
                        LOCATE 20, 69
                        IF ship(shipNum%).ordspd > 9 THEN LOCATE 20, 70
                        COLOR black, white
                        w$ = PAD$(ship(shipNum%).ordspd, 2)
                        CALL FieldEditor(w$, 1)
                        LOCATE 20, 68
                        COLOR white, blue
                        PRINT SPACE$(10)
                        IF w$ = "" THEN
                           w! = ship(shipNum%).ordspd
                        ELSE
                           w! = VAL(w$)
                        END IF
                        IF w! = 99 THEN
                           IF debug% = 1 THEN
                              debug% = 0
                           ELSE
                              debug% = 1
                           END IF
                        END IF
                     LOOP WHILE w! < 0 OR w! > ship(shipNum%).maxvelocity
                     ship(shipNum%).ordspd = w!
                     LOCATE 20, 69
                     PRINT w!
                     DELAY (1)
                  END IF

               END IF

               IF selection% = 2 THEN
                  CALL DeviceOp(shipNum%, shipdock, 0)
               END IF

            LOOP WHILE selection% <> 3
          
         CASE 7

            CALL SelectSensor(shipNum%)

         CASE 8

            CALL SelectShield(shipNum%)

         CASE 9

            CALL SelectWeapons(shipNum%)


         CASE ELSE

      END SELECT

   LOOP

END SUB

SUB Locator (shipNum%, a%, b%)
   
   SHARED control%()
   SHARED location$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships

   CLS
   CALL DrawBox(1, 1, 23, 65)
   LOCATE 1, 32 - (LEN(DEVICE$(a%)) / 2)
   PRINT DEVICE$(a%)
  
   CALL CreateScreen(shipNum%)

   q1% = ship(shipNum%).xquad
   q2% = ship(shipNum%).yquad
   s1% = CINT(ship(shipNum%).xsect)
   s2% = CINT(ship(shipNum%).ysect)

   LOCATE 6, 67
   PRINT "Quadrant"
     
   LOCATE 9, 67
   PRINT "Sector"
    
   LOCATE 12, 67
   PRINT "Origin"
     
   LOCATE 15, 67
   PRINT "Type"
     
   row% = 12
   col% = 32

   i = ship(shipNum%).xsect + 10
   j = ship(shipNum%).ysect + 10

   DO

      LOCATE 7, 67
      PRINT q1%; ","; q2%

      LOCATE 10, 67
      PRINT s1%; ","; s2%

      LOCATE 13, 67
      PRINT "              "
      LOCATE 13, 67
      IF q%(i, j) > 0 AND q%(i, j) < 250 THEN
         PRINT ship(q%(i, j)).sidename
      END IF

      LOCATE 16, 67
      PRINT "              "
      LOCATE 16, 67
      IF q%(i, j) = 254 THEN
         PRINT "Debris"
      ELSEIF q%(i, j) = 255 THEN
         PRINT "Star"
      ELSEIF q%(i, j) > 0 THEN
         PRINT ship(q%(i, j)).objname
      END IF

      COLOR black, brightwhite
      LOCATE row%, col%

      IF q%(i, j) = 0 THEN
         PRINT "   "
      ELSEIF q%(i, j) = 254 THEN
         PRINT " ° "
      ELSEIF q%(i, j) = 255 THEN
         PRINT " * "
      ELSE
         PRINT ship(q%(i, j)).image
      END IF
   
      flag% = 0
      horizmics% = 0
      vertmics% = 0

      DO
      
         keyval$ = INKEY$
         MouseNow leftButton%, rightButton%, xMouse%, yMouse%
         MouseMickey horizontal%, vertical%
   
         horizmics% = horizmics% + horizontal%
         vertmics% = vertmics% + vertical%

         IF keyval$ <> "" THEN flag% = 1

         IF horizmics% > 17 THEN flag% = 2
         IF horizmics% < -17 THEN flag% = 3
         IF vertmics% > 51 THEN flag% = 4
         IF vertmics% < -51 THEN flag% = 5
      
         IF leftButton% THEN flag% = 6

      LOOP WHILE flag% = 0

      COLOR brightwhite, black
      LOCATE row%, col%

      IF q%(i, j) = 0 THEN
         PRINT "   "
      ELSEIF q%(i, j) = 254 THEN
         PRINT " ° "
      ELSEIF q%(i, j) = 255 THEN
         PRINT " * "
      ELSE
         PRINT ship(q%(i, j)).image
      END IF

      COLOR brightwhite, lightblue
  
      IF (keyval$ = CHR$(0) + CHR$(up) OR flag% = 5) AND row% > 2 THEN
         row% = row% - 1
         i = i - 1
         s1% = s1% - 1
         IF s1% = 0 THEN
            q1% = q1% - 1
            s1% = sectsize%
         END IF

      ELSEIF (keyval$ = CHR$(0) + CHR$(down) OR flag% = 4) AND row% < 22 THEN
         row% = row% + 1
         i = i + 1
         s1% = s1% + 1
         IF s1% > sectsize% THEN
            q1% = q1% + 1
            s1% = 1
         END IF

      ELSEIF (keyval$ = CHR$(0) + CHR$(left) OR flag% = 3) AND col% > 2 THEN
         col% = col% - 3
         j = j - 1
         s2% = s2% - 1
         IF s2% = 0 THEN
            q2% = q2% - 1
            s2% = sectsize%
         END IF
   
      ELSEIF (keyval$ = CHR$(0) + CHR$(right) OR flag% = 2) AND col% < 62 THEN
         col% = col% + 3
         j = j + 1
         s2% = s2% + 1
         IF s2% > sectsize% THEN
            q2% = q2% + 1
            s2% = 1
         END IF

      ELSEIF keyval$ = CHR$(ENTER) OR flag% = 6 THEN

         DO
            MouseNow leftButton%, rightButton%, xMouse%, yMouse%
         LOOP WHILE leftButton%
  
         CALL ScannerSound
         EXIT DO

      END IF
       
   LOOP

   b% = 0
   IF q1% > 0 AND q1% <= quadsize% AND q2% > 0 AND q2% <= quadsize% THEN

      a$ = location$(q1%, q2%)
      FOR i = 1 TO LEN(a$) / 2
         temp$ = MID$(a$, i * 2 - 1, 2)
         CALL SectorDecode(temp$, objtype%, xsect%, ysect%)
         IF xsect% = s1% AND ysect% = s2% THEN
            b% = objtype%
            EXIT FOR
         END IF
      NEXT i

   END IF
   IF b% <> 0 THEN control%(shipNum%, a%) = 4
   CLS

END SUB

REM $STATIC
SUB SelectEngineering (shipNum%)
 
   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
       
   flag% = 0

   DO

   CLS
   LOCATE 2, 35
   PRINT "Engineering"
   PRINT
   PRINT " Fuel State = "; ship(shipNum%).fuel,
   PRINT " Energy State = "; ship(shipNum%).energy,
   PRINT " Life Support = "; ship(shipNum%).lstimer
   PRINT
  
   x% = DEVICENUM(shipNum%, generator1, switchboard)

   IF x% = 0 THEN
      PRINT " Executive Officer reports:"
      PRINT "    'Sir, this ship does not have any engineering equipment.'"
      PAUSE
      EXIT SUB
   END IF

   IF flag% = 0 THEN CALL MachinerySound
   flag% = 1

   REDIM dnum%(x%)
   temp = 1
   FOR i = generator1 TO switchboard
      IF control%(shipNum%, i) > -1 THEN
         dnum%(temp) = i
         temp = temp + 1
      END IF
   NEXT i

   REDIM m1Text$(1 TO x% + 1)
   i = 1
   FOR j = generator1 TO switchboard
      IF control%(shipNum%, j) > -1 THEN
         m1Text$(i) = DEVICE$(j)
         i = i + 1
      END IF
   NEXT j
          
      row% = 7
      FOR i = generator1 TO switchboard
         IF control%(shipNum%, i) > -1 THEN
            LOCATE row%, 30
            PRINT SPACE$(49)
            LOCATE row%, 30
            CALL DeviceStatus(shipNum%, i, 0)
            row% = row% + 1
         END IF
      NEXT i
             
      m1Text$(x% + 1) = "Quit"
      m1Title$ = "Engineering"
      m1.returnCode = 0
  
      m1.row = 6
      m1.col = 5
      row% = m1.row + 1

      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      m1.edgeline = -1
      COLOR white, blue, lightblue
    
      selection% = m1.returnCode
      IF selection% = 0 THEN selection% = x% + 1
      temp% = m1.returnCode
     
      IF selection% <> x% + 1 THEN
         i = dnum%(selection%)
         CALL DeviceOp(shipNum%, i, 0)
         row% = m1.row + m1.returnCode
         IF control%(shipNum%, i) > -1 THEN
            LOCATE row%, 30
            PRINT SPACE$(49)
            LOCATE row%, 30
            CALL DeviceStatus(shipNum%, i, 0)
         END IF
      END IF
      m1.returnCode = temp%

   LOOP WHILE selection% <> x% + 1
   m1.edgeline = 3

END SUB

SUB SelectSensor (shipNum%)

   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
      

   x% = DEVICENUM(shipNum%, scanner, esmdev)

   IF x% = 0 THEN
      PRINT
      PRINT " Executive Officer reports:"
      PRINT "    'Sir, this class of vessal has no sensors.'"
      PAUSE
      EXIT SUB
   END IF

   REDIM dnum%(x%)
   temp = 1
   FOR i = scanner TO esmdev
      IF control%(shipNum%, i) > -1 THEN
         dnum%(temp) = i
         temp = temp + 1
      END IF
   NEXT i

   REDIM m1Text$(1 TO x% + 1)
   i = 1
   FOR j = scanner TO esmdev
      IF control%(shipNum%, j) > -1 THEN
         m1Text$(i) = DEVICE$(j)
         i = i + 1
      END IF
   NEXT j
   m1Text$(x% + 1) = "Quit"
        
   temp% = 0
   DO
           
      m1.row = 5
      m1.col = 1
      m1Title$ = "Sensors"
      m1.returnCode = temp%
             
      CLS
      LOCATE 2, 30
      PRINT "Sensor Control"

      row% = 6
      FOR i = scanner TO esmdev
         IF control%(shipNum%, i) > -1 THEN
            LOCATE row%, 25
            PRINT SPACE$(54)
            LOCATE row%, 25
            j = 0
            IF i = director1 THEN
               j = ship(shipNum%).target1
            ELSEIF i = director2 THEN
               j = ship(shipNum%).target2
            ELSEIF i = director3 THEN
               j = ship(shipNum%).target3
            ELSEIF i = director4 THEN
               j = ship(shipNum%).target4
            END IF
            CALL DeviceStatus(shipNum%, i, j)
            row% = row% + 1
         END IF
      NEXT i

      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, blue, lightblue
   
      selection% = m1.returnCode
      IF selection% = 0 THEN selection% = x% + 1
      temp% = m1.returnCode

      IF selection% <> x% + 1 THEN
         IF dnum%(selection%) = director1 THEN
            CALL DeviceOp(shipNum%, director1, ship(shipNum%).target1)
         ELSEIF dnum%(selection%) = director2 THEN
            CALL DeviceOp(shipNum%, director2, ship(shipNum%).target2)
         ELSEIF dnum%(selection%) = director3 THEN
            CALL DeviceOp(shipNum%, director3, ship(shipNum%).target3)
         ELSEIF dnum%(selection%) = director4 THEN
            CALL DeviceOp(shipNum%, director4, ship(shipNum%).target4)
         ELSE
            CALL DeviceOp(shipNum%, dnum%(selection%), 0)
'            temp = 1
'            FOR i = scanner TO esmdev
'               IF control%(shipNum%, i) > -1 THEN
'                  dnum%(temp) = i
'                  temp = temp + 1
'               END IF
'            NEXT i
         END IF
         COLOR white, blue, lightblue
      END IF

   LOOP WHILE selection% <> x% + 1

END SUB

SUB SelectShield (shipNum%)

   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
      
   CLS
   LOCATE 2, 30
   PRINT "Shield Control"

   x% = DEVICENUM(shipNum%, shield1, shield4)

   IF x% = 0 THEN
      PRINT
      PRINT " Executive Officer reports:"
      PRINT "    'Sir, this class of vessal has no shield.'"
      PAUSE
      EXIT SUB
   END IF

   REDIM dnum%(x%)
   temp = 1
   FOR i = shield1 TO shield4
      IF control%(shipNum%, i) > -1 THEN
         dnum%(temp) = i
         temp = temp + 1
      END IF
   NEXT i
          
   REDIM m1Text$(1 TO x% + 1)
   i = 1
   FOR j = shield1 TO shield4
      IF control%(shipNum%, j) > -1 THEN
         m1Text$(i) = DEVICE$(j)
         i = i + 1
      END IF
   NEXT j
   m1Text$(x% + 1) = "Quit"
          
   m1.row = 7
   m1.col = 5
   m1Title$ = "Shields"
   m1.returnCode = 0
          
   row% = m1.row + 1
   FOR i = shield1 TO shield4
      IF control%(shipNum%, i) > -1 THEN
         LOCATE row%, 30
         PRINT SPACE$(49)
         LOCATE row%, 30
         j = 0
         IF i = shield1 THEN
            j = ship(shipNum%).shield1
         ELSEIF i = shield2 THEN
            j = ship(shipNum%).shield2
         ELSEIF i = shield3 THEN
            j = ship(shipNum%).shield3
         ELSEIF i = shield4 THEN
            j = ship(shipNum%).shield4
         END IF
         CALL DeviceStatus(shipNum%, i, j)
         row% = row% + 1
      END IF
   NEXT i

   temp% = 0
   DO
           
      LOCATE 4, 22
      PRINT SPACE$(8)
      LOCATE 4, 3
      PRINT "Energy Available = "; ship(shipNum%).energy
      PRINT
     
      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, blue, lightblue
  
      selection% = m1.returnCode
      IF selection% = 0 THEN selection% = x% + 1
      temp% = m1.returnCode

      IF selection% <> x% + 1 THEN
         a% = dnum%(selection%)
         IF a% = shield1 THEN
            CALL DeviceOp(shipNum%, shield1, ship(shipNum%).shield1)
         ELSEIF a% = shield2 THEN
            CALL DeviceOp(shipNum%, shield2, ship(shipNum%).shield2)
         ELSEIF a% = shield3 THEN
            CALL DeviceOp(shipNum%, shield3, ship(shipNum%).shield3)
         ELSEIF a% = shield4 THEN
            CALL DeviceOp(shipNum%, shield4, ship(shipNum%).shield4)
         END IF
         row% = m1.row + m1.returnCode
         IF control%(shipNum%, a%) > -1 THEN
            LOCATE row%, 30
            PRINT SPACE$(49)
            LOCATE row%, 30
            j = 0
            IF a% = shield1 THEN
               j = ship(shipNum%).shield1
            ELSEIF a% = shield2 THEN
               j = ship(shipNum%).shield2
            ELSEIF a% = shield3 THEN
               j = ship(shipNum%).shield3
            ELSEIF a% = shield4 THEN
               j = ship(shipNum%).shield4
            END IF
            CALL DeviceStatus(shipNum%, a%, j)
         END IF

      END IF
          
   LOOP WHILE selection% <> x% + 1

END SUB

SUB SelectWeapons (shipNum%)

   SHARED control%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED playerName$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED stardate%
   SHARED status%()
   SHARED totFleetNum%
   SHARED totshipnum%
   SHARED totsidenum%
   SHARED turn%
   SHARED m1 AS MenuType
     
   CLS
   LOCATE 2, 30
   PRINT "Weapons Control"
          
   x% = DEVICENUM(shipNum%, phaser1, torp4)
           
   IF x% = 0 THEN
      LOCATE 4, 1
      PRINT " Executive Officer reports:"
      PRINT "    'No weapons available on this class ship, Captain.'"
      PAUSE
      EXIT SUB
   END IF

   REDIM dnum%(x%)
   temp = 1
   FOR i = phaser1 TO torp4
      IF control%(shipNum%, i) > -1 THEN
         dnum%(temp) = i
         temp = temp + 1
      END IF
   NEXT i

   REDIM m1Text$(1 TO x% + 1)
   i = 1
   FOR j = phaser1 TO torp4
      IF control%(shipNum%, j) > -1 THEN
         m1Text$(i) = DEVICE$(j)
         i = i + 1
      END IF
   NEXT j
   m1Text$(x% + 1) = "Quit"
   m1Title$ = "Weapons"
   m1.row = 7
   m1.col = 5
   m1.returnCode = 0
                 
   row% = m1.row + 1
   FOR i = phaser1 TO torp4
      IF control%(shipNum%, i) > -1 THEN
         LOCATE row%, 30
         PRINT SPACE$(49)
         LOCATE row%, 30
         j = 0
         IF i = torp1 THEN
            j = ship(shipNum%).tcourse1
         ELSEIF i = torp2 THEN
            j = ship(shipNum%).tcourse2
         ELSEIF i = torp3 THEN
            j = ship(shipNum%).tcourse3
         ELSEIF i = torp4 THEN
            j = ship(shipNum%).tcourse4
         END IF
         CALL DeviceStatus(shipNum%, i, j)
         row% = row% + 1
      END IF
   NEXT i

   temp% = 0
   DO
              
      LOCATE 4, 2
      PRINT "Torpedoes = "; ship(shipNum%).torptot
             
      m1.returnCode = temp%
             
      CALL MouseMenu(m1, m1Text$(), m1Title$, m1Prompt$)
      COLOR white, blue, lightblue
 
      IF selection% = 0 THEN selection% = x% + 1
      selection% = m1.returnCode
      temp% = m1.returnCode

      IF selection% <> x% + 1 THEN
         a% = dnum%(selection%)
         IF a% = torp1 THEN
            CALL DeviceOp(shipNum%, torp1, ship(shipNum%).tcourse1)
         ELSEIF a% = torp2 THEN
            CALL DeviceOp(shipNum%, torp2, ship(shipNum%).tcourse2)
         ELSEIF a% = torp3 THEN
            CALL DeviceOp(shipNum%, torp3, ship(shipNum%).tcourse3)
         ELSEIF a% = torp4 THEN
            CALL DeviceOp(shipNum%, torp4, ship(shipNum%).tcourse4)
         ELSE
            CALL DeviceOp(shipNum%, a%, 0)
         END IF
         row% = m1.row + m1.returnCode
         IF control%(shipNum%, a%) > -1 THEN
            LOCATE row%, 30
            PRINT SPACE$(49)
            LOCATE row%, 30
            j = 0
            IF a% = torp1 THEN
               j = ship(shipNum%).tcourse1
            ELSEIF a% = torp2 THEN
               j = ship(shipNum%).tcourse2
            ELSEIF a% = torp3 THEN
               j = ship(shipNum%).tcourse3
            ELSEIF a% = torp4 THEN
               j = ship(shipNum%).tcourse4
            END IF
            CALL DeviceStatus(shipNum%, a%, j)
         END IF
      END IF

   LOOP WHILE selection% <> x% + 1

END SUB

REM $DYNAMIC
FUNCTION SensorDecode$ (x1%, y1%)

   SHARED location$()
   SHARED quadsize%
   SHARED ship() AS ships

   IF x1% < 1 OR x1% > quadsize% OR y1% < 1 OR y1% > quadsize% THEN
   
      SensorDecode$ = "***"

   ELSE
   
      SmallObj% = 0
      MedObj% = 0
      LgObj% = 0
      a% = LEN(location$(x1%, y1%)) / 2
   
      FOR k = 1 TO a%
         temp$ = MID$(location$(x1%, y1%), k * 2 - 1, 2)
         CALL SectorDecode(temp$, objtype%, xsect%, ysect%)
      
         IF objtype% = 255 AND LgObj% < 9 THEN
            LgObj% = LgObj% + 1
     
         ELSE
            IF objtype% <> 254 THEN
               objtype% = ship(objtype%).shiptype
               IF objtype% = station AND MedObj% < 9 THEN
                  MedObj% = MedObj% + 1
               ELSEIF objtype% = deathstar AND MedObj% < 9 THEN
                  MedObj% = MedObj% + 1
               ELSEIF SmallObj% < 9 THEN
                  SmallObj% = SmallObj% + 1
               END IF
            END IF

         END IF
   
      NEXT k

      SensorDecode$ = PAD$(SmallObj% * 100 + MedObj% * 10 + LgObj%, 3)

   END IF

END FUNCTION

REM $STATIC
SUB TorpCalc2 (shipNum%, b%)

   SHARED ship() AS ships
  
   CALL OwnPosit(shipNum%, a3, b3, x3, y3)
                    
   IF b% = 0 THEN
      PRINT "  No target designated."
   ELSEIF b% = 254 THEN
      PRINT "  No solution for debris."
   ELSEIF b% = 255 THEN
      PRINT "  No solution for star."
   ELSE
      PRINT "  "; TRIM$(ship(b%).sidename);
      PRINT " "; TRIM$(ship(b%).objname),
                   
      a1 = ship(b%).xquad
      b1 = ship(b%).yquad
      x1 = ship(b%).xsect
      y1 = ship(b%).ysect
      cse = ship(b%).course
      vel = ship(b%).velocity
      CALL CseSpd(a1, b1, x1, y1, cse, vel, a2, b2, x2, y2)
                
      row% = CSRLIN
      LOCATE row%, 43

      PRINT a2; ","; b2; "   "; x2; ","; y2;
     
      CALL DirDist(a3, b3, x3, y3, a2, b2, x2, y2, dir, dist)

      PRINT "     "; PAD$(CINT(dir), 3); "     "; dist

   END IF

END SUB

