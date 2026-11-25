/*
 * niotrek.c
 * NIO Port Copyright (C) 2002  <Chris Nystrom>
 *
 * Super Star Trek Classic (v1.1)
 * Retro Star Trek Game 
 * C Port Copyright (C) 1996  <Chris Nystrom>
 * 
 * This program is free software; you can redistribute it and/or modify
 * in any way that you wish. _Star Trek_ is a trademark of Paramount
 * I think.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * This is a C port of an old BASIC program: the classic Super Star Trek
 * game. It comes from the book _BASIC Computer Games_ edited by David Ahl
 * of Creative Computing fame. It was published in 1978 by Workman Publishing,
 * 1 West 39 Street, New York, New York, and the ISBN is: 0-89489-052-3.
 * 
 * See http://www.cfi.org/pub/ccn/startrek for more info.
 *
 * Contact Author of C port at:
 *
 * Chris Nystrom
 *
 * E-Mail: chris@gnu.ai.mit.edu, nystrom@cactus.org, or ccn@cfi.org
 *
 * BASIC -> Conversion Issues
 *
 *     - String Names changed from A$ to sA
 *     - Arrays changed from G(8,8) to g[9][9] so indexes can
 *       stay the same.
 *
 * Here is the original BASIC header:
 *
 * SUPER STARTREK - MAY 16, 1978 - REQUIRES 24K MEMORY
 *
 ***        **** STAR TREK ****        ****
 *** SIMULATION OF A MISSION OF THE STARSHIP ENTERPRISE,
 *** AS SEEN ON THE STAR TREK TV SHOW.
 *** ORIGINAL PROGRAM BY MIKE MAYFIELD, MODIFIED VERSION
 *** PUBLISHED IN DEC'S "101 BASIC GAMES", BY DAVE AHL.
 *** MODIFICATIONS TO THE LATTER (PLUS DEBUGGING) BY BOB
 *** LEEDOM - APRIL & DECEMBER 1974,
 *** WITH A LITTLE HELP FROM HIS FRIENDS . . .
 *** COMMENTS, EPITHETS, AND SUGGESTIONS SOLICITED --
 *** SEND TO:  R. C. LEEDOM
 ***           WESTINGHOUSE DEFENSE & ELECTRONICS SYSTEMS CNTR.
 ***           BOX 746, M.S. 338
 ***           BALTIMORE, MD  21203
 ***
 *** CONVERTED TO MICROSOFT 8 K BASIC 3/16/78 BY JOHN BORDERS
 *** LINE NUMBERS FROM VERSION STREK7 OF 1/12/75 PRESERVED AS
 *** MUCH AS POSSIBLE WHILE USING MULTIPLE STATMENTS PER LINE
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "nio_lib.h"

#ifndef FALSE
#define FALSE        0
#endif
 
#ifndef TRUE
#define TRUE         ! FALSE
#endif

/* Standard Terminal Sizes */
 
#define MAXROW      24
#define MAXCOL      80
 
/* Standard Page Size */
 
#define MAXLINES    66

typedef char line[MAXCOL];
 
/* Function Declarations */

void intro(void);
void new_game(void);
void initialize(void);
void new_quadrant(void);
void course_control(void);
void complete_maneuver(void);
void exceed_quadrant_limits(void);
void maneuver_energy(void);
void short_range_scan(void);
void long_range_scan(void);
void phaser_control(void);
void photon_torpedoes(void);
void torpedo_hit(void);
void damage_control(void);
void sheild_control(void);
void library_computer(void);
void galactic_record(void);
void status_report(void);
void torpedo_data(void);
void nav_data(void);
void dirdist_calc(void);
void galaxy_map(void);
void end_of_time(void);
void resign_commision(void);
void won_game(void);
void end_of_game(void);
void klingons_move(void);
void klingons_shoot(void);
void repair_damage(void);
void find_empty_place(void);
void insert_in_quadrant(void);
void get_device_name(void);
void string_compare(void);
void quadrant_name(void);
int function_d(int i);
int function_r(void);
void mid_str(char *a, char *b, int x, int y);
int cint(double d);
void compute_vector(void);
void sub1(void);
void sub2(void);
void showfile(char *filename);
int openfile(char * sFilename, char * sMode);
void closefile(void);
int getline(char *s);
int get_rand(int iSpread);
double rnd(void);

/* Global Variables */

int file_num;

int b3;                           /* Starbases in Quadrant */
int b4, b5;                 /* Starbase Location in sector */
int b9;                                 /* Total Starbases */

int c[3][10] = /* Used for location and movement */         
{
  { 0 },
  { 0, 0, -1, -1, -1,  0,  1, 1, 1, 0 },
  { 1, 1,  1,  0, -1, -1, -1, 0, 1, 1 }
};

int d0;                                     /* Docked flag */
int d1;                              /* Damage Repair Flag */
int e;                                   /* Current Energy */
int e0 = 3000;                          /* Starting Energy */
int g[9][9];                                     /* Galaxy */
int g5;                              /* Quadrant name flag */
int k[4][4];                               /* Klingon Data */
int k3;                            /* Klingons in Quadrant */
int k7;                               /* Klingons at start */
int k9;                             /* Total Klingons left */
int n;                       /* Number of secors to travel */
int p;                            /* Photon Torpedoes left */
int p0 = 10;                    /* Photon Torpedo capacity */
int q1, q2;             /* Quadrant Position of Enterprise */
int r1, r2;              /* Temporary Location Corrdinates */
int s;                             /* Current shield value */
int s3;                               /* Stars in quadrant */
int s8;                         /* Quadrant locating index */
int s9 = 200;                             /* Klingon Power */
int t0;                               /* Starting Stardate */
int t9;                                     /* End of time */
int z[9][9];                /* Cumulative Record of Galaxy */
int z3;                     /* string_compare return value */
int z1, z2;                /* Temporary Sector Coordinates */
int z4, z5;              /* Temporary quadrant coordinates */

