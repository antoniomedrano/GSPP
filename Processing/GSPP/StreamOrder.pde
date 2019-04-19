int StreamOrdering(int ArcID, int DNID) {
  
  int[] uOrders = new int[cells[DNID].adjArcs1.size()];
  
  if (cells[DNID].adjArcs1.size() == 1) {
    arcs[ArcID].order = 1;
  }
  else {
    for (int i = 0; i < cells[DNID].adjArcs1.size(); i++) {
      if (cells[DNID].adjArcs1.get(i) != ArcID) {
        uOrders[i] = StreamOrdering(cells[DNID].adjArcs1.get(i),
                                    arcs[cells[DNID].adjArcs1.get(i)].endNode);
      }
      else {
        uOrders[i] = 0;
      }
    }
  
    int maxOrder = 0;
    int maxOrderCount = 0;
  
    for (int i = 0; i < uOrders.length; i++) {
      if (uOrders[i] > maxOrder) {
        maxOrder = uOrders[i];
        maxOrderCount = 1;
      }
      else if (uOrders[i] == maxOrder) {
        maxOrderCount++;
      }
    }
    if (maxOrderCount > 1) {
      arcs[ArcID].order = maxOrder + 1;
    }
    else {
      arcs[ArcID].order = maxOrder;
    }
  }
  return arcs[ArcID].order;
}



void colorThemArcs(int g) {
  
  colorMode(HSB,360,100,100);

  if (g == 1) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].pArc1 == true) {
        arcs[i].arcColor = color(300, 50, int(100-(100/6.0)*(arcs[i].order)));
      }
    }
  }
  else if (g == 2) {
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].pArc2 == true) {
        arcs[i].arcColor2 = color(0, 50, int(100-(100/6.0)*(arcs[i].order2)));
      }
    }
  }
  colorMode(RGB,255);
}



int StreamOrdering2(int ArcID, int DNID) {
  
  int[] uOrders = new int[cells[DNID].adjArcs2.size()];
  
  if (cells[DNID].adjArcs2.size() == 1) {
    arcs[ArcID].order2 = 1;
  }
  else {
    for (int i = 0; i < cells[DNID].adjArcs2.size(); i++) {
      if (cells[DNID].adjArcs2.get(i) != ArcID) {
        uOrders[i] = StreamOrdering2(cells[DNID].adjArcs2.get(i),
                                    arcs[cells[DNID].adjArcs2.get(i)].endNode);
      }
      else {
        uOrders[i] = 0;
      }
    }
  
    int maxOrder = 0;
    int maxOrderCount = 0;
  
    for (int i = 0; i < uOrders.length; i++) {
      if (uOrders[i] > maxOrder) {
        maxOrder = uOrders[i];
        maxOrderCount = 1;
      }
      else if (uOrders[i] == maxOrder) {
        maxOrderCount++;
      }
    }
    if (maxOrderCount > 1) {
      arcs[ArcID].order2 = maxOrder + 1;
    }
    else {
      arcs[ArcID].order2 = maxOrder;
    }
  }
  return arcs[ArcID].order2;
}
