/*
 *    galrec.c
 *
 *    Super Star Trek 95 (v1.1)
 *    Retro Star Trek Game 
 *    Copyright (C) 1995  <Chris Nystrom>
 * 
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 * 
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 * 
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 * 
 *    Contact Author at:
 *
 *    Chris Nystrom
 *
 */

#include <stdio.h>
#include "galaxy.h"
#include "galrec.h"

int iGalRec[GALSIZE + 1][GALSIZE + 1];

void
new_galrec(void)
  {
    register int i, j;

    for (i = 0; i <= GALSIZE; i++)
      for (j = 0; j <= GALSIZE; j++)
        iGalRec[i][j] = UNKNOWN;
  }

void
set_galrec(int i, int j, int k)
  {
    if (i > 0 && i <= GALSIZE && j > 0 && j <= GALSIZE)
      iGalRec[i][j] = k;
  }

int
get_galrec(int i, int j)
  {
    return iGalRec[i][j];
  }

void
write_galrec(FILE *stream)
  {
    fwrite (iGalRec, sizeof (int), (GALSIZE + 1) * (GALSIZE + 1), stream);
  }

void
read_galrec(FILE *stream)
  {
    fread (iGalRec, sizeof (int), (GALSIZE + 1) * (GALSIZE + 1), stream);
  }