double a, c1;                   /* Used by Library Computer */
double d[9];                                /* Damage Array */
double d4;         /* Used for computing damage repair time */
double s1, s2;     /* Current Sector Position of Enterprise */
double t;                               /* Current Stardate */
double w1;                                   /* Warp Factor */
double x, y, x1, x2;            /* Navigational coordinates */

char sA[4];                       /* An Object in a Sector */
char sC[7];                                   /* Condition */
char sQ[194];                /* Visual Display of Quadrant */

string sG2;                 /* Used to pass string results */

FILE *stream;
bool bFlag = FALSE;         /* Prevent multiple file opens */

/* Main Program */

int
main(int argc, char *argv[])
{
  char server[MAXHOSTNAMELEN];

  if (argc < 2)
    strcpy(server, "localhost");
  else
   strcpy(server, argv[1]);

  nio_app_init(server, "niotrek", "0.1");

  nio_color_background(255, 255, 255);

  file_num = nio_load_file("nio/niotrek/oldenter2.jpg");

  intro();

  new_game();

  return(0);
}

void
intro(void)
{
  string sTemp;

  nio_print("\n\n");
  nio_print(" *************************************\n");
  nio_print(" *                                   *\n");
  nio_print(" *                                   *\n");
  nio_print(" *      * * Super Star Trek * *      *\n");
  nio_print(" *                                   *\n");
  nio_print(" *                                   *\n");
  nio_print(" *************************************\n\n\n\n\n");

  nio_input("\nDo you need instructions (y/n): ", sTemp);

  if (sTemp[0] == 'y' || sTemp[0] == 'Y')
    showfile("startrek.doc");

  nio_clear_screen();

/*
  nio_print("\n\n");
  nio_print("                         ------*------\n");
  nio_print("         -------------   `---  ------'\n");
  nio_print("         `-------- --'      / /\n");
  nio_print("                  \\\\-------  --\n");
  nio_print("                  '-----------'\n");
  nio_print("\n       The USS Enterprise --- NCC - 1701\n\n\n");
*/
  nio_color_background(0, 0, 0);

  nio_draw_file(file_num, 0, 0);

  nio_play_music("l2b.f+.p16a.c+.p l4mn<b.>e8a2mspg+e8c+f+8b2");

  t = (get_rand(20) + 20) * 100;

  nio_pause("Hit any key to continue...");
}

void
new_game(void)
{
  string sTemp;

  initialize();

  new_quadrant();

  short_range_scan();

  while(1)
  {
    if (s + e <= 10 && (e < 10 || d[7] < 0))
    {
      nio_print("\n** Fatal Error **   ");
      nio_print("You've just stranded your ship in space.\n\n");
      nio_print("You have insufficient maneuvering energy,");
      nio_print(" and Shield Control is presently\n");
      nio_print("incapable of cross circuiting to engine room!!\n\n");
      end_of_time();
    }

    nio_input("Command? ", sTemp);

    nio_clear_screen();

    if (! strncmp(sTemp, "nav", 3))
      course_control();
    else if (! strncmp(sTemp, "srs", 3))
      short_range_scan();
    else if (! strncmp(sTemp, "lrs", 3))
      long_range_scan();
    else if (! strncmp(sTemp, "pha", 3))
      phaser_control();
    else if (! strncmp(sTemp, "tor", 3))
      photon_torpedoes();
    else if (! strncmp(sTemp, "she", 3))
      sheild_control();
    else if (! strncmp(sTemp, "dam", 3))
      damage_control();
    else if (! strncmp(sTemp, "com", 3))
      library_computer();
    else if (! strncmp(sTemp, "xxx", 3))
      resign_commision();
    else
    {
      nio_print("Enter one of the following:\n\n");
      nio_print("  nav - To Set Course\n");
      nio_print("  srs - Short Range Sensors\n");
      nio_print("  lrs - Long Range Sensors\n");
      nio_print("  pha - Phasers\n");
      nio_print("  tor - Photon Torpedoes\n");
      nio_print("  she - Sheild Control\n");
      nio_print("  dam - Damage Control\n");
      nio_print("  com - Library Computer\n");
      nio_print("  xxx - Resign Command\n");
      nio_print("\n");
    }
  }
}

void
initialize(void)
{
  int i, j;
  char sX[2] = "";
  char sX0[4] = "is";

  /* InItialize time */

  t0 = (int)t;
  t9 = 25 + get_rand(10);

  /* Initialize Enterprise */

  d0 = 0;
  e = e0;
  p = p0;
  s = 0;

  q1 = function_r();
  q2 = function_r();
  s1 = (double) function_r();
  s2 = (double) function_r();

  for (i = 1; i <= 8; i++)
    d[i] = 0.0;

  /* Setup What Exists in Galaxy */

  for (i = 1; i <= 8; i++)
    for (j = 1; j <= 8; j++)
    {
      k3 = 0;
      z[i][j] = 0;
      r1 = get_rand(100);
      if (r1 > 98)
        k3 = 3;
      else if (r1 > 95)
        k3 = 2;
      else if (r1 > 80)
        k3 = 1;

      k9 = k9 + k3;
      b3 = 0;

      if (get_rand(100) > 96)
        b3 = 1;

      b9 = b9 + b3;

      g[i][j] = k3 * 100 + b3 * 10 + function_r();
    }

  if (k9 > t9)
    t9 = k9 + 1;

  if (b9 == 0)
  {
    if (g[q1][q2] < 200)
    {
      g[q1][q2] = g[q1][q2] + 100;
      k9++;
    }

    g[q1][q2] = g[q1][q2] + 10;
    b9++;

    q1 = function_r();
    q2 = function_r();
  }

  k7 = k9;

  if (b9 != 1)
  {
    strcpy(sX, "s");
    strcpy(sX0, "are");
  }

  nio_print("Your orders are as follows:\n\n");
  nio_printf("   Destroy the %i ", k9);
  nio_print("Klingon warships which have invaded\n");
  nio_print(" the galaxy before they can attack Federation Headquarters\n");
  nio_printf(" on stardate %d. This gives you %d days. There %s\n", t0 + t9, t9, sX0);
  nio_printf(" %d starbase%s in the galaxy for resupplying your ship.\n\n", b9, sX);

  nio_pause("Hit any key to accept command. ");

  nio_color_background(255, 255, 255);

  nio_clear_screen();
}

