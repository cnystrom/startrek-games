/*
 *    devices.h
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

#define DEVICE_TOT          10

#define IMPULSE_ENGINES     0
#define WARP_ENGINES        1 
#define SCANNER             2
#define SHORT_RANGE_SENSORS 3
#define LONG_RANGE_SENSORS  4
#define PHASERS             5
#define PHOTON_TORPEDOES    6
#define DAMAGE_CONTROL      7
#define SHIELDS             8
#define LIBRARY_COMPUTER    9

char * get_device_name(int iDevice);

