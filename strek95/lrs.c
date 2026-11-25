/*
 *    lrs.c
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
#include "galrec.h"
#include "location.h"
#include "posit.h"
#include "galaxy.h"
#include "devices.h"
#include "damage.h"

void
long_range_sensors (void)
{
  int i, j;
  posit posit;

  if (damaged(LONG_RANGE_SENSORS))
    {
      printf("Science Officer reports:\n");
      printf("Long Range Sensors not available, Captain.\n\n");
      return;
    }

  posit = get_posit();

  printf ("Long range sensor scan for quadrant %2.2d, %2.2d:\n\n",
	  posit.iXQuad, posit.iYQuad);

  for (i = posit.iXQuad - 1; i <= posit.iXQuad + 1; i++)
    {
      printf (" |-----|-----|-----|\n");
      printf (" |");
      for (j = posit.iYQuad - 1; j <= posit.iYQuad + 1; j++)
	if (i < 1 || i > GALSIZE || j < 1 || j > GALSIZE)
	  if (i == posit.iXQuad && j == posit.iYQuad)
	    printf (" 100 |");
	  else
	    printf (" 000 |");
	else
	  {
	    printf (" %3.3d |", get_galaxy(i, j));
	    set_galrec(i, j, get_galaxy(i, j));
	  }
      printf ("\n");
    }
  printf (" |-----|-----|-----|\n\n");
}

