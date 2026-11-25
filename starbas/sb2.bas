'
'   Name:  SB2.BAS
'
'   Type:  Library Module
'
'   Version:  0.10                   Date:  06 February 1990
'
'   Programmer:  Christopher C. Nystrom
'
'   Langauge:    MicroSoft QuickBASIC 4.5
'
'   Function:    Processes a turn for Star Battles.
'

DECLARE SUB AddMsg2 (i%, a$)
DECLARE FUNCTION DisplayName$ (a%, b%)

DECLARE SUB DamageShip (shipNum%, target%, damage%)
DECLARE SUB FirePhaser (attacker%, target%)
DECLARE SUB FireTorp (a%, b%)
DECLARE SUB KillShip (target%)
DECLARE SUB ProcessMoves ()
DECLARE SUB ProcessNavigation ()
DECLARE SUB ProcessDirDist ()
DECLARE SUB ProcessRepair ()
DECLARE SUB ProcessWeapons ()
DECLARE SUB ProcessEngineering ()
DECLARE SUB ProcessCondition ()
DECLARE SUB ProcessCompCont ()

'$INCLUDE: 'STARBAT.INC'

IF debug% = 1 THEN STOP
CALL ProcessMoves
CLS
LOCATE 2, 2
PRINT "Completed Processing Moves."
PRINT
PRINT " Loading Command Processor..."
CHAIN "SB"

REM $DYNAMIC
SUB DamageShip (shipNum%, target%, d%)

   SHARED damge%()
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED message$()
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   shieldTot% = DEVICENUM%(target%, shield1, shield4)
   t$ = ""

   IF target% = shipNum% THEN
      dir = 0
   ELSE
      dir = direction%(target%, shipNum%) - ship(target%).heading
      IF dir > 360 THEN dir = dir - 360
      IF dir < 0 THEN dir = dir + 360
   END IF

   IF shieldTot% = 1 THEN
      shield% = shield1

   ELSEIF shieldTot% = 2 THEN
   
      IF dir > 270 OR dir <= 90 THEN
         shield% = shield1
      ELSE
         shield% = shield2
      END IF

   ELSEIF shieldTot% = 3 THEN

      IF dir > 300 OR dir <= 60 THEN
         shield% = shield1
      ELSEIF dir > 60 AND dir <= 180 THEN
         shield% = shield2
      ELSE
         shield% = shield3
      END IF

   ELSE

      IF dir > 315 OR dir <= 45 THEN
         shield% = shield1
      ELSEIF dir > 45 AND dir <= 135 THEN
         shield% = shield2
      ELSEIF dir > 135 AND dir <= 225 THEN
         shield% = shield3
      ELSE
         shield% = shield4
      END IF

   END IF

   IF status%(target%, shield%) = 4 THEN

      IF shield% = shield1 THEN
         shieldval% = ship(target%).shield1

      ELSEIF shield% = shield2 THEN
         shieldval% = ship(target%).shield2
  
      ELSEIF shield% = shield3 THEN
         shieldval% = ship(target%).shield3

      ELSEIF shield% = shield4 THEN
         shieldval% = ship(target%).shield4
  
      END IF
 
      leftover% = d% - shieldval%
      IF leftover% < 0 THEN leftover% = 0
 
      shieldval% = shieldval% - d%
      IF shieldval% < 0 THEN shieldval% = 0

      IF shieldval% = 0 THEN status%(target%, shield%) = 2

      IF shield% = shield1 THEN
         ship(target%).shield1 = shieldval%

      ELSEIF shield% = shield2 THEN
         ship(target%).shield2 = shieldval%
 
      ELSEIF shield% = shield3 THEN
         ship(target%).shield3 = shieldval%

      ELSEIF shield% = shield4 THEN
         ship(target%).shield4 = shieldval%
 
      END IF

      IF ship(target%).player <> 0 THEN
         t$ = "   'Our " + DEVICE$(shield%) + " absorbs"
         t$ = t$ + STR$(d% - leftover%) + " units of energy.'"
         IF RND > .96 THEN
            t$ = t$ + CHR$(13) + " Medical Officer calls up:" + CHR$(13)
            t$ = t$ + "   'What are y'all doing up there? I didn't need "
            t$ = t$ + "anymore business.'"
         END IF
      END IF

      d% = leftover%

   END IF

   armr% = ship(target%).armor
   d% = d% - ((INTRND(armr%) + INTRND(armr%)) / 2)
   IF d% < 0 THEN d% = 0

   IF ship(shipNum%).side = ship(target%).side THEN
      ship(shipNum%).score = ship(shipNum%).score - d%
   ELSE
      ship(shipNum%).score = ship(shipNum%).score + d%
   END IF

   DO WHILE d% > 0

      counter% = 0
      DO
         targetdevice% = INTRND(controltot)

         IF status%(target%, targetdevice%) > 0 THEN
    
            leftover% = d% - (100 - damge%(target%, targetdevice%))
            IF leftover% < 0 THEN leftover% = 0
        
            b% = damge%(target%, targetdevice%)
            b% = b% + d%
            IF b% > 100 THEN b% = 100
            IF b% = 100 THEN
               status%(target%, targetdevice%) = 0
            ELSE
               status%(target%, targetdevice%) = 1
            END IF
            damge%(target%, targetdevice%) = b%
          
            IF targetdevice% = shipdock THEN
               IF ship(target%).dock > 0 THEN
                  ship(ship(target%).dock).dock = 0
               END IF
               ship(target%).dock = 0
            END IF

            IF ship(target%).player <> 0 THEN
               t$ = t$ + CHR$(13) + " Damage Control Officer reports:"
               t$ = t$ + CHR$(13) + "   '" + DEVICE$(targetdevice%)
               t$ = t$ + " has taken" + STR$(d% - leftover%)
               t$ = t$ + " units of damage.'"
               IF RND > .98 THEN
                  t$ = t$ + CHR$(13) + "    'How will we get by without our "
                  t$ = t$ + DEVICE$(targetdevice%) + ", sir?' asks the"
                  t$ = t$ + " Conning Officer."
               END IF
               IF RND > .98 THEN
                  t$ = t$ + CHR$(13) + " Medical Officer calls up:" + CHR$(13)
                  t$ = t$ + "   'You're going to have to do something Capt"
                  t$ = t$ + "ain! Sickbay is starting to fill up!'"
               END IF
            END IF

            damagEquip% = 0
            equipTot% = 0
            FOR l = 1 TO controltot
               IF status%(target%, l) > -1 THEN
                  equipTot% = equipTot% + 1
                  IF status%(target%, l) < 2 THEN
                     damagEquip% = damagEquip% + 1
                  END IF
               END IF
            NEXT l
            damageTot! = damagEquip% / equipTot%

            IF damageTot! > .5 THEN
               IF ship(target%).player <> 0 THEN
                  t$ = t$ + CHR$(13) + "   " + TRIM$(ship(target%).shipname)
                  t$ = t$ + " has been destroyed."
               END IF
               FOR l = 1 TO totShipNum%
                  IF distance%(target%, l) < 10.5 AND l <> target% THEN
                     IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                        a$ = " Science Officer reports:" + CHR$(13)
                        a$ = a$ + " " + DisplayName$(l, target%) + " has been"
                        a$ = a$ + " destroyed."
                        IF l = shipNum% THEN
                           IF ship(target%).side = ship(shipNum%).side THEN
                              a$ = a$ + CHR$(13) + "   'You know you will be"
                              a$ = a$ + " court martialed for this, sir.'"
                           ELSEIF RND > .94 THEN
                              a$ = a$ + CHR$(13) + "   'Outstanding tactics, "
                              a$ = a$ + "sir!'"
                           END IF
                        END IF
                        CALL AddMsg2(l, a$)
                     END IF
                  END IF
               NEXT l
               temp% = ship(target%).score
               IF temp% < 0 THEN temp% = 0
               a% = DEVICENUM%(target%, 1, controltot)
               IF ship(shipNum%).side = ship(target%).side THEN
                  ship(shipNum%).score = ship(shipNum%).score - temp%
                  ship(shipNum%).score = ship(shipNum%).score - (a% * 100)
               ELSE
                  ship(shipNum%).score = ship(shipNum%).score + temp%
                  ship(shipNum%).score = ship(shipNum%).score + (a% * 100)
               END IF
               IF ship(target%).player <> 0 THEN CALL AddMsg2(target%, t$)
               CALL KillShip(target%)
               EXIT SUB

            ELSEIF targetdevice% >= mag1 AND targetdevice% <= mag4 THEN
               leftover% = leftover% + 300
        
            END IF

            d% = leftover%

         END IF
         counter% = counter% + 1
         IF counter% = 100 OR d% = 0 THEN
            IF ship(target%).player <> 0 THEN CALL AddMsg2(target%, t$)
            EXIT SUB
         END IF

      LOOP

   LOOP

