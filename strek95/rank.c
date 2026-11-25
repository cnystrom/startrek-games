/*
 *    rank.c
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
#include "rank.h"

void set_full_name(void);
int show_ranks(void);

int    iRank;
bool   bPromotion = TRUE;

string sFullName,
       sName;

static char *
sRanks[] = {"Civilian",
            "Ensign",
            "Lieutenant",
            "Commander",
            "Captain",
            "Admiral"};

void
set_name(void)
{
  get_string("\nEnter your last name: ", sName);

  set_full_name();
}

void
set_full_name(void)
{
  strcpy(sFullName, get_rank_name(iRank));
  strcat(sFullName, " ");
  strcat(sFullName, sName);
}

char *
get_name(void)
{
  return(sName);
}

void
set_rank(int i)
{
  if (i >= 0 && i <= TOTAL_RANKS)
    iRank = i;
}

int
get_rank(void)
{
  return(iRank);
}

char *
get_rank_name(int i)
{
  return(sRanks[i]);
}

void
select_rank(void)
{
  int i = 0;

  while (i < 1 || i >= TOTAL_RANKS)
    i = show_ranks();

  set_rank(i);
}

int
show_ranks(void)
{
  int i;

  printf("\n");

  for (i = 1; i < TOTAL_RANKS; i++)
    {
      printf("%d. %s\n", i, get_rank_name(i));
    }

  printf("\nSelect Rank: ");

  i = getchar() - 48;

  return i;
}

void
promotion(void)
{
  printf("Well done, %s.\n\n", get_rank_name(iRank));

  if (iRank < ADMIRAL)
    {
      iRank++;
      printf("Starfleet promotes you to %s.\n\n", get_rank_name(iRank));
    }
  else
    bPromotion = FALSE;

  set_full_name();
}

void
demotion(void)
{
  if (iRank == CIVILIAN)
    {
      printf("Your Starfleet career is over.\n\n");
      exit (0);
    }

  iRank--;
  printf("Starfleet demotes you to %s.\n\n", get_rank_name(iRank));

  bPromotion = TRUE; /* variable actual flags changes in status */

  set_full_name();
}

char *
get_full_name(void)
{
  return(sFullName);
}

void
print_full_name(void)
{
  printf(sFullName);
}

bool
promoted(void)
{
  return(bPromotion);
}

