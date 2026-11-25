/*
 *    dc.c
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

#include <stdio.h>
#include <string.h>
#include "ship.h"
#include "devices.h"
#include "damage.h"

void
do_dc (void)
{
  char sDeviceName[81] = "";
  register int i, j;

  if (damaged(DAMAGE_CONTROL))
    {
      printf("Damage Control Officer reports:\n");
      printf("  Damage Control not operational, sir.\n\n");
      return;
    }

  printf ("Damage Control Report for %s:\n\n", get_shipname());

  printf ("   Device\t        Status\n");
  for (i = 0; i < DEVICE_TOT; i++)
    {
      strcpy (sDeviceName, get_device_name(i));
      printf (" %s", sDeviceName);
      for (j = strlen(sDeviceName); j < 24; j++)
        printf(" ");
      printf ("%d\n", get_damage(i));
    }
  printf("\n");
}