END SUB

'
' Call with a% = side and b% = ship whose name is to be returned.
'
FUNCTION DisplayName$ (a%, b%)

   SHARED ship() AS ships
  
   IF ship(b%).side = ship(a%).side THEN
      DisplayName$ = TRIM$(ship(b%).shipname)
   ELSE
      DisplayName$ = TRIM$(ship(b%).sidename) + " " + TRIM$(ship(b%).objname)
   END IF

END FUNCTION

SUB FirePhaser (attacker%, target%)

   SHARED damge%()
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED message$()
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%
  
   pha% = ship(attacker%).maxphaser

   IF ship(attacker%).energy < pha% THEN
      IF ship(attacker%).player <> 0 THEN
         a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
         a$ = a$ + "   'We did not have enough energy to fire phaser, sir.'"
         CALL AddMsg2(attacker%, a$)
      END IF

   ELSE
     
      IF ship(attacker%).player <> 0 THEN
         a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
         a$ = a$ + "   'We fired a phaser, sir!'"
         CALL AddMsg2(attacker%, a$)
      END IF
      FOR l = 1 TO totShipNum%
         IF attacker% <> l AND distance%(attacker%, l) < 11 THEN
            IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
               a$ = CHR$(13) + " Science Officer reports:" + CHR$(13)
               a$ = a$ + "   '" + DisplayName$(l, attacker%)
               a$ = a$ + " fired phaser.'"
               CALL AddMsg2(l, a$)
            END IF
         END IF
      NEXT l
    
      ship(attacker%).energy = ship(attacker%).energy - pha%

      IF target% = 0 THEN
         a$ = " Science Officer reports:" + CHR$(13) + "   'Phaser missed.'"
         FOR l = 1 TO totShipNum%
            IF distance%(attacker%, l) < 11 THEN
               IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                  CALL AddMsg2(l, a$)
               END IF
            END IF
         NEXT l

      ELSEIF target% = 255 THEN
         IF ship(attacker%).player <> 0 THEN
            a$ = " Science Officer reports:" + CHR$(13)
            a$ = a$ + "   'Star absorbed" + STR$(pha%)
            a$ = a$ + " units of energy from phaser.'"
            IF RND > .96 THEN
               a$ = a$ + CHR$(13)
               a$ = a$ + "   'The star seemes to be unaffected, sir.'"
            END IF
            CALL AddMsg2(attacker%, a$)
         END IF
         FOR l = 1 TO totShipNum%
            IF distance%(attacker%, l) < 10.5 AND l <> attacker% THEN
               IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                  a$ = " Science Officer reports:" + CHR$(13)
                  a$ = a$ + "   'Star absorbed phaser energy, sir.'"
                  CALL AddMsg2(l, a$)
               END IF
            END IF
         NEXT l

      ELSEIF target% = 254 OR ship(target%).shiptype = 254 THEN
         IF ship(attacker%).player <> 0 THEN
            a$ = " Science Officer reports:" + CHR$(13)
            a$ = a$ + "   'Phaser hit debris with" + STR$(pha%)
            a$ = a$ + " units of energy.'"
            IF RND > .98 THEN
               a$ = CHR$(13) + "   'Guess we won't be hearing anything from "
               a$ = a$ + "him!', says an excited Communications Officer."
            END IF
            CALL AddMsg2(attacker%, a$)
         END IF
         FOR l = 1 TO totShipNum%
            IF distance%(attacker%, l) < 10.5 AND l <> attacker% THEN
               IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                  a$ = " Science Officer reports:" + CHR$(13)
                  a$ = a$ + "   'Phaser hit debris, sir.'"
                  CALL AddMsg2(l, a$)
               END IF
            END IF
         NEXT l

      ELSE
       
         IF ship(ship(target%).dock).shiptype = station THEN
            target% = ship(target%).dock
         END IF

         damge! = 1 - distance%(attacker%, target%) / 11
         d% = (pha% / 2) + (pha% / 2 * damge!) + INTRND(10) - 5
         IF d% < 0 THEN d% = 0

         IF ship(attacker%).player <> 0 THEN
            a$ = " Science Officer reports:" + CHR$(13)
            a$ = a$ + "   'Phaser hit "
            a$ = a$ + DisplayName$(attacker%, target%) + " with"
            a$ = a$ + STR$(d%) + " units of energy.'"
            IF RND > .8 THEN
               a$ = a$ + CHR$(13) + "   'Good Shot, Captain.'"
            ELSEIF RND > .98 THEN
               a$ = a$ + CHR$(13) + "   'Blast them suckers!', yells the"
               a$ = a$ + " Communications Officer."
            END IF
            CALL AddMsg2(attacker%, a$)
         END IF
         IF ship(target%).player <> 0 THEN
            a$ = CHR$(13) + " Science Officer reports:" + CHR$(13)
            a$ = "   'Phaser hit us with" + STR$(d%)
            a$ = a$ + " units of energy, sir.'"
            CALL AddMsg2(target%, a$)
         END IF
         FOR l = 1 TO totShipNum%
            IF distance%(attacker%, l) < 11 THEN
               IF l <> attacker% AND l <> target% THEN
                  IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                     a$ = " Science Officer reports:" + CHR$(13) + "   'Phaser"
                     a$ = a$ + " hit " + DisplayName$(l, target%) + "."
                     CALL AddMsg2(l, a$)
                  END IF
               END IF
            END IF
         NEXT l
       
         shipNum% = attacker%
         CALL DamageShip(attacker%, target%, d%)

      END IF

   END IF

END SUB

