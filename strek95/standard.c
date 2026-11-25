/*
 *    standard.c
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "disk_io.h"
#include "standard.h"

int get_lkey(void);

/* Get lowercase key */

int
get_lkey(void)
{
  int c;
  string s;

  fflush(stdin);

  gets(s);
  c  = s[0];;

  if (c < 97)
    c = c + 32;

  return c;
}

/* Print a prompt and get a y or n response */

int
y_or_n(char *s)
{
  int c;

  printf(s);
  c = get_lkey();

  while (c != 'y' && c != 'n')
    {
      printf(s);
      c = get_lkey();
    }

  return c;
}

/* Next Three Functions From K&R C Book */

/* reverse a string s in place */
void
reverse(char s[])
{
  int c, i, j;

  for (i = 0, j = strlen(s) - 1; i < j; i++, j--)
    {
      c = s[i];
      s[i] = s[j];
      s[j] = c;
    }
}

/* convert n to characters in s */
void
itoa(int n, char s[])
{
  int i, sign;

  if ((sign = n) < 0)  /* record sign */
    n = -n;

  i = 0;
  do
      s[i++] = n % 10 + '0';  /* get next digit */
  while ((n /= 10) > 0);

  if (sign < 0)
    s[i++] = '-';
  s[i] = '\0';

  reverse(s);
}
     
int
get_string(char *s1, char *s2)
{
  int c, i, lim = MAXLEN;

  printf(s1);

  i = 0;

  fflush(stdin);

  c = getchar();

  lim--;

  if (c != '\n')
    s2[i++] = c;
  else  
    s2[i++] = getchar();

  while (--lim > 0 && (c = getchar()) != EOF && c != '\n')
    s2[i++] = c;

  s2[i] = '\0';

  return i;
}

void
pause (void)
{
  string s;

  printf (" Hit ENTER or RETURN key to continue...");
  gets(s);
}

void
showfile(char *filename)
{
  line lBuffer;
  int iRow = 0;

  if (openfile(filename, "r") != 0)
    return;

  while (getline(lBuffer) != 0)
    {
      printf(lBuffer);
      
      if (iRow++ > MAXROW - 3)
        {
          pause();
          iRow = 0;
        }
    }

  closefile();
}

/* Round off floating point numbers instead of truncating */

int
cint (double d)
{
  int i;

  i = (int) (d + 0.5);

  return(i);
}

/* The following two functions from

   "Microsoft Quick C Programmer's Toolbox" by John Clark Craig

*/
   
char *
s_rot(char *s1, int n)
{
  int i, len;
  char *tmp;

  len = strlen(s1);

  n = (-n);

  if (n >= len)
    n %= len;

  if (n < 0)
    {
      n %= len;
      n += len;
    }

  if ((tmp = strdup(s1)) == NULL)
    return(NULL);

  for (i = 0; i < len; i++)
    {
      *s1++ = *(tmp + n);
      if (++n >= len)
        n -= len;
    }

  free(tmp);

  return(s1);
}

char *
s_center(char *s1)
{
  int i = 0, j, len;

  len = strlen(s1);

  while (s1[i] == ' ' && i < len)
    i++;

  j = len - 1;
  while (s1[j] == ' ' && j)
    j--;

  s_rot(s1, (len - j - i - 1) / 2);

  return(s1);
}
