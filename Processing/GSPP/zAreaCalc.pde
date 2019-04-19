// Builds polygon gateway path, then sends it to polygonArea() to calculate the area difference
float gatewayAreaDiff(int gwNode) {
  
  int cNode = gwNode; // the current node
  int gwcLength1; // chain length of forward gateway path portion
  int gwcLength;  // chain length of total gateway path + 1
  int pgonLength; // total polygon chain length + 1 (closing node included)
  
  int x[];  // x-coordinates of area polygon
  int y[];  // y-coordinates of area polygon
  int gwNodes1[]; // nodes for the forward gateway path portion
  
  // determine chain lengths for relevant paths
  gwcLength1 = cells[gwNode].chainLength1;
  gwcLength = cells[gwNode].chainLength1 + cells[gwNode].chainLength2 + 1;
  pgonLength = gwcLength + cells[endingNode].chainLength1;
  
  // initialize arrays for polygon coordinates and forward gateway nodes
  x = new int[pgonLength];
  y = new int[pgonLength];
  gwNodes1 = new int[gwcLength1];
  
  // acquire forward gateway nodes
  for(int i = 0; i < gwcLength1; i++) {
    gwNodes1[i] = cells[cNode].prevNode1;
    cNode = gwNodes1[i];
  }
  
  cNode = gwNode;
  
  // build the gateway path polygon chain
  for(int i = 0; i < gwcLength; i++) {
    if (i < gwcLength1) {
      x[i]=i2c(gwNodes1[gwcLength1-1-i]);
      y[i]=i2r(gwNodes1[gwcLength1-1-i]);
    }
    else if (i == gwcLength1) {
      x[i]=i2c(gwNode);
      y[i]=i2r(gwNode);
    }
    else {
      cNode = cells[cNode].prevNode2;
      x[i]=i2c(cNode);
      y[i]=i2r(cNode);      
    }
  }
  
  // build the shortest path polygon chain
  for (int i = gwcLength; i < pgonLength; i++) {
      cNode = cells[cNode].prevNode1;
      x[i]=i2c(cNode);
      y[i]=i2r(cNode);
  }
  
  return polygonArea(x, y, pgonLength);
}


// Finds the area of any simple polygon
float polygonArea(int x[], int y[], int pgonLength) {
  float a = 0;

  for (int i = 1; i < pgonLength-1; i++) {
    a += x[i]*(y[i+1]-y[i-1]);
  }
  a += x[pgonLength-1]*(y[1]-y[pgonLength-2]);
  
  return abs(a/2);
}
