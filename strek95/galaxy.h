/*
 *    galaxy.h
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

#define GALSIZE		8	/* Galaxy Size in Quadrants */

/* Max Number of Stars and stations in a Quadrant */

#define MAX_STARS	5
#define MAX_STATIONS    1

void new_galaxy(int iRank);
int get_galaxy(int iXQuad, int iYQuad);
int get_tot_klingons(void);
int get_tot_starbases(void);
int get_klingons_left(void);

void add_ship_galaxy(int iXQuad, int iYQuad);
void add_station_galaxy(int iXQuad, int iYQuad);
void add_star_galaxy(int iXQuad, int iYQuad, int i);
void sub_ship_galaxy(int iXQuad, int iYQuad);
void sub_station_galaxy(int iXQuad, int iYQuad);