void
new_quadrant(void)
{
  int i;

  z4 = q1;
  z5 = q2;
  k3 = 0;
  b3 = 0;
  s3 = 0;
  g5 = 0; 
  d4 = (double) get_rand(100) / 100 / 50;
  z[q1][q2] = g[q1][q2];

  if (q1 >= 1 && q1 <= 8 && q2 >= 1 && q2 <= 8)
  {
    quadrant_name();

    if (t0 != t)
      nio_printf("Now entering %s quadrant...\n\n", sG2);
    else
    {
      nio_print("\nYour mission begins with your starship located\n");
      nio_printf("in the galactic quadrant %s.\n\n", sG2);
    }
  }

  k3 = (int)(g[q1][q2] * .01);
  b3 = (int)(g[q1][q2] * .1 - 10 * k3);
  s3 = g[q1][q2] - 100 * k3 - 10 * b3;

  if (k3 > 0)
  {
    nio_print("Combat Area  Condition Red\n");

    if (s < 200)
      nio_print("Shields Dangerously Low\n");
  }

  for (i = 1; i <= 3; i++)
  {
    k[i][1] = 0;
    k[i][2] = 0;
    k[i][3] = 0;
  }

  for (i = 0; i <= 192; i++)
    sQ[i] = ' ';

  sQ[193] = '\0';

  /* Position Enterprise, then Klingons, Starbases, and stars */

  strcpy(sA, "<*>");
  z1 = (int) s1;
  z2 = (int) s2;
  insert_in_quadrant();

  if (k3 > 0)
  {
    for (i = 1; i <= k3; i++)
    {
      find_empty_place();

      strcpy(sA, "+K+");
      z1 = r1;
      z2 = r2;
      insert_in_quadrant();

      k[i][1] = r1;
      k[i][2] = r2;
      k[i][3] = 100 + get_rand(200);
    }
  }

  if (b3 > 0)
  {
    find_empty_place();

    strcpy(sA, ">!<");
    z1 = r1;
    z2 = r2;
    insert_in_quadrant();

    b4 = r1;
    b5 = r2;
  }

  for (i = 1; i <= s3; i++)
  {
    find_empty_place();

    strcpy(sA, " * ");
    z1 = r1;
    z2 = r2;
    insert_in_quadrant();
  }
}

void
course_control(void)
{
  int i, q4, q5;
  string sTemp;
  double c1;
  char sX[4] = "8";

  nio_input("Course (0-9): ", sTemp);

  c1 = atof(sTemp);
 
  if (c1 == 9.0)
    c1 = 1.0;

  if (c1 < 0 || c1 > 9.0)
  {
    nio_print("Lt. Sulu roports:\n");
    nio_print("  Incorrect course data, sir!\n\n");
    return;
  }

  if (d[1] < 0.0)
    strcpy(sX, "0.2");

  nio_printf("Warp Factor (0-%s): ", sX);

  nio_gets(sTemp);

  nio_print("\n");

  w1 = atof(sTemp);

  if (d[1] < 0.0 && w1 > 0.21)
  {
    nio_print("Warp Engines are damaged. ");
    nio_print("Maximum speed = Warp 0.2.\n\n");
    return;
  }

  if (w1 <= 0.0)
    return;

  if (w1 > 8.1)
  {
    nio_print("Chief Engineer Scott reports:\n");
    nio_print("  The engines will not take warp ");
    nio_printf("%4.1f!\n\n", w1);
    return;
  }

  n = cint(w1 * 8.0);
  
  if (e - n < 0)
  {
    nio_print("Engineering reports:\n");
    nio_print("  Insufficient energy available for maneuvering");
    nio_printf(" at warp %4.1f!\n\n", w1);

    if (s >= n && d[7] >= 0.0)
    {
      nio_print("Deflector Control Room acknowledges:\n");
      nio_printf("  %d units of energy presently deployed to shields.\n", s);
    }

    return;
  }

  klingons_move();

  repair_damage();

  strcpy(sA, "   ");
  z1 = (int)s1;
  z2 = (int)s2;
  insert_in_quadrant();

  x1 = c[1][(int)c1] + (c[1][(int)c1 + 1] - c[1][(int)c1]) * (c1 - (int)c1);
  x2 = c[2][(int)c1] + (c[2][(int)c1 + 1] - c[2][(int)c1]) * (c1 - (int)c1);

  x = s1;
  y = s2;
  q4 = q1;
  q5 = q2;

  for (i = 1; i <= n; i++)
  {
    s1 = s1 + x1;
    s2 = s2 + x2;

    z1 = (int)s1;
    z2 = (int)s2;

    if (z1 < 1 || z1 >= 9 || z2 < 1 || z2 >= 9)
    {
      exceed_quadrant_limits();
      complete_maneuver();
      return;
    }

    string_compare();

    if (z3 != 1) /* Sector not empty */
    {
      s1 = s1 - x1;
      s2 = s2 - x2;
      nio_print("Warp Engines shut down at sector ");
      nio_printf("%d, %d due to bad navigation.\n\n", z1, z2);
      i = n + 1;
    }
  }

  complete_maneuver();
}

