'$INCLUDE: 'STANDARD.INC'

REM $DYNAMIC
DEFSNG A-Z
'
'   TYPE areaType
'      row1     AS INTEGER
'      col1     AS INTEGER
'      row2     AS INTEGER
'      col2     AS INTEGER
'      fgd      AS INTEGER
'      bgd      AS INTEGER
'      edgeline AS INTEGER
'   END TYPE
'
SUB Area (a AS areaType, title$, prompt$) STATIC

' Check that area is on screen
 
      IF a.row1 < 1 OR a.col1 < 1 OR a.row2 > 25 OR a.col2 > 80 THEN
          SCREEN , , 0, 0
          PRINT "Error: Area - part of area is off screen"
          PAUSE
      END IF

' Set the edge characters
 
      SELECT CASE a.edgeLine

      CASE 1
          ul% = 32
          ur% = 32
          ll% = 32
          lr% = 32
          vl% = 32
          hl% = 32

      CASE 2
          ul% = 218
          ur% = 191
          ll% = 192
          lr% = 217
          vl% = 179
          hl% = 196

      CASE 3
          ul% = 201
          ur% = 187
        
          ll% = 200
          lr% = 188
          vl% = 186
          hl% = 205

      CASE 4
          ul% = 213
          ur% = 184
          ll% = 212
          lr% = 190
          vl% = 179
          hl% = 205

      CASE 5
          ul% = 214
          ur% = 183
          ll% = 211
          lr% = 189
          vl% = 186
          hl% = 196

      CASE ELSE
          SCREEN , , 0, 0
          PRINT "Error: Area - Edge line type incorrect"
          PAUSE

      END SELECT

' Calculate length%

      length% = a.col2% - a.col1% - 1

' Set Colors
   
      COLOR a.fgd, a.bgd

' Draw top edge of the box
 
      LOCATE a.row1, a.col1, 0
      PRINT CHR$(ul%); STRING$(length%, hl%); CHR$(ur%);

' Draw the body
 
      FOR r% = a.row1 + 1 TO a.row2 - 1
          LOCATE r%, a.col1, 0
          PRINT CHR$(vl%); SPACE$(length%); CHR$(vl%);
      NEXT r%

' Draw bottom edge of the box
 
      LOCATE a.row2, a.col1, 0
      PRINT CHR$(ll%); STRING$(length%, hl%); CHR$(lr%);

' Center and print top title if present
 
      IF title$ <> "" THEN
          LOCATE a.row1, (a.col1 + a.col2 - LEN(title$) + 1) \ 2, 0
          PRINT title$;
      END IF

' Center and print prompt if present
 
      IF prompt$ <> "" THEN
          LOCATE a.row2, (a.col1 + a.col2 - LEN(prompt$) + 1) \ 2, 0
          PRINT prompt$;
      END IF

END SUB

FUNCTION CURSORLINE%
                       
   CURSORLINE% = 0
   IF CSRLIN = 24 THEN
      PAUSE
      CLS
      CURSORLINE% = 1
   END IF

END FUNCTION

SUB DELAY (Delaytime)

   CONST SecondsInDay = 24& * 60& * 60&
  
   LoopFinish = TIMER + Delaytime
 
'     If DELAY begins before midnight and lasts until after midnight.

   IF LoopFinish > SecondsInDay THEN
      LoopFinish = LoopFinish - SecondsInDay
      DO WHILE TIMER > LoopFinish
      LOOP
   END IF

   DO WHILE TIMER < LoopFinish
   LOOP

END SUB

FUNCTION DELETE$ (a$, a%, b%)

   c% = LEN(a$)

   IF a% < 1 OR a% > c% - b% + 1 THEN
      PRINT "Error in DELETE$ function."
      PAUSE
 
   ELSEIF a% = 1 THEN
      DELETE$ = RIGHT$(a$, c% - b%)

   ELSEIF a% = c% - b% + 1 THEN
      DELETE$ = LEFT$(a$, a% - 1)

   ELSE
      DELETE$ = LEFT$(a$, a% - 1) + RIGHT$(a$, c% - a% - b% + 1)

   END IF

END FUNCTION

SUB DrawBox (row1%, col1%, row2%, col2%)

   wide% = col2% - col1% - 1

   LOCATE row1%, col1%, 0
   PRINT CHR$(201);
   PRINT STRING$(wide%, 205);
   PRINT CHR$(187)

   FOR i = row1% + 1 TO row2% - 1
      LOCATE i, col1%, 0
      PRINT CHR$(186);
      LOCATE i, wide% + 2
      PRINT CHR$(186)
   NEXT i

   LOCATE row2%, col1%, 0
   PRINT CHR$(200);
   PRINT STRING$(wide%, 205);
   PRINT CHR$(188)

END SUB

