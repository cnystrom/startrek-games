'                                                           
'   Name:  SBCREATE.BAS                                     
'                                                           
'   Type:  Main Module                                      
'                                                           
'   Version:  0.10                   Date:  7 January 1990
'                                                           
'   Programmer:  Christopher C. Nystrom                     
'                                                           
'   Language:    MicroSoft QuickBASIC 4.5                 
'                                                           
'
DECLARE SUB FieldEditor (text$, f%)
'$INCLUDE: 'STARBAT.INC'

debug% = 0
progMode% = 1

SCREEN 0
COLOR white, blue, lightblue
CLS
 
LOCATE 4, 22
PRINT "Star Battles Scenario Creator   v0.1"
LOCATE 6, 30
PRINT "(c) Chris Nystrom"

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
   c%(2, 10) = 1

DIM q%(10, 10)
   
w1.action = 2
w1.edgeline = 2
w1.bdr = lightblue
w1.fgdEdge = white
w1.bgdEdge = blue
w1.fgdBody = bright + white
w1.bgdBody = black
w1.fgdHighlight = black
w1.bgdHighlight = white
w1.fgdTitle = white
w1.bgdTitle = blue
w1.fgdPrompt = white
w1.bgdPrompt = blue

DIM side$(10)

side$(1) = "Federation"
side$(2) = "Klargon"
side$(3) = "Zornian"
side$(4) = "Hasmurd"
side$(5) = "Robotron"
side$(6) = "Farnnic"
side$(7) = "Chaldean"
side$(8) = "Phesian"'
side$(9) = "Hattian"
side$(10) = "Alien"
 
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
 
   OPEN "SBCRINST.DOC" FOR INPUT AS #1
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

stardate% = INTRND%(500) + 2500
stard$ = TRIM$(STR$(stardate%))
LOCATE 10, 2
PRINT "Stardate: ";
COLOR black, white
CALL FieldEditor(stard$, 1)
COLOR white, blue
LOCATE 10, 11
stardate% = VAL(stard$)
PRINT stardate%

DO
   BEEP
   LOCATE 12, 2
   INPUT "Galaxy Size (10-70)"; quadsize%
LOOP WHILE quadsize% < 10 OR quadsize% > 70

PRINT
DO
   BEEP
   LOCATE 14, 2
   INPUT "Number of Fleets (1-250)"; totFleetNum%
LOOP WHILE totFleetNum% < 1 OR totFleetNum% > 250

PRINT
DO
   BEEP
   LOCATE 16, 2
   INPUT "Number of Ships (1-250)"; totshipnum%
LOOP WHILE totshipnum% < 1 OR totshipnum% > 250

PRINT
PRINT " Creating Galaxy"
 
starNum% = quadsize% ^ 2
DIM location$(quadsize%, quadsize%)
DIM fleet(totFleetNum%) AS fleets
DIM ship(totshipnum%) AS ships
DIM status%(totshipnum%, controltot)
DIM control%(totshipnum%, controltot)
DIM damge%(totshipnum%, controltot)
DIM distance%(totshipnum%, totshipnum%)
DIM direction%(totshipnum%, totshipnum%)
DIM message$(totshipnum%)
 
FOR i = 1 TO totshipnum%
   FOR j = 1 TO controltot
      status%(i, j) = -1
      control%(i, j) = -1
      damge%(i, j) = 0
   NEXT j
NEXT i

PRINT " Starnum =       of "; starNum%
FOR i = 1 TO starNum%
   xquad% = INTRND%(quadsize%)
   yquad% = INTRND%(quadsize%)
   xsect! = (sectSize% - 1) * RND + 1
   ysect! = (sectSize% - 1) * RND + 1
 
   IF FRE(1) < 1100 THEN EXIT FOR

   a$ = SectorEncode$(255, xsect!, ysect!)
   location$(xquad%, yquad%) = location$(xquad%, yquad%) + a$
   LOCATE 19, 12
   PRINT i

NEXT i
   
totPlayerNum% = 1
DIM playerName$(totPlayerNum%)
playerName$(1) = "Creator"

'      Setup Fleets

CLS
FOR i = 1 TO totFleetNum%

   PRINT
   PRINT " Fleet"; i; "Name: ";
   fltN$ = SPACE$(60)
   COLOR black, white
   CALL FieldEditor(fltN$, 0)
   COLOR white, blue
   fleet(i).fleetName = fltN$
   fleet(i).controller = 1
   PRINT

NEXT i