SUB FireTorp (a%, b%)

   SHARED c%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED message$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   IF ship(a%).player <> 0 THEN
      t$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
      t$ = t$ + "   'We fired a torpedo, sir!'"
      t$ = t$ + CHR$(13) + " Science Officer reports:" + CHR$(13)
      t$ = t$ + "      Torpedo track:"
   END IF
   FOR l = 1 TO totShipNum%
      IF distance%(a%, l) < 11 AND l <> a% THEN
         IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
            a$ = CHR$(13) + " Science Officer reports:" + CHR$(13)
            a$ = a$ + "   '" + DisplayName$(l, a%) + " fired Torpedo.'"
            CALL AddMsg2(l, a$)
         END IF
      END IF
   NEXT l
 
   c1! = b% / 45 + 1
   c2% = INT(c1!)
   c3% = INT(c1! + 1)
   x1! = c%(1, c2%) + (c%(1, c3%) - c%(1, c2%)) * (c1! - c2%)
   y1! = c%(2, c2%) + (c%(2, c3%) - c%(2, c2%)) * (c1! - c2%)
  
   IF debug% = 1 THEN
      IF x1! > 1 OR y1! > 1 THEN STOP
      IF x1! < -1 OR y1! < -1 THEN STOP
   END IF

   q1% = ship(a%).xquad
   q2% = ship(a%).yquad
   s1! = ship(a%).xsect
   s2! = ship(a%).ysect
   hit% = 0
  
   FOR j = 1 TO 10
   
      s1! = s1! + x1!
      s2! = s2! + y1!
   
      flag% = 0
     
      IF CINT(s1!) < 1 THEN
         IF q1% - 1 < 1 THEN EXIT FOR
         q1% = q1% - 1
         s1! = sectsize%
         flag% = 1
      ELSEIF CINT(s1!) > sectsize% THEN
         IF q1% + 1 > quadsize% THEN EXIT FOR
         q1% = q1% + 1
         s1! = 1
         flag% = 1
      END IF

      IF CINT(s2!) < 1 THEN
         IF q2% - 1 < 1 THEN EXIT FOR
         q2% = q2% - 1
         s2! = sectsize%
         flag% = 1
      ELSEIF CINT(s2!) > sectsize% THEN
         IF q2% + 1 > quadsize% THEN EXIT FOR
         q2% = q2% + 1
         s2! = 1
         flag% = 1
      END IF
        
      IF flag% = 1 AND ship(a%).player <> 0 THEN
         t$ = t$ + CHR$(13)
         t$ = t$ + "       Quadrant " + STR$(q1%) + "," + STR$(q2%)
      END IF
      flag% = 0

      IF ship(a%).player <> 0 THEN
         t$ = t$ + CHR$(13)
         t$ = t$ + "           " + STR$(CINT(s1!)) + "," + STR$(CINT(s2!))
      END IF

      REDIM q%(sectsize%, sectsize%)
      CALL QuadTable(q1%, q2%, 0, 0)
  
      IF q%(CINT(s1!), CINT(s2!)) > 0 THEN
     
         hit% = 1
         b% = q%(CINT(s1!), CINT(s2!))
         IF b% < 250 THEN
            IF ship(b%).player <> 0 AND ship(b%).shiptype <> 254 THEN
               a$ = "   'We have been hit Captain!'"
               CALL AddMsg2(b%, a$)
            END IF
            FOR l = 1 TO totShipNum%
               IF distance%(a%, l) < 11 AND l <> b% THEN
                  IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                     a$ = ""
                     IF l = a% THEN
                        t$ = t$ + CHR$(13)
                        a$ = t$
                     END IF
                     a$ = a$ + "   Torpedo hits " + DisplayName$(l, b%) + "."
                     CALL AddMsg2(l, a$)
                  END IF
               END IF
            NEXT l
            CALL DamageShip(a%, b%, 500)
            EXIT SUB

         ELSEIF b% = 254 THEN
            FOR l = 1 TO totShipNum%
               IF distance%(a%, l) < 11 THEN
                  IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                     a$ = ""
                     IF l = a% THEN
                        t$ = t$ + CHR$(13)
                        a$ = t$
                     END IF
                     a$ = a$ + "   'Torpedo hits debris.'"
                     CALL AddMsg2(l, a$)
                  END IF
               END IF
            NEXT l
            EXIT SUB

         ELSEIF b% = 255 THEN
            FOR l = 1 TO totShipNum%
               IF distance%(a%, l) < 11 THEN
                  IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
                     a$ = ""
                     IF l = a% THEN
                        t$ = t$ + CHR$(13)
                        a$ = t$
                     END IF
                     a$ = a$ + "   'Torpedo hits star.'"
                     CALL AddMsg2(l, a$)
                  END IF
               END IF
            NEXT l
            EXIT SUB

         END IF

      END IF

   NEXT j

   IF hit% = 0 THEN
      FOR l = 1 TO totShipNum%
         IF distance%(a%, l) < 11 THEN
            IF ship(l).player <> 0 AND ship(l).shiptype <> 254 THEN
               a$ = ""
               IF l = a% THEN
                  t$ = t$ + CHR$(13)
                  a$ = t$
               END IF
               a$ = a$ + "   Torpedo missed."
               CALL AddMsg2(l, a$)
            END IF
         END IF
      NEXT l
   END IF

END SUB

SUB KillShip (target%)

   SHARED debug%
   SHARED ship() AS ships
   SHARED status%()
   SHARED location$()

   temp$ = SectorEncode$(target%, ship(target%).xsect, ship(target%).ysect)
   a$ = location$(ship(target%).xquad, ship(target%).yquad)
   a% = INSTR(a$, temp$)
   IF debug% = 1 THEN IF a% = 0 THEN STOP
   a$ = DELETE$(a$, a%, 2)
   location$(ship(target%).xquad, ship(target%).yquad) = a$

   q1% = ship(target%).xquad
   q2% = ship(target%).yquad
   s1! = ship(target%).xsect
   s2! = ship(target%).ysect
   temp$ = SectorEncode$(254, s1!, s2!)
   location$(q1%, q2%) = location$(q1%, q2%) + temp$

   FOR l = 1 TO controltot
      status%(target%, l) = -1
   NEXT l
   ship(target%).target1 = 0
   ship(target%).target1 = 0
   ship(target%).target3 = 0
   ship(target%).target4 = 0

   ship(target%).shiptype = 254

END SUB

'
'     Process Computer Controlled Vessals
'
SUB ProcessCompCont
  
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED ship() AS ships
   SHARED control%()
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Processing Computer Controlled Vessals."
   PRINT

   FOR i = 1 TO totShipNum%

      IF ship(i).shiptype <> 254 AND ship(i).player = 0 THEN
'
'   Turn on important equipment.
'
         FOR j = generator1 TO thruster2
            IF control%(i, j) = 2 THEN control%(i, j) = 4
         NEXT j
         IF control%(i, scanner) = 2 THEN control%(i, scanner) = 4
         IF control%(i, lifesupport) = 2 THEN control%(i, lifesupport) = 4
         IF control%(i, computer) = 2 THEN control%(i, computer) = 4
'
'   Determine Agressive, or defensive based on ship type.
'
         offense = 0
         defense = 1
         ship(i).mission = offense
         IF ship(i).shiptype > dreadnought THEN
            ship(i).mission = defense
         END IF
         IF ship(i).shiptype = deathstar THEN ship(i).mission = offense
'
'   If enemy combatant bigger than you, then be defensive.
'
         enemy% = ship(i).enemy
         frend% = ship(i).frend
         eDist% = distance%(i, enemy%)
         IF eDist% = 0 THEN eDist% = 1000
         fDist% = distance%(i, frend%)
         IF fDist% = 0 THEN fDist% = 1000

         IF ship(i).shiptype < ship(enemy%).shiptype THEN
            IF ship(enemy%).shiptype < station THEN
               IF eDist% < 10.5 AND fDist% > 10.5 THEN
                  ship(i).mission = defense
               END IF
            END IF
         END IF
'
'   If Damaged be defensive.
'
         IF DAMAGECALC%(i) > 25 THEN ship(i).mission = defense
'
'   If no enemies, no need to be defensive.
'
         IF enemy% = 0 THEN ship(i).mission = offense
