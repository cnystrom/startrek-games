/*
 *    rank.h
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
 *    E-Mail: chris@gnu.ai.mit.edu, nystrom@cactus.org, or ccn@cfi.org
 *
 */

#define TOTAL_RANKS	6

#define CIVILIAN    0
#define ENSIGN      1
#define LIEUTENANT  2
#define COMMANDER   3
#define CAPTAIN     4
#define ADMIRAL     5

void set_name(void);
char * get_name(void);
void set_rank(int i);
int get_rank(void);
char * get_rank_name(int i);
void select_rank(void);
void promotion(void);
void demotion(void);
char * get_full_name(void);
void print_full_name(void);
bool promoted(void);

