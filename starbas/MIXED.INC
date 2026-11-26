'$DYNAMIC

DEFINT A-Z

TYPE RegType

   ax    AS INTEGER
   bx    AS INTEGER
   cx    AS INTEGER
   dx    AS INTEGER
   Bp    AS INTEGER
   si    AS INTEGER
   di    AS INTEGER
   flags AS INTEGER

END TYPE

DECLARE SUB Mouse (m1%, m2%, m3%, m4%)
DECLARE SUB Interrupt (intnum%, inreg AS RegType, outreg AS RegType)

CONST ENTER = 13
CONST up = 72
CONST down = 80
CONST left = 75
CONST right = 77

CONST black = 0
CONST blue = 1
CONST green = 2
CONST cyan = 3
CONST red = 4
CONST magenta = 5
CONST brown = 6
CONST white = 7
CONST gray = 8
CONST lightblue = 9
CONST lightgreen = 10
CONST lightcyan = 11
CONST lightred = 12
CONST lightmagenta = 13
CONST yellow = 14
CONST brightwhite = 15
CONST blink = 16


