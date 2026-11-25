/*
 *    nav.c
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
#include "location.h"
#include "stardate.h"
#include "galrec.h"
#include "galaxy.h"
#include "space.h"
#include "posit.h"
#include "ship.h"
#include "devices.h"
#include "damage.h"
#include "qnames.h"

void nav(int iCourse, int iVelocity);

extern void short_range_sensors(void);

void
impulse_engines(void)
{
  int iCourse, iVelocity, iEnergy;
  double d;

  if (damaged(IMPULSE_ENGINES))
    {
      printf("Conning Officer reports:\n");
      printf("  Impulse Engines not available, sir.\n\n");
      return;
    }

  course_display();

  if (! get_number("Course: ", &d) || d < 0 || d > 360)
    {
      printf("\nConning Officer reports:\n");
      printf("  Invalid course, sir.\n\n");
      return;
    }
  iCourse = (int) d;

  if (! get_number("Impulse Factor: ", &d) || d < 0 || d > 8)
    {
      printf("\nChief Engineer reports:\n  The impulse engines can not");
      printf(" do that impulse factor, sir.\n\n");
      return;
    }
  iVelocity = (int) d;

  printf("\n");

  iEnergy = get_energy();

  if (iVelocity > iEnergy)
    {
      printf("Chief Engineer reports:\n");
      printf("  We do not have enough energy, Captain!\n\n");
      return;
    }

  if (iVelocity < 0 || iVelocity > 8)
    {
      printf("Chief Engineer reports:\n  The impulse engines can not");
      printf(" do impulse factor %d, sir.\n\n", iVelocity);
      return;
    }

  add_stardate(iVelocity / 10.0);

  nav(iCourse, iVelocity);
}

void
warp_engines(void)
{
  int iCourse, iVelocity, iEnergy;
  double d;

  if (damaged(WARP_ENGINES))
    {
      printf("Conning Officer reports\n");
      printf("  Warp Engines not available, sir.\n\n");
      return;
    }

  course_display();

  if (! get_number("Course: ", &d) || d < 0 || d > 360)
    {
      printf("\nConning Officer reports:\n");
      printf("  Invalid course, sir.\n\n");
      return;
    }
  iCourse = (int) d;

  if (! get_number("Warp Factor: ", &d) || d < 0 || d > 8)
    {
      printf("\nChief Engineer reports:\n  The warp engines can not take");
      printf(" that warp factor, sir.\n\n");
      return;
    }

  printf("\n");

  iVelocity = (int)(d * QUADSIZE);

  iEnergy = get_energy();

  if (iVelocity > iEnergy)
    {
      printf("Chief Engineer reports:\n");
      printf("  We do not have enough energy, Captain!\n\n");
      return;
    }
  
  if (iVelocity < 0 || iVelocity > (8 * QUADSIZE))
    {
      printf("Chief Engineer reports:\n  The warp engines can not take");
      printf(" warp %d, sir.\n\n", (int) (iVelocity / QUADSIZE));
      return;
    }

  inc_stardate();

  nav(iCourse, iVelocity);
}

void
nav(int iCourse, int iVelocity)
{
  register int i, j;
  int iQ1, iQ2;
  posit posit, posP;

  set_energy(get_energy() - iVelocity);

  /* Start moving the ship ... */

  posit = posP = get_posit();

  for (i = 0; i < iVelocity; i++)
    {
      set_space((int) posP.fXSect, (int) posP.fYSect, SPACE);

      posP = course_spd(posit, iCourse, 1);

      if (! in_galaxy(posP))
        {
          /* Stop at the edge of the galaxy, as the BASIC game does */
          printf("Lt. Uhura reports message from Starfleet Command:\n");
          printf("  Permission to attempt crossing of galactic perimeter\n");
          printf("  is hereby *denied*. Shut down your engines.\n\n");
          break;
        }

      if ((posit.iXQuad != posP.iXQuad) || (posit.iYQuad != posP.iYQuad))
        {
          iQ1 = posit.iXQuad;
          iQ2 = posit.iYQuad;

          sub_ship_galaxy(iQ1, iQ2);
          set_galrec(iQ1, iQ2, get_galaxy(iQ1, iQ2));

          /* Move ship the rest of the way all at once */

          posP = course_spd(posit, iCourse, iVelocity - i);
          if (! in_galaxy(posP))
            {
              printf("Lt. Uhura reports message from Starfleet Command:\n");
              printf("  Permission to attempt crossing of galactic perimeter\n");
              printf("  is hereby *denied*. Shut down your engines.\n\n");
              posP = clamp_to_galaxy(posP);
            }
          posP.fXSect = (int) posP.fXSect;  /* whole sectors, like BASIC */
          posP.fYSect = (int) posP.fYSect;
          i = iVelocity;

          iQ1 = posP.iXQuad;
          iQ2 = posP.iYQuad;

          add_ship_galaxy(iQ1, iQ2);
          set_posit(posP);
          set_galrec(iQ1, iQ2, get_galaxy(iQ1, iQ2));
          new_space(iQ1, iQ2);

          printf ("Now entering ");
          printf("%s...\n", quadrant_name(iQ1, iQ2));
        }
      else
        {
          j = get_space((int) posP.fXSect, (int) posP.fYSect);

          if (j != SPACE)
            {
              if (j == STAR)
                {
                  printf("Conning Officer reports:\n");
	          printf("  Engines shutdown to avoid star, sir.\n\n");
                }
              else if (j == STATION)
                {
                  printf("Conning Officer reports:\n");
	          printf("  Engines shutdown to avoid starbase, sir.\n\n");
                }
              else if (j == KLINGON) 
                {
                  printf("Conning Officer reports:\n");
	          printf("  Engines shutdown to avoid Klingon, sir.\n\n");
                }
              /* Stop here, but still fall through to the docking and
                 condition update below: returning early left the ship
                 "Docked" after it had moved away from the starbase */
              break;
            }
          else
            {
               set_posit(posP);
               posit = posP;
               set_space((int) posit.fXSect, (int) posit.fYSect, SHIP);
            }
        }
    }

  /* Finish on a whole sector so the display, torpedoes and docking
     all agree on where the ship is */
  posit = get_posit();
  posit.fXSect = (int) posit.fXSect;
  posit.fYSect = (int) posit.fYSect;
  set_posit(posit);
  set_space((int) posit.fXSect, (int) posit.fYSect, SHIP);

  check_dock();
  set_condition();

  printf("\n");
  short_range_sensors();
}

