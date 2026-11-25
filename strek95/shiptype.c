/*
 *    shiptype.c
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

#include "shiptype.h"

struct shiptype
{
  char *sTypeName;
  char *sImage;
  int  iManeuver;
  int  iMaxVelocity;
  int  iMaxFuel;
  int  iMaxEnergy;
  int  iGenCap;
  int  iMaxPhaser;
  int  iMaxTorp;
  int  iMaxShield;
  int  iArmor;
} shiptype[] =
{
  {"Nothing",      "   ",  0,  0,    0,     0,    0,    0,   0,    0,   0},
  {"Patrol",       "{+}", 60,  8,  100,   500,  150,   50,   0,   50,   0},
  {"Corvette",     "{=}", 80, 10,  150,   700,  200,   50,   0,   50,   0},
  {"Torpedo Craft","(=)", 80, 10,  150,   800,  200,    0,   4,   50,   0},
  {"Frigate",      "(+)", 90, 12,  200,  1000,  250,  100,   4,  100,  10},
  {"Destroyer",    "<+>", 60, 10,  300,  1500,  200,  150,   8,  150,  20},
  {"Light Cruiser","[+]", 50, 10,  600,  2000,  300,  200,  12,  200,  30},
  {"Heavy Cruiser","{+}", 40,  8,  750,  2700,  300,  250,  16,  250,  40},
  {"Monitor",      "<Q>", 10,  2, 1000,  3500,  350,  350,   0,  350,  60},
  {"BattleCruiser","(#)", 30,  8, 1200,  4200,  350,  300,  20,  300,  50},
  {"Battleship",   "<#>", 20,  6, 1800,  5400,  450,  350,  24,  400,  60},
  {"Dreadnought",  "[#]", 20,  6, 2000,  6000,  500,  400,  30,  400,  70},
  {"Death Star",   "-+O",  5,  2, 8000, 16000, 2000, 4000,   0, 1500, 100},
  {"Starbase",     ">O<",  0,  0, 5000, 12000, 1000,  500, 150,  600,  80},
  {"Space Outpost",">=<",  0,  0, 3000,  6000,  500,  250,  50,  300,  40},
  {"Space Dock",   ">+<",  0,  0, 2000,  2000,  300,    0,   0,  200,  20},
  {"Sensor Ship",  ")-(", 30,  8,  200,  1000,  150,  100,   0,  100,  10},
  {"Fueler",       "+@+", 30, 10, 3000,  2000,  300,  200,  50,  200,  20},
  {"Repair Ship",  "+X+", 20,  6, 1000,  1000,  200,  100,   0,  100,   0},
  {"Freighter",    "=O=", 10,  2,  200,   200,  100,    0,   0,   25,   0},
  {"Transport",    "(H)", 10,  2,  200,   200,  100,    0,   0,   25,   0},
  {"Tanker",       "+O+", 10,  2, 1000,   200,  100,    0,   0,   25,   0},
  {"Barge",        "-O-", 10,  0, 1000,   100,   50,    0,   0,   25,   0},
  {"Klingon",      "+K+", 60, 10,  300,  1500,  200,  150,   8,  150,  20}
};

char *
get_typename(int iType)
{
  return shiptype[iType].sTypeName;
}

char *
get_image(int iType)
{
  return shiptype[iType].sImage;
}

int
get_maneuver(int iType)
{
  return shiptype[iType].iManeuver;
}

int
get_maxvelocity(int iType)
{
  return shiptype[iType].iMaxVelocity;
}

int
get_maxfuel(int iType)
{
  return shiptype[iType].iMaxFuel;
}

int
get_maxenergy(int iType)
{
  return shiptype[iType].iMaxEnergy;
}

int
get_gencap(int iType)
{
  return shiptype[iType].iGenCap;
}

int
get_maxphaser(int iType)
{
  return shiptype[iType].iMaxPhaser;
}

int
get_maxtorp(int iType)
{
  return shiptype[iType].iMaxTorp;
}

int
get_maxsheild(int iType)
{
  return shiptype[iType].iMaxShield;
}

int
get_armor(int iType)
{
  return shiptype[iType].iArmor;
}

