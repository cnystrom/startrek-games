/*
 *    qnames.c
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
#include <string.h>
#include "standard.h"
#include "qnames.h"

#define NAME_LIMIT	8
  
static char * quad_name[] = {"","Antares","Rigel","Procyon","Vega",
  "Canopus","Altair","Sagittarius","Pollux","Sirius","Deneb","Capella",
  "Betelgeuse","Aldebaran","Regulus","Arcturus","Spica"};

static char * sect_name[] = {""," I"," II"," III"," IV"};

char *
quadrant_name(int z4, int z5)
{
  static string sG2;

  if (z4 < 1 || z4 > NAME_LIMIT || z5 < 1 || z5 > NAME_LIMIT)
    return("Unknown");

  if (z5 <= 4)
    strcpy(sG2, quad_name[z4]);
  else
    strcpy(sG2, quad_name[z4+8]);

  if (z5 > 4)
    z5 = z5 - 4;

  strcat(sG2, sect_name[z5]);

  return(sG2);
}

char *
map_name(int z4, int z5)
{
  int len;
  static string sG2;

  if (z4 < 1 || z4 > NAME_LIMIT || z5 < 1 || z5 > NAME_LIMIT)
    strcpy(sG2, "Unknown");
  else if (z5 <= 4)
    strcpy(sG2, quad_name[z4]);
  else
    strcpy(sG2, quad_name[z4+8]);

  len = strlen(sG2);

  while (len < 24)
    {
      sG2[len] = ' ';
      len ++;
    }

  sG2[23] = '\0';

  return(s_center(sG2));
}