void
complete_maneuver(void)
{
  double t8;

  strcpy(sA, "<*>");
  z1 = (int)s1;
  z2 = (int)s2;
  insert_in_quadrant();

  maneuver_energy();

  t8 = 1.0;

  if (w1 < 1.0)
    t8 = w1;

  t = t + t8;

  if (t > t0 + t9)
    end_of_time();

  short_range_scan();
}

void
exceed_quadrant_limits(void)
{
  int x5 = 0;   /* Outside galaxy flag */

  x = (8 * q1) + x + (n * x1);
  y = (8 * q2) + y + (n * x2);

  q1 = (int)(x / 8.0);
  q2 = (int)(y / 8.0);
  
  s1 = x - (q1 * 8);
  s2 = y - (q2 * 8);

  if ((int)s1 == 0)
  {
    q1 = q1 - 1;
    s1 = s1 + 8.0;
  }

  if ((int)s2 == 0)
  {
    q2 = q2 - 1;
    s2 = s2 + 8.0;
  }

  /* check if outside galaxy */

  if (q1 < 1)
  {
    x5 = 1;
    q1 = 1;
    s1 = 1.0;
  }

  if (q1 > 8)
  {
    x5 = 1;
    q1 = 8;
    s1 = 8.0;
  }

  if (q2 < 1)
  {
    x5 = 1;
    q2 = 1;
    s2 = 1.0;
  }

  if (q2 > 8)
  {
    x5 = 1;
    q2 = 8;
    s2 = 8.0;
  }

  if (x5 == 1)
  {
    nio_print("LT. Uhura reports:\n");
    nio_print("  Message from Starfleet Command:\n\n");
    nio_print("  Permission to attempt crossing of galactic perimeter\n");
    nio_print("  is hereby *denied*. Shut down your engines.\n\n");
    nio_print("Chief Engineer Scott reports:\n");
    nio_printf("  Warp Engines shut down at sector %d, ", (int)s1);
    nio_printf("%d of quadrant %d, %d.\n\n", (int)s2, q1, q2);
  }

  maneuver_energy();

  if (t > t0 + t9)
    end_of_time();

  t = t + 1;

  new_quadrant();
}

void
maneuver_energy(void)
{
  e = e - n - 10;

  if (e >= 0)
    return;

  nio_print("Shield Control supplies energy to complete maneuver.\n\n");

  s = s + e;
  e = 0;

  if (s <= 0)
    s = 0;
}

void
short_range_scan(void)
{
  int i, j;

  strcpy(sC, "GREEN");

  if (e < e0 * .1)
    strcpy(sC, "YELLOW");

  if (k3 > 0)
    strcpy(sC, "*RED*");

  d0 = 0;

  for (i = (int)(s1 - 1); i <= (int)(s1 + 1); i++)
    for (j = (int)(s2 - 1); j <= (int)(s2 + 1); j++)
      if (i >= 1 && i <= 8 && j >= 1 && j <= 8)
      {
        strcpy(sA, ">!<");
        z1 = i;
        z2 = j;
        string_compare();
        if (z3 == 1)
        {
          d0 = 1;
          strcpy(sC, "DOCKED");
          e = e0;
          p = p0;
          nio_print("Shields dropped for docking purposes.\n");
          s = 0;
        }
      }
          
  if (d[2] < 0.0)
  {
    nio_print("\n*** Short Range Sensors are out ***\n");
    return;
  }

  nio_print("------------------------\n");
  for (i = 0; i < 8; i++)
  {
    nio_reverse_video();

    for (j = 0; j < 24; j++)
      nio_putchar(sQ[i * 24 + j]); 

    nio_reverse_video();

    if (i == 0)
      nio_printf("    Stardate            %d\n", (int) t);
    if (i == 1)
    {
      nio_print("    Condition           ");

      nio_set_text_fg_color("green");

      if (e < e0 * .1)
        nio_set_text_fg_color("yellow");

      if (k3 > 0)
        nio_set_text_fg_color("red");

      nio_printf("%s\n", sC);

      nio_set_text_fg_color("black");

    }
    if (i == 2)
      nio_printf("    Quadrant            %d, %d\n", q1, q2);
    if (i == 3)
      nio_printf("    Sector              %d, %d\n", (int)s1, (int)s2);
    if (i == 4)
      nio_printf("    Photon Torpedoes    %d\n", p);
    if (i == 5)
      nio_printf("    Total Energy        %d\n", e + s);
    if (i == 6)
      nio_printf("    Shields             %d\n", s);
    if (i == 7)
      nio_printf("    Klingons Remaining  %d\n", k9);
  }

  nio_print("------------------------\n\n");

  return;
}

void
long_range_scan(void)
{
  int i, j;

  if (d[3] < 0.0)
  {
    nio_print("Long Range Sensors are inoperable.\n");
    return;
  }

  nio_printf("Long Range Scan for Quadrant %d, %d\n\n", q1, q2);

  for (i = q1 - 1; i <= q1 + 1; i++)
  {
    nio_print("--------------------\n:");

    for (j = q2 - 1; j <= q2 + 1; j++)
      if (i > 0 && i <= 8 && j > 0 && j <= 8)
      {
        z[i][j] = g[i][j];
        nio_printf(" %3.3d :", z[i][j]);
      }
      else
        nio_print(" *** :");

    nio_print("\n");
  }

  nio_print("--------------------\n\n");
}

