class Arc {
  int n;                  // arc number
  int startNode;
  int endNode;
  int arcType;
  //float lFactor;
  double cost;
  double L;               // shortest path cost to startNode + Arc[].cost
  int sx, sy, ex, ey;
  int middle;
  color arcColor = cClear;
  color bkpColor = cClear;
  int order = 1;
  color arcColor2 = cClear;
  color bkpColor2 = cClear;
  int order2 = 1;
  boolean unlabeled1 = true;
  boolean unlabeled2 = true;
  boolean pArc1 = false;
  boolean pArc2 = false;
  int middle1;
  int middle2;
  boolean blackArc = false;
  
  Arc (int sN, int eN, int aType, double lFactor) {
    int middle;
    
    startNode = sN;
    sx = cells[sN].x;
    sy = cells[sN].y;
    endNode = eN;
    ex = cells[eN].x;
    ey = cells[eN].y;
    arcType = aType;
    
    // Old automated length factor code
    // arcType = abs(i2r(sN)-i2r(eN)) + abs(i2c(sN) - i2c(eN)) - 1;
    // lFactor = sqrt(pow(r, 2) + 1);
    
    if (arcType <= 1) {  // cost for arcType == 0 and arcType == 1 arcs
      cost = (cells[sN].cost + cells[eN].cost) *lFactor / 2;
    }
    if (arcType == 2) {  // cost for arcType == 2 arcs
      if (abs(i2r(eN) - i2r(sN)) == 1) {     // if it's a horizontal r=2 arc
        middle = (i2c(sN) + i2c(eN)) / 2;
        middle1 = rc2i(i2r(sN), middle);
        middle2 = rc2i(i2r(eN), middle);
        cost = (cells[sN].cost + cells[eN].cost + cells[middle1].cost + cells[middle2].cost) * lFactor / 4;
      }
      else {  // otherwise, if it's a vertical arcType=2 arc
        middle = (i2r(sN) + i2r(eN)) / 2;
        middle1 = rc2i(middle, i2c(sN));
        middle2 = rc2i(middle, i2c(eN));
        cost = (cells[sN].cost + cells[eN].cost + cells[middle1].cost + cells[middle2].cost) * lFactor / 4;
      }
    }
  }
  

  void display() {
    strokeWeight(1+2*order);
    stroke(arcColor);
    line(sx,sy,ex,ey);
    strokeWeight(1);
  }
  
  void display2() {
    strokeWeight(1+2*order2);
    stroke(arcColor2);
    line(sx,sy,ex,ey);
    strokeWeight(1);
  }

}
  
