/*
 *    damage.c
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
#include "standard.h"
#include "stardate.h"
#include "devices.h"
#include "rand.h"
#include "damage.h"
#include "sound.h"

int damage[DEVICE_TOT];

void
new_damage(void)
{
  register i;

  for  (i = 0; i < DEVICE_TOT; i++)
    set_damage(i, OPERATIONAL);
}

void
set_damage(int iDevice, int iDamage)
{
  damage[iDevice] = iDamage;
}

int
get_damage(int iDevice)
{
  return(damage[iDevice]);
}

int
damaged(int iDevice)
{
  if (damage[iDevice] < OPERATIONAL)
    return(TRUE);
  else
    return(FALSE);
}

void
repair_damage(void)
{
  int iDevice, iDamage, iRepair;

  iDevice = get_rand(DEVICE_TOT) - 1;
  iDamage = get_damage(iDevice);
  if (iDamage < OPERATIONAL)
    {
      printf("Damage Control Report:\n");
      iRepair = get_rand(100);
      if (iDamage + iRepair >= OPERATIONAL)
        {
	  set_damage(iDevice, OPERATIONAL);
          printf("    %s", get_device_name(iDevice));
          printf(" repaired and operational.\n\n");
         }
      else
	{
          printf("    %s", get_device_name(iDevice));
          printf(" repaired %d%%.\n\n", iRepair);
          set_damage(iDevice, iDamage + iRepair);
	} 
      beep();
    }
}

void
at_shipyard(void)
{
  register i;
  char c;
  int iActual, iDamageTot = 0;
  float fEstimate;

  for  (i = 0; i < DEVICE_TOT; i++)
    iDamageTot = iDamageTot + (100 - get_damage(i));

  printf("Total damage: %d\n\n", iDamageTot);

  if (iDamageTot == 0)
    return;

  fEstimate = (float) iDamageTot / 50;

  printf("Technicians standby ready to make repairs on your ship,");
  printf(" Captain.\nWe estimate repairs to take ");
  printf("%3.1f stardate", fEstimate);
  if (fEstimate > 1.0)
    printf("s");
  printf(".\n\n");

  c = y_or_n("Commence repairs, Captain? (Y/N) ");

  printf("\n");

  if (c == 'y')
  {
    new_damage();
    iActual = get_rand(fEstimate * 1.7);
    add_stardate(iActual);

    printf("Executive Officer reports:\n");
    printf("  Repairs took %d stardate", iActual);
    if (iActual > 1)
      printf("s");
    printf(", Captain.\n\n");
  }
}