void
phaser_control(void)
{
  int i;
  int iEnergy;
  int h1, h;
  string sTemp;

  if (d[4] < 0.0)
  {
    nio_print("Phasers Inoperative\n\n");
    return;
  }

  if (k3 <= 0)
  {
    nio_print("Science Officer Spock reports:\n");
    nio_print("  'Sensors show no enemy ships in this quadrant'\n\n");
    return;
  }

  if (d[8] < 0.0)
    nio_print("Computer failure hampers accuracy.\n");

  nio_print("Phasers locked on target;\n");
  nio_printf("Energy available = %d units\n\n", e);

  nio_input("Number of units to fire: ", sTemp);

  iEnergy = atoi(sTemp);

  if (iEnergy <= 0)
    return;

  if (e - iEnergy < 0)
  {
    nio_print("Not enough energy available.\n\n");
    return;
  }

  e = e - iEnergy;

  if (d[8] < 0.0)
    iEnergy = (int)(iEnergy * rnd());

  h1 = iEnergy / k3;

  for (i = 1; i <= 3; i++)
  {
    if (k[i][3] > 0)
    {
      h = (int)(h1 / function_d(0) * (rnd() + 2));
      if (h <= .15 * k[i][3])
      {
        nio_print("Sensors show no damage to enemy at ");
        nio_printf("%d, %d\n\n", k[i][1], k[i][2]);
      }
      else
      {
        k[i][3] = k[i][3] - h;
        nio_printf("%d unit hit on Klingon at sector ", h);
        nio_printf("%d, %d\n", k[i][1], k[i][2]);

        if (k[i][3] <= 0)
        {
          nio_print("*** Klingon Destroyed ***\n\n");
          k3--;
          k9--;
          z1 = k[i][1];
          z2 = k[i][2];
          strcpy(sA, "   ");
          insert_in_quadrant();
          k[i][3] = 0;
          g[q1][q2] = g[q1][q2] - 100;
          z[q1][q2] = g[q1][q2];
          if (k9 <= 0)
            won_game();
        }
        else
          nio_printf("   (Sensors show %d units remaining.)\n\n", k[i][3]);
      }
    }
  }

  klingons_shoot();
}

void
photon_torpedoes(void)
{
  int x3, y3, x5;
  string sTemp;
  double c1;

  if (p <= 0)
  {
    nio_print("All photon torpedoes expended\n");
    return;
  }

  if (d[5] < 0.0)
  {
    nio_print("Photon Tubes not operational\n");
    return;
  }

  nio_input("Course (0-9): ", sTemp);

  c1 = atof(sTemp);

  if (c1 == 9.0)
    c1 = 1.0;

  if (c1 < 1.0 || c1 > 9.0)
  {
    nio_print("Ensign Chekov roports:\n");
    nio_print("  Incorrect course data, sir!\n\n");
    return;
  }

  e = e - 2;
  p--;

  x1 = c[1][(int)c1] + (c[1][(int)c1 + 1] - c[1][(int)c1]) * (c1 - (int)c1);
  x2 = c[2][(int)c1] + (c[2][(int)c1 + 1] - c[2][(int)c1]) * (c1 - (int)c1);

  x = s1 + x1;
  y = s2 + x2;

  x3 = cint(x);
  y3 = cint(y);

  x5 = 0;

  nio_print("Torpedo Track:\n");

  while (x3 >= 1 && x3 <= 8 && y3 >= 1 && y3 <= 8)
  {
    nio_printf("    %d, %d\n", x3, y3);

    strcpy(sA, "   ");
    z1 = x3;
    z2 = y3;

    string_compare();

    if (z3 == 0)
    {
      torpedo_hit();
      klingons_shoot();
      return;
    }

    x = x + x1;
    y = y + x2;

    x3 = cint(x);
    y3 = cint(y);
  }

  nio_print("Torpedo Missed\n\n");

  klingons_shoot();
}

void
torpedo_hit(void)
{
  int i, x3, y3;

  x3 = cint(x);
  y3 = cint(y);

  z3 = 0;

  strcpy(sA, " * ");
  string_compare();

  if (z3 == 1)
  {
    nio_printf("Star at %d, %d absorbed torpedo energy.\n\n", x3, y3);
    return;
  }

  strcpy(sA, "+K+");
  string_compare();

  if (z3 == 1)
  {
    nio_print("*** Klingon Destroyed ***\n\n");
    k3--;
    k9--;

    if (k9 <= 0)
      won_game();

    for (i=0; i<=3; i++)
      if (x3 == k[i][1] && y3 == k[i][2])
        k[i][3] = 0;
  }

  strcpy(sA, ">!<");
  string_compare();

  if (z3 == 1)
  {
    nio_print("*** Starbase Destroyed ***\n");
    b3--;
    b9--;

    if (b9 <= 0 && k9 <= t - t0 - t9)
    {
      nio_print("That does it, Captain!!");
      nio_print("You are hereby relieved of command\n");
      nio_print("and sentanced to 99 stardates of hard");
      nio_print("labor on Cygnus 12!!\n");
      resign_commision();
    }

    nio_print("Starfleet Command reviewing your record to consider\n");
    nio_print("court martial!\n\n");

    d0 = 0;    /* Undock */
  }

  z1 = x3;
  z2 = y3;
  strcpy(sA,"   ");
  insert_in_quadrant();

  g[q1][q2] = (k3 * 100) + (b3 * 10) + s3;
  z[q1][q2] = g[q1][q2];
}

