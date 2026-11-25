/*
 *    stardate.c
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
#include <stdlib.h>
#include "standard.h"
#include "stardate.h"

float fStardate, fStartdate, fDeadline;

void
new_stardate(void)
{
  fStardate = fStartdate = (float) (rand() % 500) + 2500;
}

float
get_stardate(void)
{
  return (fStardate);
}

void
inc_stardate(void)
{
  fStardate++;
}

void
add_stardate(float f)
{
  fStardate = fStardate + f;
}

float
get_startdate(void)
{
  return(fStardate);
}

void
set_deadline(int i)
{
  fDeadline = fStardate + i;
}

int
check_expiration(void)
{
  if (fStardate >= fDeadline)
    return(TRUE);
  else
    return(FALSE);
}

float
get_timeleft(void)
{
  return(fDeadline - fStardate);
}

float
get_elapsed_time(void)
{
  return(fStardate - fStartdate);
}

void
print_stardate(void)
{
  printf("%4.2f", fStardate);
}