'
'   Control Sensors.
'
         IF ship(i).mission = offense OR ship(i).shiptype = station THEN
        
            IF control%(i, lrsensor) = 2 THEN
               control%(i, lrsensor) = 4
            END IF
            IF control%(i, srsensor) = 2 THEN
               control%(i, srsensor) = 4
            END IF
            IF control%(i, scanner) = 2 THEN
               control%(i, scanner) = 4
            END IF
      
         ELSE
         
            IF control%(i, lrsensor) > 2 THEN
               control%(i, lrsensor) = 2
            END IF
            IF control%(i, srsensor) > 2 THEN
               control%(i, srsensor) = 2
            END IF
            IF control%(i, scanner) = 2 THEN
               control%(i, scanner) = 4
            END IF
        
         END IF
'
'   If Aggressive, head toward enemy, else join up with frend.
'
         IF ship(i).mission = offense THEN
            IF enemy% > 0 THEN
               ship(i).heading = direction%(i, enemy%) + INTRND(60) - 30
            ELSEIF frend% > 0 AND frend% > i THEN
               ship(i).heading = direction%(i, frend%) + INTRND(60) - 30
            END IF
         END IF
'
'   If defensive, and enemy nearest, run away, else run to freind.
'
         IF ship(i).mission = defense THEN
            IF enemy% > 0 AND eDist% < fDist% THEN
               ship(i).heading = direction%(i, enemy%) + INTRND(60) + 150
            ELSEIF frend% > 0 AND fDist% <= eDist% THEN
               ship(i).heading = direction%(i, frend%) + INTRND(20) - 10
            ELSE
               IF debug% = 1 THEN STOP
            END IF
         END IF
'
'        Default is max speed available.
'
         ship(i).ordspd = ship(i).maxvelocity

'
'   Enemy Nearby.
'
         IF eDist% < 25.5 THEN
            IF ship(i).mission = offense THEN
               ship(i).ordspd = INTRND(ship(i).maxvelocity / 2) + 1
            END IF
         END IF
'
'   Enemy in Immediate Area.
'
         IF eDist% < 10.5 THEN
          
            IF ship(i).mission = offense THEN
               ship(i).ordspd = ship(enemy%).velocity + 1
            ELSE
               ship(i).heading = INTRND(360)
            END IF
           
            FOR j = director1 TO director4
               IF control%(i, j) > 1 THEN control%(i, j) = 4
            NEXT j

            IF control%(i, director1) = 4 THEN
               ship(i).target1 = enemy%
               IF control%(i, phaser1) > 1 THEN control%(i, phaser1) = 4
            END IF
              
            IF control%(i, director2) = 4 THEN
               ship(i).target2 = enemy%
               IF control%(i, phaser2) > 1 THEN control%(i, phaser2) = 4
            END IF
          
            IF control%(i, director3) = 4 THEN
               ship(i).target3 = enemy%
               IF control%(i, phaser3) > 1 THEN control%(i, phaser3) = 4
            END IF
          
            IF control%(i, director4) = 4 THEN
               ship(i).target4 = enemy%
               IF control%(i, phaser4) > 1 THEN control%(i, phaser4) = 4
            END IF
               
            IF control%(i, computer) = 4 THEN
               CALL TorpCalc(i, enemy%, dir%, d%, 0)
            ELSE
               dir% = INTRND(360)
            END IF

            t% = 1
            FOR j = 1 TO totShipNum%
               IF i <> j AND ship(j).shiptype < 250 THEN
                  IF ship(i).side = ship(j).side AND distance%(i, j) < 11 THEN
                     d% = direction%(i, j)
                     IF dir% = d% THEN t% = 0
                     IF dir% < d% AND dir% + 45 >= d% THEN t% = 0
                     IF dir% > d% AND dir% - 45 <= d% THEN t% = 0
                     IF dir% + 45 > 360 AND dir% + 45 - 360 >= d% THEN t% = 0
                     IF dir% - 45 < 0 AND dir% - 45 + 360 <= d% THEN t% = 0
                  END IF
               END IF
            NEXT j

            FOR j = torp1 TO torp4
               IF ship(i).torptot > 0 AND t% = 1 AND control%(i, j) > 1 THEN
                  control%(i, j) = 4
                  ship(i).torptot = ship(i).torptot - 1
               END IF
            NEXT j
                   
            IF control%(i, torp1) = 4 THEN
               ship(i).tcourse1 = dir% - 5 + INTRND(10)
            END IF

            IF control%(i, torp2) = 4 THEN
               ship(i).tcourse2 = dir% - 10 + INTRND(20)
            END IF
              
            IF control%(i, torp3) = 4 THEN
               ship(i).tcourse3 = dir% - 10 + INTRND(20)
            END IF
             
            IF control%(i, torp4) = 4 THEN
               ship(i).tcourse4 = dir% - 20 + INTRND(40)
            END IF
        
            FOR j = shield1 TO shield4
               IF control%(i, j) > 1 THEN control%(i, j) = 4
            NEXT j
       
         END IF
'
'   Enemy not in immediate area.
'
         IF eDist% > 10.5 THEN
            ship(i).energy = TOTENERGY%(i)
            ship(i).shield1 = 0
            ship(i).shield2 = 0
            ship(i).shield3 = 0
            ship(i).shield4 = 0
            FOR j = shield1 TO shield4
               IF control%(i, j) > 2 THEN control%(i, j) = 2
            NEXT j
            FOR j = director1 TO director4
               IF control%(i, j) > 2 THEN control%(i, j) = 2
            NEXT j
         END IF
'
'   No Enemies Nearby.
'
         IF eDist% > 25 THEN
            FOR j = generator2 TO generator4
               IF control%(i, j) > 2 THEN control%(i, j) = 2
            NEXT j
         END IF
'
'   Formations.
'
         IF fDist% < 11 AND frend% < i THEN
            IF ship(frend%).shiptype <> station THEN
               ship(i).heading = ship(frend%).heading
               ship(i).ordspd = ship(frend%).ordspd
            END IF
         END IF
'
'   If Damaged use max speed.
'
         IF DAMAGECALC%(i) > 25 THEN ship(i).ordspd = ship(i).maxvelocity
'
'   If stopped, get moving.
'
         IF ship(i).velocity = 0 THEN
            IF ship(i).xquad = 1 AND ship(i).xsect = 1 THEN
               ship(i).heading = 45 + INTRND(90)
            ELSEIF ship(i).yquad = 1 AND ship(i).ysect = 1 THEN
               ship(i).heading = 135 + INTRND(90)
            ELSEIF ship(i).xquad = quadsize% THEN
               IF ship(i).xsect = sectsize% THEN
                  ship(i).heading = 225 + INTRND(90)
               END IF
            ELSEIF ship(i).yquad = quadsize% THEN
               IF ship(i).ysect = sectsize% THEN
                  ship(i).heading = 315 + INTRND(90)
               END IF
            ELSE
               ship(i).heading = INTRND(360)
            END IF
            ship(i).ordspd = 1
         END IF
'
'   Final Orders Check.
'
         IF ship(i).heading < 0 THEN
            ship(i).heading = ship(i).heading + 360
         ELSEIF ship(i).heading > 360 THEN
            ship(i).heading = ship(i).heading - 360
         END IF
     
         IF ship(i).ordspd > ship(i).maxvelocity THEN
            ship(i).ordspd = ship(i).maxvelocity
         END IF
'
'   Turn off unneccessary engines to save energy.
'
         IF ship(i).maxvelocity > 0 THEN
            spdRat% = ship(i).ordspd * 100 / ship(i).maxvelocity
            engNum% = DEVICENUM%(i, impulsengine1, impulsengine4)
            engReq% = INT((spdRat% * engNum% / 100) + .99)
            engOL% = DEVICEUP%(i, impulsengine1, impulsengine4)
            IF engReq% < engOL% THEN
               engOff% = engOL% - engReq%
               temp% = impulsengine1 + engOL% - engOff%
               FOR j = temp% TO temp% + engOff% - 1
                  IF control%(i, j) > 1 THEN control%(i, j) = 2
               NEXT j
            END IF
         END IF
