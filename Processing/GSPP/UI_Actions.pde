void keyPressed() {
  println(keyCode);

  if (key == ENTER) {
    
    long start = System.currentTimeMillis();

    spCost = forwardDijkstra(startingNode, endingNode);
    
    long elapsed = System.currentTimeMillis() - start;
    printRuntime(elapsed);
  }

  else if (key == TAB) {
    if (looping) {
      noLoop();
      looping = false;
    }
    else {
      loop();
      looping = true;
    }
  }

  else if (keyPressed && keyCode == SHIFT) {
    println("SHIFT BABY!!");
    for (int i = 0; i < numNodes; i++) {
      if(cells[i].nodeColor != cBlack) { 
        cells[i].bkpColor = cells[i].nodeColor;
        cells[i].nodeColor = cClear;
      }
    }
    for (int i = 0; i < arcs.length; i++) {
      arcs[i].bkpColor = arcs[i].arcColor;
      arcs[i].arcColor = cClear;
      arcs[i].bkpColor2 = arcs[i].arcColor2;
      arcs[i].arcColor2 = cClear;
    }
  }

  else if (key == 'q') {  // the letter q causes only for forward path to show
    disp2 = 0;
  }

  else if (key == 'w') {  // the letter w causes only for forward path to show
    disp2 = 4;
  }

  else if (key == 'a') {  // the letter A causes the nodes to toggle on and off
    nodesView = !nodesView;
  }
  
  else if (key == 'e') {  // the letter E exports all gateway nodes path lengths and area differences to a file
      exportGatewayLengthsAndAreas();
  }
  
  else if (key == 'p') {  // the letter P causes the Strahler selected nodes to highlight
    RouteFind(1);
    exportStrahlerGatewayLengthsAndAreas();
  }

  else if (key == 'r') {  // the letter R causes the top layer of tree to toggle
    if (disp2 == 1) {
      disp2 = 2;
    }
    else {
      disp2 = 1;
    }
  }

  else if (key == 't') {  // the letter T calculates dijsktra and order of reverse path


    // This enacts the second iteration of Dykstra to get the reverse paths
    reverseDijkstra(endingNode, startingNode);
    allCalc = true;

    long start = System.currentTimeMillis();

    for(int i = 0; i < cells[endingNode].adjArcs2.size(); i++) {
      StreamOrdering2(cells[endingNode].adjArcs2.get(i), arcs[cells[endingNode].adjArcs2.get(i)].endNode);
    }

    long elapsed = System.currentTimeMillis() - start;
    printRuntime(elapsed);
    
    colorThemArcs(2);
    disp2 = 2;
    
    // calculate total gateway path cost for each node
    for (int i = 0; i < numNodes; i++) {
      cells[i].gwCost = cells[i].pathCostF + cells[i].pathCostR;
    }
  }

  else if (key == 'y') {  // the letter Y calculates order for the forward path
    for(int i = 0; i < cells[startingNode].adjArcs1.size(); i++) {
      StreamOrdering(cells[startingNode].adjArcs1.get(i), arcs[cells[startingNode].adjArcs1.get(i)].endNode);
    }
    colorThemArcs(1);
  }

  else {
    try {RouteFind(Character.getNumericValue(key));}
    catch (NumberFormatException e) {}
    
    //iterateDijkstra();
  }

  refresh();
}

void keyReleased() {
  if (keyCode == SHIFT) {
    for (int i = 0; i < numNodes; i++) {
      if (cells[i].nodeColor != cBlack) {
        cells[i].nodeColor = cells[i].bkpColor;
      }
    }
    for (int i = 0; i < arcs.length; i++) {
      arcs[i].arcColor = arcs[i].bkpColor;
      arcs[i].arcColor2 = arcs[i].bkpColor2;
    }
  }
  refresh();
}


