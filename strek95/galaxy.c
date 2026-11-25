/*
 *    galaxy.c
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
#include <string.h>
#include "standard.h"
#include "location.h"
#include "posit.h"
#include "klingon.h"
#include "rank.h"
#include "space.h"
#include "rand.h"
#include "galaxy.h"

int iGalaxy[GALSIZE + 1][GALSIZE + 1];

int iTotKlingons;  /* Total Klingons at start */
int iTotShips;     /* Total Ships left, including own */
int iTotStations;  /* Total Stations left */
int iTotStars;     /* Fixed, never changes */

int
get_galaxy(int iXQuad, int iYQuad)
{
  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    return(iGalaxy[iXQuad][iYQuad]);
  else
    return(100);
}

int
get_tot_klingons(void)
{
  return(iTotKlingons);
}

int
get_klingons_left(void)
{
  return(iTotShips - 1);
}

int
get_tot_starbases(void)
{
  return(iTotStations);
}

void
add_ship_galaxy(int iXQuad, int iYQuad)
{
  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    {
      iGalaxy[iXQuad][iYQuad] = iGalaxy[iXQuad][iYQuad] + 100;
      iTotShips++;
    }
}

void
add_station_galaxy(int iXQuad, int iYQuad)
{
  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    {
      iGalaxy[iXQuad][iYQuad] = iGalaxy[iXQuad][iYQuad] + 10;
      iTotStations++;
    }
}

void
add_star_galaxy(int iXQuad, int iYQuad, int i)
{
  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    {
      iGalaxy[iXQuad][iYQuad] = iGalaxy[iXQuad][iYQuad] + i;
      iTotStars = iTotStars + i;
    }
}

void
sub_ship_galaxy(int iXQuad, int iYQuad)
{
  int i;

  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    {
      i = get_galaxy(iXQuad, iYQuad);

      if (i >= 100)
        iGalaxy[iXQuad][iYQuad] = i - 100;

      iTotShips--;
    }
}

void
sub_station_galaxy(int iXQuad, int iYQuad)
{
  int i;

  if (iXQuad > 0 && iXQuad <= GALSIZE && iYQuad > 0 && iYQuad <= GALSIZE)
    {
      i = get_galaxy(iXQuad, iYQuad);

      if (i >= 10)
        {
          iGalaxy[iXQuad][iYQuad] = i - 10;
          iTotStations--;
        }
    }
}
 
int
stations_in_quad(int iXQuad, int iYQuad)
{
  int iGal, iShips;

  iGal = iGalaxy[iXQuad][iYQuad];
  iShips = (int)(iGal / 100);
  return((int)((iGal - (iShips * 100)) / 10));
}

 
int
ships_in_quad(int iXQuad, int iYQuad)
{
  int iGal;

  iGal = iGalaxy[iXQuad][iYQuad];
  return((int) iGal / 100);
}

void
free_quad(int iType)
{
  int iXQuad, iYQuad;

  iXQuad = get_rand(GALSIZE);
  iYQuad = get_rand(GALSIZE);

  if (iType == KLINGON)
    {
      if (ships_in_quad(iXQuad, iYQuad) < MAX_KLINGONS_QUAD)
        add_ship_galaxy(iXQuad, iYQuad);
      else
        free_quad(KLINGON);
    }
  else if (iType == STATION)
   {
      if (stations_in_quad(iXQuad, iYQuad) < MAX_STATIONS)
        add_station_galaxy(iXQuad, iYQuad);
      else
        free_quad(STATION);
   }
}

void
new_galaxy(int iRank)
{
  register int i, j;
  int k, iStations;
  posit posit;

  iTotShips = 0;
  iTotStations = 0;
  iStations = 6 - iRank;
  iTotKlingons = (iRank * 5) + get_rand(3);

  /* Reset Galaxy and Add Stars */

  for (i = 1; i <= GALSIZE; i++)
    for (j = 1; j <= GALSIZE; j++)
      {
        iGalaxy[i][j] = 0;
        k = get_rand(MAX_STARS);
        add_star_galaxy(i, j, k);
      }

  /* Add Klingons to Galaxy */

  for (i = 1; i <= iTotKlingons; i++)
    free_quad(KLINGON);

  /* Add Ownship to Galaxy */

  new_posit();
  posit = get_posit();

  add_ship_galaxy(posit.iXQuad, posit.iYQuad);

  /* Add Stations to Galaxy */

  add_station_galaxy(posit.iXQuad, posit.iYQuad);

  for (i = 1; i <= (iStations - 1); i++)
    free_quad(STATION);
}
