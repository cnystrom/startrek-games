/*
 *    klingon.c
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
#include <stdlib.h>
#include "standard.h"
#include "space.h"
#include "devices.h"
#include "ship.h"
#include "damage.h"
#include "klingon.h"
#include "score.h"
#include "rank.h"
#include "sound.h"
#include "end_game.h"
#include "rand.h"

struct klingon_struct klingons[MAX_KLINGONS_QUAD + 1];

void
set_klingon(int iKlingonNum, int iXSect, int iYSect)
{
  klingons[iKlingonNum].iXSect = iXSect;
  klingons[iKlingonNum].iYSect = iYSect;
  klingons[iKlingonNum].iEnergy = 300;
}

void
set_klingon_energy(int iKlingonNum, int iEnergy)
{
  klingons[iKlingonNum].iEnergy = iEnergy;
}

klingon
get_klingon(int iKlingonNum)
{
  return(klingons[iKlingonNum]);
}

void
clear_klingons(void)
{
  int i;

  for (i = 0; i <= MAX_KLINGONS_QUAD; i++)
    {
      klingons[i].iXSect = 0;
      klingons[i].iYSect = 0;
      klingons[i].iEnergy = -1;
    }
}

void
del_klingon(int iXSect, int iYSect)
{
  int i;

  for (i = 0; i <= MAX_KLINGONS_QUAD; i++)
    {
      if (iXSect == klingons[i].iXSect)
        if (iYSect == klingons[i].iYSect)
          {
            klingons[i].iXSect = 0;
            klingons[i].iYSect = 0;
            klingons[i].iEnergy = -1;
          }
    }
  sub_klingon_space(iXSect, iYSect);
}

void
klingons_move(void)
{
  register int i;

  for (i = 1; i <= MAX_KLINGONS_QUAD; i++)
    if (get_rand(100) > 80)
      move_klingon(i);
}

void
klingons_fire(void)
{
  register int i, j;
  int iEnergy, iShot, iShields, iDevice, iDamage, iCount;
  klingon klingon;

  for (i = 1; i <= MAX_KLINGONS_QUAD; i++)
    {
      klingon = get_klingon(i);
      if (klingon.iEnergy >= 0 && get_rand(100) > 40)
        {
          iEnergy = get_rand(klingon.iEnergy);
          printf("Weapons Officer reports:\n");
          printf("  We have been hit by %d units of energy from ", iEnergy);
	  printf("Klingon at sector %d, %d.\n", klingon.iXSect, klingon.iYSect);
          beep();

          if (get_condition() != DOCKED)
            {
              iShot = iEnergy - get_shields();
              if (iShot < 0)
                iShot = 0;
              iShields = iEnergy - iShot;
              set_shields(get_shields() - iShields);
              printf("  Shields absorb %d units, sir.\n\n", iShields);
            }
          else
            {
              iShot = 0;
              printf("Starbase shields protect %s\n\n", get_shipname());
            }

          if (iShot > 0)
            {
              iDevice = get_rand(DEVICE_TOT) - 1;
              iDamage = get_damage(iDevice) - iShot;
              if (iDamage < 0)
                iDamage = 0;
              sub_score(get_damage(iDevice) - iDamage);  /* damage done */
              set_damage(iDevice, iDamage);
              printf("Damage Control Reports:\n %s damaged by the hit.\n\n",
                get_device_name(iDevice));
              beep();

              iCount = 0;
              for (j = 0; j < DEVICE_TOT; j++)
                if (get_damage(j) < 100)
                  iCount++;
 
              if (iCount > DEVICE_TOT / 2)
                ship_destroyed();
            }
        }
    }
}

