/*
 *    sound.c
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
#include "sound.h"

#ifndef FALSE
#define FALSE        0
#endif

#ifndef TRUE
#define TRUE         ! FALSE
#endif

#ifndef BEL
#define BEL          7
#endif

#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202000L
typedef int bool;   /* bool is a keyword from C23 on */
#endif

bool iSound=TRUE;

void
toggle_sound(void)
{
  if (iSound)
    {
      iSound = FALSE;
      printf("Sound off.\n\n");
    }
  else
    {
      iSound = TRUE;
      beep();
      printf("Sound on.\n\n");
    }
}

/* And it has multi-media support... */
void
beep (void)
{
  if (iSound)
    putchar (BEL);
}

