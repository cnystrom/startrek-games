/*
 *    shields.c
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
#include <stdlib.h>
#include "standard.h"
#include "ship.h"
#include "devices.h"
#include "damage.h"

void
shield_control(void)
{
  double d;

  int iEnergy = get_energy();
  int iShields = get_shields();

  if (damaged(SHIELDS))
    {
      printf("Weapons Officer reports:\n");
      printf("  Shield Control not available, sir.\n\n");
      return;
    }

  iEnergy = iEnergy + iShields;
  iShields = 0;

  printf("Shield Control\n\n");
  printf("Energy Available for Shields = %d\n\n", iEnergy);

  if (! get_number("Amount of energy to shields: ", &d))
    {
      printf("\nWeapons Officer reports:\n");
      printf("  Shields unchanged, sir.\n\n");
      return;
    }

  printf("\n");

  iShields = (d > iEnergy) ? iEnergy : (int) d;

  if (iShields > iEnergy)
     iShields = iEnergy;
  else if (iShields < 0)
     iShields = 0;

  if (iShields > 0 && get_condition() == DOCKED)
    undock();

  iEnergy = iEnergy - iShields;

  set_energy(iEnergy);
  set_shields(iShields);

  printf("Weapons Officer reports:\n");
  printf("  Shields now at %d units per your command, sir.\n\n", iShields);
}

