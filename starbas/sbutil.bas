'                                                                       
'   Name:  SBUTIL.BAS                                               
'                                                                       
'   Type:  Main Module                                                  
'                                                                       
'   Version:  1.00                   Date:  11 November 1989
'                                                                       
'   Programmer:  Christopher C. Nystrom                                 
'                                                                       
'   Langauge:    MicroSoft QuickBASIC 4.0
'                                                                       
'   Function:    SBUTIL.BAS 
'               
'                                                                     
'$INCLUDE: 'STARBAT.INC'

TYPE fleets2

   fleetName    AS STRING * 80
   totShips     AS INTEGER
   controller   AS INTEGER

END TYPE

TYPE ships2
  
   player       AS INTEGER
   fleet        AS INTEGER                  'v4
   side         AS INTEGER
   sidename     AS STRING * 10
   objname      AS STRING * 14
   shipname     AS STRING * 25
   shiptype     AS INTEGER
   image        AS STRING * 3
  
   score        AS LONG                     ' v4
   mission      AS INTEGER                  ' v2
   condition    AS INTEGER                  ' v2
   enemy        AS INTEGER                  ' v3
   frend        AS INTEGER                  ' v3

   xquad        AS INTEGER
   yquad        AS INTEGER
   xsect        AS SINGLE
   ysect        AS SINGLE
   course       AS INTEGER
   heading      AS INTEGER
   manuever     AS INTEGER
   maxvelocity  AS INTEGER
   availvel     AS INTEGER
   velocity     AS INTEGER
   ordspd       AS INTEGER
   movement     AS INTEGER                  ' v2
   maxfuel      AS INTEGER
   fuel         AS INTEGER
   maxenergy    AS INTEGER
   energy       AS INTEGER
   generatorcap AS INTEGER
   lstimer      AS INTEGER
   maxphaser    AS INTEGER

   target1 AS INTEGER
   target2 AS INTEGER
   target3 AS INTEGER
   target4 AS INTEGER

   maxtorp AS INTEGER
   torptot AS INTEGER

   tcourse1 AS INTEGER
   tcourse2 AS INTEGER
   tcourse3 AS INTEGER
   tcourse4 AS INTEGER

   maxshields AS INTEGER

   shield1 AS INTEGER
   shield2 AS INTEGER
   shield3 AS INTEGER
   shield4 AS INTEGER

   armor AS INTEGER

   dock AS INTEGER

END TYPE

CONST totshiptype2 = 14
CONST controltot2 = 39

SCREEN 0
COLOR white, lightblue, lightblue
CLS

LOCATE 10, 20
PRINT "Star Battles Scenario Translator Utility"
LOCATE 12, 30
PRINT "by Chris Nystrom"

'
'   Load Old File
'

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

   GET #1, , stardate%
   GET #1, , quadsize%
   GET #1, , totsidenum%
   GET #1, , totFleetNum%
   GET #1, , totshipnum%
 
   REDIM location$(quadsize%, quadsize%)
   REDIM fleet(totFleetNum%) AS fleets
   REDIM ship(totshipnum%) AS ships
   REDIM status%(totshipnum%, controltot)
   REDIM control%(totshipnum%, controltot)
   REDIM damage%(totshipnum%, controltot)
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

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         GET #1, , status%(i, j)
      NEXT j
   NEXT i

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO controltot
         GET #1, , control%(i, j)
      NEXT j
   NEXT i

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         GET #1, , distance%(i, j)
      NEXT j
   NEXT i

   FOR i = 1 TO totshipnum%
      FOR j = 1 TO totshipnum%
         GET #1, , direction%(i, j)
      NEXT j
   NEXT i

   FOR i = 1 TO totshipnum%
      GET #1, , ship(i)
   NEXT i

   CLOSE #1

   IF debug% = 1 THEN IF totshipnum% = 0 THEN STOP

LOCATE 22, 2
PRINT "                                      "
LOCATE 22, 2
fileName$ = a$ + ".DAT"
PRINT "RENAMING: "; fileName$; " as "; a$; ".BAK"
NAME fileName$ AS a$ + ".BAK"

'
'  Revise Old File
'

REDIM fleet(totFleetNum%) AS fleets

fleet(1).fleetName = "Enterprise"
fleet(1).totShips = 1

fleet(2).fleetName = "Federation Merchants"
fleet(2).totShips = 10

fleet(3).fleetName = "Klargon Invasion Force"
fleet(3).totShips = 11

'
'  Using old file parameters, Dimension new Arrays and Records
'

stardate2% = stardate%
quadSize2% = quadsize%
'totSideNum2% = totsidenum%
totFleetNum2% = totFleetNum%
totShipNum2% = totshipnum%

