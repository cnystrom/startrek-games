/*
 *    scanners.c
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
#include "standard.h"
#include "damage.h"
#include "devices.h"
#include "klingon.h"
#include "starbase.h"

void
scanners(void)
{
  register int i;
  int iFlag = TRUE;
  klingon klingon;
  starbase starbase = get_starbase();

  if (damaged(SCANNER))
    {
      printf("Science Officer reports:\n");
      printf("  Scanner not operational, Captain.\n\n");
      return;
    }

  for (i = 1; i <= MAX_KLINGONS_QUAD; i++)
    {
      klingon = get_klingon(i);
      if (klingon.iEnergy >= 0)
        {
          printf("Science Officer Reports:\n");
          printf("    Klingon Battlecruiser at sector ");
          printf("%d,%d with %d units of energy.\n\n", klingon.iXSect,
            klingon.iYSect, klingon.iEnergy);
          iFlag = FALSE;
        }
    }

  if (starbase.iEnergy >= 0)
    {
      printf("Science Officer Reports:\n");
      printf("    Starbase at sector %d,%d with %d units of energy.\n\n",
        starbase.iXSect, starbase.iYSect, starbase.iEnergy);
      iFlag = FALSE;
    }

  if (iFlag)
    {
      printf("Science Officer Reports:\n  Scanners show no signs of Klingon");
      printf(" warships, sir.\n\n");
    }
}