'
'   Energy to Shields, If Required.
'
         IF control%(i, shield1) = 4 THEN

            IF ship(i).energy > ship(i).maxshields THEN
               ship(i).shield1 = ship(i).maxshields
               ship(i).energy = ship(i).energy - ship(i).maxshields
            ELSE
               ship(i).shield1 = ship(i).energy
               ship(i).energy = 0
            END IF

         END IF
        
         IF control%(i, shield2) = 4 THEN
          
            IF ship(i).energy > ship(i).maxshields THEN
               ship(i).shield2 = ship(i).maxshields
               ship(i).energy = ship(i).energy - ship(i).maxshields
            ELSE
               ship(i).shield2 = ship(i).energy
               ship(i).energy = 0
            END IF

         END IF

         IF control%(i, shield3) = 4 THEN
        
            IF ship(i).energy > ship(i).maxshields THEN
               ship(i).shield3 = ship(i).maxshields
               ship(i).energy = ship(i).energy - ship(i).maxshields
            ELSE
               ship(i).shield3 = ship(i).energy
               ship(i).energy = 0
            END IF

         END IF
        
         IF control%(i, shield4) = 4 THEN

            IF ship(i).energy > ship(i).maxshields THEN
               ship(i).shield4 = ship(i).maxshields
               ship(i).energy = ship(i).energy - ship(i).maxshields
            ELSE
               ship(i).shield4 = ship(i).energy
               ship(i).energy = 0
            END IF

         END IF
                 
         IF ship(i).shiptype = station OR ship(i).shiptype = fueler THEN
        
            IF ship(i).dock > 0 THEN
        
               dockship% = ship(i).dock
           
               F = ship(dockship%).maxfuel - ship(dockship%).fuel
               IF F > ship(i).fuel THEN F = ship(i).fuel
               ship(i).fuel = ship(i).fuel - F
               ship(dockship%).fuel = ship(dockship%).fuel + F

               e = ship(dockship%).maxenergy - ship(dockship%).energy
               IF e > ship(i).energy THEN e = ship(i).energy
               ship(i).energy = ship(i).energy - e
               ship(dockship%).energy = ship(dockship%).energy + e
        
               t = ship(dockship%).maxtorp - ship(dockship%).torptot
               IF t > ship(i).torptot THEN t = ship(i).torptot
               ship(i).torptot = ship(i).torptot - t
               ship(dockship%).torptot = ship(dockship%).torptot + t

            END IF
     
         END IF

      END IF

   NEXT i

   CLS

END SUB

'
'      Determine Condition
'
SUB ProcessCondition

   SHARED distance%()
   SHARED message$()
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Processing Condition."
   PRINT
  
   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         FOR j = 1 TO totShipNum%
            IF j <> i AND CINT(distance%(i, j)) < 11 THEN
               IF ship(i).side <> ship(j).side AND ship(j).shiptype <> 254 THEN
                  a$ = CHR$(13) + " Message from Communications Officer:"
                  a$ = a$ + CHR$(13) + "    '" + TRIM$(ship(i).shipname)
                  a$ = a$ + " located quadrant"
                  a$ = a$ + STR$(ship(i).xquad) + ","
                  a$ = a$ + TRIM$(STR$(ship(i).yquad))
                  a$ = a$ + ", sector" + STR$(CINT(ship(i).xsect))
                  a$ = a$ + "," + TRIM$(STR$(CINT(ship(i).ysect)))
                  a$ = a$ + ", in the presence of enemy vessals.'"
                  IF LEN(a$) > 80 THEN
                     b$ = LEFT$(a$, 80)
                     l = LASTCHAR(b$, " ")
                     MID$(a$, l, 1) = CHR$(13)
                  END IF
                 
                  FOR k = 1 TO totShipNum%
                     IF k <> i AND ship(i).side = ship(k).side THEN
                        IF ship(k).player <> 0 AND ship(k).shiptype <> 254 THEN
                           CALL AddMsg2(k, a$)
                           GOTO here
                        END IF
                     END IF
                  NEXT k
               END IF
            END IF
         NEXT j

here:

         IF ship(i).target1 > 250 THEN
            IF ship(i).target1 = 254 THEN
               ship(i).target1 = 0
            ELSEIF ship(i).target1 = 255 THEN
               ship(i).target1 = 0
            END IF
         END IF

         IF ship(i).target2 > 250 THEN
            IF ship(i).target2 = 254 THEN
               ship(i).target2 = 0
            ELSEIF ship(i).target2 = 255 THEN
               ship(i).target2 = 0
            END IF
         END IF

         IF ship(i).target3 > 250 THEN
            IF ship(i).target3 = 254 THEN
               ship(i).target3 = 0
            ELSEIF ship(i).target2 = 255 THEN
               ship(i).target3 = 0
            END IF
         END IF

         IF ship(i).target4 > 250 THEN
            IF ship(i).target4 = 254 THEN
               ship(i).target4 = 0
            ELSEIF ship(i).target4 = 255 THEN
               ship(i).target4 = 0
            END IF
         END IF

'
'   Determine max sensor range.
'
         IF status%(i, lrsensor) = 4 THEN
            maxSdist% = 35
         ELSEIF status%(i, srsensor) = 4 THEN
            maxSdist% = 25
         ELSE
            maxSdist% = 11
         END IF
'
'   Find nearest friend and enemy.
'
         eDist% = 1000
         fDist% = 1000
         ship(i).enemy = 0
         ship(i).frend = 0
       
         FOR j = 1 TO totShipNum%
          
            IF j <> i AND ship(j).shiptype < 250 THEN
'
'   Determine ESM range.
'
               IF status%(i, esmdev) < 4 THEN
                  maxEdist% = 0
               ELSEIF status%(j, lrsensor) = 4 THEN
                  maxEdist% = 90
               ELSEIF status%(j, srsensor) = 4 THEN
                  maxEdist% = 60
               ELSEIF status%(j, scanner) = 4 THEN
                  maxEdist% = 30
               ELSE
                  maxEdist% = 0
               END IF
               
               IF distance%(i, j) < maxEdist% THEN
                  IF ship(i).side = ship(j).side THEN
                     IF distance%(i, j) < fDist% THEN
                        fDist% = distance%(i, j)
                        ship(i).frend = j
                     END IF
                  ELSE
                     IF distance%(i, j) < eDist% THEN
                        eDist% = distance%(i, j)
                        ship(i).enemy = j
                     END IF
                  END IF
               END IF
        
               IF distance%(i, j) < maxSdist% THEN
                  IF ship(i).side = ship(j).side THEN
                     IF distance%(i, j) < fDist% THEN
                        fDist% = distance%(i, j)
                        ship(i).frend = j
                     END IF
                  ELSE
                     IF distance%(i, j) < eDist% THEN
                        eDist% = distance%(i, j)
                        ship(i).enemy = j
                     END IF
                  END IF
               END IF
             
            END IF
      
         NEXT j
      
         IF eDist% < 11 THEN
            ship(i).condition = 2
         ELSEIF eDist% < 26 THEN
            ship(i).condition = 1
         ELSE
            ship(i).condition = 0
         END IF
   
      END IF
   NEXT i
   CLS

END SUB

