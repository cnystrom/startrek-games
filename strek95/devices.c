/*
 *    devices.c
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

#include "devices.h"

static char * devices[] =
  {
    "Impulse Engines",
    "Warp Engines",
    "Scanners",
    "Short Range Sensors",
    "Long Range Sensors",
    "Phasers",
    "Photon Torpedoes",
    "Damage Control",
    "Shields",
    "Library Computer"
  };

char *
get_device_name(int iDevice)
{
  if (iDevice >= 0 && iDevice < DEVICE_TOT)
    return(devices[iDevice]);
  else
    return 0;
}

