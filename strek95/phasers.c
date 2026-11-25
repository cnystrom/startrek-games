/*
 *    phasers.c
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
#include "location.h"
#include "posit.h"
#include "galaxy.h"
#include "space.h"
#include "ship.h"
#include "klingon.h"
#include "devices.h"
#include "damage.h"
#include "score.h"
#include "sound.h"
#include "end_game.h"

void hit_klingon(int iKlingonNum, int iEnergy);

void
phasers(void)
{
  register i;
  int iEnergy, iEnergyAvail, iDamage, iKlingons, iPotentialDamage;
  string s;
  klingon klingon;
  posit pos1, pos2;
  vector v;

  if (damaged(PHASERS))
    {
      printf("Weapons Officer reports:\n");
      printf("  Phasers not available, sir.\n\n");
      return;
    }

  iKlingons = get_klingons_space();

  if (! iKlingons)
    {
      printf("Science Officer reports:\n");
      printf("  I am unable to detect the presence of Klingons in this");
      printf(" quadrant, Captain.\n\n");
      return;
    }

  iEnergyAvail = get_energy();

  if (iEnergyAvail <= 0)
    {
      printf("Weapons Officer reports:\n");
      printf("  No energy for phasers available, sir.\n\n");
      return;

    }
  printf("Energy Available: %d\n\n", iEnergyAvail);

  get_string("Energy to Phasers: ", s);

  printf("\n");

  iEnergy = atoi(s);

  if (iEnergy <= 0)
    return;

  if (iEnergy > iEnergyAvail)
    {
      printf("Weapons Officer reports:\n");
      printf("  We do not have that much energy available, sir.\n\n");
      return;
    }

  sub_energy(iEnergy);

  iPotentialDamage = iEnergy / iKlingons;

  pos1 = get_posit();
  pos2.iXQuad = pos1.iXQuad;
  pos2.iYQuad = pos1.iYQuad;

  for (i = 1; i <= MAX_KLINGONS_QUAD; i++)
    {
      klingon = get_klingon(i);

      if (klingon.iEnergy > 0)
        {

          pos2.fXSect = (float) klingon.iXSect;
          pos2.fYSect = (float) klingon.iYSect;

          v = compute_dirdist(pos1, pos2);

          iDamage = (((100 - (v.iDist * 100 / (QUADSIZE + 2)))
            * iPotentialDamage) / 100);

          add_score(iDamage);

          printf("%d unit hit on Klingon Battlecruiser at sector %d, %d\n\n",
            iDamage, klingon.iXSect, klingon.iYSect);

          hit_klingon(i, iDamage);
        }
    }
}

void
hit_klingon(int iKlingonNum, int iEnergy)
{
  int i, iXSect, iYSect;
  klingon klingon = get_klingon(iKlingonNum);
  posit posit = get_posit();

  i = klingon.iEnergy - iEnergy;

  if (i < 0)
    {
      iXSect = klingon.iXSect;
      iYSect = klingon.iYSect;

      printf("*** Klingon Destroyed ***\n\n");
      beep();
      sub_ship_galaxy(posit.iXQuad, posit.iYQuad);
      del_klingon(iXSect, iYSect);
      if (get_klingons_left() <= 0)
	won_game();
    }
  else
    set_klingon_energy(iKlingonNum, i);
}