'
'  Compute Directions and Distances
'
SUB ProcessDirDist
  
   SHARED direction%()
   SHARED distance%()
   SHARED message$()
   SHARED ship() AS ships
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Computing Directions and Distances."
   LOCATE 4, 2
   PRINT "ShipNum=";
   FOR i = 1 TO totShipNum%
      LOCATE 4, 11
      PRINT i
      IF ship(i).shiptype <> 254 THEN
         FOR j = 1 TO totShipNum%
            IF i <> j AND ship(j).shiptype <> 254 THEN
               a1 = ship(i).xquad
               b1 = ship(i).yquad
               x1 = ship(i).xsect
               y1 = ship(i).ysect
               a2 = ship(j).xquad
               b2 = ship(j).yquad
               x2 = ship(j).xsect
               y2 = ship(j).ysect
               CALL DirDist(a1, b1, x1, y1, a2, b2, x2, y2, dir, dist)
               direction%(i, j) = dir
               distance%(i, j) = dist
            END IF
         NEXT j
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
   
      IF ship(i).target1 > 0 AND ship(i).target1 < 250 THEN
         IF distance%(i, ship(i).target1) > 11 THEN
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
               a$ = a$ + "    'We dropped track on "
               a$ = a$ + DisplayName$(i, ship(i).target1) + ".'"
               CALL AddMsg2(i, a$)
            END IF
            ship(i).target1 = 0
         END IF
      END IF

      IF ship(i).target2 > 0 AND ship(i).target2 < 250 THEN
         IF distance%(i, ship(i).target2) > 11 THEN
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
               a$ = a$ + "    'We dropped track on "
               a$ = a$ + DisplayName$(i, ship(i).target2) + ".'"
               CALL AddMsg2(i, a$)
            END IF
            ship(i).target2 = 0
         END IF
      END IF

      IF ship(i).target3 > 0 AND ship(i).target3 < 250 THEN
         IF distance%(i, ship(i).target3) > 11 THEN
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
               a$ = a$ + "    'We dropped track on "
               a$ = a$ + DisplayName$(i, ship(i).target3) + ".'"
               CALL AddMsg2(i, a$)
            END IF
            ship(i).target3 = 0
         END IF
      END IF

      IF ship(i).target4 > 0 AND ship(i).target4 < 250 THEN
         IF distance%(i, ship(i).target4) > 11 THEN
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Weapons Officer reports:" + CHR$(13)
               a$ = a$ + "    'We dropped track on "
               a$ = a$ + DisplayName$(i, ship(i).target4) + ".'"
               CALL AddMsg2(i, a$)
            END IF
            ship(i).target4 = 0
         END IF
      END IF

   NEXT i

   CLS

END SUB

'
'     Process Engineering
'
SUB ProcessEngineering
  
   SHARED message$()
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Processing Engineering."
   PRINT

   FOR i = 1 TO totShipNum%
 
      IF ship(i).shiptype <> 254 THEN
 
         FOR j = 1 TO controltot
            IF status%(i, j) = 3 THEN status%(i, j) = 4
         NEXT j

         IF ship(i).player = 0 THEN ship(i).fuel = ship(i).maxfuel

         IF ship(i).fuel <= 0 THEN
            FOR j = generator1 TO generator4
               status%(i, j) = 2
            NEXT j
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Message from Engineering Officer:" + CHR$(13)
               a$ = a$ + "    'Generators are shutting down because we are out"
               a$ = a$ + " of fuel Captain.'"
               CALL AddMsg2(i, a$)
            END IF
         END IF

         online% = DEVICEUP%(i, generator1, generator4)

         energy% = online% * ship(i).generatorcap

         ship(i).energy = ship(i).energy + energy%
         IF ship(i).energy > ship(i).maxenergy THEN
            ship(i).energy = ship(i).maxenergy
         END IF

         consumption% = (online% * ship(i).generatorcap / 100)
         ship(i).fuel = ship(i).fuel - consumption%
         IF ship(i).fuel < 0 THEN ship(i).fuel = 0

         IF ship(i).energy <= 0 THEN
            FOR j = 1 TO controltot
               IF status%(i, j) > 2 THEN
                  status%(i, j) = 2
               END IF
            NEXT j
            IF ship(i).player <> 0 THEN
               a$ = CHR$(13) + " Message from Engineering Officer:" + CHR$(13)
               a$ = a$ + "    'There is no more energy left to run the "
               a$ = a$ + "equipment Captain.'"
               CALL AddMsg2(i, a$)
            END IF
         ELSE
            FOR j = 1 TO controltot
               IF status%(i, j) = 4 THEN ship(i).energy = ship(i).energy - 1
            NEXT j
            IF ship(i).energy < 0 THEN ship(i).energy = 0
         END IF
           
         CALL OwnVelocity(i, ship(i).velocity, minVel%, flag%)
        
         engineUp% = DEVICEUP%(i, impulsengine1, impulsengine4)
         IF flag% <> 0 AND ship(i).player <> 0 THEN
            a$ = CHR$(13) + " Message from Engineering Officer:"
            IF flag% = 1 THEN
               a$ = a$ + CHR$(13) + "   'I "
               a$ = a$ + "need an engine online to move Captain.'"
            ELSEIF flag% = 2 THEN
               a$ = a$ + CHR$(13) + "   'She's a good ship Captain, but she"
               a$ = a$ + " can't make ordered speed with no engines!'"
            ELSE
               a$ = a$ + CHR$(13) + "   'I "
               a$ = a$ + "can not make ordered speed with only "
               a$ = a$ + STR$(engineUp%) + " engine"
               IF engineUp% > 1 THEN a$ = a$ + "s"
               a$ = a$ + " online.'"
            END IF
            CALL AddMsg2(i, a$)
         END IF
        
         IF engineUp% * ship(i).velocity * 10 > ship(i).energy THEN
            IF ship(i).player <> 0 THEN
               a$ = a$ + CHR$(13) + " Message from Engineering Officer:"
               a$ = a$ + CHR$(13) + "    'We need at least "
               a$ = a$ + STR$(CINT(engineUp% * ship(i).velocity * 10))
               a$ = a$ + " units of energy to make speed "
               a$ = a$ + STR$(ship(i).velocity) + " with "
               a$ = a$ + STR$(engineUp%) + " engine"
               IF engineUp% > 1 THEN a$ = a$ + "s"
               a$ = a$ + " on the line.'"
               CALL AddMsg2(i, a$)
            END IF
            ship(i).velocity = INT(ship(i).energy / (engineUp% * 10))
            IF ship(i).velocity < minVel% THEN ship(i).velocity = minVel%
         END IF
       
         ship(i).movement = ship(i).velocity
        
         ship(i).energy = ship(i).energy - (engineUp% * ship(i).velocity * 10)
         IF ship(i).velocity = 0 THEN
            ship(i).energy = ship(i).energy - (engineUp% * 10)
         END IF

         IF ship(i).energy < 0 THEN ship(i).energy = 0

         IF ship(i).player <> 0 THEN
            shieldte% = TOTENERGY%(i) - ship(i).energy
            IF shieldte% < ship(i).energy THEN
               ship(i).energy = ship(i).energy - shieldte%
            ELSE
               ship(i).shield1 = 0
               ship(i).shield2 = 0
               ship(i).shield3 = 0
               ship(i).shield4 = 0
               a$ = CHR$(13) + " Message from Engineering Officer:" + CHR$(13)
               a$ = a$ + "    'I have not got enough energy to keep the "
               a$ = a$ + "shield"
               shieldTot% = DEVICEUP%(i, shield1, shield2)
               IF shieldTot% > 1 THEN a$ = a$ + "s"
               a$ = a$ + " up."
               CALL AddMsg2(i, a$)
            END IF
         END IF

         IF status%(i, lifesupport) = 2 AND ship(i).energy > 0 THEN
            status%(i, lifesupport) = 4
         END IF

         IF status%(i, lifesupport) < 4 THEN
            IF ship(i).lstimer = 0 THEN ship(i).player = 0
            IF ship(i).lstimer > 0 THEN ship(i).lstimer = ship(i).lstimer - 1
         ELSEIF ship(i).lstimer < 10 THEN
            ship(i).lstimer = ship(i).lstimer + 1
         END IF

      END IF

   NEXT i

   CLS