DEFINT A-Z
SUB FieldEditor (text$, f)

   IF LEN(text$) = 0 THEN
      PRINT " Error: Field size 0. "
      PAUSE
   END IF

   screenWidth = 80

   DEF SEG = 0
   IF PEEK(&H463) = &HB4 THEN
      csrSize = 12
   ELSE
      csrSize = 7
   END IF

   edit$ = SPACE$(LEN(text$))
   LSET edit$ = text$

   txtPos = 1

   leftCol = POS(0)
   IF leftCol + LEN(edit$) > screenWidth THEN
      PRINT " Error: Field cannot fit on screen at current column. "
      PAUSE
   END IF

   PRINT edit$;

   exitFlag = 0
   DO
      LOCATE , leftCol + txtPos - 1, 1

      DO
         ky$ = INKEY$
      LOOP UNTIL LEN(ky$)

      IF LEN(ky$) = 1 THEN
         keyCode = ASC(ky$)
      ELSE
         keyCode = -ASC(RIGHT$(ky$, 1))
      END IF

      SELECT CASE keyCode

         CASE 8   ' BackSpace
            IF txtPos > 1 THEN txtPos = txtPos - 1
            LOCATE , leftCol + txtPos - 1, 0
            IF txtPos > 0 THEN
               IF insert THEN
                  MID$(edit$, txtPos) = MID$(edit$, txtPos + 1) + " "
               ELSE
                  MID$(edit$, txtPos) = " "
               END IF
               PRINT MID$(edit$, txtPos);
            END IF

         CASE 13   '   Return
            exitFlag = 1
            EXIT DO

         CASE 27   '   Escape
            exitFlag = 2
            EXIT DO

         CASE 32 TO 254
            IF f = 0 OR (keyCode > 47 AND keyCode < 58) THEN
               LOCATE , , 0
               IF insert THEN
                  MID$(edit$, txtPos) = ky$ + MID$(edit$, txtPos)
                  PRINT MID$(edit$, txtPos);
               ELSE
                  MID$(edit$, txtPos) = ky$
                  PRINT ky$;
               END IF
               IF txtPos < LEN(edit$) THEN txtPos = txtPos + 1
            END IF

         CASE -75   '   Left Arrow
            IF txtPos > 1 THEN txtPos = txtPos - 1

         CASE -77   '   Right Arrow
            IF txtPos < LEN(edit$) THEN txtPos = txtPos + 1

         CASE -71   '   Home
            txtPos = 1

         CASE -79   '   End
            FOR i = LEN(edit$) TO 1 STEP -1
               IF MID$(edit$, i, 1) <> " " THEN EXIT FOR
            NEXT
            txtPos = i + 1
            IF txtPos > LEN(edit$) THEN txtPos = LEN(edit$)

         CASE -82   '   Insert
            insert = NOT insert
            IF insert THEN
               LOCATE , , , csrSize / 2, csrSize
            ELSE
               LOCATE , , , csrSize - 1, csrSize
            END IF
       
         CASE -83   '   Delete
            MID$(edit$, txtPos) = MID$(edit$, txtPos + 1) + " "
            LOCATE , , 0
            PRINT MID$(edit$, txtPos);

         CASE ELSE
         
      END SELECT

   LOOP WHILE exitFlag = 0

   IF exitFlag = 1 THEN text$ = edit$

END SUB

DEFSNG A-Z
FUNCTION INTRND% (a%)

   IF a% = 0 THEN
      INTRND% = 0
   ELSE
      INTRND% = INT(a% * RND + 1)
   END IF

END FUNCTION

FUNCTION LASTCHAR% (a$, b$)

   a% = LEN(a$)
   counter% = 0
   c$ = a$
   DO WHILE RIGHT$(c$, 1) <> b$
      counter% = counter% + 1
      IF LEN(c$) = 1 THEN
         LASTCHAR% = -1
         EXIT FUNCTION
      END IF
      c$ = LEFT$(c$, LEN(c$) - 1)
   LOOP
   LASTCHAR% = a% - counter%

END FUNCTION

DEFINT A-Z
'
'   TYPE menuType
'      action     AS INTEGER
'      numCol     AS INTEGER
'      row        AS INTEGER
'      col        AS INTEGER
'      fgd        AS INTEGER
'      bgd1       AS INTEGER
'      bgd2       AS INTEGER
'      edgeline   AS INTEGER
'      returnCode AS INTEGER
'   END TYPE
'
SUB MouseMenu (m AS menuType, mText$(), mTitle$, mPrompt$) STATIC

   CONST MICK = 17

' Determine array bounds
   
   lbText% = LBOUND(mText$)
   totNum% = UBOUND(mText$)
 
