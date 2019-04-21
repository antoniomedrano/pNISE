/**pNISE_EISPC.pde
 *
 * This program solves a multi-objective shortest path problem. For the moment, it just does 2 objectives.
 *
 * It solves for the supported pareto optimal solutions using the NISE method on the EISPC data
 *
 */

import java.util.List;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;
import java.util.ArrayList; 
import java.util.PriorityQueue;
import java.util.ListIterator;
import java.util.Iterator;
import java.util.Comparator;

Cell[] cells;
Arc[] arcs;
int cols, rows, numNodes;
float blockCost1, blockCost2;
float minCost1 = 9999999;
float maxCost1 = -1; 
float minCost2 = 9999999;
float maxCost2 = -1;
PFont font;
color cBlue = #5566FF;      // blue color
color cGreen = #00C000;//#9BBB59;//#5EFF5E;     // green color
color cRed = #FF6655;       // red color
color cBrown = #776633;     // brown color
color cPurple = #AA66AA;    // Purple color
color cGrey = #999999;      // grey color
color cOrange = #FF9955;    // orange color
color cPink = #FF69BC;      // pink color
color cYellow = #FFFF00;    // yellow color
color cMauve = #990033;     // mauve color
color cClear = color(255,0);// transparent
color cBlack = color(0);    // black color
color cWhite = color(250);  // white color
int startingNode, endingNode;
int disp2 = 1;
boolean nodesView = true;
int r, n, sup, pointCount;
int count = 0;
int gap = 50;
int wX, wY;

// Timing and counting variables
long start, elapsed;
int days, hours, minutes;
float seconds;
float t_sec;

void setup() {
  
  // size must always be first, or else setup will run twice
  size(550,685);
  pixelDensity(displayDensity());
  
  // set the font that will be used
  //font = loadFont("GoudyModernMTStd-Italic-20.vlw");
  font = createFont("GoudyModernMTStd-Italic",20);

  // run the importData() function
  start = System.currentTimeMillis();
  importData();
  elapsed = System.currentTimeMillis() - start;
  printRuntime(elapsed);
  
  wX = cols/2+gap;
  wY = rows/2+gap;

  println(startingNode);
  println(endingNode);
    
  //smooth();
  background(200);
  
  //refresh();
  noLoop();
  
}


void draw() {
  //refresh();
  background(200);
  
  fill(180); stroke(0);
  rect(309,540,216,70);
  
  // place some text
  fill(0);
  textFont(font,20);
  textAlign(LEFT);
  text("Return - run NISE",25,560);
  text("1 - show landuse cost",25,580);
  text("2 - show slope cost",25,600);
  text("A - hide permanent nodes",25,620);
  text("Time (d:h:m:s) = " + days + ":" + hours + ":" + minutes + ":" + seconds,25,640);
  text("Time (seconds) = " + t_sec,25,660);
//  text("Shift - hide nodes and arcs",282,840);
  
  fill(0);
  textFont(font,20);
  textAlign(LEFT);
  text(rows + " x " + cols + ", r = " + r,316,560);
  text("supported = " + sup, 316, 580);
  text("# of points = " + pointCount, 316, 600);
  
  
  // display background cells
  loadPixels();
  n = 0;

  if (disp2 == 1) {
    for (int i = wX*2*gap+gap; i < wX*wY*4-wX*2*gap-gap; i++) {
      if (i%(wX*2) < gap || i%(wX*2) > wX*2-gap-1) {continue;}
      else {
        //pixels[i] = color(random(floor((256))));
        pixels[i] = cells[n].fillColor1;
        n++;
      }
    }
  }
  else if (disp2 == 2) {
    for (int i = wX*2*gap+gap; i < wX*wY*4-wX*2*gap-gap; i++) {
      if (i%(wX*2) < gap || i%(wX*2) > wX*2-gap-1) {continue;}
      else {
        //pixels[i] = color(random(floor((256))));
        pixels[i] = cells[n].fillColor2;
        n++;
      }
    }
  }
  updatePixels();
  
  // display permanent arcs
  for (int i = 0; i < arcs.length; i++) {
    if (arcs[i].paretoArc == true) {
      arcs[i].display();
    }
  }
}

int rc2i(int row, int col) {
  return row * (cols) + col;
}

int i2r(int index) {
  return index / (cols);
}

int i2c(int index) {
  return index % (cols);
}
