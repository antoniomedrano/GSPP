void RouteFind(int thresh) {
  
  // First, set the cell order to the max order of the arcs  
  for (int i = 0; i < arcs.length; i++) {
    
    if (arcs[i].order > cells[arcs[i].startNode].order1) {
      cells[arcs[i].startNode].order1 = arcs[i].order;
    }
    if (arcs[i].order > cells[arcs[i].endNode].order1) {
      cells[arcs[i].endNode].order1 = arcs[i].order;
    }
    if (arcs[i].order2 > cells[arcs[i].startNode].order2) {
      cells[arcs[i].startNode].order2 = arcs[i].order2;
    }
    if (arcs[i].order2 > cells[arcs[i].endNode].order2) {
      cells[arcs[i].endNode].order2 = arcs[i].order2;
    }
  }
 
 
 // Next, highlight cells that meet the threshold criteria
 //int thresh = 3;   // 3 is good for 20x20, 4 is good for 80x80
 
 for (int i = 0; i < numNodes; i++) {

    // revert cell colors
    if (cells[i].nodeColor == cYellow)
      cells[i].nodeColor = cells[i].bkpColor;

    // IF the order exceeds the threshold AND the point is not on the shortest path AND the point
    // is not part of a dead end    
    if (cells[i].order1 >= thresh && cells[i].order2 >= thresh
        && cells[i].nodeColor != cOrange
        && cells[i].prevNode1 != cells[i].prevNode2) {
//      if (((cells[i].order1 >= thresh && cells[i].order2 >= thresh-1) ||
//         (cells[i].order1 >= thresh-1 && cells[i].order2 >= thresh))
//        && cells[i].nodeColor != cOrange
//        && cells[i].prevNode1 != cells[i].prevNode2) {
      // then make the color yellow
      cells[i].bkpColor = cells[i].nodeColor;
      cells[i].nodeColor = cYellow;
    }
  }
}