// display the path length with the clicked gateway point
void mouseClicked() {
  clicked = true;

  if (mouseY >= 33 && mouseX >= 33 && mouseY < 753 && mouseX < 753 && allCalc) {

    // convert previously clicked node to prior color
    if (cells[gNode].bkpColor != cClear) {
      cells[gNode].nodeColor = cells[gNode].bkpColor;
    }
    
    // convert previously shown path to original color
    if (gNodeStore != -1) {
      gNode = gNodeStore;
      
      while (gNode != startingNode) {
         arcs[cells[gNode].prevArc1].arcColor = arcs[cells[gNode].prevArc1].bkpColor;
         arcs[cells[gNode].prevArc1].bkpColor = cClear;
         gNode = cells[gNode].prevNode1;
      }
      gNode = gNodeStore;
          
      while (gNode != endingNode) {
        arcs[cells[gNode].prevArc2].arcColor2 = arcs[cells[gNode].prevArc2].bkpColor2;
        arcs[cells[gNode].prevArc2].bkpColor2 = cClear;
        gNode = cells[gNode].prevNode2;
      }
    }

    // Determine which cell was just clicked
    mouseRow = (mouseY - 33) / cellSize;
    mouseCol = (mouseX - 33) / cellSize;
    println(mouseRow);
    println(mouseCol);
    gNode = rc2i(mouseRow,mouseCol);
    gNodeStore = gNode;
    println("gNode = " + gNode);

    if (cells[gNode].blackNode == false) {
      
      area = gatewayAreaDiff(gNode);

      println("gateway cost = " + str((float)cells[gNode].gwCost));
      println("gateway path area difference = " + area);
      println("forward chain length = " + str(cells[gNode].chainLength1));
      println("reverse chain length = " + str(cells[gNode].chainLength2));
     
      // change node to green
      cells[gNode].bkpColor = cells[gNode].nodeColor;
      cells[gNode].nodeColor = cGreen;
      
      // change gateway path to green
      while (gNode != startingNode) {
        arcs[cells[gNode].prevArc1].bkpColor = arcs[cells[gNode].prevArc1].arcColor;
        arcs[cells[gNode].prevArc1].arcColor = cGreen;
        gNode = cells[gNode].prevNode1;
      }
      
      gNode = gNodeStore;
        
      while (gNode != endingNode) {
        arcs[cells[gNode].prevArc2].bkpColor2 = arcs[cells[gNode].prevArc2].arcColor2;
        arcs[cells[gNode].prevArc2].arcColor2 = cGreen;
        gNode = cells[gNode].prevNode2;
      }
    }
    
    else {
      text("Gateway cost = invalid",541,800);
      gNode = -1;
    }
    gNode = gNodeStore;
  }
  refresh();
}


// display the row and column where the mouse is located
void mouseMoved() {
  /*  
   fill(180);
   //noStroke();
   rect(534,760,216,48);
   
   // show text displaying row and column of cell that mouse is over
   
   if (mouseY >= 33 && mouseX >= 33 && mouseY < 753 && mouseX < 753) {
   
   mouseRow = (mouseY - 33) / cellSize;
   mouseCol = (mouseX - 33) / cellSize;
   
   fill(0);
   textFont(font,20);
   textAlign(LEFT);
   text("Row = " + str(mouseRow),541,780);
   text("Column = " + str(mouseCol),641,780);
   //println((mouseX - 33) / cellSize + " " + (mouseY - 33) / cellSize);
   }
   */
}

void printRuntime(long elapsed) {

  int days = (int) elapsed/86400000;
  int rem = (int) (elapsed%86400000);
  int hours = rem / 3600000;
  rem = rem % 3600000;
  int minutes = rem / 60000;
  rem = rem % 60000;
  float seconds = rem / 1000.0;
  
  text("Time (d:h:m:s) = " + days + ":" + hours + ":" + minutes + ":" + seconds,282,820);
  println("runtime took " + days + " days, " + hours + " hours, " + minutes + " minutes, and " +
           seconds + " seconds (" + elapsed + " total ms)");
}