void
damage_control(void)
{ 
  int i, a1;
  double d3 = 0.0;

  if (d[6] < 0.0)
  {
    nio_print("Damage Control report not available.\n");

    if (d0 == 0)
      return;

    d3 = 0.0;
    for (i = 1; i <= 8; i++)
      if (d[i] < 0.0)
        d3 = d3 + .1;

    if (d3 == 0.0)
      return;

    d3 = d3 + d4;
    if (d3 >= 1.0)
      d3 = 0.9;

    nio_print("\nTechnicians standing by to effect repairs to your");
    nio_printf("ship;\nEstimated time to repair: %4.2f stardates.\n", d3);
    nio_print("Will you authorize the repair order (Y/N)? ");

    a1 = nio_getchar(TRUE);

    if (a1 == 'Y' || a1 == 'y')
    {
      for (i = 1; i <= 8; i++)
        if (d[i] < 0.0)
          d[i] = 0.0;

      t = t + d3 + 0.1;
    }
  }

  nio_print("Device            State of Repair\n");

  for (r1 = 1; r1 <= 8; r1++)
  {
    get_device_name();
    nio_print(sG2);
    for (i = 1; i < 25 - (int)strlen(sG2); i++)
      nio_print(" ");
    nio_printf("%4.2f\n", d[r1]);
  }

  nio_print("\n");
} 

void
sheild_control(void)
{
  int i;
  string sTemp;

  if (d[7] < 0.0)
  {
    nio_print("Sheild Control inoperable\n");
    return;
  }

  nio_printf("Energy available = %d\n\n", e + s);

  nio_input("Input number of units to shields: ", sTemp);

  i = atoi(sTemp);

  if (i < 0 || s == i)
  {
    nio_print("<Sheilds Unchanged>\n\n");
    return;
  }

  if (i >= e + s)
  {
    nio_print("Sheild Control Reports:\n");
    nio_print("  'This is not the Federation Treasury.'\n");
    nio_print("<Sheilds Unchanged>\n\n");
    return;
  }

  e = e + s - i;
  s = i;

  nio_print("Deflector Control Room report:\n");
  nio_printf("  'Shields now at %d units per your command.'\n\n", s);
}

void
library_computer(void)
{
  string sTemp;

  if (d[8] < 0.0)
  {
    nio_print("Library Computer inoperable\n");
    return;
  }

  while(1)
  {
    nio_input("Computer active and awating command: ", sTemp);

    nio_clear_screen();

    if (! strncmp(sTemp, "0", 1))
      galactic_record();
    else if (! strncmp(sTemp, "1", 1))
      status_report();
    else if (! strncmp(sTemp, "2", 1))
      torpedo_data();
    else if (! strncmp(sTemp, "3", 1))
      nav_data();
    else if (! strncmp(sTemp, "4", 1))
      dirdist_calc();
    else if (! strncmp(sTemp, "5", 1))
      galaxy_map();
    else if (! strncmp(sTemp, "6", 1))
      return;
    else
    {
      nio_print("Functions available from Library-Computer:\n\n");
      nio_print("   0 = Cumulative Galactic Record\n");
      nio_print("   1 = Status Report\n");
      nio_print("   2 = Photon Torpedo Data\n");
      nio_print("   3 = Starbase Nav Data\n");
      nio_print("   4 = Direction/Distance Calculator\n");
      nio_print("   5 = Galaxy 'Region Name' Map\n\n");
      nio_print("   6 = Log off computer\n\n");
    }
  }
}

void
galactic_record(void)
{
  int i, j;

  nio_printf("\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", q1, q2);
  nio_print("     1     2     3     4     5     6     7     8\n");

  for (i = 1; i <= 8; i++)
  { 
    nio_print("   ----- ----- ----- ----- ----- ----- ----- -----\n");

    nio_printf("%d", i);

    for (j = 1; j <= 8; j++)
    {
      nio_print("   ");

      if (z[i][j] == 0)
        nio_print("***");
      else
        nio_printf("%3.3d", z[i][j]);
    }

    nio_print("\n");
  }

  nio_print("   ----- ----- ----- ----- ----- ----- ----- -----\n\n");
}

void
status_report(void)
{
  char sX[2] = "";

  nio_print("   Status Report:\n\n");

  if (k9 > 1)
    strcpy(sX, "s");

  nio_printf("Klingon%s Left: %d\n", sX, k9);

  nio_printf("Mission must be completed in %4.1f stardates\n",
    .1 * (int)((t0 + t9 - t) * 10));

  if (b9 < 1)
  {
    nio_print("Your stupidity has left you on your own in the galaxy\n");
    nio_print(" -- you have no starbases left!\n");
  }
  else
  {  
    strcpy(sX, "s");
    if (b9 < 2)
      strcpy(sX, "");

    nio_printf("The Federation is maintaining %d starbase%s in the galaxy\n",
      b9, sX);
  }

  nio_print("\n");
}

void
torpedo_data(void)
{
  int i;
  char sX[2] = "";

  if (k3 <= 0)
  {
    nio_print("Science Officer Spock reports:\n");
    nio_print("  'Sensors show no enemy ships in this quadrant.'\n\n");
    return;
  }

  if (k3 > 1)
    strcpy(sX, "s");
 
  nio_printf("From Enterprise to Klingon battlecriuser%s:\n\n", sX);

  for (i = 1; i <= 3; i++)
  {
    if (k[i][3] > 0)
    {
      w1 = k[i][1];
      x  = k[i][2];
      c1 = s1;
      a  = s2;

      compute_vector();
    }
  }
}

