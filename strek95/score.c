/*
 *    score.c
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
#include "stardate.h"
#include "galaxy.h"

void print_score(void);

float fScore;

void
new_score(void)
{
  fScore = 0;
}

void
add_score(int i)
{
  fScore = fScore + i;
}

void
sub_score(int i)
{
  fScore = fScore - i;
}

float
get_score(void)
{
  return(fScore);
}

void
print_score(void)
{
  printf("Score = %4.2f\n", fScore);
}

float
get_rating(void)
{
  int i, j;
  float fRating;

  i = get_elapsed_time();
  j = get_tot_klingons();

  if  (i > 0)
    {
      fRating = (float) j / i;
      fRating = 1000 * fRating * fRating;
    }
  else
    fRating = 0;

  return(fRating);
}

