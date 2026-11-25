/*
 *    startrek.c
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
#include <string.h>
#include "standard.h"
#include "location.h"
#include "devices.h"
#include "damage.h"
#include "galaxy.h"
#include "space.h"
#include "posit.h"
#include "shiptype.h"
#include "ship.h"
#include "klingon.h"
#include "stardate.h"
#include "galrec.h"
#include "rank.h"
#include "score.h"
#include "sound.h"
#include "rand.h"

void intro (void);
void new_game(void);
void show_menu(void);

extern void instructions(void);
extern void end_game(void);
extern void end_of_time(void);
extern void computer(void);
extern void do_dc(void);
extern void resign_commision(void);
extern void impulse_engines(void);
extern void long_range_sensors(void);
extern void phasers(void);
extern void scanners(void);
extern void shield_control(void);
extern void short_range_sensors(void);
extern void photon_torpedoes(void);
extern void warp_engines(void);

void
main (void)
{
  intro (); 
  new_game();
}

void
intro (void)
{
  printf("Super Star Trek 95, Copyright (C) 1995 Chris Nystrom\n");
  printf("Super Star Trek 95 comes with ABSOLUTELY NO WARRANTY\n");
  printf("This is free software, and you are welcome to redistribute it\n");
  printf("under certain conditions: type `copying' at the main menu for\n");
  printf("details.\n\n");

  printf (" ******  *******  ******  *****  \n");
  printf (" *          *     *    *  *    * \n");
  printf (" *          *     *    *  *    * \n");
  printf (" ******     *     ******  *****  \n");
  printf ("      *     *     *    *  *    * \n");
  printf ("      *     *     *    *  *    * \n");
  printf ("      *     *     *    *  *    * \n");
  printf (" ******     *     *    *  *    * \n");
  printf ("\n");
  printf (" *******  *****   ******  *    * \n");
  printf ("    *     *    *  *       *   * \n");
  printf ("    *     *    *  *       *  *  \n");
  printf ("    *     *****   *****   ***   \n");
  printf ("    *     *    *  *       *  *  \n");
  printf ("    *     *    *  *       *   * \n");
  printf ("    *     *    *  *       *    * \n");
  printf ("    *     *    *  ******  *    * \n");
  printf ("\n\n   (c) 1995 by Chris Nystrom\n\n");

  instructions();
  randomize();
  new_stardate();
  new_score();
  select_rank();
  set_name();
}

void
new_game(void)
{ 
  int iDeadline, iRank, iTotKlingons, iTotStations, iShipType;
  string sCommand;
  posit posit;
  
  iRank = get_rank();

  new_damage();
  new_ship(iRank);
  new_galaxy(iRank);
  new_galrec();

  posit = get_posit();
  new_space(posit.iXQuad, posit.iYQuad);

  /*  Print Greeting */

  iTotKlingons = get_tot_klingons();
  iDeadline = iTotKlingons * 5 + (10 - (iRank * 2)) + get_rand(5);
  if (iDeadline < 10)
    iDeadline = 10;
  set_deadline(iDeadline);
  iTotStations = get_tot_starbases();
  iShipType = get_shiptype();

  printf("\n--\n\n");


  if (iRank == CIVILIAN)
    {
      printf("Welcome %s.\n\n", get_full_name());
      printf("Your simulation cruise will be aboard the Federation ");
      printf("%s %s.\n", get_typename(iShipType), get_shipname());
      printf("Please take the helm.\n\n");
    }
  else if (promoted())
    {
      printf("Welcome %s.\n\n", get_full_name());
      printf("You have been given command of the Federation %s %s.\n\n",
        get_typename(iShipType), get_shipname());
    }

  if (iTotKlingons > 0)
    {
      printf("Your orders are to destroy the %d Klingon", iTotKlingons);
      if (iTotKlingons > 1)
        printf("s that have");
      else
        printf(" that has");
      printf(" invaded this system.\n");
      printf("You have %2.1f stardates to complete your mission.\n\n", 
        get_timeleft());
    }

  if (iTotStations > 1)
    printf ("There are %d Starbases for resupplying your ship.\n\n",
      iTotStations);

  if (iTotStations == 1)
    printf ("There is 1 Starbase to resupply your ship.\n\n");

  if (iRank)
    printf("Good luck, %s.\n\n", get_rank_name(iRank));

  printf("--\n\n");

  /*    MAIN LOOP    */

  do
    {
      if ((get_energy() + get_shields()) <= 0)
        {
          printf("You have run out of energy and you do not have any");
          printf(" energy to divert to your\n");
          printf(" shields. Your ship is stranded in space!\n\n");
          printf("Your ship is towed back to a starbase and you are");
          printf(" relieved of command.\n\n");
          demotion();
          end_game();
        }

      if (get_timeleft() < 0)
        end_of_time();

      get_string("Command: ", sCommand);

      printf("\n");

      repair_damage();
      klingons_move();
      klingons_fire();
      add_stardate(.1);

      if (strncmp (sCommand,"com",3) == 0)
	computer();

      else if (strncmp (sCommand,"copying",7) == 0)
	showfile("COPYING");

      else if (strncmp (sCommand,"dam",3) == 0)
        do_dc();

      else if (strncmp (sCommand,"end",3) == 0)
        resign_commision();

      else if (strncmp (sCommand,"quit",4) == 0)
        resign_commision();

      else if (strncmp (sCommand,"help",4) == 0)
	show_menu ();

      else if (strncmp (sCommand,"imp",3) == 0)
	impulse_engines();

      else if (strncmp (sCommand,"ins",3) == 0)
	showfile("startrek.doc");

      else if (strncmp (sCommand,"lrs",3) == 0)
        long_range_sensors();

      else if (strncmp (sCommand,"pha",3) == 0)
	phasers();

      else if (strncmp (sCommand,"sca",3) == 0)
        scanners();

      else if (strncmp (sCommand,"she",3) == 0)
        shield_control();

      else if (strncmp (sCommand,"snd",3) == 0)
        toggle_sound();

      else if (strncmp (sCommand,"srs",3) == 0)
	short_range_sensors();

      else if (strncmp (sCommand,"tor",3) == 0)
	photon_torpedoes();

      else if (strncmp (sCommand,"wrp",3) == 0)
	warp_engines();

      else
	show_menu ();
    }
  while(1);
}

void
show_menu(void)
{
  printf("     Available Commands:\n\n");
  printf(" com  - Library Computer.\n");
  printf(" dam  - Damage Control.\n");
  printf(" end  - Resign Commision.\n");
  printf(" imp  - Impulse Engines.\n");
  printf(" lrs  - Long Range Sensors.\n");
  printf(" pha  - Phasers.\n");
  printf(" tor  - Torpedoes.\n");
  printf(" sca  - Scanners.\n");
  printf(" she  - Shield Control.\n");
  printf(" snd  - Toggle Beep.\n");
  printf(" srs  - Short Range Sensors.\n");
  printf(" wrp  - Warp Engines.\n\n");
}