END SUB

'
'  Process Moves
'
SUB ProcessMoves

   SHARED c%()
   SHARED control%()
   SHARED debug%
   SHARED damge%()
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%
   SHARED turn%

   CLS
   LOCATE 2, 2
   PRINT "Processing Moves..."

   '
   '  Determine if Game is over.
   '
   temp% = 0
   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype < 254 THEN
         temp% = ship(i).side
         a% = i
         EXIT FOR
      END IF
   NEXT i
   IF temp% = 0 THEN CALL EndGame    ' No ships left.
   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype < 254 AND i <> a% THEN
         IF ship(i).side <> ship(a%).side THEN EXIT FOR
      END IF
      IF i = totShipNum% THEN CALL EndGame
   NEXT i
 
   CALL ProcessCompCont

   LOCATE 2, 2
   PRINT "Processing Messages..."
   turn% = turn% + 1
   shipNum% = 0
  
   tempPath$ = ENVIRON$("TMP")
   fileName$ = tempPath$ + "CCN.TMP"
   OPEN fileName$ FOR APPEND AS #1
      PRINT #1, "CCN"
   CLOSE #1
   fileName$ = tempPath$ + "*.TMP"
   KILL fileName$
  
   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype = 254 THEN
         a$ = CHR$(13) + " This ship has been destroyed."
         CALL AddMsg2(i, a$)
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      FOR j = 1 TO controltot
         status%(i, j) = control%(i, j)
      NEXT j
   NEXT i

   CALL ProcessRepair
   CALL ProcessEngineering
   CALL ProcessNavigation
   CALL ProcessDirDist
   IF progMode% = 0 THEN CALL ProcessWeapons
   CALL ProcessCondition

   FOR i = 1 TO totShipNum%
      FOR j = 1 TO controltot
         control%(i, j) = status%(i, j)
      NEXT j
   NEXT i

END SUB

'
'     Process Navigation
'
SUB ProcessNavigation
  
   SHARED c%()
   SHARED distance%()
   SHARED location$()
   SHARED message$()
   SHARED progMode%
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%
  
   LOCATE 2, 2
   PRINT "Processing Navigation."

   FOR i = 1 TO totShipNum%

      IF ship(i).shiptype <> 254 THEN
  
         CALL OwnCourse(i, ship(i).course, flag%)
        
         IF flag% = 1 THEN
            IF ship(i).player <> 0 AND ship(i).heading <> ship(i).course THEN
               a$ = CHR$(13) + " Message from Conning Officer:" + CHR$(13)
               a$ = "    'We can't change course without a thruster Captain.'"
               CALL AddMsg2(i, a$)
            END IF
         END IF
        
      END IF

   NEXT i

   DO

       flag% = 0

       FOR i = 1 TO totShipNum%

         IF ship(i).shiptype <> 254 AND ship(i).movement > 0 AND progMode% = 0 THEN
     
            flag% = 1

            c1! = ship(i).course / 45 + 1
            c2! = INT(c1!)
            c3! = INT(c1! + 1)
            x1! = c%(1, c2!) + (c%(1, c3!) - c%(1, c2!)) * (c1! - c2!)
            y1! = c%(2, c2!) + (c%(2, c3!) - c%(2, c2!)) * (c1! - c2!)
            IF debug% = 1 THEN
               IF x1! > 1 OR y1! > 1 THEN STOP
               IF x1! < -1 OR y1! < -1 THEN STOP
            END IF
            q1% = ship(i).xquad
            q2% = ship(i).yquad
            s1! = ship(i).xsect
            s2! = ship(i).ysect
     
            temp$ = SectorEncode$(i, ship(i).xsect, ship(i).ysect)
            a$ = location$(ship(i).xquad, ship(i).yquad)
            a% = INSTR(a$, temp$)
            IF debug% = 1 THEN IF a% = 0 THEN STOP
            a$ = DELETE$(a$, a%, 2)
            location$(ship(i).xquad, ship(i).yquad) = a$
        
            q3% = q1%
            q4% = q2%
            s3! = s1! + x1!
            s4! = s2! + y1!
         
            DO
               DO
               
                  IF CINT(s3!) < 1 THEN
                     IF q3% - 1 < 1 THEN
                        ship(i).velocity = 0
                        ship(i).movement = 0
                        s3! = s3! - x1!
                        s4! = s4! - y1!
                        IF ship(i).player <> 0 THEN
                           a$ = "   " + TRIM$(ship(i).shipname)
                           a$ = a$ + " engines shut down to prevent unauth"
                           a$ = a$ + "orized penetration of galactic barrier."
                           CALL AddMsg2(i, a$)
                        END IF
                     ELSE
                        q3% = q3% - 1
                        s3! = sectsize%
                     END IF
                  END IF
        
                  IF CINT(s3!) > sectsize% THEN
                     IF q3% + 1 > quadsize% THEN
                        ship(i).velocity = 0
                        ship(i).movement = 0
                        s3! = s3! - x1!
                        s4! = s4! - y1!
                        IF ship(i).player <> 0 THEN
                           a$ = "   " + TRIM$(ship(i).shipname)
                           a$ = a$ + " engines shut down to prevent unauth"
                           a$ = a$ + "orized penetration of galactic barrier."
                           CALL AddMsg2(i, a$)
                        END IF
                     ELSE
                        q3% = q3% + 1
                        s3! = 1
                     END IF
                  END IF
              
                  IF CINT(s4!) < 1 THEN
                     IF q4% - 1 < 1 THEN
                        ship(i).velocity = 0
                        ship(i).movement = 0
                        s3! = s3! - x1!
                        s4! = s4! - y1!
                        IF ship(i).player <> 0 THEN
                           a$ = "   " + TRIM$(ship(i).shipname)
                           a$ = a$ + " engines shut down to prevent unauth"
                           a$ = a$ + "orized penetration of galactic barrier."
                           CALL AddMsg2(i, a$)
                        END IF
                     ELSE
                        q4% = q4% - 1
                        s4! = sectsize%
                     END IF
                  END IF

                  IF CINT(s4!) > sectsize% THEN
                     IF q4% + 1 > quadsize% THEN
                        ship(i).velocity = 0
                        ship(i).movement = 0
                        s3! = s3! - x1!
                        s4! = s4! - y1!
                        IF ship(i).player <> 0 THEN
                           a$ = "   " + TRIM$(ship(i).shipname)
                           a$ = a$ + " engines shut down to prevent unauth"
                           a$ = a$ + "orized penetration of galactic barrier."
                           CALL AddMsg2(i, a$)
                        END IF
                     ELSE
                        q4% = q4% + 1
                        s4! = 1
                     END IF
                  END IF
            
               LOOP WHILE CINT(s4!) < 1 OR CINT(s4!) > sectsize%
            LOOP WHILE CINT(s3!) < 1 OR CINT(s3!) > sectsize%

            REDIM q%(10, 10)
         
            FOR k = 1 TO LEN(location$(q3%, q4%)) / 2
               temp$ = MID$(location$(q3%, q4%), k * 2 - 1, 2)
               CALL SectorDecode(temp$, objnum%, xsect%, ysect%)
               q%(xsect%, ysect%) = objnum%
            NEXT k
  
            IF q%(CINT(s3!), CINT(s4!)) = 0 THEN
               q1% = q3%
               q2% = q4%
               s1! = s3!
               s2! = s4!
            ELSE
               IF ship(i).player <> 0 THEN
                  a$ = "   " + TRIM$(ship(i).shipname)
                  shipNum% = i
                  IF q%(CINT(s3!), CINT(s4!)) < 250 THEN
                     target% = q%(CINT(s3!), CINT(s4!))
                     a$ = " " + a$ + " collides with "
                     a$ = a$ + DisplayName$(i, target%) + "."
                     CALL AddMsg2(i, a$)
                     FOR l = 1 TO totShipNum%
                        IF distance%(i, l) < 10.5 AND l <> i THEN
                           IF ship(l).player <> 0 THEN
                              a$ = " " + DisplayName$(l, target%) + " rammed"
                              a$ = a$ + " by " + DisplayName$(l, i) + "."
                              CALL AddMsg2(l, a$)
                           END IF
                        END IF
                     NEXT l
                     d% = INTRND(ship(i).velocity * 100)
                     CALL DamageShip(i, target%, d%)
                  ELSE
                     a$ = a$ + " engines shut down to prevent navigation"
                     a$ = a$ + " disaster."
                     CALL AddMsg2(i, a$)
                  END IF
                  target% = i
                  d% = INTRND(ship(i).velocity * 100)
                  CALL DamageShip(i, target%, d%)
               END IF
               ship(i).velocity = 0
               ship(i).movement = 0
               IF ship(i).dock > 0 THEN
                  dockship% = ship(i).dock
                  ship(doskship%).dock = 0
                  ship(i).dock = 0
               END IF
            END IF
  
            ship(i).xquad = q1%
            ship(i).yquad = q2%
            ship(i).xsect = s1!
            ship(i).ysect = s2!
            temp$ = SectorEncode$(i, s1!, s2!)
            location$(q1%, q2%) = location$(q1%, q2%) + temp$
          
            ship(i).movement = ship(i).movement - 1

         END IF

      NEXT i

   LOOP WHILE flag% = 1

   CLS

