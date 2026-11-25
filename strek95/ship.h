/*
 *    ship.h
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

#define SHIPNAME_LEN	12

/* Conditions */

#define DOCKED	   0
#define GREEN	   1
#define YELLOW	   2
#define RED	   3

struct ship_struct
{
  int iShipType;
  char sShipName[SHIPNAME_LEN];
  int iCondition;
  int iEnergy;
  int iTorpedoes;
  int iShields;
};

typedef struct ship_struct ship;

void set_shiptype(int i);
int get_shiptype(void);
void set_shipname(char *sShipName);
char * get_shipname(void);
void set_condition(void);
int get_condition(void);
char * get_condition_name(void);
void set_torpedoes(int iTorpedoes);
void sub_torpedo(void);
int get_torpedoes(void);
void set_energy(int iEnergy);
int get_energy(void);
void sub_energy(int iEnergy);
void set_shields(int iShields);
int get_shields(void);
void new_ship(int iRank);
void check_dock(void);
int next_to_station(void);
void undock(void);

