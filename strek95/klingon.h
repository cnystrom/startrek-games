/*
 *    klingon.h
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

#define MAX_KLINGONS_QUAD	3

struct klingon_struct
{
  int iXSect;
  int iYSect;
  int iEnergy;
};

typedef struct klingon_struct klingon;

void set_klingon(int iKlingonNum, int iXSect, int iYSect);
void set_klingon_energy(int iKlingonNum, int iEnergy);
klingon get_klingon(int iKlingonNum);
void del_klingon(int iXSect, int iYSect);
void clear_klingons(void);
void klingons_move(void);
void klingons_fire(void);

