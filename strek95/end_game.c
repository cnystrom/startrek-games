/*
 *    end_game.c
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
#include "stardate.h"
#include "rank.h"
#include "galaxy.h"
#include "ship.h"
#include "score.h"
#include "end_game.h"

extern void new_game(void);

void
ship_destroyed(void)
{
  int i;

  i = get_klingons_left();

  printf("The %s has been destroyed. ", get_shipname());
  printf("These quadrants will be conquered.\n\n");
  printf("You have escaped in an escape pod.\n\n");

  demotion();

  printf("There ");
  if (i == 1)
    printf("was 1 Klingon Battlecruiser");
  else
    printf("were %d Klingon Battlecruisers", i);
  printf(" left at the end of your mission.\n\n");

  end_game();
}

void
end_of_time(void)
{
  printf("It is stardate ");
  print_stardate();
  printf(". You are out of time.\n");
  printf("This portion of the Federation will be conquered.\n\n");
  printf("There were %d Klingon Battlecruisers", get_klingons_left());
  printf(" left at the end of your mission.\n\n");

  end_game();
}

void
resign_commision(void)
{
  printf("Your resignation has been accepted.\n\n");

  printf("There were %d Klingon Battlecruisers", get_klingons_left());
  printf(" left at the end of your mission.\n\n");

  end_game();
}

void
won_game(void)
{
  printf("Congratulations, ");
  print_full_name();
  printf("!\n\n");
  printf("The last Klingon Battle Cruiser ");
  printf("menacing the Federation has been destoyed.\n\n");
  printf("Your efficiency rating is %6.1f\n\n", get_rating());
  printf("Your score is %6.1f\n\n", get_score());

  promotion();

  end_game();
}

void
end_game(void)
{
  string sTemp;

  if (get_tot_starbases() > 0)
    {
      printf("The Federation is in need of a new starship commander");
      printf(" for a similar mission.\n");
      printf("If there is a volunteer, let him step forward and");
      printf(" enter 'aye': ");

      gets(sTemp);
      printf("\n");

      if (! strncmp(sTemp, "aye", 3))
        new_game();
    }

  printf("Fair winds and following seas, %s.\n\n", get_full_name());
  printf("Starfleet out.\n\n");

  exit(0);
}

