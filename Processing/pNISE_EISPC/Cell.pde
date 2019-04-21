class Cell{
  int row;      // which row it's located in the array, 0 indexing
  int col;      // which column it's located in the array, 0 indexing
  float cost1;
  float cost2;
  int x, y;     // pixel position of the node
  color fillColor1;
  color fillColor2;
  boolean blackNode = false;
  
  ArrayList<Integer> ll = new ArrayList<Integer>();
  int index = -1;
 
  Cell(int i, int r, int c, float penalty) {
    index = i;
    row = r;
    col = c;
    cost1 = penalty;
    x =  int(col + gap);
    y =  int(row + gap);
  }
  
  Cell(int i, int r, int c, float penalty1, float penalty2) {
    index = i;
    row = r;
    col = c;
    cost1 = penalty1;
    cost2 = penalty2;
    x =  int(col + gap);
    y =  int(row + gap);
  }
  
  
  void displaySquare(int layer) {
    stroke(0);
    if (layer == 1)
      fill(fillColor1);
    else if (layer == 2)
      fill(fillColor2);
    //rect(col*cellSize + 30, row*cellSize + 30, cellSize, cellSize);   
  }
}


public class CLabel implements Cloneable {
  
  int prevNode = -1;
  int prevArc = -1;
  double pathCostF = Double.POSITIVE_INFINITY;
  double pathCost1 = 0;
  double pathCost2 = 0;
  boolean pNode = false;
  boolean tNode = false;
  int index = -1;
  
  CLabel(int i) {
    index = i;
  } 
}
  
