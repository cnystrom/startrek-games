/*
 *    location.c
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

#include <math.h>
#include "location.h"

vector
compute_vector(location l1, location l2)
{
  int a, b, a3, b3, x3, y3;
  double dTemp, x, y;
  vector v;

  a = l1.fX;
  b = l1.fY;
  x3 = l2.fX;
  y3 = l2.fY;

  x = y3 - b;
  y = a - x3;

  if (x == 0)
    {
      if (y > 0)
	dTemp = PI / 2.0;
      else if (y < 0)
	dTemp = -PI / 2.0;
      else
	dTemp = 0.0;
    }
  else if (y == 0)
    {
      if (x < 0)
	dTemp = PI;
      else
	dTemp = 0.0;
    }
  else
    {
      if (x < 0)
	{
	  if (y > 0)
	    dTemp = atan (y / x) + PI;
	  else
	    dTemp = atan (y / x) - PI;
	}
      else 
	dTemp = atan (y / x);
    }

  dTemp = dTemp * CONV;
  dTemp = 90.0 - dTemp;

  if (dTemp < 0.0)
    dTemp += 360.0;

  if (dTemp == 360.0)
    dTemp = 0.0;

  v.iDir = (int) dTemp;

  a3 = fabs(a - x3);
  b3 = fabs(b - y3);

  if (a3 > b3)
    v.iDist = a3;
  else
    v.iDist = b3;

  return v;
}

location
resolve_vector (location l, vector v)
{
  int cs2, cs3;
  float cs, x, y;
  location lRet;

/*  c[0] Controls movement in the x direction:

      -1    -1    -1

       0     0     0

       1     1     1

    c[1] controls movement in the y direction:

       -1    0     1

       -1    0     1

       -1    0     1

    Both start straight up at the 000 direction, which is covered
    twice, at the start and at the end of the array for overlap.

    Movement is always the full amount of v.iDist in either the x,
    or y direction, and a portion of v.iDist on the other
    coordinate.

    The purpose of this system is to accomodate a box like, as
    opposed to a more accurate circular display. Therefore,
    if you are at 1,1, and the other guy is at 6,6 you are only 5
    sectors away, which in reality you would be farther away than
    that.
*/

  int c[2][10] =
  {
    {-1, -1, 0, 1, 1, 1, 0, -1, -1, -1,},
    {0, 1, 1, 1, 0, -1, -1, -1, 0, 0}
  };

  cs = (float) (v.iDir / 45.0);
  cs2 = ((int) cs);
  cs3 = ((int) cs) + 1;

  x = c[0][cs2] + (c[0][cs3] - c[0][cs2]) * (cs - cs2);
  y = c[1][cs2] + (c[1][cs3] - c[1][cs2]) * (cs - cs2);

  lRet.fX = (x * v.iDist) + l.fX;
  lRet.fY = (y * v.iDist) + l.fY;

  return lRet;
}


