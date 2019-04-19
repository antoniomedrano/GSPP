void importData() {
  String[] dataLoad;
  String[] dataLoad2 = {""};
  String[] dataLine;
  String[] dataLine2 = {""};
  int index = 0;
  double lngth;

  r = 2;    // r=0  =>  orthagonal only
            // r=1  =>  diagonal allowed
            // r=2  =>  knight moves allowed

  dataLoad = loadStrings("HC2020.asc");
  //dataLoad = loadStrings("HC8080.asc");
  //dataLoad = loadStrings("HC100160ec.asc"); rows=100; cols=160; startingNode = rc2i(rows-1,3); endingNode = rc2i(0,cols-1);
  //dataLoad = loadStrings("HC100160en.asc"); rows=100; cols=160; startingNode = rc2i(rows-1,3); endingNode = rc2i(0,cols-1);
  
  //dataLoad = loadStrings("HC100160ec.asc");  dataLoad2 = loadStrings("HC100160en.asc"); rows=100; cols=160; startingNode = rc2i(0,0); endingNode = rc2i(rows-2,cols-1);

  //parse the first line of the file to get the number of columns
  dataLine = splitTokens(dataLoad[0]," ");
  cols = int(dataLine[1]);

  // parse the second line of the file to get the number of rows
  dataLine = splitTokens(dataLoad[1]," ");
  rows = int(dataLine[1]);

  // parse the 6th line to get the maximum value
  dataLine = splitTokens(dataLoad[5]," ");
  blockCost = int(dataLine[1]);

  cells = new Cell[rows*cols];
  numNodes = cells.length;

  if (rows > cols)
    cellSize = round(720/rows);
  else
    cellSize = round(720/cols);

  nodeSize = int(floor(cellSize / 1.5));
  if ((cellSize - nodeSize) % 2 == 1)
    nodeSize--;
  if (nodeSize < 5)
    nodeSize = cellSize - 2;
  //println(nodeSize);

  fontSize = int(ceil(nodeSize / 1.2));
  textFont(font,fontSize);
  
  // parse the rest of the lines to build the data table
  for (int i = 0; i < rows; i++) {
    dataLine  = split(dataLoad[i+6], ' ');
    for (int j = 0; j < cols; j++) {
      cells[index] = new Cell(index, i, j, float(dataLine[j]));
      index++;
    }
  }

  findMinMax();
  
  // create directional arc objects
  if (r == 0)
    arcs = new Arc[2*(2*rows*cols - rows - cols)];
  else if (r==1)
    arcs = new Arc[2*(4*rows*cols - 3*rows - 3*cols + 2)];
  else if (r==2)
    arcs = new Arc[2*(8*rows*cols - 9*rows - 9*cols + 10)];
  
  index = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      
      // R >=0 arcs
      if (i < rows-1) {
        lngth = 1;
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j), 0, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j), 0, lngth);
        index++;
      }
      if (j < cols-1) {
        lngth = 1;
        arcs[index] = new Arc(rc2i(i,j), rc2i(i,j+1), 0, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i,j), 0, lngth);
        index++;
      }
      
      // R >=1 arcs
      if ((r > 0) && (i < rows-1) && (j < cols-1)) {
        lngth = sqrt(2);
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j+1), 1, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j+1), rc2i(i,j), 1, lngth);
        index++;
        
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j+1), 1, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i+1,j), 1, lngth);
        index++;
      }
      
      // R >= 2 arcs
      if ((r > 1) && (i < rows - 2) && (j < cols - 1)) {
        lngth = sqrt(5);
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+2,j+1), 2, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i+2,j+1), rc2i(i,j), 2, lngth);
        index++;
        
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i+2,j), 2, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i+2,j), rc2i(i,j+1), 2, lngth);
        index++;
      }
      if ((r > 1) && (i < rows - 1) && (j < cols - 2)) {
        lngth = sqrt(5);
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j+2), 2, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j+2), rc2i(i,j), 2, lngth);
        index++;
        
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j+2), 2, lngth);
        index++;
        arcs[index] = new Arc(rc2i(i,j+2), rc2i(i+1,j), 2, lngth);
        index++;
      }
    }
  }
  
  colorBackground();

  // for all arcs, associate them with the linked lists for their start and end nodes
  for (int i = 0; i < arcs.length; i++) {
        
    if (cells[arcs[i].startNode].blackNode == true || cells[arcs[i].endNode].blackNode == true) {
      arcs[i].blackArc = true;
      i++;
      arcs[i].blackArc = true;
      continue;
    }
    if (arcs[i].arcType == 2) {
      if (cells[arcs[i].middle1].blackNode == true || cells[arcs[i].middle2].blackNode == true) {
        arcs[i].blackArc = true;
        i++;      // bi-directional arcs are made in groups of 4, if one has a black middle node, all do
        arcs[i].blackArc = true;
        i++;
        arcs[i].blackArc = true;
        i++;
        arcs[i].blackArc = true;
        continue;
      }
    }
    
    // add the arc to the start and end nodes' edge list
    cells[arcs[i].startNode].LLout.add(new Integer(i));
    cells[arcs[i].endNode].LLin.add(new Integer(i));
  }
}


void findMinMax() {
  // determine the highest cost, 2nd highest cost, and lowest costs
  for (int i = 0; i < cells.length; i++) {
    if (cells[i].cost >= blockCost) {
      //maxCost = max(maxCost,blockCost);
      blockCost = cells[i].cost;
    }
    else if (cells[i].cost > maxCost) {
      maxCost = cells[i].cost;
    }
    else if (cells[i].cost < minCost) {
      minCost = cells[i].cost;
    }
  }
}



void colorBackground() {
  // color the nodes and cells according to their cost value
  for (int i = 0; i < cells.length; i++) {
    if (cells[i].cost == blockCost) {
      cells[i].blackNode = true;
      cells[i].nodeColor = cBlack;
      cells[i].fillColor = color(255 - maxCost * 180 / (maxCost - minCost));
    }
    else {
      cells[i].fillColor = color(255 - (cells[i].cost - minCost + 1) * 180 / (maxCost - minCost));
      //cells[i].fillColor = color(255 - cells[i].cost2 * 180 / (maxCost2 - minCost));
    }  
  }
}


// Exports gateway areas to a data file
void exportGatewayLengthsAndAreas() {
  int index=-1;
  println("export begun");
  
  String filename = new String("gwLengthsAreas"+rows+cols+".csv");
  
  String[] lines = new String[cols*rows+1];

  lines[0] = new String("row,column,area difference,gw path length");
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      index++;
      if (cells[index].nodeColor != cBlack)
        lines[index+1] = new String((i+1) + "," + (j+1) + "," + gatewayAreaDiff(index) + "," + cells[index].gwCost);
      else
        lines[index+1] = new String((i+1) + "," + (j+1) + ",,");
    }
  }
  
  saveStrings(filename, lines);
  println("export complete");
}

// Exports strahler selected gateway areas to a data file
void exportStrahlerGatewayLengthsAndAreas() {
  println("export begun");
  int index = -1;
  int k = 1;  // line counter
  
  String filename = new String("gwStrahlerLengthsAreas"+rows+cols+".csv");
  
  String[] lines = new String[cols*rows+1];

  lines[0] = new String("row,column,area difference,gw path length");
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      index++;
      if (cells[index].nodeColor == cYellow) {
        lines[k] = new String((i+1) + "," + (j+1) + "," + gatewayAreaDiff(index) + "," + cells[index].gwCost);
        k++;
      }
    }
  }
  
  saveStrings(filename, subset(lines,0,k));
  println("export complete");
}
