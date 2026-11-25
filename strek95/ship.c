/*
 *    ship.c
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
#include <string.h>
#include "standard.h"
#include "location.h"
#include "posit.h"
#include "space.h"
#include "rank.h"
#include "shiptype.h"
#include "starbase.h"
#include "damage.h"
#include "sound.h"
#include "ship.h"

int next_to_station(void);
void dock(void);

ship ownship;

void
set_shiptype(int i)
{
  ownship.iShipType = 0;

  if (i >= 0 && i < TOT_SHIP_TYPES)
    ownship.iShipType = i;
}

int
get_shiptype(void)
{
  return(ownship.iShipType);
}

void
set_shipname(char *sShipName)
{
  strcpy(ownship.sShipName, sShipName);
}

char *
get_shipname(void)
{
  return(ownship.sShipName);
}

void
set_condition(void)
{
  if (next_to_station() && ownship.iCondition == DOCKED)
      return;
  else if (get_klingons_space())
    ownship.iCondition = RED;
  else if (get_energy() + get_shields() <= 100)
    ownship.iCondition = YELLOW;
  else
    ownship.iCondition = GREEN;
}

int
get_condition(void)
{
  return(ownship.iCondition);
}

char *
get_condition_name(void)
{
  if (ownship.iCondition == DOCKED)
    return("Docked");
  else if (ownship.iCondition == RED)
    {
       beep();
       return("Red");
    }
  else if (ownship.iCondition == YELLOW)
    return("Yellow");
  else
    return("Green");
}

void
set_torpedoes(int iTorpedoes)
{
  ownship.iTorpedoes = iTorpedoes;
}

void
sub_torpedo(void)
{
  ownship.iTorpedoes--;
}

int
get_torpedoes(void)
{
  return(ownship.iTorpedoes);
}

void
set_energy(int iEnergy)
{
  ownship.iEnergy = iEnergy;
}

int
get_energy(void)
{
  return(ownship.iEnergy);
}

void
sub_energy(int iEnergy)
{
  ownship.iEnergy = ownship.iEnergy - iEnergy;
  if (ownship.iEnergy < 0)
    ownship.iEnergy = 0;
}

void
set_shields(int iShields)
{
  ownship.iShields = iShields;
}

int
get_shields(void)
{
  return(ownship.iShields);
}

void
new_ship(int iRank)
{
  if (iRank == CIVILIAN)
    {
      set_shiptype(HCRUISER);
      set_shipname("Enterprise");
    }
  else if (iRank == ENSIGN)
    {
      set_shiptype(FRIGATE);
      set_shipname("McKenzie");
    }
  else if (iRank == LIEUTENANT)
    {
      set_shiptype(DESTROYER);
      set_shipname("Valiant");
    }
  else if (iRank == COMMANDER)
    {
      set_shiptype(LCRUISER);
      set_shipname("Andromeda");
    }
  else if (iRank == CAPTAIN)
    {
      set_shiptype(HCRUISER);
      set_shipname("Enterprise");
    }
  else
    {
      set_shiptype(BCRUISER);
      set_shipname("Tiger");
    }

  set_condition();
  set_energy(get_maxenergy(get_shiptype()) - 500);
  set_torpedoes(get_maxtorp(get_shiptype()));
  set_shields(500);
}

int
next_to_station(void)
{
  int iA, iB, iC, iD;
  posit posit;
  starbase starbase;

  posit = get_posit();
  starbase = get_starbase();

  if (starbase.iEnergy)
    {
      iA = (int) posit.fXSect;
      iB = (int) posit.fYSect;
      iC = starbase.iXSect;
      iD = starbase.iYSect;

      if (iC <= (iA + 1) && iC >= (iA - 1) &&
          iD <= (iB + 1) && iD >= (iB - 1))
        return(TRUE);
    }

  return(FALSE);
}

void
check_dock(void)
{
  int iShipType, iShields;

  if (! next_to_station())
    return;

  ownship.iCondition = DOCKED;

  iShipType = get_shiptype();

  set_energy(get_maxenergy(iShipType));
  set_torpedoes(get_maxtorp(iShipType));

  iShields = get_shields();

  if (iShields)
  {
    set_shields(0);

    printf("Weapons Officer reports:\n");
    printf("  Shields dropped, sir.\n\n");
    beep();
  }

  printf("Conning Officer reports:\n");
  printf("  Docked, sir!\n\n");

  at_shipyard();
}

void
undock(void)
{
 /* Set the condition to GREEN so as to not be DOCKED, then modify
  * as needed.
  */

  ownship.iCondition = GREEN;

  set_condition();

  printf("Conning Officer reports:\n");
  printf("  We are now underway, Captain.\n\n");
}
