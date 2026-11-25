/*
 *    space.c
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
#include "location.h"
#include "galaxy.h"
#include "klingon.h"
#include "starbase.h"
#include "posit.h"
#include "ship.h"
#include "rand.h"
#include "space.h"

/* Maps the contents of the quadrant */
int space[QUADSIZE + 1][QUADSIZE + 1];

/* Klingon Index */
int iKIndex;

/* Object Couters */
int iKlingons, iStations, iStars;

void
set_space(int iXSect, int iYSect, int iObject)
{
  if (iXSect > 0 && iXSect <= QUADSIZE && iYSect > 0 && iYSect <= QUADSIZE)
    space[iXSect][iYSect] = iObject;
}

int
get_space(int iXSect, int iYSect)
{
  if (iXSect > 0 && iXSect <= QUADSIZE && iYSect > 0 && iYSect <= QUADSIZE)
    return(space[iXSect][iYSect]);
  else
    return(SPACE);
}

int
get_klingons_space(void)
{
  return(iKlingons);
}

void
sub_klingon_space(int iXSect, int iYSect)
{
  if (iXSect > 0 && iXSect <= QUADSIZE && iYSect > 0 && iYSect <= QUADSIZE)
    {
      space[iXSect][iYSect] = SPACE;

      if (iKlingons)
        iKlingons--;

      set_condition();
    }
}

void
sub_station_space(int iXSect, int iYSect)
{
  if (iXSect > 0 && iXSect <= QUADSIZE && iYSect > 0 && iYSect <= QUADSIZE)
    {
      space[iXSect][iYSect] = SPACE;

      if (iStations)
        iStations--;
    }
}

void
free_space(int iObject)
{
  int i, j;

  i = get_rand(QUADSIZE);
  j = get_rand(QUADSIZE);

  if (space[i][j] == SPACE)
    {
      space[i][j] = iObject;
      if (iObject == KLINGON)
        {
          set_klingon(iKIndex, i, j);
	  iKlingons++;
          iKIndex++;
        }
      else if (iObject == STATION)
        {
          set_starbase(i, j);
	  iStations++;
        }
    }
  else
    free_space(iObject);
}

void
new_space(int iXQuad, int iYQuad)
{
  register i, j;
  int iGalaxy, iShips, iK, iS;
  posit posit;

  for (i = 0; i <= QUADSIZE; i++)
    for (j = 0; j <= QUADSIZE; j++)
      space[i][j] = SPACE;

  iKIndex = 1;
  iKlingons = 0;
  clear_klingons();

  iStations = 0;
  clear_starbase();

  iStars = 0;

  posit = get_posit();

  i = (int) posit.fXSect;
  j = (int) posit.fYSect;

  space[i][j] = SHIP;

  iGalaxy = get_galaxy(iXQuad, iYQuad);
  
  iShips = (int) (iGalaxy / 100);
  iK = iShips - 1;
  iS = (int) ((iGalaxy - (iShips * 100)) / 10);
  iStars = (int) (iGalaxy - (iShips * 100) - (iS * 10));

  set_condition();

  for (i = 0; i < iK; i++)
    free_space(KLINGON);
  
  for (i = 0; i < iS; i++)
    free_space(STATION);

  for (i = 0; i < iStars; i++)
    free_space(STAR);
}

void
move_klingon(int iKNum)
{
  klingon klingon;

  klingon = get_klingon(iKNum);

  if (klingon.iEnergy <= 0)
    return;

  sub_klingon_space(klingon.iXSect, klingon.iYSect);

  iKIndex = iKNum;
  free_space(KLINGON); 
}

