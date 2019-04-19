 /* GSPP.pde
 *
 * This program displays the use of Strahler Stream order to find best alternatives to the 
 * shortest path found by Dijkstra's algorithm with binary heaps.
 *
 */

import java.util.*;
import java.text.DecimalFormat;

Cell[] cells;
Arc[] arcs;
int cols, rows, numNodes;
int cellSize, nodeSize, fontSize;
int mouseRow, mouseCol;
float minCost = 9999999;
float maxCost = -1; 
float arcDist, bestDist, blockCost, area;
double spCost = 0;
PFont font; 
color cBlue = #5566FF;      // blue color
color cGreen = #5EFF5E;     // green color
color cRed = #FF6655;       // red color
color cBrown = #776633;     // brown color
color cPurple = #AA66AA;    // Purple color
color cGrey = #999999;      // grey color
color cOrange = #FF9955;    // orange color
color cPink = #FF69BC;      // pink color
color cYellow = #FFFF00;    // yellow color
color cClear = color(255,0);// transparent
color cBlack = color(0);    // black color
color cWhite = color(250);  // white color
int startingNode, endingNode;
int gNode;
int gNodeStore = -1;
int disp2 = 0;
int r;
boolean nodesView = true;
boolean looping = true;
boolean allCalc = false;
boolean clicked = false;
//ListIterator it;            // linked list iterator for going through arcs that come from each node
//int u, v, uv;

// for formatting gateway cost output
DecimalFormat df = new DecimalFormat("####0.00");


void setup() {

  size(780,855);
  pixelDensity(displayDensity());
  
  // set the font that wil be used
  font = createFont("GoudyModernMTStd-Italic",20);

  // run the importData() function
  importData();

  if (cols != 160) {
    startingNode = rc2i(rows-1,0);
    endingNode = rc2i(0,cols-1);
  }
  else {
    size(1180,855, "processing.core.PGraphicsRetina2D");
  }
  println(startingNode);
  println(endingNode);
  
//  hint(ENABLE_RETINA_PIXELS);
  //smooth();
  background(200);  
  refresh();
}


void draw() {
  //refresh();
  // empty since all changes rely on user actions (no animations)
}


void refresh() {
  background(200);
  
  fill(180);
  stroke(0);
  rect(534,760,216,70);
  
  // place some text
  fill(0);
  textFont(font,20);
  textAlign(LEFT);
  text("Return - forward Dijkstra",30,780);
  text("Y - Strahler order",30,800);
  text("T - reverse Dijkstra & order",30,820);
  text("R - toggle tree on top",30,840);
  text("Q - display only forward",282,780);
  text("W - display only reverse",282,800);
  text("A - hide nodes",282,820);
  text("# - highlight good gateway points",282,840);
  
  fill(0);
  textFont(font,20);
  textAlign(LEFT);
  
  if (clicked == false)
    text("SP Cost = " + df.format(spCost),541,780);

  if (clicked == true) {
    
    text("Row = " + str(mouseRow+1),541,780);
    text("Column = " + str(mouseCol+1),641,780);
    
    if (cells[gNode].nodeColor != cBlack) {
      text("Gateway cost = " + df.format(cells[gNode].gwCost), 541, 800);
    }
    else {
      text("Gateway cost = invalid",541,800);
    }
    
    if (cells[gNode].nodeColor != cBlack) {
      text("Area difference = " + area, 541, 820);
    }
    else {
      text("Area difference = invalid",541,820);
    }
  }
  
  // display background cells
  for (int i = 0; i < cells.length; i++) {
    cells[i].displaySquare();
  }
  
  // display permanent arcs
  if (disp2 == 1 || disp2 == 4) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].pArc2 == true) {
        arcs[i].display2();
      }
    }
  }
  
  if (disp2 != 4) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].pArc1 == true) {
        arcs[i].display();
      }
    }
  }
  
  if (disp2 == 2) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].pArc2 == true) {
        arcs[i].display2();
      }
    }
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].arcColor == cGreen) {
        arcs[i].display();
      }
      else if (arcs[i].arcColor2 == cGreen) {
        arcs[i].display2();
      }
    }
  }
  
  if (disp2 == 1) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].arcColor == cGreen) {
        arcs[i].display();
      }
      else if (arcs[i].arcColor2 == cGreen) {
        arcs[i].display2();
      }
    }
  }
  
/*  for (int i = 0; i < pArcs.length; i++) {
    if (arcs[pArcs[i]].arcColor == cGreen)
      arcs[pArcs[i]].display();
  }*/
  
  // display nodes
  if (nodesView) {
    if (nodeSize < 13) {
      for (int i = 0; i < cells.length; i++) {
        cells[i].displayNodeNoText();
      }
    }
    else {
      for (int i = 0; i < cells.length; i++) {
        cells[i].displayNodeWithText();
      }
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
