# startrek-games

Chris Nystrom's Star Trek game sources, grouped in one place.

The maintained Super Star Trek Classic is version 1.2 at
https://github.com/cnystrom/startrek (tag `v1.2`).

The classic copies in this repo are historical and are kept as they
were. They are not the maintained tree. The other folders are other
versions or other games.

## What's in here

- **strek95/** — "Star Trek 95", described on the old programs page as
  "a new re-write of the classic game." The original README calls it a
  total re-write in C of the Super Star Trek game from David Ahl's
  *BASIC Computer Games* (1978), with added features such as impulse
  engines, ranks, and sound. Sources are dated 1995. Now at v1.1, a
  bug-fix release (see `strek95/README` for the changes), plus a 2026
  Windows build fix (Chris's `itoa` helper was renamed so mingw can
  compile it). The original 1995 code, byte-identical to the
  `strek95.tgz` on the old programs site, is preserved at the git tag
  `strek95-orig`.
- **startrek-classic-v1.0/** — Super Star Trek Classic (v1.0), the 1996
  C port as published on cactus.org and as packed in `startrek.tgz`.
  This tree is byte-identical to the `startrek.tgz` on the old programs
  site and to the copy in the hallie source archive. Historical copy,
  kept as it was; see `HISTORY.md`. The maintained version is startrek
  1.2 at https://github.com/cnystrom/startrek.
- **startrek-classic-v1.1-cactus-2006/** — Super Star Trek Classic (v1.1)
  as it appeared as `startrek.c` on the old site. This is labeled v1.1
  in the header, but it is **not** the same file as the v1.1 later
  published at https://github.com/cnystrom/startrek. Historical copy,
  kept as it was; see `HISTORY.md`. The maintained version is startrek
  1.2.
- **niotrek/** — An NIO port of Super Star Trek Classic (v1.1),
  copyright 2002, from the hallie source archive. It includes
  `nio_lib.h` and is not a standalone terminal program. A related
  NIO demo, also named `startrek.c`, is in the nio-jukebox repo at
  `nio/nio_demo_apps/startrek.c`.
- **starbas/** — BASIC source for Chris's "Starbase" / Star Trek-related
  QuickBASIC programs, from the hallie archive. Binaries (`.exe`,
  `.lib`, `.qlb`), binary `.DAT` data files, a binary `sship.doc`, and
  `qb.ini` were stripped. Source, include files, makefiles, batch files,
  and text documentation remain.
  The main program is **Star Battles** (1990): STARBAT, SB, SB2 and
  SBCREATE. Version 2.0 (2026) builds with QB64 Phoenix Edition on modern
  systems; see "Star Battles 2.0" below. The 1990 originals are at the
  git tag `starbas-1990`.

## Origin

`strek95` and the v1.0 classic tree also come from Chris Nystrom's old
programs page, and from the related Classic Computer Game: Star Trek
page (originally on cactus.org):

- https://nystrom.family/chris/old/programs.html
- https://nystrom.family/chris/old/startrek.html

The Star Trek project page is at:

https://nystrom.family/chris/startrek/

All of Chris's code: https://nystrom.family/chris/code/

Copies of the original downloads are on the old site:

- https://nystrom.family/chris/old/startrek.tgz
- https://nystrom.family/chris/old/strek95.tgz
- https://nystrom.family/chris/old/startrek.c
  (the later v1.1 website copy)

`niotrek` and `starbas` are from Chris's personal source archive (the
hallie tree), posted publicly at his request.

`strek95.tar.gz`, also linked from `startrek.html`, is not on the live
page. The content is the same as `strek95.tgz`, which is.

## License

- The classic C port header says you may redistribute and modify it in
  any way you wish, with no warranty. *Star Trek* is noted as a
  trademark of Paramount.
- `strek95` includes a GNU GPL `COPYING` file (the program headers
  should be read with that).
- `niotrek` uses the same classic-port terms plus a 2002 NIO-port
  copyright line.
- `starbas` source has no separate license file in the remaining tree.

See LICENSE for the terms of each tree in this repository.

## Build

- **startrek-classic-v1.0** and **startrek-classic-v1.1-cactus-2006**:
  historical copies, kept as they were. For a maintained build, use
  startrek 1.2 (https://github.com/cnystrom/startrek).
  Default gcc and `-std=gnu89` fail on a modern system because the
  program defines its own `getline`. Both historical trees build with
  `gcc -std=c89 -O0 startrek.c -o startrek -lm`. There are warnings
  about the old `gets()` calls. The code was not modified.
- **strek95** (v1.1): `make` builds it with `cc`. It compiles cleanly
  with gcc and clang in C89 and default modes. A Windows .exe builds
  with `make CC=x86_64-w64-mingw32-gcc`. The original 1995 tree
  (tag `strek95-orig`) named the compiler `acc` and needs
  `make CC=gcc CFLAGS="-std=c89 -g"`.
- **niotrek**: does not compile standalone; it expects NIO headers
  (`nio_lib.h`).
- **starbas**: Star Battles 2.0 builds with QB64 Phoenix Edition; see
  below. The 1990 QuickBASIC 4.5 sources are at tag `starbas-1990`.

## Star Battles 2.0 (2026, QB64 Phoenix Edition)

Star Battles is Chris Nystrom's 1990 QuickBASIC 4.5 space fleet battle game.
Version 2.0 ports it to QB64 Phoenix Edition, which is free and open source,
so it builds and runs on Linux and Windows today (macOS should work too, but
is untested). The code stays Chris's 1990 code. Each line the port had to
change is kept as a `'PE` comment next to its replacement, and
`starbas/PORTING.md` lists every change with its original line number. 2.0
also fixes four bugs in the original:

- Esc in the Weapons menu showed "' has been destroyed, sir." It now backs out.
- In the scenario creator, a Side above 10 crashed the program. Side is now
  1-10.
- A stray quote in the scenario creator was removed.
- The stardate now advances one per turn.

Build (QB64-PE 4.7 or later from
https://github.com/QB64-Phoenix-Edition/QB64pe/releases):

- Linux or macOS: `cd starbas && QB64PE=/path/to/qb64pe ./build-qb64pe.sh game`
- Windows: `cd starbas`, `set QB64PE=C:\path\to\qb64pe.exe`, then
  `build-qb64pe.cmd game`

Play: run `STARBAT` from the game folder for the title screen and
instructions, which then loads the command processor (SB). Run `SBCREATE`
first to build a scenario. It hands off to SB as "Creator": set things up,
end the turn once, then **Save Game**. In a new session choose **Load Game**,
press Enter at the Path prompt to use the game folder, type the scenario name,
and assign fleets to players or the computer. Each player gives orders
(sensors, Director targeting, weapons, navigation). **End Turn** runs SB2,
which moves the ships, resolves combat and returns to SB. Use the arrow keys
and Enter, or the mouse: move to highlight, click to choose. Esc or Quit
backs out of menus.

Prebuilt Windows and Linux downloads are attached to the GitHub release
`starbas-2.0`, not stored in this repository.
