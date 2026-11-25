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

TYPE areaType

   row1     AS INTEGER
   col1     AS INTEGER
   row2     AS INTEGER
   col2     AS INTEGER
   fgd      AS INTEGER
   bgd      AS INTEGER
   edgeLine AS INTEGER

END TYPE

TYPE menuType

   action     AS INTEGER
   numCol     AS INTEGER
   row        AS INTEGER
   col        AS INTEGER
   fgd        AS INTEGER
   bgd1       AS INTEGER
   bgd2       AS INTEGER
   edgeLine   AS INTEGER
   center     AS INTEGER
   mtime      AS INTEGER
   trow       AS INTEGER
   tcol       AS INTEGER
   returnCode AS INTEGER

END TYPE

DECLARE FUNCTION CURSORLINE% ()
DECLARE FUNCTION DELETE$ (a$, a%, b%)
DECLARE FUNCTION INTRND% (a%)
DECLARE FUNCTION LASTCHAR% (a$, b$)
DECLARE FUNCTION PAD$ (a%, b%)
DECLARE FUNCTION TRIM$ (a$)

DECLARE SUB Area (a AS areaType, title$, prompt$)
DECLARE SUB DELAY (Delaytime!)
DECLARE SUB DrawBox (row1%, col1%, row2%, col2%)
DECLARE SUB FieldEditor (text$, f%)
DECLARE SUB Interrupt (intnum%, inreg AS RegType, outreg AS RegType)
DECLARE SUB Mouse (m1%, m2%, m3%, m4%)
DECLARE SUB MouseMenu (m AS menuType, mText$(), mTitle$, mPrompt$)
DECLARE SUB MouseMickey (horizontal, vertical%)
DECLARE SUB MouseNow (leftButton%, rightButton%, xMouse%, yMouse%)
DECLARE SUB PAUSE ()
DECLARE SUB ScreenNew (page%, a%)
DECLARE SUB ScreenPop (page%)
DECLARE SUB ScreenPush (page%)

CONST FALSE = 0
CONST TRUE = NOT FALSE

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

