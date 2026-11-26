$IF STARBAT_INC = UNDEFINED THEN
$LET STARBAT_INC = DEFINED
'$INCLUDE: 'STANDARD.INC'

TYPE fleets

   fleetName    AS STRING * 60
   totShips     AS INTEGER
   controller   AS INTEGER

END TYPE

TYPE ships
 
   player       AS INTEGER
   fleet        AS INTEGER                  ' v4
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

DECLARE FUNCTION DAMAGECALC% (a%)
DECLARE FUNCTION SectorEncode$ (a%, b!, c!)
DECLARE FUNCTION DEVICE$ (a%)
DECLARE FUNCTION TOTENERGY% (shipNum%)
DECLARE FUNCTION DEVICENUM% (shipNum%, a%, b%)
DECLARE FUNCTION DEVICEUP% (shipNum%, a%, b%)
DECLARE FUNCTION TYPESHIP$ (a%)

DECLARE SUB SectorDecode (x$, objnum%, xsect%, ysect%)
DECLARE SUB DirDist (a1%, b1%, x1%, y1%, a2%, b2%, x2%, y2%, dir%, dist%)
DECLARE SUB CseSpd (a1%, b1%, x1%, y1%, cse%, vel%, a2%, b2%, x2%, y2%)
DECLARE SUB TorpCalc (i%, j%, dir%, dist%, a%)
DECLARE SUB EndGame ()
DECLARE SUB GetPlayerNames ()
DECLARE SUB SBLoad (fileName$)
DECLARE SUB SBSave ()
DECLARE SUB QuadTable (q1%, q2%, xoffset%, yoffset%)
DECLARE SUB OwnPosit (i%, a3%, b3%, x3%, y3%)
DECLARE SUB OwnCourse (i%, cse%, flag%)
DECLARE SUB OwnVelocity (i%, vel%, minVel%, flag%)

' QB64 port: COMMON arrays crash QB64-PE (heap corruption in its COMMON
' support), and CHAIN is emulated by PE_CHAIN.BI, so each COMMON line is
' kept as a comment and declared with DIM instead. SUBs still see these
' through their own SHARED statements, exactly as before.
'PE COMMON c%()
DIM c%()
'PE COMMON control%()
DIM control%()
'PE COMMON damge%()
DIM damge%()
'PE COMMON debug%
DIM debug%
'PE COMMON direction%()
DIM direction%()
'PE COMMON distance%()
DIM distance%()
'PE COMMON fleet() AS fleets
DIM fleet() AS fleets
'PE COMMON location$()
DIM location$()
'PE COMMON message$()
DIM message$()
'PE COMMON playerName$()
DIM playerName$()
'PE COMMON progMode%
DIM progMode%
'PE COMMON q%()
DIM q%()
'PE COMMON quadsize%
DIM quadsize%
'PE COMMON ship() AS ships
DIM ship() AS ships
'PE COMMON stardate%
DIM stardate%
'PE COMMON status%()
DIM status%()
'PE COMMON totFleetNum%
DIM totFleetNum%
'PE COMMON totPlayerNum%
DIM totPlayerNum%
'PE COMMON totshipnum%
DIM totshipnum%
'PE COMMON totsidenum%
DIM totsidenum%
'PE COMMON turn%
DIM turn%
'PE COMMON m1  AS MenuType
DIM m1  AS MenuType

CONST sectsize% = 10

CONST totshiptype = 22

CONST patrol = 1
CONST corvette = 2
CONST torpcraft = 3
CONST frigate = 4
CONST destroyer = 5
CONST lcruiser = 6
CONST hcruiser = 7
CONST monitor = 8
CONST bcruiser = 9
CONST battleship = 10
CONST dreadnought = 11
CONST deathstar = 12
CONST station = 13
CONST outpost = 14
CONST spacedock = 15
CONST sensor = 16
CONST fueler = 17
CONST repair = 18
CONST freighter = 19
CONST transport = 20
CONST tanker = 21
CONST barge = 22

CONST controltot = 39

CONST generator1 = 1
CONST generator2 = 2
CONST generator3 = 3
CONST generator4 = 4
CONST impulsengine1 = 5
CONST impulsengine2 = 6
CONST impulsengine3 = 7
CONST impulsengine4 = 8
CONST thruster1 = 9
CONST thruster2 = 10
CONST switchboard = 11
CONST shield1 = 12
CONST shield2 = 13
CONST shield3 = 14
CONST shield4 = 15
CONST scanner = 16
CONST srsensor = 17
CONST lrsensor = 18
CONST director1 = 19
CONST director2 = 20
CONST director3 = 21
CONST director4 = 22
CONST esmdev = 23
CONST phaser1 = 24
CONST phaser2 = 25
CONST phaser3 = 26
CONST phaser4 = 27
CONST torp1 = 28
CONST torp2 = 29
CONST torp3 = 30
CONST torp4 = 31
CONST mag1 = 32
CONST mag2 = 33
CONST mag3 = 34
CONST mag4 = 35
CONST dccentral = 36
CONST computer = 37
CONST lifesupport = 38
CONST shipdock = 39

'$INCLUDE: 'START.INC'

$END IF
