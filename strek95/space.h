/*
 *    space.h
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

#define QUADSIZE	8    /* Number of sectors in a quadrant */

#define SPACE		0
#define SHIP		1
#define STATION		2
#define KLINGON		3
#define STAR		4

void new_space(int iXQuad, int iYQuad);
void set_space(int iXQuad, int iYQuad, int iObject);
int get_space(int iXSect, int iYSect);
int get_klingons_space(void);
void sub_klingon_space(int iXSect, int iYSect);
void sub_station_space(int iXSect, int iYSect);
void move_klingon(int iKNum);

