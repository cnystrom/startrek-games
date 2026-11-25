# startrek-games

Chris Nystrom's Star Trek game sources, grouped in one place.

This repo does **not** replace the already-published v1.1 tree at
https://github.com/cnystrom/startrek (sha256 of that `startrek.c` starts
`1c7b20569f1a4b74...`). The copies here are other versions or other
games, kept so those are not duplicated as a second `startrek` repo.

## What's in here

- **strek95/** — "Star Trek 95", described on the old programs page as
  "a new re-write of the classic game." The original README calls it a
  total re-write in C of the Super Star Trek game from David Ahl's
  *BASIC Computer Games* (1978), with added features such as impulse
  engines, ranks, and sound. Sources are dated 1995. Byte-identical to
  the `strek95.tgz` on the old programs site.
- **startrek-classic-v1.0/** — Super Star Trek Classic (v1.0), the 1996
  C port as published on cactus.org and as packed in `startrek.tgz`.
  This tree is byte-identical to the `startrek.tgz` on the old programs
  site and to the copy in the hallie source archive.
- **startrek-classic-v1.1-cactus-2006/** — Super Star Trek Classic (v1.1)
  as it appeared as `startrek.c` on the old site. This is labeled v1.1
  in the header, but it is **not** the same file as the already-published
  GitHub repo (39708 bytes here vs 41660 bytes there).
- **niotrek/** — An NIO port of Super Star Trek Classic (v1.1),
  copyright 2002, from the hallie source archive. It includes
  `nio_lib.h` and is not a standalone terminal program.
- **starbas/** — BASIC source for Chris's "Starbase" / Star Trek-related
  QuickBASIC programs, from the hallie archive. Binaries (`.exe`,
  `.lib`, `.qlb`), binary `.DAT` data files, a binary `sship.doc`, and
  `qb.ini` were stripped. Source, include files, makefiles, batch files,
  and text documentation remain.

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

## Build

- **startrek-classic-v1.0** and **startrek-classic-v1.1-cactus-2006**:
  default gcc and `-std=gnu89` fail on a modern system because the
  program defines its own `getline`. Both build with
  `gcc -std=c89 -O0 startrek.c -o startrek -lm`. There are warnings
  about the old `gets()` calls. The code was not modified.
- **strek95**: the Makefile names the compiler `acc`. As written, `make`
  fails here (`acc` not found). It builds with
  `make CC=gcc CFLAGS="-std=c89 -g"` and links with `-lm`. Default gcc
  (no `-std=c89`) fails on implicit `int`. The Makefile in the tree was
  not edited.
- **niotrek**: does not compile standalone; it expects NIO headers
  (`nio_lib.h`).
- **starbas**: QuickBASIC / DOS sources; not compiled here.
