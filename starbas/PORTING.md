# Star Battles on QB64 Phoenix Edition

This folder is Chris Nystrom's 1990 QuickBASIC 4.5 Star Battles (STARBAT, SB, SB2,
SBCREATE), ported to build with QB64 Phoenix Edition (tested with 4.7.0) on Linux
and Windows. The original code and authorship are unchanged. Each original line
that had to change is still in the file as a comment that starts with `'PE`, and
the new line below it says why.

## Build

Get QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases (free,
open source). Then:

* Linux or macOS: `QB64PE=/path/to/qb64pe ./build-qb64pe.sh game`
* Windows: `set QB64PE=C:\qb64pe\qb64pe.exe` and then `build-qb64pe.cmd game`

Both scripts compile the four programs into `game/` and copy SBINST.DOC,
SBCRINST.DOC and CREATION.DOC next to them.

## Run

Run from the game folder: `./STARBAT` (Windows: `STARBAT.exe`). To make a
scenario first, run `SBCREATE`. It hands off to SB as "Creator". Use Save Game
there, then Load Game in a normal session. At the Path prompt, press Enter for the
game folder. Scenarios are saved as NAME.DAT in the game folder.

## Files added for the port

| File | Purpose |
|---|---|
| PE_STARBAT.BAS, PE_SB.BAS, PE_SB2.BAS, PE_SBCREATE.BAS | Build files. Each one `$INCLUDE`s the same modules its .MAK file listed. QB64 builds one program per file. SBCREATE.MAK listed FLDEDIT.BAS, which is not in the archive. FieldEditor is in STANDARD.BAS, so that file is used instead. |
| PE_CHAIN.BI | CHAIN and COMMON emulation (see change 3). |
| PE_SHIMS.BM | `Mouse`, which replaces the INT 33h routine from MIXED.LIB (functions 3 and 11, the only ones used), and `PELaunch`, which starts the next program. |
| build-qb64pe.sh, build-qb64pe.cmd | Build scripts. |

## Changes to original files (original line numbers)

File names are upper case, as on DOS, because the code includes and opens them
that way (for example `'$INCLUDE: 'STARBAT.INC'` and `SBINST.DOC`). Linux is case
sensitive. In the repo they are lower case, so the staged copy renames them.

1. **STARBAT.INC, top and end; STANDARD.INC, top and end:** added an
   `$IF ..._INC = UNDEFINED` include guard. Every module includes STARBAT.INC.
   With all modules in one QB64 program, the TYPEs, CONSTs and START.INC code
   would be defined twice. The DOS end-of-file byte (Ctrl-Z) at STARBAT.INC line
   189 was dropped because it sat inside the guard.
2. **STARBAT.INC lines 95-116** (the 22 `COMMON` lines): each one is kept as a
   `'PE COMMON` comment and declared with `DIM` instead. QB64-PE puts COMMON arrays
   in its emulated DOS memory, and that crashed SBCREATE (a segfault at line 190,
   `fleet(i).fleetName = fltN$`, where the array descriptor was overwritten). The
   SUBs still get these variables through their own `SHARED` lines, as before.
3. **CHAIN: STARBAT.BAS line 125, SB.BAS line 56, SB2.BAS line 40, SBCREATE.BAS
   line 1279:** `CHAIN "X"` became `peTarget$ = "X": GOSUB PEChain`. QB64-PE only
   implements CHAIN on Windows. PE_CHAIN.BI writes every COMMON variable to
   SBCHAIN.TMP, starts the next program with `/CHAIN`, and exits. The next
   program reads the file back at startup and deletes it.
4. **START.INC, after line 6 (`start:`):** added `'$INCLUDE: 'PE_CHAIN.BI'`. This
   is the module-level code that every main program runs first.
5. **SBCREATE.BAS line 166 and lines 200-203:** the `FRE(1)` string-space checks
   were commented out. QB64 has no `FRE(1)`, and memory is not a limit.
6. **SBLIB.BAS line 371 (EndGame, "Play another game"):** `RUN "SB"` became
   `CALL PELaunch("SB", "")`. On Linux, QB64's RUN calls `system("SB")`, which is
   not on the PATH and would block.
7. **SBLIB.BAS line 641 (SBLoad):** the default Path changed from `"A:\"` to blank
   (the game folder). On Windows there is usually no floppy drive A:, and on Linux
   the old default made a file literally named `A:\NAME.DAT`.
8. **TMP folder (PE_CHAIN.BI, no change to original lines):** the game writes
   messages to `ENVIRON$("TMP") + "n.TMP"` and cleans up with
   `KILL ... + "*.TMP"`. On Windows, TMP is set and has no trailing backslash,
   which would scatter files in the parent folder. The port clears TMP at startup
   so these files live in the game folder, as on a DOS PC with no TMP set.

Not changed, because QB64-PE handles them: SCREEN 0 text pages and colors, `DEF SEG
= 0: PEEK(&H463)`, PLAY, SOUND and BEEP, `ON KEY(10)`, LPRINT (only used if you
answer Yes to "Send output to printer"), and the fixed-length binary save files.

## Bug fixes in 2.0

Each fix keeps the original line as a `'PE fix:` comment. Line numbers are
from the 1990 files.

1. **SB.BAS line 2413 (SelectWeapons):** Esc returned 0, but
   `IF selection% = 0 THEN selection% = x% + 1` ran before
   `selection% = m1.returnCode`, so the menu called DeviceOp with device 0 and
   showed "' has been destroyed, sir." The check now follows the assignment, so
   Esc acts as Quit. Lines 580, 2054, 2163 and 2285 already had the right order,
   so Esc worked there and they are unchanged.
2. **SBCREATE.BAS lines 213-214:** Side was accepted from 1 to 250, but line 281
   prints `side$(ship(i).side)` and `side$()` has only 10 entries, so Side 11 or
   higher stopped with "Subscript out of range". The prompt now says
   "Side (1-10)" and re-asks for anything outside `UBOUND(side$)`.
3. **SBCREATE.BAS line 70:** removed the stray quote after `"Phesian"`.
4. **SB2.BAS ProcessMoves (lines 1445 and 1474):** the stardate never moved. It
   now goes up by 1 each turn, next to `turn% = turn% + 1`, and
   `SHARED stardate%` was added so ProcessMoves can see it. SBCREATE starts
   scenarios at stardate 2500-2999, so one stardate per turn fits.

Not changed: when a prompt such as Side re-asks, the old input stays on screen
under the new one. This is the original INPUT/LOCATE behavior, and it is only
cosmetic.
