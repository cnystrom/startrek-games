'                                                                      
'   Name:  SBLIB1.BAS                                               
'                                                                      
'   Type:  Library Module                                                
'                                                                      
'   Version:  1.00                   Date:  14 November 1989
'                                                                      
'   Programmer:  Christopher C. Nystrom                                
'                                                                      
'   Langauge:    MicroSoft QuickBASIC 4.5
'                                                                      
'   Function:    Provides a library of routines for STAR BATTTLES that do not
'                use SHARED variables.
'                                                                    

'$INCLUDE: 'STARBAT.INC'

REM $DYNAMIC
'                                                                  
'   Name:  CseSpd                                                         
'                                                                    
'   Type:  Subprogram                                                         
'                                                                    
'   Version:  1.01                   Date:  8 March 1989                      
'                                                                    
'   Programmer:  Christopher C. Nystrom                              
'                                                                    
'   Langauge:    MicroSoft QuickBASIC 4.0                            
'                                                                    
'
SUB CseSpd (a1%, b1%, x1%, y1%, cse%, vel%, a2%, b2%, x2%, y2%)

   a = ((a1 - 1) * 10) + x1           ' Convert to Single Plane
   b = ((b1 - 1) * 10) + y1           '   vice Quad/Sect.
 
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
  
   cse = cse / 45 + 1
   cs2 = INT(cse)
   cs3 = INT(cse + 1)
   x = c%(1, cs2) + (c%(1, cs3) - c%(1, cs2)) * (cse - cs2)
   y = c%(2, cs2) + (c%(2, cs3) - c%(2, cs2)) * (cse - cs2)

   x = CINT(x * vel)
   y = CINT(y * vel)

   x = a + x
   y = b + y
              
   a2 = INT(x / 10) + 1
   b2 = INT(y / 10) + 1
   x2 = CINT(x - ((a2 - 1) * 10))
   IF x2 = 0 THEN
      a2 = a2 - 1
      x2 = 10
   END IF
   y2 = CINT(y - ((b2 - 1) * 10))
   IF y2 = 0 THEN
      b2 = b2 - 1
      y2 = 10
   END IF

END SUB

DEFSNG A-Z
'*****************************************************************************
'                                                                    
'   Name:  DEVICE$                                                         
'                                                                    
'   Type:  FUNCTION                                                         
'                                                                    
'   Version:  1.02                   Date:  02 July 1989                      
'                                                                    
'   Programmer:  Christopher C. Nystrom                              
'                                                                    
'   Langauge:    MicroSoft QuickBASIC 4.0                            
'                                                                    
'   Use:  Returns name of device.                                                          
'                                                                    
'                                                                    
'   Called by:  DamageControl, DamageShip
'
'
'   Parameters:   a% - integer indicating device. Passed by value.                                              
'                                                                    
'                                                                    
'*****************************************************************************
'
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

DEFINT A-Z
'****************************************************************************
'                                                                  
'   Name:  DirDist                                                       
'                                                                  
'   Type:  Subprogram                                                       
'                                                                  
'   Version:  1.00                   Date:  08 February 1989                    
'                                                                  
'   Programmer:  Christopher C. Nystrom                            
'                                                                  
'   Langauge:    MicroSoft QuickBASIC 4.0                          
'                                                                  
'                                                                  
'****************************************************************************
'
SUB DirDist (a1%, b1%, x1%, y1%, a2%, b2%, x2%, y2%, dir%, dist%)

   CONST PI = 3.141593
   CONST CONV = 57.29578              ' Radians * CONV = Degrees.

   x1 = CINT(x1)
   y1 = CINT(y1)
   x2 = CINT(x2)
   y2 = CINT(y2)

   a = ((a1 - 1) * 10) + x1           ' Convert to Single Plane
   b = ((b1 - 1) * 10) + y1           '   vice Quad/Sect.
   x3 = ((a2 - 1) * 10) + x2
   y3 = ((b2 - 1) * 10) + y2

   x = y3 - b                          ' Make first point Origin.
   y = a - x3
    
   IF x = 0 THEN
      IF y > 0 THEN
         d = PI / 2
      ELSEIF y < 0 THEN
         d = -PI / 2
      ELSE
         d = 0
      END IF
   
   ELSEIF y = 0 THEN
      IF x < 0 THEN
         d = PI
      ELSE
         d = 0
      END IF
  
   ELSE
      IF x < 0 THEN
         IF y > 0 THEN
            d = ATN(y / x) + PI
         ELSE
            d = ATN(y / x) - PI
         END IF
      ELSE
         d = ATN(y / x)
      END IF
  
   END IF

   d = d * CONV                   ' Convert Radians to Degrees.

   d = 90 - d                     ' Convert to bearing by rotating
   IF d < 0 THEN d = d + 360    '    counter-clockwise 90 deg.
   IF d = 360 THEN d = 0
   dir% = CINT(d)
   a3 = ABS(a - x3)
   b3 = ABS(b - y3)
   IF a3 > b3 THEN
      dist% = a3
   ELSE
      dist% = b3
   END IF

END SUB

DEFSNG A-Z
'****************************************************************************
'                                                                      
'   Name:  SectorDecode                                                
'                                                                      
'   Type:  Subprogram                                                  
'                                                                      
'   Version:  1.01                   Date:  22 November 1988          
'                                                                      
'   Programmer:  Christopher C. Nystrom                                
'                                                                      
'   Langauge:    MicroSoft QuickBASIC 4.0                              
'                                                                      
'   Function:    Decodes Quadrant description information.             
'                                                                      
'                                                                      
'   Global Variables:                                                  
'                                                                      
'                                                                      
'   Local Variables:                                                   
'                                                                      
'                                                                      
'                                                                      
'****************************************************************************
'
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

'****************************************************************************
'                                                                      
'   Name:  SectorEncode$                                               
'                                                                      
'   Type:  Function                                                    
'                                                                      
'   Version:  1.01                   Date:  22 November               
'                                                                      
'   Programmer:  Christopher C. Nystrom                                
'                                                                      
'   Langauge:    MicroSoft QuickBASIC 4.0                              
'                                                                      
'   Function:    Encodes string to describe placement of object in     
'                quadrant in terms of sectors.                         
'                                                                      
'   Global Variables:                                                  
'                                                                      
'                                                                      
'   Local Variables:                                                   
'                                                                      
'                                                                      
'                                                                      
'****************************************************************************
'
FUNCTION SectorEncode$ (a%, b!, c!)

   SectorEncode$ = CHR$(a%) + CHR$(CINT(b! - 1) * 10 + CINT(c!))

END FUNCTION

FUNCTION TYPESHIP$ (a%)

   CONST freighter = 12
  
   IF a% = tug THEN
      shiptype$ = "Tug"

   ELSEIF a% = freighter THEN
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

   ELSE
      shiptype$ = ""

   END IF

   TYPESHIP$ = shiptype$

END FUNCTION