END SUB

'
'  Process Repair
'
SUB ProcessRepair
  
   SHARED damge%()
   SHARED message$()
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Processing Damage Repair."
   PRINT
   FOR i = 1 TO totShipNum%

      IF ship(i).shiptype <> 254 THEN
 
         IF ship(i).dock = 1000 THEN ship(i).dock = 0
         IF ship(i).dock < 0 THEN ship(i).dock = ABS(ship(i).dock)
        
         FOR j = 1 TO 10
   
            equip% = INTRND(controltot)
        
            IF ship(i).shiptype = station THEN
               IF status%(i, equip%) = 0 THEN
                  status%(i, equip%) = 1
               END IF
            END IF
        
            IF ship(ship(i).dock).shiptype = station THEN
               IF ship(i).side = ship(ship(i).dock).side THEN
                  IF status%(i, equip%) = 0 THEN
                     status%(i, equip%) = 1
                  END IF
               END IF
            END IF
       
            IF ship(ship(i).dock).shiptype = repair THEN
               IF ship(i).side = ship(ship(i).dock).side THEN
                  IF status%(i, equip%) = 0 THEN
                     status%(i, equip%) = 1
                  END IF
               END IF
            END IF
           
            IF status%(i, equip%) = 1 THEN
               a% = INTRND(10) + INTRND(10)
               damge%(i, equip%) = damge%(i, equip%) - a%
               IF ship(i).player <> 0 THEN
                  a$ = CHR$(13) + " Repair Officer reports:"
                  a$ = a$ + CHR$(13) + "    '" + TRIM$(ship(i).shipname)
                  a$ = a$ + " " + DEVICE$(equip%)
               END IF
               IF damge%(i, equip%) <= 0 THEN
                  damge%(i, equip%) = 0
                  status%(i, equip%) = 2
                  IF ship(i).player <> 0 THEN
                     a$ = a$ + " repaired and operational.'"
                     CALL AddMsg2(i, a$)
                  END IF
               ELSE
                  IF ship(i).player <> 0 THEN
                     a$ = a$ + " repaired" + STR$(a%) + "%.'"
                     CALL AddMsg2(i, a$)
                  END IF
               END IF
            END IF

         NEXT j

      END IF

   NEXT i

   CLS

END SUB

'
'  ProcessWeapons
'
SUB ProcessWeapons
 
   SHARED c%()
   SHARED damge%()
   SHARED debug%
   SHARED direction%()
   SHARED distance%()
   SHARED location$()
   SHARED message$()
   SHARED q%()
   SHARED quadsize%
   SHARED ship() AS ships
   SHARED status%()
   SHARED totShipNum%

   LOCATE 2, 2
   PRINT "Processing Weapons."
   LOCATE 4, 2
   PRINT "ShipNum=";

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, phaser1) = 4 THEN
            CALL FirePhaser(i, ship(i).target1)
            status%(i, phaser1) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, torp1) = 4 THEN
            CALL FireTorp(i, ship(i).tcourse1)
            status%(i, torp1) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, phaser2) = 4 THEN
            CALL FirePhaser(i, ship(i).target2)
            status%(i, phaser2) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, torp2) = 4 THEN
            CALL FireTorp(i, ship(i).tcourse2)
            status%(i, torp2) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, phaser3) = 4 THEN
            CALL FirePhaser(i, ship(i).target3)
            status%(i, phaser3) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, torp3) = 4 THEN
            CALL FireTorp(i, ship(i).tcourse3)
            status%(i, torp3) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, phaser4) = 4 THEN
            CALL FirePhaser(i, ship(i).target4)
            status%(i, phaser4) = 2
         END IF
      END IF
   NEXT i

   FOR i = 1 TO totShipNum%
      IF ship(i).shiptype <> 254 THEN
         LOCATE 4, 11
         PRINT i
         IF status%(i, torp4) = 4 THEN
            CALL FireTorp(i, ship(i).tcourse4)
            status%(i, torp4) = 2
         END IF
    
         IF status%(i, director1) < 4 THEN ship(i).target1 = 0
         IF status%(i, director2) < 4 THEN ship(i).target2 = 0
         IF status%(i, director3) < 4 THEN ship(i).target3 = 0
         IF status%(i, director4) < 4 THEN ship(i).target4 = 0
   
         IF ship(i).target1 > 0 AND ship(i).target1 < 250 THEN
            IF ship(ship(i).target1).shiptype = 254 THEN ship(i).target1 = 254
         END IF
  
         IF ship(i).target2 > 0 AND ship(i).target2 < 250 THEN
            IF ship(ship(i).target2).shiptype = 254 THEN ship(i).target2 = 254
         END IF
  
         IF ship(i).target3 > 0 AND ship(i).target3 < 250 THEN
            IF ship(ship(i).target3).shiptype = 254 THEN ship(i).target3 = 254
         END IF
  
         IF ship(i).target4 > 0 AND ship(i).target4 < 250 THEN
            IF ship(ship(i).target4).shiptype = 254 THEN ship(i).target4 = 254
         END IF
     
      END IF
   NEXT i

   CLS

END SUB

SUB TorpCalc (i%, j%, dir%, dist%, a%)

   SHARED ship() AS ships
   SHARED status%()

   CALL OwnPosit(i%, a3, b3, x3, y3)
  
   a1 = ship(j).xquad
   b1 = ship(j).yquad
   x1 = ship(j).xsect
   y1 = ship(j).ysect
   cse = ship(j).course
   vel = ship(j).velocity
   CALL CseSpd(a1, b1, x1, y1, cse, vel, a2, b2, x2, y2)
                 
   CALL DirDist(a3, b3, x3, y3, a2, b2, x2, y2, dir, dist)

END SUB

