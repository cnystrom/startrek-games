/*
 *    shiptype.h
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

#define TOT_SHIP_TYPES    23

#define PATROL      1
#define CORVETTE    2
#define TORPCRAFT   3
#define FRIGATE     4
#define DESTROYER   5
#define LCRUISER    6
#define HCRUISER    7
#define MONITOR     8
#define BCRUISER    9
#define BATTLESHIP  10
#define DREADNOUGHT 11
#define DEATHSTAR   12
#define STARBASE    13
#define OUTPOST     14
#define SPACEDOCK   15
#define SENSOR      16
#define FUELER      17
#define REPAIR      18
#define FREIGHTER   19
#define TRANSPORT   20
#define TANKER      21
#define BARGE       22

char * get_typename(int iType);
char * get_image(int iType);
int get_maneuver(int iType);
int get_maxvelocity(int iType);
int get_maxfuel(int iType);
int get_maxenergy(int iType);
int get_gencap(int iType);
int get_maxphaser(int iType);
int get_maxtorp(int iType);
int get_maxsheild(int iType);
int get_armor(int iType);

