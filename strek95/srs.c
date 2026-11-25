/*
 *    srs.c
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
#include "stardate.h"
#include "posit.h"
#include "shiptype.h"
#include "ship.h"
#include "galaxy.h"
#include "space.h"
#include "devices.h"
#include "damage.h"

void
short_range_sensors(void)
{
  register i, j;
  int iObject;
  posit posit = get_posit();

  if (get_condition() == RED)
    printf("Combat Area Condition Red\n");

  for (i = 0; i < (QUADSIZE/2); i++)
    printf(" ");
  printf("Short Range Scan\n");

  for (i = 0; i < (QUADSIZE * 3); i++)
    printf("-");
  printf("\n");

  for (i = 1; i <= QUADSIZE; i++)
    {
      if (damaged(SHORT_RANGE_SENSORS))
        {
          if (i == 4)
            {
              for (j = 0; j < (QUADSIZE/2) + 1; j++)
                printf(" ");
              printf("Not Available ");
              for (j = 0; j < (QUADSIZE/2) + 1; j++)
                printf(" ");
            }
          else
            for (j = 1; j <= QUADSIZE; j++)
              printf("   ");
        }
      else
        {
          for (j = 1; j <= QUADSIZE; j++)
            {
              iObject = get_space(i, j);
              if (damaged(SHORT_RANGE_SENSORS))
                printf("   ");
              else if (iObject == SHIP)
                printf(get_image(get_shiptype()));
              else if (iObject == KLINGON)
                printf("+K+");
              else if (iObject == STATION)
                printf(">?<");
              else if (iObject == STAR)
                printf(" * ");
              else
                printf("   ");
            }
        }

      if (i == 1)
         printf("  Stardate:   %5.1f\n", get_stardate());
      else if (i == 2)
         printf("  Condition:  %s\n", get_condition_name());
      else if (i == 3)
         printf("  Quadrant:   %d, %d\n", posit.iXQuad, posit.iYQuad);
      else if (i == 4)
         printf("  Sector:     %d, %d\n", cint(posit.fXSect),
         cint(posit.fYSect));
      else if (i == 5)
         printf("  Torpedoes:  %d\n", get_torpedoes());
      else if (i == 6)
         printf("  Energy:     %d\n", get_energy());
      else if (i == 7)
         printf("  Shields:    %d\n", get_shields());
      else if (i == 8)
         printf("  Klingons:   %d\n", get_klingons_left());
      else
        printf("\n");
    }

  for (i = 0; i < (QUADSIZE * 3); i++)
    printf("-");
  printf("\n\n");
}