'      Setup Ships in Galaxy
   
FOR i = 1 TO totshipnum%

   IF FRE(1) < 100 THEN
      totshipnum% = i
      EXIT FOR
   END IF

   CLS
   PRINT
   PRINT " Ship Number:"; i
   PRINT
  
   ship(i).player = 1
       
   DO
      LOCATE 4, 2
      INPUT "Side (1-250)"; ship(i).side
   LOOP WHILE ship(i).side < 1 OR ship(i).side > 250

   PRINT
   PRINT " The Known Races of the Galaxy:"
   FOR j = 1 TO 10
      LOCATE j + 5, 40
      PRINT TRIM$(STR$(j)); ". ";
      IF j < 10 THEN PRINT " ";
      PRINT side$(j)
   NEXT j
   LOCATE 16, 40
   PRINT "11. Other"
      
   DO
      LOCATE 19, 2
      INPUT "Culture (1-11)"; cult%
   LOOP WHILE cult% < 1 OR cult% > 11

   IF cult% < 11 THEN
      ship(i).sidename = side$(cult%)
   ELSE
      LOCATE 19, 2
      PRINT " Culture Name: ";
      culture$ = SPACE$(10)
      COLOR black, white
      CALL FieldEditor(culture$, 0)
      COLOR white, blue
      ship(i).sidename = culture$
   END IF

   CLS
   PRINT
   PRINT " Ship Number:"; i
   PRINT
   PRINT " Culture: "; ship(i).sidename
  
   DO
      LOCATE 6, 2
      PRINT "Fleet Number (1-"; TRIM$(STR$(totFleetNum%));
      INPUT ")"; ship(i).fleet
   LOOP WHILE ship(i).fleet < 1 OR ship(i).fleet > totFleetNum%

   LOCATE 6, 2
   PRINT SPACE$(78);
   LOCATE 6, 2
   fltN$ = TRIM$(fleet(ship(i).fleet).fleetName)
   IF LEN(fltN$) > 34 THEN fltN$ = LEFT$(fltN$, 34)
   PRINT "Fleet Name: "; fltN$
   PRINT

   FOR j = 1 TO totshiptype
      LOCATE j + 1, 40
      PRINT TRIM$(STR$(j)); ". ";
      IF j < 10 THEN PRINT " ";
      PRINT TYPESHIP$(j);
   NEXT j
      
   DO
      LOCATE 8, 2
      INPUT "Ship Type (1-22)"; ship(i).shiptype
   LOOP WHILE ship(i).shiptype < 1 OR ship(i).shiptype > totshiptype

   CLS
   PRINT
   PRINT " Ship Number:"; i
   PRINT
   PRINT " Side: "; side$(ship(i).side)
   PRINT
   PRINT " Fleet Name: "; TRIM$(fleet(ship(i).fleet).fleetName)
   PRINT
   PRINT " Ship Type: "; TYPESHIP$(ship(i).shiptype)
   PRINT
  
   IF ship(i).shiptype = patrol THEN
    
      ship(i).objname = "Patrol"
      ship(i).image = "{+}"
      ship(i).manuever = 60
      ship(i).maxvelocity = 8
      ship(i).maxfuel = 100
      ship(i).maxenergy = 500
      ship(i).generatorcap = 150
      ship(i).lstimer = 10
      ship(i).maxphaser = 50
      ship(i).maxshields = 50
    
      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, director1) = 4

      status%(i, phaser1) = 2
   
      status%(i, mag1) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = corvette THEN
    
      ship(i).objname = "Corvette"
      ship(i).image = "{=}"
      ship(i).manuever = 80
      ship(i).maxvelocity = 10
      ship(i).maxfuel = 150
      ship(i).maxenergy = 700
      ship(i).generatorcap = 200
      ship(i).lstimer = 10
      ship(i).maxphaser = 50
      ship(i).maxshields = 50
    
      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, director1) = 4
      status%(i, director2) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
   
      status%(i, mag1) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = torpcraft THEN
   
      ship(i).objname = "Torpedo Craft"
      ship(i).image = "(=)"
      ship(i).manuever = 80
      ship(i).maxvelocity = 10
      ship(i).maxfuel = 150
      ship(i).maxenergy = 800
      ship(i).generatorcap = 200
      ship(i).lstimer = 10
      ship(i).maxtorp = 4
      ship(i).maxshields = 50
   
      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, director1) = 4
     
      status%(i, torp1) = 2
      status%(i, torp2) = 2
  
      status%(i, mag1) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = frigate THEN
     
      ship(i).objname = "Frigate"
      ship(i).image = "(+)"
      ship(i).manuever = 90
      ship(i).maxvelocity = 12
      ship(i).maxfuel = 200
      ship(i).maxenergy = 1000
      ship(i).generatorcap = 250
      ship(i).lstimer = 10
      ship(i).maxphaser = 100
      ship(i).maxtorp = 4
      ship(i).maxshields = 100
      ship(i).armor = 10
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4
 
      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4
      status%(i, director1) = 4
      status%(i, esmdev) = 4
      status%(i, phaser1) = 2
      status%(i, torp1) = 2
    
      status%(i, mag1) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = destroyer THEN
     
      ship(i).objname = "Destroyer"
      ship(i).image = "<+>"
      ship(i).manuever = 60
      ship(i).maxvelocity = 10
      ship(i).maxfuel = 300
      ship(i).maxenergy = 1500
      ship(i).generatorcap = 200
      ship(i).lstimer = 10
      ship(i).maxphaser = 150
      ship(i).maxtorp = 8
      ship(i).maxshields = 150
      ship(i).armor = 20
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4
 
      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4
      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, torp1) = 2
      status%(i, torp2) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = lcruiser THEN
     
      ship(i).objname = "Light Cruiser"
      ship(i).image = "[+]"
      ship(i).manuever = 50
      ship(i).maxvelocity = 10
      ship(i).maxfuel = 600
      ship(i).maxenergy = 2000
      ship(i).generatorcap = 300
      ship(i).lstimer = 10
      ship(i).maxphaser = 200
      ship(i).maxtorp = 12
      ship(i).maxshields = 200
      ship(i).armor = 30
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
      status%(i, switchboard) = 4
 
      status%(i, shield1) = 2
      status%(i, shield2) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4
      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, torp1) = 2
      status%(i, torp2) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = hcruiser THEN
     
      ship(i).objname = "Heavy Cruiser"
      ship(i).image = "{#}"
      ship(i).manuever = 40
      ship(i).maxvelocity = 8
      ship(i).maxfuel = 750
      ship(i).maxenergy = 2700
      ship(i).generatorcap = 300
      ship(i).lstimer = 10
      ship(i).maxphaser = 250
      ship(i).maxtorp = 16
      ship(i).maxshields = 250
      ship(i).armor = 40
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, impulsengine3) = 4

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4

      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
 
      status%(i, switchboard) = 4
     
      status%(i, shield1) = 2
      status%(i, shield2) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, director3) = 4
     
      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, phaser3) = 2

      status%(i, torp1) = 2
      status%(i, torp2) = 2
      status%(i, torp3) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = monitor THEN
   
      ship(i).objname = "Monitor"
      ship(i).image = "<é>"
      ship(i).manuever = 10
      ship(i).maxvelocity = 2
      ship(i).maxfuel = 1000
      ship(i).maxenergy = 3500
      ship(i).generatorcap = 350
      ship(i).lstimer = 10
      ship(i).maxphaser = 350
      ship(i).maxshields = 350
      ship(i).armor = 60
   
      status%(i, impulsengine1) = 4

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
     
      status%(i, thruster1) = 4

      status%(i, switchboard) = 4
    
      status%(i, shield1) = 2
      status%(i, shield2) = 2
     
      status%(i, scanner) = 4
      status%(i, srsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
     
      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
     
      status%(i, mag1) = 4
      status%(i, mag2) = 4
     
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = bcruiser THEN
     
      ship(i).objname = "BattleCruiser"
      ship(i).image = "(#)"
      ship(i).manuever = 30
      ship(i).maxvelocity = 8
      ship(i).maxfuel = 1200
      ship(i).maxenergy = 4200
      ship(i).energy = ship(i).maxenergy
      ship(i).generatorcap = 350
      ship(i).lstimer = 10
      ship(i).maxphaser = 300
      ship(i).maxtorp = 20
      ship(i).maxshields = 300
      ship(i).armor = 50
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, impulsengine3) = 4

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
      status%(i, generator4) = 4

      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
 
      status%(i, switchboard) = 4
     
      status%(i, shield1) = 2
      status%(i, shield2) = 2
      status%(i, shield3) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, director3) = 4

      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, phaser3) = 2

      status%(i, torp1) = 2
      status%(i, torp2) = 2
      status%(i, torp3) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4
      status%(i, mag4) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = battleship THEN
     
      ship(i).objname = "Battleship"
      ship(i).image = "<#>"
      ship(i).manuever = 20
      ship(i).maxvelocity = 6
      ship(i).maxfuel = 1800
      ship(i).maxenergy = 5400
      ship(i).generatorcap = 450
      ship(i).lstimer = 10
      ship(i).maxphaser = 350
      ship(i).maxtorp = 24
      ship(i).maxshields = 350
      ship(i).armor = 60
     
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, impulsengine3) = 4
      status%(i, impulsengine4) = 4

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
      status%(i, generator4) = 4

      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
 
      status%(i, switchboard) = 4
     
      status%(i, shield1) = 2
      status%(i, shield2) = 2
      status%(i, shield3) = 2
      status%(i, shield4) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, director3) = 4
      status%(i, director4) = 4

      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, phaser3) = 2
      status%(i, phaser4) = 2

      status%(i, torp1) = 2
      status%(i, torp2) = 2
      status%(i, torp3) = 2
      status%(i, torp4) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4
      status%(i, mag4) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = dreadnought THEN
     
      ship(i).objname = "Dreadnought"
      ship(i).image = "[#]"
      ship(i).manuever = 20
      ship(i).maxvelocity = 6
      ship(i).maxfuel = 2000
      ship(i).maxenergy = 6000
      ship(i).generatorcap = 500
      ship(i).lstimer = 10
      ship(i).maxphaser = 400
      ship(i).maxtorp = 28
      ship(i).maxshields = 400
      ship(i).armor = 70

      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, impulsengine3) = 4
      status%(i, impulsengine4) = 4
 
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
      status%(i, generator4) = 4
 
      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
  
      status%(i, switchboard) = 4
     
      status%(i, shield1) = 2
      status%(i, shield2) = 2
      status%(i, shield3) = 2
      status%(i, shield4) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, director3) = 4
      status%(i, director4) = 4

      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, phaser3) = 2
      status%(i, phaser4) = 2
 
      status%(i, torp1) = 2
      status%(i, torp2) = 2
      status%(i, torp3) = 2
      status%(i, torp4) = 2
     
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4
      status%(i, mag4) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = deathstar THEN
    
      ship(i).objname = "Death Star"
      ship(i).image = "-+O"
      ship(i).manuever = 5
      ship(i).maxvelocity = 2
      ship(i).maxfuel = 8000
      ship(i).maxenergy = 16000
      ship(i).generatorcap = 2000
      ship(i).lstimer = 10
      ship(i).maxphaser = 4000
      ship(i).maxshields = 1500
      ship(i).armor = 100

      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, impulsengine3) = 4
      status%(i, impulsengine4) = 4

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
      status%(i, generator4) = 4

      status%(i, thruster1) = 4
      status%(i, thruster2) = 4

      status%(i, switchboard) = 4
    
      status%(i, shield1) = 2
      status%(i, shield2) = 2
      status%(i, shield3) = 2
      status%(i, shield4) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
    
      status%(i, esmdev) = 4

      status%(i, phaser1) = 2

      status%(i, mag1) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = station THEN
    
      ship(i).objname = "Space Station"
      ship(i).image = ">O<"
      ship(i).maxfuel = 5000
      ship(i).maxenergy = 12000
      ship(i).generatorcap = 1000
      ship(i).lstimer = 10
      ship(i).maxphaser = 500
      ship(i).maxtorp = 150
      ship(i).maxshields = 600
      ship(i).armor = 80

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, generator3) = 4
      status%(i, generator4) = 4

      status%(i, switchboard) = 4
     
      status%(i, shield1) = 2
      status%(i, shield2) = 2
      status%(i, shield3) = 2
      status%(i, shield4) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
      status%(i, director3) = 4
      status%(i, director4) = 4

      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
      status%(i, phaser3) = 2
      status%(i, phaser4) = 2

      status%(i, torp1) = 2
      status%(i, torp2) = 2
      status%(i, torp3) = 2
      status%(i, torp4) = 2
    
      status%(i, mag1) = 4
      status%(i, mag2) = 4
      status%(i, mag3) = 4
      status%(i, mag4) = 4

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
 
   ELSEIF ship(i).shiptype = outpost THEN
   
      ship(i).objname = "Space Outpost"
      ship(i).image = ">=<"
      ship(i).manuever = 0
      ship(i).maxvelocity = 0
      ship(i).maxfuel = 3000
      ship(i).maxenergy = 6000
      ship(i).generatorcap = 500
      ship(i).lstimer = 10
      ship(i).maxphaser = 250
      ship(i).maxtorp = 50
      ship(i).maxshields = 300
      ship(i).armor = 40

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, switchboard) = 4
    
      status%(i, shield1) = 2
      status%(i, shield2) = 2
     
      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4

      status%(i, director1) = 4
      status%(i, director2) = 4
     
      status%(i, esmdev) = 4

      status%(i, phaser1) = 2
      status%(i, phaser2) = 2
     
      status%(i, torp1) = 2
      status%(i, torp2) = 2
     
      status%(i, mag1) = 4
      status%(i, mag2) = 4
     
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = spacedock THEN
  
      ship(i).objname = "Space Dock"
      ship(i).image = ">+<"
      ship(i).manuever = 0
      ship(i).maxvelocity = 0
      ship(i).maxfuel = 2000
      ship(i).maxenergy = 2000
      ship(i).generatorcap = 300
      ship(i).lstimer = 10
      ship(i).maxshields = 200
      ship(i).armor = 20

      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, switchboard) = 4
   
      status%(i, shield1) = 2
      status%(i, shield2) = 2
    
      status%(i, scanner) = 4
      status%(i, srsensor) = 4
     
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   ELSEIF ship(i).shiptype = sensor THEN
    
      ship(i).objname = "Sensor Ship"
      ship(i).image = ")I("
      ship(i).manuever = 30
      ship(i).maxvelocity = 8
      ship(i).maxfuel = 200
      ship(i).maxenergy = 1000
      ship(i).generatorcap = 150
      ship(i).lstimer = 10
      ship(i).maxphaser = 100
      ship(i).maxshields = 100
      ship(i).armor = 10
    
      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4
      status%(i, director1) = 4
      status%(i, esmdev) = 4
      status%(i, phaser1) = 2
     
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = fueler THEN
    
      ship(i).objname = "Fueler"
      ship(i).image = "+è+"
      ship(i).manuever = 30
      ship(i).maxvelocity = 10
      ship(i).maxfuel = 3000
      ship(i).maxenergy = 2000
      ship(i).generatorcap = 300
      ship(i).lstimer = 10
      ship(i).maxphaser = 200
      ship(i).maxtorp = 50
      ship(i).maxshields = 200
      ship(i).armor = 20

      status%(i, impulsengine1) = 4
      status%(i, impulsengine2) = 4
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, thruster1) = 4
      status%(i, thruster2) = 4
      status%(i, switchboard) = 4
 
      status%(i, shield1) = 2
      status%(i, shield2) = 2

      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, lrsensor) = 4
      status%(i, director1) = 4
      status%(i, esmdev) = 4
     
      status%(i, phaser1) = 2

      status%(i, mag1) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
 
   ELSEIF ship(i).shiptype = repair THEN
   
      ship(i).objname = "Repair Ship"
      ship(i).image = "+X+"
      ship(i).manuever = 20
      ship(i).maxvelocity = 6
      ship(i).maxfuel = 1000
      ship(i).maxenergy = 1000
      ship(i).generatorcap = 200
      ship(i).lstimer = 10
      ship(i).maxphaser = 100
      ship(i).maxshields = 100
     
      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, generator2) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2
     
      status%(i, scanner) = 4
      status%(i, srsensor) = 4
      status%(i, director1) = 4
     
      status%(i, phaser1) = 2

      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = freighter THEN
    
      ship(i).objname = "Freighter"
      ship(i).image = "ðOð"
      ship(i).manuever = 10
      ship(i).maxvelocity = 2
      ship(i).maxfuel = 200
      ship(i).maxenergy = 200
      ship(i).generatorcap = 100
      ship(i).lstimer = 10
      ship(i).maxshields = 25

      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4
 
      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
  
   ELSEIF ship(i).shiptype = transport THEN
   
      ship(i).objname = "Transport"
      ship(i).image = "(ð)"
      ship(i).manuever = 10
      ship(i).maxvelocity = 2
      ship(i).maxfuel = 200
      ship(i).maxenergy = 200
      ship(i).generatorcap = 100
      ship(i).lstimer = 10
      ship(i).maxshields = 25

      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

  
   ELSEIF ship(i).shiptype = tanker THEN
   
      ship(i).objname = "Tanker"
      ship(i).image = "+O+"
      ship(i).manuever = 10
      ship(i).maxvelocity = 2
      ship(i).maxfuel = 1000
      ship(i).maxenergy = 200
      ship(i).generatorcap = 100
      ship(i).lstimer = 10
      ship(i).maxshields = 25

      status%(i, impulsengine1) = 4
      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4

      status%(i, shield1) = 2

      status%(i, scanner) = 4
      status%(i, dccentral) = 4
      status%(i, computer) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4
 
   ELSEIF ship(i).shiptype = barge THEN
  
      ship(i).objname = "Barge"
      ship(i).image = "-O-"
      ship(i).manuever = 60
      ship(i).maxfuel = 1000
      ship(i).maxenergy = 100
      ship(i).generatorcap = 50
      ship(i).lstimer = 10
      ship(i).maxshields = 25

      status%(i, generator1) = 4
      status%(i, thruster1) = 4
      status%(i, switchboard) = 4
      status%(i, shield1) = 2
      status%(i, scanner) = 4
      status%(i, dccentral) = 4
      status%(i, lifesupport) = 4
      status%(i, shipdock) = 4

   END IF
 
   LOCATE 10, 2
   shipN$ = SPACE$(25)
   PRINT "Ship's Name: ";
   COLOR black, white
   CALL FieldEditor(shipN$, 0)
   ship(i).shipname = shipN$
   COLOR white, blue
   LOCATE 10, 15
   PRINT ship(i).shipname
  
   DO
      LOCATE 12, 2
      PRINT "Quadrant X-Coordinate (1-"; TRIM$(STR$(quadsize%)); ")";
      INPUT ship(i).xquad
   LOOP WHILE ship(i).xquad < 1 OR ship(i).xquad > quadsize%
     
   DO
      LOCATE 13, 2
      PRINT "Quadrant Y-Coordinate (1-"; TRIM$(STR$(quadsize%)); ")";
      INPUT ship(i).yquad
   LOOP WHILE ship(i).yquad < 1 OR ship(i).yquad > quadsize%

   PRINT
   DO
      LOCATE 15, 2
      PRINT "Sector X-Coordinate (1-"; TRIM$(STR$(sectSize%)); ")";
      INPUT ship(i).xsect
   LOOP WHILE ship(i).xsect < 1 OR ship(i).xsect > sectSize%

   DO
      LOCATE 16, 2
      PRINT "Sector Y-Coordinate (1-"; TRIM$(STR$(sectSize%)); ")";
      INPUT ship(i).ysect
   LOOP WHILE ship(i).ysect < 1 OR ship(i).ysect > sectSize%

   DO
      LOCATE 18, 2
      PRINT "Course (000-360)";
      INPUT ship(i).course
   LOOP WHILE ship(i).course < 0 OR ship(i).course > 360

   DO
      LOCATE 20, 2
      PRINT "Velocity (0-"; TRIM$(STR$(ship(i).maxvelocity)); ")";
      INPUT ship(i).velocity
   LOOP WHILE ship(i).velocity < 0 OR ship(i).velocity > ship(i).maxvelocity

   DO
      LOCATE 12, 50
      PRINT "Fuel (0-"; TRIM$(STR$(ship(i).maxfuel)); ")";
      INPUT ship(i).fuel
   LOOP WHILE ship(i).fuel < 0 OR ship(i).fuel > ship(i).maxfuel

   DO
      LOCATE 14, 50
      PRINT "Energy (0-"; TRIM$(STR$(ship(i).maxenergy)); ")";
      INPUT ship(i).energy
   LOOP WHILE ship(i).energy < 0 OR ship(i).energy > ship(i).maxenergy

   IF ship(i).maxtorp > 0 THEN
      DO
         LOCATE 16, 50
         PRINT "Torpedoes (0-"; TRIM$(STR$(ship(i).maxtorp)); ")";
         INPUT ship(i).torptot
      LOOP WHILE ship(i).torptot < 0 OR ship(i).torptot > ship(i).maxtorp
   END IF
  
   ship(i).heading = ship(i).course
   ship(i).ordspd = ship(i).velocity

   CLS
  
   a$ = location$(ship(i).xquad, ship(i).yquad)
   a$ = a$ + SectorEncode$(i, ship(i).xsect, ship(i).ysect)
   location$(ship(i).xquad, ship(i).yquad) = a$

   fleet(ship(i).fleet).totShips = fleet(ship(i).fleet).totShips + 1

   FOR j = 1 TO controltot
      control%(i, j) = status%(i, j)
   NEXT j

NEXT i

CHAIN "SB"




