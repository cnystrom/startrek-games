/*
 *    torps.c
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
#include "location.h"
#include "score.h"
#include "standard.h"
#include "galaxy.h"
#include "space.h"
#include "starbase.h"
#include "ship.h"
#include "klingon.h"
#include "posit.h"
#include "devices.h"
#include "damage.h"
#include "rank.h"
#include "sound.h"
#include "end_game.h"

void
photon_torpedoes(void)
{
  register int i, j;
  int iCourse, iX, iY;
  double d;
  posit posit, posP;

  if (damaged(PHOTON_TORPEDOES))
    {
      printf("Weapons Officer reports:\n");
      printf("  Photon torpedos not available, sir.\n\n");
      return;
    }

  if (get_torpedoes() <= 0)
    {
      printf("Weapons Officer reports:\n");
      printf("  No torpedoes left, sir.\n\n");
      return;
    }

  course_display();
      
  if (! get_number("Torpedo Course: ", &d) || d < 0 || d > 360)
    {
      printf("\nWeapons Officer reports:\n");
      printf("  Invalid torpedo course, sir.\n\n");
      return;
    }
  iCourse = (int) d;

  sub_torpedo();

  printf("\nTorpedo Track:\n");

  posit = posP = get_posit();

  for (i = 0; i < QUADSIZE; i++)
    {

      posP = course_spd(posP, iCourse, 1);

      /* Round to the nearest sector, as BASIC does (INT(X+.5)), so a
         torpedo aimed straight at a target hits it.  Work relative to
         the ship's quadrant so rounding across its edge is handled. */
      iX = cint((posP.iXQuad - posit.iXQuad) * QUADSIZE + posP.fXSect);
      iY = cint((posP.iYQuad - posit.iYQuad) * QUADSIZE + posP.fYSect);

      if (iX < 1 || iX > QUADSIZE || iY < 1 || iY > QUADSIZE)
        {
          printf("  Torpedo Missed\n\n");
          return;
        }
      else
        {
          printf("       %d %d\n", iX, iY);

          j = get_space(iX, iY);

          if (j != SPACE)
            {
              if (j == STAR)
                printf ("Star absorbs torpedo.\n\n");
              else if (j == STATION)
                {
	          printf ("*** Station Destroyed ***\n\n");
		  beep();
                  sub_station_galaxy(posit.iXQuad, posit.iYQuad);
                  /* del_starbase also forgets the base, so the ship
                     can no longer dock at (or be shielded by) it */
                  del_starbase(iX, iY);
                  set_condition();
		  demotion();
		  sub_score(1000);
                }
              else if (j == KLINGON) 
	        {
                  printf ("*** Klingon Destroyed ***\n\n");
		  beep();
                  sub_ship_galaxy(posit.iXQuad, posit.iYQuad);
                  del_klingon(iX, iY);
                  add_score(300);
		  if (get_klingons_left() <= 0)
		    won_game();
                }
              return;
            }
        }
    }
}