void
nav_data(void)
{
  if (b3 <= 0)
  {
    nio_print("Mr. Spock reports,\n");
    nio_print("  'Sensors show no starbases in this quadrant.'\n\n");
    return;
  }

  w1 = b4;
  x  = b5;
  c1 = s1;
  a  = s2;

  compute_vector();
}

void
dirdist_calc(void)
{
  string sTemp;

  nio_print("Direction/Distance Calculator\n\n");
  nio_printf("You are at quadrant %d,%d sector %d,%d\n\n", q1, q2,
    (int)s1, (int)s2);
    
  nio_input("Please enter initial X coordinate: ", sTemp);

  c1 = atoi(sTemp);

  nio_input("Please enter initial Y coordinate: ", sTemp);

  a = atoi(sTemp);

  nio_input("Please enter final X coordinate: ", sTemp);

  w1 = atoi(sTemp);

  nio_input("Please enter final Y coordinate: ", sTemp);

  x = atoi(sTemp);

  compute_vector();
}

void
galaxy_map(void)
{
  int i, j, j0;

  g5 = 1;

  nio_print("\n                   The Galaxy\n\n");
  nio_print("    1     2     3     4     5     6     7     8\n");

  for (i = 1; i <= 8; i++)
  {
    nio_print("  ----- ----- ----- ----- ----- ----- ----- -----\n");

    nio_printf("%d ", i);

    z4 = i;
    z5 = 1;
    quadrant_name();

    j0 = (int)(11 - (strlen(sG2) / 2));

    for (j = 0; j < j0; j++)
      nio_print(" ");

    printf(sG2);

    for (j = 0; j < j0; j++)
      nio_print(" ");

    if (! (strlen(sG2) % 2))
      nio_print(" ");

    z5 = 5;
    quadrant_name();

    j0 = (int)(12 - (strlen(sG2) / 2));

    for (j = 0; j < j0; j++)
      nio_print(" ");

    nio_printf("%s\n", sG2); 
  }

  nio_print("  ----- ----- ----- ----- ----- ----- ----- -----\n\n");

}

void
compute_vector(void)
{
  x = x - a;
  a = c1 - w1;

  if (x <= 0.0)
  {
    if (a > 0.0)
    {    
      c1 = 3.0;
      sub2();
      return;
    }
    else
    {
      c1 = 5.0;
      sub1();
      return;
    }
  }
  else if (a < 0.0)
  {
    c1 = 7.0;
    sub2();
    return;
  }
  else
  {
    c1 = 1.0;
    sub1();
    return;
  }
}

void
sub1(void)
{
  x = fabs(x);
  a = fabs(a);

  if (a <= x)
    nio_printf("  DIRECTION = %4.2f\n", c1 + (a / x));
  else
    nio_printf("  DIRECTION = %4.2f\n", c1 + (((a * 2) - x) / a));

  nio_printf("  DISTANCE = %4.2f\n\n", (x > a) ? x : a);
}

void
sub2(void)
{
  x = fabs(x);
  a = fabs(a);

  if (a >= x)
    nio_printf("  DIRECTION = %4.2f\n", c1 + (x / a));
  else
    nio_printf("  DIRECTION = %4.2f\n", c1 + (((x * 2) - a) / x));

  nio_printf("  DISTANCE = %4.2f\n\n", (x > a) ? x : a);
}

void
ship_destroyed(void)
{
  nio_print("The Enterprise has been destroyed. ");
  nio_print("The Federation will be conquered.\n\n");

  end_of_time();
}

void
end_of_time(void)
{
  nio_printf("It is stardate %d.\n\n", (int) t);

  resign_commision();
}

void
resign_commision(void)
{
  nio_printf("There were %d Klingon Battlecruisers left at the", k9);
  nio_print(" end of your mission.\n\n");

  end_of_game();
}

void
won_game(void)
{
  nio_print("Congradulations, Captain!  The last Klingon Battle Cruiser\n");
  nio_print("menacing the Federation has been destoyed.\n\n");
 
  if (t - t0 > 0)
    nio_printf("Your efficiency rating is %4.2f\n", 1000 * pow(k7 / (t - t0), 2));

  end_of_game();
}

void
end_of_game(void)
{
  string sTemp;

  if (b9 > 0)
  {
    nio_print("The Federation is in need of a new starship commander");
    nio_print(" for a similar mission.\n");
    nio_print("If there is a volunteer, let him step forward and");
    nio_input(" enter 'aye': ", sTemp);

    if (! strncmp(sTemp, "aye", 3))
      new_game();
  }

  exit(0);
}

void
klingons_move(void)
{
  int i;

  for (i = 1; i <= 3; i++)
  {
    if (k[i][3] > 0)
    {
      strcpy(sA, "   ");
      z1 = k[i][1];
      z2 = k[i][2];
      insert_in_quadrant();

      find_empty_place();

      k[i][1] = z1;
      k[i][2] = z2;
      strcpy(sA, "+K+");
      insert_in_quadrant();
    }
  }

  klingons_shoot();
}

void
klingons_shoot(void)
{
  int h, i;

  if (k3 <= 0)
    return;

  if (d0 != 0)
  {
    nio_print("Starbase shields protect the Enterprise\n\n");
    return;
  }

  for (i = 1; i <= 3; i++)
  {
    if (k[i][3] > 0)
    {
      h = (int) ((k[i][3] / function_d(i)) * (2 + rnd()));
      s = s - h;
      k[i][3] = (int)(k[i][3] / (3 + rnd()));

      nio_printf("%d unit hit on Enterprise from sector ", h);
      nio_printf("%d, %d\n", k[i][1], k[i][2]);

      if (s <= 0)
      {
        nio_print("\n");
        ship_destroyed();
      }

      nio_printf("    <Shields down to %d units>\n\n", s);

      if (h >= 20)
      {
        if (rnd() <= 0.6 || (h / s) > 0.2)
        {
          r1 = function_r();
          d[r1] = d[r1] - (h / s) - (0.5 * rnd());

          get_device_name();

          nio_print("Damage Control reports\n");
          nio_printf("   '%s' damaged by hit\n\n", sG2);
        }
      }
    }
  }
} 

