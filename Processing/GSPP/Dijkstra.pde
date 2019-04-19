/******************************************************************************************** 
 *  DIJKSTRA                                                                                *
 ********************************************************************************************
 */

double forwardDijkstra(int sNode, int eNode) {

  // TSpath is true is pathfinding is from destination to origin (reverse shortest path)
  
  int uv, tempSNode, tempENode, newPArc, llsize;
  double tempDist;
  double Lsp = -1;
  double Lz1 = -1;
  double Lz2 = -1;
  int bestNode = -2;
  int newPNode = -1;
  int u = sNode;
  int v;
  int prevNode;
  boolean found = false;
  boolean pathShown = false;
  PriorityQueue<Cell> tNodes = new PriorityQueue<Cell>(ceil(sqrt(numNodes))*(r+3), new CellComparator());
  Cell bestCell;

  // color and label the starting node appropriately
  cells[sNode].nodeColor = cBlue;  // change color of the starting node to blue
  cells[sNode].prevNode1 = sNode;  // set itself as previous node (because it's a starting node)
  cells[sNode].pNode = true;
  cells[sNode].pathCostF = 0;

  // color the ending node red
  cells[eNode].nodeColor = cRed;  // change color of the ending node


  // begin iteration

  while (!pathShown) {

    if (!found) {

      // find all arcs emanating from last permanently marked node and mark them temprorary
      llsize = cells[u].LLout.size();   // start at index 0

      for (int i = 0; i < llsize; i++) {

        uv = cells[u].LLout.get(i);
        v = arcs[uv].endNode;

        // update the node if not labeled permanent
        if (cells[v].pNode == false) {
          tempDist = arcs[uv].cost + cells[u].pathCostF;
          if (tempDist < cells[v].pathCostF) {
            if (cells[v].tNode == true) {
              tNodes.remove(cells[v]);
              cells[v].pathCostF = tempDist;
              cells[v].prevNode1 = u;
              cells[v].prevArc1 = uv;
              tNodes.offer(cells[v]);
            }
            else {
              cells[v].pathCostF = tempDist;
              cells[v].prevNode1 = u;
              cells[v].prevArc1 = uv;
              cells[v].tNode = true;                   // set node as temporarily labeled
              tNodes.offer(cells[v]);
            }
          }
        }
      }

      // pop the best node from the tNodes binary heap, set newPNode to cell number
      bestCell = tNodes.poll();
      newPNode = bestCell.n;

      // permanently label the node and arc
      newPArc = bestCell.prevArc1;
      tempSNode = bestCell.prevNode1;

      // set node as permanent
      cells[newPNode].nodeColor = cPurple;      // set newPNode color to permanent
      cells[newPNode].pathCostF = arcs[newPArc].cost + cells[tempSNode].pathCostF;
      cells[newPNode].pNode = true;

      // bookkeeping for Strahler analysis
      prevNode = bestCell.prevNode1;
      cells[newPNode].chainLength1 = cells[prevNode].chainLength1+1;
      cells[newPNode].adjArcs1.add(newPArc);
      cells[prevNode].adjArcs1.add(newPArc);

      // set arc as permanent
      arcs[newPArc].arcColor = cPurple;                       // set arc color to permanent
      arcs[newPArc].pArc1 = true;                       // set arc color to permanent


      // designate newPNode as u for next calculation
      u = newPNode;

      // stop when all nodes are permanent 
      if (tNodes.isEmpty()) {
        
        boolean tunnel = false;
        
        //Check if it's in fact the end, or just a "tunnel"
        llsize = cells[u].LLout.size();   // start at index 0
  
        for (int i = 0; i < llsize; i++) {
        
          uv = cells[u].LLout.get(i);
          v = arcs[uv].endNode;
        
          // update the node if not labeled permanent
          if (cells[v].pNode == false) {
            tunnel = true;
            break;
          }
        }
        // if all nodes from last permanent node are also permanent, then we're done
        if (tunnel == false)
          found = true;
      }
    }

    // backtrack from the end to display the shortest path
    else {
      cells[eNode].nodeColor = cRed;   // mark endNode as red
      tempENode = eNode;
      while (!pathShown) {
        tempSNode = cells[tempENode].prevNode1;            
        if (tempENode == sNode) {
          pathShown = true;
          cells[tempSNode].nodeColor = cBlue;
        }
        else {
          arcs[cells[tempENode].prevArc1].arcColor = cRed;
          cells[tempSNode].nodeColor = cOrange;
          tempENode = tempSNode;
        }
      }
      Lsp = cells[eNode].pathCostF;
      println("FSP cost = " + Lsp);
//      println("Z1 cost = " + Lz1);
//      println("Z2 cost = " + Lz2);
//      println();
    }
  }
  
  return Lsp;
}

