/*
 *    standard.c
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "disk_io.h"
#include "standard.h"

int get_lkey(void);

/* Read one line from stdin into s (at most size-1 chars), strip the
   newline and discard the rest of an over-long line.  End of input
   ends the game cleanly instead of looping forever. */

void
read_line(char *s, int size)
{
  char *nl;
  int ch;

  fflush(stdout);

  if (fgets(s, size, stdin) == NULL)
    {
      printf("\n");
      exit(0);
    }

  if ((nl = strchr(s, '\n')) != NULL)
    *nl = '\0';
  else
    while ((ch = getchar()) != '\n' && ch != EOF)
      ;
}

/* Prompt for a number.  Returns 1 and stores it in *d if the whole
   reply is a finite number, otherwise returns 0. */

int
get_number(char *prompt, double *d)
{
  string s;
  char *end;
  double v;

  get_string(prompt, s);
  v = strtod(s, &end);
  if (end == s)
    return 0;
  while (*end == ' ' || *end == '\t')
    end++;
  if (*end != '\0' || v != v || v > 1e9 || v < -1e9)
    return 0;
  *d = v;
  return 1;
}

/* Get lowercase key */

int
get_lkey(void)
{
  int c;
  string s;

  read_line(s, sizeof s);
  c = tolower((unsigned char) s[0]);

  return c;
}

/* Print a prompt and get a y or n response */

int
y_or_n(char *s)
{
  int c;

  fputs(s, stdout);
  c = get_lkey();

  while (c != 'y' && c != 'n')
    {
      fputs(s, stdout);
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
  fputs(s1, stdout);
  read_line(s2, MAXLEN);
  return strlen(s2);
}

void
pause (void)
{
  string s;

  printf (" Hit ENTER or RETURN key to continue...");
  read_line(s, sizeof s);
}

void
showfile(char *filename)
{
  line lBuffer;
  int iRow = 0;

  if (openfile(filename, "r") != 0)
    return;

  while (read_file_line(lBuffer) != 0)
    {
      fputs(lBuffer, stdout);
      
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

  if (len == 0)
    return(s1);

  n = (-n);

  if (n >= len)
    n %= len;

  if (n < 0)
    {
      n %= len;
      n += len;
    }

  if ((tmp = malloc(len + 1)) == NULL)
    return(NULL);
  strcpy(tmp, s1);

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
