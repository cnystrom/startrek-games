'
'   SOUNDFX.BAS      v0.10
'
'   ChrisNystrom     22 November 1989
'
'   Microsoft QickBASIC 4.5
'
'
DECLARE SUB ElectronicSounds ()
DECLARE SUB WhoopSiren ()
DECLARE SUB TorpedoSound ()
DECLARE SUB PhaserSound ()
DECLARE SUB GeneratorOffSound ()
DECLARE SUB GeneratorOnSound ()
DECLARE SUB MachinerySound ()
DECLARE SUB LRSound ()
DECLARE SUB SRSound ()
DECLARE SUB ScannerSound ()
DECLARE SUB ShieldUpSound ()
DECLARE SUB ShieldDownSound ()

'$INCLUDE: 'STARBAT.INC'

REM $DYNAMIC
DEFSNG A-Z
SUB ElectronicSounds

   FOR x = 1 TO 20
      SOUND (2000 * RND) + 37, 1
   NEXT x

END SUB

SUB GeneratorOffSound

   FOR x = 1000 TO 37 STEP -5
      SOUND x, .2
      SOUND 2 * x, .2
      SOUND 3 * x, .2
   NEXT

END SUB

SUB GeneratorOnSound

   FOR x = 37 TO 1000 STEP 5
      SOUND x, .2
      SOUND 2 * x, .2
      SOUND 3 * x, .2
   NEXT

END SUB

SUB LRSound

   SOUND 60, 2
   DELAY (2)
   SOUND 60, 2
   DELAY (2)
   SOUND 60, 2

END SUB

SUB MachinerySound

   FOR i = 1 TO 3
      FOR x = 400 TO 100 STEP -10
         SOUND x, .2
         SOUND x / 2 + 37, .2
         SOUND x / 3 + 37, .2
      NEXT x
   NEXT i

END SUB

SUB PhaserSound

   FOR i = 1 TO 5
      FOR x = 300 TO 1800 STEP 100
         SOUND x, .2
      NEXT x
   NEXT i
   FOR x = 100 TO 1000 STEP 100
      SOUND x, .2
   NEXT x
   FOR x = 1000 TO 100 STEP -10
      SOUND x, .2
   NEXT x
  
END SUB

SUB ScannerSound

   FOR i = 1 TO 20
      SOUND 10000, .2
      SOUND 5000, .2
      SOUND 3000, .2
   NEXT i

END SUB

SUB ShieldDownSound

   FOR x = 10000 TO 1000 STEP -1000
      SOUND x, .2
      SOUND x / 2, .2
      SOUND x / 3 + 5, .2
   NEXT x

END SUB

SUB ShieldUpSound

   FOR x = 100 TO 10000 STEP 1000
      SOUND x, .2
      SOUND x / 2, .2
      SOUND x / 3 + 5, .2
   NEXT x

END SUB

SUB SRSound
   
   SOUND 90, 2
   DELAY (1)
   SOUND 90, 2
   DELAY (1)
   SOUND 90, 2

END SUB

SUB TorpedoSound
  
   FOR x = 100 TO 10000 STEP 500
      SOUND x, .2
      SOUND x / 2, .2
      SOUND x / 3 + 5, .2
   NEXT x
   SOUND 40, 10
  
END SUB

SUB WhoopSiren

   FOR i = 1 TO 3
      FOR a = 900 TO 1000
         SOUND a, .2
      NEXT
   NEXT i

END SUB

