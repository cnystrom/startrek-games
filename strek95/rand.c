/*
 *    rand.c
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
 *    E-Mail: chris@gnu.ai.mit.edu, nystrom@cactus.org, or ccn@cfi.org
 *
 */

#include <stdlib.h>
#include <time.h>
#include "rand.h"

/* Seed the randomizer with the timer */
void
randomize(void)
{
  time_t timer;
  srand ((unsigned) time (&timer));
}

/* Returns an integer from 1 to iSpread */
int
get_rand(int iSpread)
{
  if (iSpread == 0)
    return(1);
  else
    return((rand() % iSpread) + 1);
}

float
rnd(void)
{
  float f;

  f = rand() / (float) RAND_MAX;
  
  return(f);
}

