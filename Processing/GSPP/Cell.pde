class Cell{
  int row;      // which row it's located in the array, 0 indexing
  int col;      // which column it's located in the array, 0 indexing
  float cost;   // cost to traverse this cell
  int n;        // reference index value of the cell
  int x, y;     // pixel position of the node
  color nodeColor = cClear;
  color bkpColor = cClear;
  color fillColor;
  int prevNode1 = -1;
  int prevNode2 = -1;
  double pathCostF = Double.POSITIVE_INFINITY;
  double pathCostR = Double.POSITIVE_INFINITY;
  double gwCost = -1;
  int chainLength1 = 0;
  int chainLength2 = 0;
  int prevArc1;
  int prevArc2;
  ArrayList<Integer> adjArcs1 = new ArrayList<Integer>();
  ArrayList<Integer> adjArcs2 = new ArrayList<Integer>();
  int order1 = 0;
  int order2 = 0;
  ArrayList<Integer> LLout = new ArrayList<Integer>();
  ArrayList<Integer> LLin = new ArrayList<Integer>();
  boolean pNode = false;
  boolean tNode = false;
  boolean blackNode = false;

 
  Cell(int index, int r, int c, float penalty) {
    n = index;
    row = r;
    col = c;
    cost = penalty;
    x =  int( ( col + 0.5 ) * float(cellSize) + 30 );
    y =  int( ( row + 0.5 ) * float(cellSize) + 30 );
  }
 
  void clear() {
    this.tNode = false;
    this.pNode = false;
  }
 
  void displaySquare() {

    stroke(0);
    fill(fillColor);
    rect(col*cellSize + 30, row*cellSize + 30, cellSize, cellSize);   
   
  } 
 
  void displayNodeWithText() {
    
    // then add the circle node
    stroke(50);
    fill(nodeColor);    // set the fill color to be whatever is store in this object's circleColor property
    ellipse(x+0.5,y+0.5, nodeSize, nodeSize);    // draw the circle using the x,y and circleSize properties of this object

    // finally, display the text
    fill(0);
    textAlign(CENTER, CENTER);
    text(str(int(cost)), x, y);
  }
  
  void displayNodeNoText() {

    // then add the circle node
    stroke(50);
    fill(nodeColor);    // set the fill color to be whatever is store in this object's nodeColor property
    ellipse(x,y, nodeSize, nodeSize); // draw the circle using the x,y and nodeSize properties of this object
    
  }
}


public class CellComparator implements Comparator<Cell> {
  
  public int compare (Cell node1, Cell node2) {

//    double diff = node1.pathCostF - node2.pathCostF;
//
//    if (diff < 0) {return -1;}
//    if (diff > 0) {return 1;}
//    return 0;
    
    return Double.compare(node1.pathCostF, node2.pathCostF);
  }
}

public class CellComparator2 implements Comparator<Cell> {
  
  public int compare (Cell node1, Cell node2) {

//    double diff = node1.pathCostF - node2.pathCostF;
//
//    if (diff < 0) {return -1;}
//    if (diff > 0) {return 1;}
//    return 0;
    
    return Double.compare(node1.pathCostR, node2.pathCostR);
  }
}