void
repair_damage(void)
{
  int i;
  double d6;              /* Repair Factor */

  d6 = w1;

  if (w1 >= 1.0)
    d6 = w1 / 10;

  for (i = 1; i <= 8; i++)
  {
    if (d[i] < 0.0)
    {
      d[i] = d[i] + d6;
      if (d[i] > -0.1 && d[i] < 0)
        d[i] = -0.1;
      else if (d[i] >= 0.0)
      {
        if (d1 != 1)
          d1 = 1;

        nio_print("Damage Control report:\n");
        r1 = i;
        get_device_name();
        nio_printf("    %s repair completed\n\n", sG2);
      }
    }
  }

  if (rnd() <= 0.2)
  {
    r1 = function_r();

    if (rnd() < .6)
    {
      d[r1] = d[r1] - (rnd() * 5.0 + 1.0);
      nio_print("Damage Control report:\n");
      get_device_name();
      nio_printf("    %s damaged\n\n", sG2);
    }
    else
    {
      d[r1] = d[r1] + (rnd() * 3.0 + 1.0);
      nio_print("Damage Control report:\n");
      get_device_name();
      nio_printf("    %s state of repair improved\n\n", sG2);
    }
  }
}

/* Misc Functions and Subroutines */

void
find_empty_place(void)
{
  do
  {
    r1 = function_r();
    r2 = function_r();

    strcpy(sA, "   ");

    z1 = r1;
    z2 = r2;

    string_compare();
  } while (z3 == 0);

  z3 = 0;
}

void
insert_in_quadrant(void)
{
  int i, j = 0;

  s8 = ((int)(z2 - 0.5) * 3) + ((int)(z1 - 0.5) * 24) + 1;

  for (i = s8 - 1; i <= s8 + 1; i++)
    sQ[i] = sA[j++];

  return;
}

void
get_device_name(void)
{
  static char * device_name[] = {
    "",
    "Warp Engines",
    "Short Range Sensors",
    "Long Range Sensors",
    "Phaser Control",
    "Photon Tubes",
    "Damage Control",
    "Sheild Control",
    "Library-Computer" };

  if (r1 < 0 || r1 > 8)
    r1 = 0;

  strcpy(sG2, device_name[r1]);

  return;
}

void
string_compare(void)
{
  int i;
  char sB[4];

  z1 = (int)(z1 + 0.5);
  z2 = (int)(z2 + 0.5);

  s8 = ((z2 - 1) * 3) + ((z1 - 1) * 24) + 1;

  mid_str(sB, sQ, s8, 3);

  i = strncmp(sB, sA, 3);

  if (i == 0)
    z3 = 1;
  else
    z3 = 0;

  return;
}

void
quadrant_name(void)
{
  static char * quad_name[] = { "",
    "Antares",
    "Rigel",
    "Procyon",
    "Vega",
    "Canopus",
    "Altair",
    "Sagittarius",
    "Pollux",
    "Sirius",
    "Deneb",
    "Capella",
    "Betelgeuse",
    "Aldebaran",
    "Regulus",
    "Arcturus",
    "Spica"
  };

  static char * sect_name[] = {""," I"," II"," III"," IV"};

  if (z4 < 1 || z4 > 8 || z5 < 1 || z5 > 8)
    strcpy(sG2, "Unknown");

  if (z5 <= 4)
    strcpy(sG2, quad_name[z4]);
  else
    strcpy(sG2, quad_name[z4+8]);

  if (g5 != 1)
  {
    if (z5 > 4)
    z5 = z5 - 4;
    strcat(sG2, sect_name[z5]);
  }

  return;
}

int
function_d(int i)
{
  int j;

  j = (int)sqrt(pow((k[i][1] - s1), 2) + pow((k[i][2] - s2), 2));

  return j;
}

int
function_r(void)
{
  return(get_rand(8));
}

void
mid_str(char *a, char *b, int x, int y)
{
  --x;
  y += x;

  while (x < y && x <= (int)strlen(b))
    *a++ = *(b + x++);

  *a = '\0';
}

/* Round off floating point numbers instead of truncating */

int
cint (double d)
{
  int i;

  i = (int) (d + 0.5);

  return(i);
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
    nio_print(lBuffer);
      
    if (iRow++ > MAXROW - 3)
    {
      getchar();
      iRow = 0;
    }
  }

  closefile();
}

int
openfile(char * sFilename, char * sMode)
{
  if (bFlag || (stream = fopen (sFilename, sMode)) == NULL)
  {
    fprintf (stderr, "\nError - Unable to open file: %s.\n\n", sFilename);
    return 1;
  }

  bFlag = TRUE;

  return 0;
}

void
closefile(void)
{
  if (! bFlag)
    fclose(stream);

  bFlag = FALSE;
}

int
getline(char *s)
{
  if (fgets(s, MAXCOL, stream) == NULL)
    return(0);
  else
    return(strlen(s));
}

/* Returns an integer from 1 to iSpread */
int
get_rand(int iSpread)
{
  return((rand() % iSpread) + 1);
}

double
rnd(void)
{
  double d;

  d = rand() / (double) RAND_MAX;
  
  return(d);
}
