/*
 *    computer.c
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
#include "stardate.h"
#include "galaxy.h"
#include "galrec.h"
#include "posit.h"
#include "ship.h"
#include "klingon.h"
#include "starbase.h"
#include "devices.h"
#include "damage.h"
#include "score.h"
#include "qnames.h"

void show_computer_menu(void);
void galactic_record(int iMap);
void dd_calc(void);
void starbase_nav(void);
void status_report(void);
void torp_calc(void);
void location_calc(void);

/* Keep calculator input in a sane range (also turns NaN into 0) so the
   float-to-int conversions below are defined. */
static double
clamp_input(double d)
{
  if (!(d > -1000.0))
    return (d < 0.0) ? -1000.0 : 0.0;
  if (d > 1000.0)
    return 1000.0;
  return d;
}

void
computer(void)
{
  string sCommand;

  if (damaged(LIBRARY_COMPUTER))
    {
      printf("\nScience Officer reports:\n");
      printf("Library Computer not available, Captain.\n\n");
      return;
    }

  printf("Computer active and awaiting command...\n\n");

  do
    {
      get_string("> ", sCommand);

      printf("\n");

      add_stardate(.1);

      if (strncmp (sCommand,"cgr",3) == 0)
        galactic_record(0);

      else if (strncmp(sCommand,"ddc",3) == 0)
        dd_calc();

      else if (strncmp(sCommand,"exit",3) == 0)
        return;

      else if (strncmp (sCommand,"grm",3) == 0)
        galactic_record(1);

      else if (strncmp(sCommand,"loc",3) == 0)
        location_calc();

      else if (strncmp(sCommand,"help",4) == 0)
	show_computer_menu();

      else if (strncmp(sCommand,"nav",3) == 0)
	starbase_nav();

      else if (strncmp(sCommand,"sta",3) == 0)
	status_report();

      else if (strncmp(sCommand,"tor",3) == 0)
	torp_calc();

      else
	show_computer_menu();

    }
  while(1);
}

void
show_computer_menu(void)
{
  printf("     Available Computer Commands:\n\n");
  printf(" cgr  - Cumulative Galactic Record.\n");
  printf(" ddc  - Direction and Distance Calculator.\n");
  printf(" exit - Exit Computer.\n");
  printf(" grm  - Galactic Region Map.\n");
  printf(" loc  - Location Calculator.\n");
  printf(" nav  - Starbase Navigation Data.\n");
  printf(" sta  - Status Report.\n");
  printf(" tor  - Torpedo Course Calculator.\n\n");
}

void
galactic_record(int iMap)
{
  register int i, j;
  int k;
  int iXIndex, iYIndex, iDisplaySize = 9;
  posit posit = get_posit();

  if (iDisplaySize > GALSIZE)
    iDisplaySize = GALSIZE;

  if (iMap)
    printf("                   Galactic Region Map\n\n");
  else
    {
      printf ("   Computer Record of Galaxy for ");
      printf ("Quadrant %2.2d, %2.2d\n\n", posit.iXQuad, posit.iYQuad);
    }

  iXIndex = posit.iXQuad - (iDisplaySize / 2);
  if (iXIndex > GALSIZE - iDisplaySize)
    iXIndex = GALSIZE - iDisplaySize + 1;
  if (iXIndex < 1)
    iXIndex = 1;

  iYIndex = posit.iYQuad - (iDisplaySize / 2);
  if (iYIndex > GALSIZE - iDisplaySize)
    iYIndex = GALSIZE - iDisplaySize + 1;
  if (iYIndex < 1)
    iYIndex = 1;

  printf ("  ");
  for (i = iYIndex; i < iYIndex + iDisplaySize; i++)
    printf("    %2.2d", i);
  printf ("\n");

  for (i = iXIndex; i < iXIndex + iDisplaySize; i++)
    {
      printf ("    ");
      for (j = 0; j < iDisplaySize; j++)
        printf("+-----");
      printf("+\n");

      printf (" %2.2d |", i);

      if (iMap)
        {
          printf("%s", map_name(i, 1));
          printf("|");
          printf("%s", map_name(i, 5));
          printf("|");
        }
      else
        {
          for (j = iYIndex; j < iYIndex + iDisplaySize; j++)
            {
              k = get_galrec(i, j);
              if (k == UNKNOWN)
                printf(" *** |");
              else
	        printf (" %3.3d |", get_galrec(i, j));
            }
        }

      printf ("\n");
    }

  printf ("    ");
  for (i = 0; i < iDisplaySize; i++)
    printf("+-----");
  printf("+\n\n");
}