double reverseDijkstra(int sNode, int eNode) {

  // TSpath is true is pathfinding is from destination to origin (reverse shortest path)
  
  int uv, tempSNode, tempENode, newPArc, llsize;
  double tempDist;
  double Lsp = -1;
  double Lz1 = -1;
  double Lz2 = -1;
  int bestNode = -2;
  int newPNode = -1;
  int u = sNode;
  int v;
  int prevNode;
  boolean found = false;
  boolean pathShown = false;
  PriorityQueue<Cell> tNodes = new PriorityQueue<Cell>(ceil(sqrt(numNodes))*(r+3), new CellComparator2());
  Cell bestCell;

  for (int i = 0; i < numNodes; i++) {
    cells[i].clear();
  }

  // color and label the starting node appropriately
  cells[sNode].nodeColor = cBlue;  // change color of the starting node to blue
  cells[sNode].prevNode2 = sNode;  // set itself as previous node (because it's a starting node)
  cells[sNode].pNode = true;
  cells[sNode].pathCostR = 0;

  // color the ending node red
  cells[eNode].nodeColor = cRed;  // change color of the ending node


  // begin iteration

  while (!pathShown) {

    if (!found) {

      // find all arcs emanating from last permanently marked node and mark them temprorary
      llsize = cells[u].LLout.size();   // start at index 0
      
      for (int i = 0; i < llsize; i++) {

        uv = cells[u].LLout.get(i);
        v = arcs[uv].endNode;

        // update the node if not labeled permanent
        if (cells[v].pNode == false) {
          tempDist = arcs[uv].cost + cells[u].pathCostR;
          if (tempDist < cells[v].pathCostR) {
            if (cells[v].tNode == true) {
              tNodes.remove(cells[v]);
              cells[v].pathCostR = tempDist;
              cells[v].prevNode2 = u;
              cells[v].prevArc2 = uv;
              tNodes.offer(cells[v]);
            }
            else {
              cells[v].pathCostR = tempDist;
              cells[v].prevNode2 = u;
              cells[v].prevArc2 = uv;
              cells[v].tNode = true;                   // set node as temporarily labeled
              tNodes.offer(cells[v]);
            }
          }
        }
      }

      // pop the best node from the tNodes binary heap, set newPNode to cell number
      bestCell = tNodes.poll();
      newPNode = bestCell.n;

      // permanently label the node and arc
      newPArc = bestCell.prevArc2;
      tempSNode = bestCell.prevNode2;

      // set node as permanent
      cells[newPNode].nodeColor = cPurple;      // set newPNode color to permanent
      cells[newPNode].pathCostR = arcs[newPArc].cost + cells[tempSNode].pathCostR;
      cells[newPNode].pNode = true;

      // bookkeeping for Strahler analysis
      prevNode = bestCell.prevNode2;
      cells[newPNode].chainLength2 = cells[prevNode].chainLength2+1;
      cells[newPNode].adjArcs2.add(newPArc);
      cells[prevNode].adjArcs2.add(newPArc);

      // set arc as permanent
      arcs[newPArc].arcColor = cPurple;                       // set arc color to permanent
      arcs[newPArc].pArc2 = true;                       // set arc color to permanent

      // designate newPNode as u for next calculation
      u = newPNode;

      // stop when all nodes are permanent 
      if (tNodes.isEmpty()) {
        
        boolean tunnel = false;
        
        //Check if it's in fact the end, or just a "tunnel"
        llsize = cells[u].LLout.size();   // start at index 0
  
        for (int i = 0; i < llsize; i++) {
        
          uv = cells[u].LLout.get(i);
          v = arcs[uv].endNode;
        
          // update the node if not labeled permanent
          if (cells[v].pNode == false) {
            tunnel = true;
            break;
          }
        }
        // if all nodes from last permanent node are also permanent, then we're done
        if (tunnel == false)
          found = true;
      }
    }

    // backtrack from the end to display the shortest path
    else {
      cells[eNode].nodeColor = cRed;   // mark endNode as red
      tempENode = eNode;
      while (!pathShown) {
        tempSNode = cells[tempENode].prevNode2;            
        if (tempENode == sNode) {
          pathShown = true;
          cells[tempSNode].nodeColor = cBlue;
        }
        else {
          arcs[cells[tempENode].prevArc2].arcColor = cRed;
          cells[tempSNode].nodeColor = cOrange;
          tempENode = tempSNode;
        }
      }
      Lsp = cells[eNode].pathCostR;
      println("RSP cost = " + Lsp);
    }
  }
  
  return Lsp;
}