' Check the text array bounds, lower always 1, upper > 0
   
   IF lbText% <> 1 OR totNum% < 1 THEN
      SCREEN , , 0, 0
      PRINT "Error: Menu - Text array dimensioned incorrectly."
      PAUSE
   END IF
 
' Trim spaces and determine longest string in the text array
   
   length% = 0
   FOR i% = 1 TO totNum%
      mText$(i%) = TRIM$(mText$(i%))
      temp% = LEN(mText$(i%))
      IF temp% > length% THEN length% = temp%
   NEXT i%

' Center all text arrays

   IF m.center = 1 THEN
      FOR i% = 1 TO totNum%
         addlen% = (length% - LEN(mText$(i%))) / 2
         IF addlen% THEN
            mText$(i%) = SPACE$(addlen%) + mText$(i%) + SPACE$(addlen%)
         END IF
         IF LEN(mText$(i%)) > length% THEN
            mText$(i%) = RIGHT$(mText$(i%), length%)
         END IF
         IF LEN(mText$(i%)) < length% THEN
            mText$(i%) = mText$(i%) + " "
         END IF
      NEXT i%
   END IF

'  Add spaces to front and back of strings.

   FOR i% = 1 TO totNum%
      mText$(i%) = " " + mText$(i%) + " "
   NEXT i%

   length% = length% + 2

' Determine the bottom right corner of window
 
   totRow% = CINT(totNum% / m.numCol + .49)
   totCol% = m.numCol * length%
 
   row2% = m.row + totRow% + 1
   col2% = m.col + totCol% + 1

' Draw the area

   IF m.edgeLine < 0 THEN
      rw% = m.row
      cl% = m.col

   ELSEIF m.edgeLine = 0 THEN
      rw% = m.row - 1
      cl% = m.col - 1

   ELSE
      DIM a1 AS areaType
         a1.row1 = m.row
         a1.col1 = m.col
         a1.row2 = row2%
         a1.col2 = col2%
         a1.fgd = m.fgd
         a1.bgd = m.bgd1
         a1.edgeLine = m.edgeLine
      CALL Area(a1, mTitle$, mPrompt$)
      rw% = m.row
      cl% = m.col
 
   END IF

' Print the menu
 
   IF m.edgeLine > -1 THEN
      COLOR m.fgd, m.bgd2
      counter% = 1
      FOR c% = 1 TO totCol% STEP length%
         FOR r% = 1 TO totRow%
            LOCATE r% + rw%, c% + cl%, 0
            IF counter% <= totNum% THEN
               PRINT mText$(counter%);
            ELSE
               PRINT SPACE$(length%);
            END IF
            counter% = counter% + 1
         NEXT r%
      NEXT c%
   END IF

'  Build trace table

   REDIM trace%(totNum%, 4)
   counter% = 1
   FOR i = 1 TO totNum%
       
      trace%(i, 1) = i - 1                   ' Up
      IF counter% = 1 THEN trace%(i, 1) = 0

      trace%(i, 2) = i + 1                 ' Down
      IF counter% = totRow% THEN trace%(i, 2) = 0

      IF i > totRow% THEN                  ' Left
         trace%(i, 3) = i - totRow%
      END IF
    
      IF i + totRow% <= totNum% THEN        ' Right
         trace%(i, 4) = i + totRow%
      END IF

      counter% = counter% + 1
      IF counter% > totRow% THEN counter% = 1

   NEXT i

