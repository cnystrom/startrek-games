/*
 *    starbase.c
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

#include "standard.h"
#include "space.h"
#include "starbase.h"

starbase sb;

void
set_starbase(int iXSect, int iYSect)
{
  sb.iXSect = iXSect;
  sb.iYSect = iYSect;
  sb.iEnergy = 3000;
}

starbase
get_starbase(void)
{
  return(sb);
}

void
clear_starbase(void)
{
  sb.iXSect = 0;
  sb.iYSect = 0;
  sb.iEnergy = -1;
}

void
del_starbase(int iXSect, int iYSect)
{
  clear_starbase();
  sub_station_space(iXSect, iYSect);
}