void
starbase_nav(void)
{
  posit p1, p2;
  starbase starbase;
  vector v;

  starbase = get_starbase();

  if (starbase.iEnergy < 0)
    {
      printf("Science Officer reports:\n");
      printf("There are no Starbases in this quadrant, Captain.\n\n");
      return;
    }

  printf("Starbase Navigation Calculator\n\n");

  p1 = get_posit();

  p2.iXQuad = p1.iXQuad;
  p2.iYQuad = p1.iYQuad;

  p2.fXSect = (float) starbase.iXSect;
  p2.fYSect = (float) starbase.iYSect;

  printf ("Starbase at %d, %d:\n\n", starbase.iXSect,
    starbase.iYSect);

  v = compute_dirdist(p1, p2);

  printf ("   Direction: %3.3d.\n", v.iDir);
  printf ("   Distance: %d.\n\n", v.iDist - 1);
}

void
status_report(void)
{
  float f;
  posit posit;

  posit = get_posit();

  printf("    Status Report\n");
  printf("    -------------\n\n");
  printf("  Quadrant:   %d, %d\n", posit.iXQuad, posit.iYQuad);
  printf("  Sector:     %d, %d\n", (int) posit.fXSect, (int) posit.fYSect);
  printf("  Condition:  %s\n", get_condition_name());
  printf("  Energy:     %d\n", get_energy());
  printf("  Shields:    %d\n", get_shields());
  printf("  Torpedoes:  %d\n\n", get_torpedoes());
  printf("  Klingons Remaining:    %d\n\n", get_klingons_left());
  printf("  Starbases Remaining:   %d\n\n", get_tot_starbases());
  printf("  Time Remaining:      ");
  f = get_timeleft();
  if (f < 100)
    {
      printf(" ");
    }
  printf("%5.1f Stardates\n\n", f);
  printf("  Score:                 %5.1f\n\n", get_score());
}

void
torp_calc(void)
{
  register int i;
  posit p1, p2;
  klingon klingon;
  vector v;

  p1 = get_posit();

  if (get_galaxy(p1.iXQuad, p1.iYQuad) < 200)
    {
      printf("Science Officer reports:\n");
      printf("There are no Klingons in this quadrant, Captain.\n\n");
      return;
    }

  printf("Photon Torpedo Calculator\n\n");

  p2.iXQuad = p1.iXQuad;
  p2.iYQuad = p1.iYQuad;

  for (i = 1; i <= 3; i++)
    {
      klingon = get_klingon(i);

      if (klingon.iEnergy > 0)
        {
          p2.fXSect = (float) klingon.iXSect;
          p2.fYSect = (float) klingon.iYSect;

          printf ("Klingon at %d, %d:\n\n", klingon.iXSect,
             klingon.iYSect);

          v = compute_dirdist(p1, p2);

          printf ("   Direction: %3.3d.\n", v.iDir);
          printf ("   Distance: %d.\n\n", v.iDist);
        }
    }
}

void
dd_calc(void)
{
  char sBuffer[81] = "";
  location l1, l2;
  vector v;

  printf("Direction Distance Calculator\n\n");

  printf("Input 1st X-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l1.fX = clamp_input(atof(sBuffer));
  printf("Input 1st Y-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l1.fY = clamp_input(atof(sBuffer));

  printf("\n");

  printf("Input 2nd X-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l2.fX = clamp_input(atof(sBuffer));
  printf("Input 2nd Y-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l2.fY = clamp_input(atof(sBuffer));

  v = compute_vector(l1, l2);

  printf ("\nThe direction is: %3.3d.\n", v.iDir);
  printf ("The distance is: %d.\n\n", v.iDist);
}

void
location_calc(void)
{
  char sBuffer[81] = "";
  location l;
  vector v;

  printf("Location Calculator\n\n");

  printf("Input X-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l.fX = clamp_input(atof(sBuffer));
  printf("Input Y-Coordinate: ");
  read_line(sBuffer, sizeof sBuffer);
  l.fY = clamp_input(atof(sBuffer));

  printf("\nInput Course: ");
  read_line(sBuffer, sizeof sBuffer);
  v.iDir = clamp_input(atof(sBuffer));
  printf("Input Speed: ");
  read_line(sBuffer, sizeof sBuffer);
  v.iDist = clamp_input(atof(sBuffer));

  l = resolve_vector(l, v);

  printf("\nX-Coordinate: %4.1f\n", l.fX);
  printf("Y-Coordinate: %4.1f\n\n", l.fY);
}

