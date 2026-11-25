/*
 *    disk_io.c
 *
 *    Super Star Trek 95 (v1.0)
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
 *    E-Mail: chris@gnu.ai.mit.edu, nystrom@cactus.org, or ccn@cfi.org
 *
 */

#include <stdio.h>
#include <string.h>
#include "disk_io.h"

#ifndef FALSE
#define FALSE  0
#endif

#ifndef TRUE
#define TRUE   ! FALSE
#endif

#ifndef MAXCOL
#define MAXCOL  80
#endif

typedef int bool;

FILE *stream;
bool bFlag = FALSE;   /* Prevent multiple file opens */

int
openfile(char * sFilename, char * sMode)
{
  if (bFlag || (stream = fopen (sFilename, sMode)) == NULL)
    {
      fprintf (stderr, "\nError - Unable to open file: %s.\n\n", sFilename);
      return 1;
    }

  bFlag = TRUE;

  return 0;
}

void
closefile(void)
{
  if (! bFlag)
    fclose(stream);

  bFlag = FALSE;
}

int
getline(char *s)
{
  if (fgets(s, MAXCOL, stream) == NULL)
    return(0);
  else
    return(strlen(s));
}

void
write_int(int *i)
{
  fwrite (i, sizeof (int), 1, stream);
}

void
read_int(int *i)
{
  fread (i, sizeof (int), 1, stream);
}

/* The following two routines handle file io for a square block
   of integers */

void
write_int_array(int *array, int iSize)
{
  fwrite (array, sizeof (int), iSize ^ 2, stream);
}

void
read_int_array(int *array, int iSize)
{
  fread (array, sizeof (int), iSize ^ 2, stream);
}

