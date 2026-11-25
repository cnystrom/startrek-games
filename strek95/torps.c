/*
 *    torps.c
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
#include "location.h"
#include "score.h"
#include "standard.h"
#include "galaxy.h"
#include "space.h"
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
  register i, j;
  int iCourse;
  string s;
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
      
  get_string("Torpedo Course: ", s);

  printf("\n");

  iCourse = atoi(s);

  if (iCourse < 0 || iCourse > 360)
    {
      printf("\nWeapons Officer reports:\n");
      printf("  Invalid torpedo course, sir.\n\n");
      return;
    }

  sub_torpedo();

  printf("\nTorpedo Track:\n");

  posit = posP = get_posit();

  for (i = 0; i < QUADSIZE; i++)
    {

      posP = course_spd(posP, iCourse, 1);

      if ((posit.iXQuad != posP.iXQuad) || (posit.iYQuad != posP.iYQuad))
        {
          printf("  Torpedo Missed\n\n");
          return;
        }
      else
        {

          printf("       %d %d\n", (int) posP.fXSect, (int) posP.fYSect); 

          j = get_space((int) posP.fXSect, (int) posP.fYSect);

          if (j != SPACE)
            {
              if (j == STAR)
                printf ("Star absorbs torpedo.\n\n");
              else if (j == STATION)
                {
	          printf ("*** Station Destroyed ***\n\n");
		  beep();
                  sub_station_galaxy(posP.iXQuad, posP.iYQuad);
                  sub_station_space((int) posP.fXSect, (int) posP.fYSect);
		  demotion();
		  sub_score(1000);
                }
              else if (j == KLINGON) 
	        {
                  printf ("*** Klingon Destroyed ***\n\n");
		  beep();
                  sub_ship_galaxy(posP.iXQuad, posP.iYQuad);
                  del_klingon((int) posP.fXSect, (int) posP.fYSect);
                  add_score(300);
		  if (get_klingons_left() <= 0)
		    won_game();
                }
              return;
            }
        }
    }
}