'  Take next action based on action code
 
   SELECT CASE m.action

   CASE 1
   
      BEEP
      m.returnCode = 0
      DO
      LOOP WHILE INKEY$ = ""
   
   CASE 2
   
      BEEP

      '   Set choice pointer to last selection if known
     
      IF m.returnCode > 0 AND m.returnCode < totNum% THEN
         ptr% = m.returnCode
         m.returnCode = 0
      ELSE
         ptr% = 1
      END IF
   
      IF ptr% > 1 THEN
         lastPtr% = 1
      ELSEIF totNum% > 1 THEN
         lastPtr% = 2
      ELSE
         lastPtr% = 1
         flag% = 1
      END IF

      '   Main loop, monitor mouse and keyboard
    
      DO
         
         '   Update the highlight

         IF ptr% <> lastPtr% OR flag% = 1 THEN
          
            COLOR m.fgd, m.bgd2
            a% = 0
            FOR i = 1 TO m.numCol
               IF lastPtr% > (totRow% * i) THEN a% = i
            NEXT i
            row% = rw% + lastPtr% - (totRow% * a%)
            col% = cl% + (length% * a%) + 1
            LOCATE row%, col%, 0
            PRINT mText$(lastPtr%);
            
            COLOR m.bgd2, m.fgd
            a% = 0
            FOR i = 1 TO m.numCol
               IF ptr% > (totRow% * i) THEN a% = i
            NEXT i
            row% = rw% + ptr% - (totRow% * a%)
            col% = cl% + (length% * a%) + 1
            LOCATE row%, col%, 0
            PRINT mText$(ptr%);
  
            lastPtr% = ptr%
       
         END IF

         '   Clear any mouse mickey counts
         DO
            Mouse 11, 0, horizontal%, vertical%
         LOOP WHILE horizontal% <> 0 OR vertical% <> 0
         flag% = 0
         horizmics% = 0
         vertmics% = 0
       
         DO
               
            keyval$ = INKEY$
          
            Mouse 3, m2%, m3%, m4%
               leftButton% = ((m2% AND 1) <> 0)
               rightButton% = ((m2% AND 2) <> 0)
            Mouse 11, 0, horizontal%, vertical%
               
            vertmics% = vertmics% + vertical%
            horizmics% = horizmics% + horizontal%
            
            IF keyval$ <> "" THEN flag% = 1

            IF horizmics% > MICK THEN flag% = 2
            IF horizmics% < -MICK THEN flag% = 3
            IF vertmics% > MICK THEN flag% = 4
            IF vertmics% < -MICK THEN flag% = 5
            IF leftButton% THEN flag% = 6

            IF m.mtime = 1 THEN
               COLOR white, black
               LOCATE m.trow, m.tcol
               PRINT TIME$;
            END IF

         LOOP WHILE flag% = 0

         IF keyval$ = CHR$(27) THEN
            m.returnCode% = 0
            EXIT DO

         ELSEIF (keyval$ = CHR$(0) + CHR$(up) OR flag% = 5) THEN
            ptr% = trace%(ptr%, 1)
            IF ptr% = 0 THEN ptr% = lastPtr%

         ELSEIF (keyval$ = CHR$(0) + CHR$(down) OR flag% = 4) THEN
            ptr% = trace%(ptr%, 2)
            IF ptr% = 0 THEN ptr% = lastPtr%

         ELSEIF (keyval$ = CHR$(0) + CHR$(left) OR flag% = 3) THEN
            ptr% = trace%(ptr%, 3)
            IF ptr% = 0 THEN ptr% = lastPtr%

         ELSEIF (keyval$ = CHR$(0) + CHR$(right) OR flag% = 2) THEN
            ptr% = trace%(ptr%, 4)
            IF ptr% = 0 THEN ptr% = lastPtr%

         ELSEIF keyval$ = CHR$(ENTER) OR flag% = 6 THEN
            DO
               Mouse 3, m2%, m3%, m4%
               leftButton% = ((m2% AND 1) <> 0)
               rightButton% = ((m2% AND 2) <> 0)
            LOOP WHILE leftButton%
            m.returnCode% = ptr%
            EXIT DO

         END IF
         IF ptr% > totNum% THEN ptr% = totNum%

      LOOP

   CASE ELSE
      m.returnCode = 0
 
   END SELECT

END SUB

DEFSNG A-Z
' ************************************************
' **  Name:          MouseMickey                **
' **  Type:          Subprogram                 **
' **  Module:        MOUSSUBS.BAS               **
' **  Language:      Microsoft QuickBASIC 4.00  **
' ************************************************
'
SUB MouseMickey (horizontal%, vertical%) STATIC
 
   Mouse 11, 0, horizontal%, vertical%

END SUB

' ************************************************
' **  Name:          MouseNow                   **
' **  Type:          Subprogram                 **
' **  Module:        MOUSSUBS.BAS               **
' **  Language:      Microsoft QuickBASIC 4.00  **
' ************************************************
'
SUB MouseNow (leftButton%, rightButton%, xMouse%, yMouse%) STATIC

   Mouse 3, m2%, xMouse%, yMouse%
   leftButton% = ((m2% AND 1) <> 0)
   rightButton% = ((m2% AND 2) <> 0)

END SUB

FUNCTION PAD$ (a%, b%)

   a$ = LTRIM$(RTRIM$(STR$(a%)))
   c% = LEN(a$)

   IF c% < b% THEN
     c% = b% - c%
     FOR i = 1 TO c%
        a$ = "0" + a$
     NEXT i
   END IF

   PAD$ = a$

END FUNCTION

SUB PAUSE

   LOCATE 25, 13
   PRINT "Press any key or click left mouse button to continue.";

   BEEP

   DO
      MouseNow leftButton%, rightButton%, xMouse%, yMouse%
   LOOP WHILE leftButton% = 0 AND INKEY$ = ""
   
'     Ensure left mouse button has been let up

   DO
      MouseNow leftButton%, rightButton%, xMouse%, yMouse%
   LOOP WHILE leftButton%

   LOCATE 25, 13
   PRINT SPACE$(65);

END SUB

FUNCTION TRIM$ (a$)

   TRIM$ = LTRIM$(RTRIM$(a$))

END FUNCTION