DIM fleet2(totFleetNum2%) AS fleets2
DIM ship2(totShipNum2%) AS ships2
DIM status2%(totShipNum2%, controltot2)
DIM control2%(totShipNum2%, controltot2)
DIM damage2%(totShipNum2%, controltot2)

DIM distance2%(totShipNum2%, totShipNum2%)
DIM direction2%(totShipNum2%, totShipNum2%)

'
'   Create New Scenrio File
'

FOR i = 1 TO totFleetNum%
  
   fleet2(i).fleetName = fleet(i).fleetName
   fleet2(i).totShips = fleet(i).totShips
   fleet2(i).controller = fleet(i).controller

NEXT i

FOR i = 1 TO totshipnum%
  
   ship2(i).fleet = ship(i).fleet
   ship2(i).side = ship(i).side
   ship2(i).sidename = ship(i).sidename
   ship2(i).objname = ship(i).objname
   ship2(i).shipname = ship(i).shipname
   ship2(i).shiptype = ship(i).shiptype
   ship2(i).image = ship(i).image

   ship2(i).score = ship(i).score
   ship2(i).mission = ship(i).mission
   ship2(i).condition = ship(i).condition
   ship2(i).xquad = ship(i).xquad
   ship2(i).yquad = ship(i).yquad
   ship2(i).xsect = ship(i).xsect
   ship2(i).ysect = ship(i).ysect
   ship2(i).course = ship(i).course
   ship2(i).heading = ship(i).heading
   ship2(i).manuever = ship(i).manuever
   ship2(i).maxvelocity = ship(i).maxvelocity
   ship2(i).availvel = ship(i).availvel
   ship2(i).velocity = ship(i).velocity
   ship2(i).ordspd = ship(i).ordspd
   ship2(i).movement = ship(i).movement
   ship2(i).maxfuel = ship(i).maxfuel
   ship2(i).fuel = ship(i).fuel
   ship2(i).maxenergy = ship(i).maxenergy
   ship2(i).energy = ship(i).energy
   ship2(i).generatorcap = ship(i).generatorcap
   ship2(i).lstimer = ship(i).lstimer
   ship2(i).maxphaser = ship(i).maxphaser

   ship2(i).target1 = ship(i).target1
   ship2(i).target2 = ship(i).target2
   ship2(i).target3 = ship(i).target3
   ship2(i).target4 = ship(i).target4

   ship2(i).maxtorp = ship(i).maxtorp
   ship2(i).torptot = ship(i).torptot

   ship2(i).tcourse1 = ship(i).tcourse1
   ship2(i).tcourse2 = ship(i).tcourse2
   ship2(i).tcourse3 = ship(i).tcourse3
   ship2(i).tcourse4 = ship(i).tcourse4

   ship2(i).maxshields = ship(i).maxshields

   ship2(i).shield1 = ship(i).shield1
   ship2(i).shield2 = ship(i).shield2
   ship2(i).shield3 = ship(i).shield3
   ship2(i).shield4 = ship(i).shield4

   ship2(i).armor = ship(i).armor

   ship2(i).dock = ship(i).dock

NEXT i

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      status2%(i, j) = status%(i, j)
   NEXT j
NEXT i

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      control2%(i, j) = status%(i, j)
   NEXT j
NEXT i

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      damage2%(i, j) = 0
   NEXT j
NEXT i

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO totShipNum2%
      distance2%(i, j) = distance%(i, j)
   NEXT j
NEXT i

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO totShipNum2%
      direction2%(i, j) = direction%(i, j)
   NEXT j
NEXT i

'
'   Save new Scenario
'
  
LOCATE 22, 2
PRINT "                                      "
LOCATE 22, 2
PRINT "Saving: "; fileName$

a% = 1
check% = 9999

OPEN fileName$ FOR BINARY AS #1

PUT #1, , a%

PUT #1, , stardate2%
PUT #1, , quadSize2%
PUT #1, , totFleetNum2%
PUT #1, , totShipNum2%

PUT #1, , check%

FOR i = 1 TO quadSize2%
   FOR j = 1 TO quadSize2%
      a% = LEN(location$(i, j))
      PUT #1, , a%
      PUT #1, , location$(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      PUT #1, , status2%(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      PUT #1, , control2%(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO controltot2
      PUT #1, , damage2%(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO totShipNum2%
      PUT #1, , distance2%(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   FOR j = 1 TO totShipNum2%
      PUT #1, , direction2%(i, j)
   NEXT j
NEXT i

PUT #1, , check%

FOR i = 1 TO totFleetNum2%
   PUT #1, , fleet2(i)
NEXT i

PUT #1, , check%

FOR i = 1 TO totShipNum2%
   PUT #1, , ship2(i)
NEXT i

PUT #1, , check%

CLOSE #1

CLS

END

