/*
 *    standard.h
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

#ifndef FALSE
#define FALSE        0
#endif

#ifndef TRUE
#define TRUE         1
#endif

#define NUL          0
#define SOH          1
#define STX          2
#define ETX          3
#define EOT          4
#define ENQ          5
#define ACK          6
#define BEL          7
#define BS           8
#define HT           9
#define LF          10
#define VT          11
#define NP          12    /* New Page */
#define FF          12    /* Also Form Feed */
#define CR          13
#define SO          14
#define SI          15
#define DLE         16
#define DC1         17
#define DC2         18
#define DC3         19
#define DC4         20
#define NAK         21
#define SYN         22
#define ETB         23
#define CAN         24
#define EM          25
#define SUB         26
#define ESC         27
#define FS          28
#define GS          29
#define RS          30
#define US          31

#define DEL        127

#define BLOCK_SIZE 2048    /* 2k block size */

/* Standard Line Length */

#define MAXLEN     255

/* Standard Terminal Sizes */

#define MAXROW	    24
#define MAXCOL      80

/* Standard Page Size */

#define MAXLINES    66

/* Useful typedefs */

#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202000L
typedef int bool;   /* bool is a keyword from C23 on */
#endif
typedef char line[MAXCOL];
typedef char string[MAXLEN];

/* Standard function definitions */

int y_or_n(char *s);
void itoa(int n, char s[]);
int get_string(char *s1, char *s2);
void read_line(char *s, int size);
int get_number(char *prompt, double *d);
void pause (void);
void showfile(char *filename);
int cint(double d);
char * s_rot(char *s1, int n);
char * s_center(char *s1);

