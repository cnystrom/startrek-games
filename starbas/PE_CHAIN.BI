'
'   PE_CHAIN.BI  -  QB64 Phoenix Edition port shim (not part of the 1990 original)
'
'   QuickBASIC CHAIN kept the COMMON block in memory while it loaded the next
'   program. QB64-PE only implements CHAIN on Windows, so the port does it the
'   same way everywhere: GOSUB PEChain saves every COMMON variable from
'   STARBAT.INC to SBCHAIN.TMP, starts the next program with /CHAIN, and exits.
'   The code at the top of this file loads SBCHAIN.TMP back when started that way.
'   Included once per program from START.INC (module level).
'
' The game keeps per-ship message files at ENVIRON$("TMP") + "n.TMP" and clears
' them with KILL ... "*.TMP". Modern systems set TMP to a shared folder with no
' trailing slash, so point it at the game folder (empty = current folder, as on
' a DOS machine without TMP set).
ENVIRON "TMP="

IF INSTR(UCASE$(COMMAND$), "/CHAIN") > 0 AND _FILEEXISTS("SBCHAIN.TMP") THEN
   peF% = FREEFILE
   OPEN "SBCHAIN.TMP" FOR BINARY AS #peF%
   GET #peF%, , debug%
   GET #peF%, , progMode%
   GET #peF%, , quadsize%
   GET #peF%, , stardate%
   GET #peF%, , totFleetNum%
   GET #peF%, , totPlayerNum%
   GET #peF%, , totshipnum%
   GET #peF%, , totsidenum%
   GET #peF%, , turn%
   GET #peF%, , m1
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM c%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , c%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM control%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , control%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM damge%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , damge%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM direction%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , direction%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM distance%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , distance%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM q%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , q%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM status%(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , status%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&: GET #peF%, , peU2&
      REDIM location$(peU1&, peU2&)
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         GET #peF%, , peL&: peS$ = SPACE$(peL&): GET #peF%, , peS$: location$(peI&, peJ&) = peS$
      NEXT peJ&, peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&
      REDIM message$(peU1&)
      FOR peI& = 0 TO peU1&
         GET #peF%, , peL&: peS$ = SPACE$(peL&): GET #peF%, , peS$: message$(peI&) = peS$
      NEXT peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&
      REDIM playerName$(peU1&)
      FOR peI& = 0 TO peU1&
         GET #peF%, , peL&: peS$ = SPACE$(peL&): GET #peF%, , peS$: playerName$(peI&) = peS$
      NEXT peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&
      REDIM fleet(peU1&) AS fleets
      FOR peI& = 0 TO peU1&
         GET #peF%, , fleet(peI&)
      NEXT peI&
   END IF
   GET #peF%, , peOK%
   IF peOK% THEN
      GET #peF%, , peU1&
      REDIM ship(peU1&) AS ships
      FOR peI& = 0 TO peU1&
         GET #peF%, , ship(peI&)
      NEXT peI&
   END IF
   CLOSE #peF%
   KILL "SBCHAIN.TMP"
END IF
GOTO PEChainEnd

PEChain:   ' in: peTarget$ = program name as written in the original CHAIN
   peF% = FREEFILE
   IF _FILEEXISTS("SBCHAIN.TMP") THEN KILL "SBCHAIN.TMP"
   OPEN "SBCHAIN.TMP" FOR BINARY AS #peF%
   PUT #peF%, , debug%
   PUT #peF%, , progMode%
   PUT #peF%, , quadsize%
   PUT #peF%, , stardate%
   PUT #peF%, , totFleetNum%
   PUT #peF%, , totPlayerNum%
   PUT #peF%, , totshipnum%
   PUT #peF%, , totsidenum%
   PUT #peF%, , turn%
   PUT #peF%, , m1
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(c%, 1): peU2& = UBOUND(c%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , c%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(control%, 1): peU2& = UBOUND(control%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , control%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(damge%, 1): peU2& = UBOUND(damge%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , damge%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(direction%, 1): peU2& = UBOUND(direction%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , direction%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(distance%, 1): peU2& = UBOUND(distance%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , distance%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(q%, 1): peU2& = UBOUND(q%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , q%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(status%, 1): peU2& = UBOUND(status%, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         PUT #peF%, , status%(peI&, peJ&)
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(location$, 1): peU2& = UBOUND(location$, 2)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&: PUT #peF%, , peU2&
      FOR peI& = 0 TO peU1&: FOR peJ& = 0 TO peU2&
         peS$ = location$(peI&, peJ&): peL& = LEN(peS$): PUT #peF%, , peL&: PUT #peF%, , peS$
      NEXT peJ&, peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(message$, 1)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&
      FOR peI& = 0 TO peU1&
         peS$ = message$(peI&): peL& = LEN(peS$): PUT #peF%, , peL&: PUT #peF%, , peS$
      NEXT peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(playerName$, 1)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&
      FOR peI& = 0 TO peU1&
         peS$ = playerName$(peI&): peL& = LEN(peS$): PUT #peF%, , peL&: PUT #peF%, , peS$
      NEXT peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(fleet, 1)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&
      FOR peI& = 0 TO peU1&
         PUT #peF%, , fleet(peI&)
      NEXT peI&
   END IF
   peOK% = -1: ON ERROR GOTO PEChainNoArray
   peU1& = UBOUND(ship, 1)
   ON ERROR GOTO 0
   PUT #peF%, , peOK%
   IF peOK% THEN
      PUT #peF%, , peU1&
      FOR peI& = 0 TO peU1&
         PUT #peF%, , ship(peI&)
      NEXT peI&
   END IF
   CLOSE #peF%
   CALL PELaunch(peTarget$, " /CHAIN")   ' in PE_SHIMS.BM

PEChainNoArray:   ' array never dimensioned: nothing to pass
   peOK% = 0
   RESUME NEXT

PEChainEnd:
