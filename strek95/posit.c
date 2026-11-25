/*
 *    posit.c
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
#include "standard.h"
#include "galaxy.h"
#include "space.h"
#include "klingon.h"
#include "rand.h"
#include "posit.h"

posit pos;

void
set_posit(posit posP)
{
  pos = posP;
}

posit
get_posit(void)
{
  return(pos);
}

posit
get_rand_posit(void)
{
  posit posP;

  posP.iXQuad = get_rand(GALSIZE);
  posP.iYQuad = get_rand(GALSIZE);
  posP.fXSect = get_rand(QUADSIZE);
  posP.fYSect = get_rand(QUADSIZE);

  return(posP);
}

void
new_posit(void)
{
  set_posit(get_rand_posit());
}

vector
compute_dirdist(posit posP1, posit posP2)
{
  location l1, l2;

  l1.fX = ((posP1.iXQuad - 1) * QUADSIZE) + (int) posP1.fXSect;
  l1.fY = ((posP1.iYQuad - 1) * QUADSIZE) + (int) posP1.fYSect;
  l2.fX = ((posP2.iXQuad - 1) * QUADSIZE) + (int) posP2.fXSect;
  l2.fY = ((posP2.iYQuad - 1) * QUADSIZE) + (int) posP2.fYSect;

  return compute_vector(l1, l2);
}

posit
course_spd (posit posP, int iCourse, int iVelocity)
{
  int a2, b2;
  float x, x2, y, y2;
  location l1, l2;
  vector v;
  posit posRet;

  /* Convert to Single Plane vice Quad/Sect */

  l1.fX = (float) ((posP.iXQuad - 1) * QUADSIZE) + posP.fXSect;
  l1.fY = (float) ((posP.iYQuad - 1) * QUADSIZE) + posP.fYSect;

  v.iDir = iCourse;
  v.iDist = iVelocity;

  l2 = resolve_vector(l1, v);

  /* Convert back to Quad/Sect */

  x = l2.fX;
  y = l2.fY;
  
  a2 = (((int) x) / QUADSIZE) + 1;
  b2 = (((int) y) / QUADSIZE) + 1;

  x2 = (x - (float) ((a2 - 1) * QUADSIZE));
  if ((int) x2 <= 0)
    {
      x2 = QUADSIZE;
      a2 = a2 - 1;
    }
  y2 = (y - (float) ((b2 - 1) * QUADSIZE));
  if ((int) y2 <= 0)
    {
      y2 = QUADSIZE;
      b2 = b2 - 1;
    }
  posRet.iXQuad = a2;
  posRet.iYQuad = b2;
  posRet.fXSect = x2;
  posRet.fYSect = y2;

  return posRet;
}

void
course_display(void)
{

  printf("        000\n");
  printf("         |\n");
  printf("         |\n");
  printf(" 270 <- <+> -> 090\n");
  printf("         |\n");
  printf("         |\n");
  printf("        180\n\n");

}

