class Arc {
  int startNode;
  int endNode;
  int index;
  double cost1, cost2;
  int sx, sy, ex, ey;
  color arcColor = cClear;
  color bkpColor = cClear;
  boolean blackArc = false;
  boolean paretoArc = false;
  
  Arc (int sN, int eN, int aType, double lFactor, int n) {
    int middle;
    int middle1;
    int middle2;  
    int arcType = aType;
    
    index = n;
    startNode = sN;
    sx = cells[sN].x/2;
    sy = cells[sN].y/2;
    endNode = eN;
    ex = cells[eN].x/2;
    ey = cells[eN].y/2;
    
    if (cells[startNode].cost1 == blockCost1 || cells[endNode].cost1 == blockCost1 ||
        cells[startNode].cost2 == blockCost1 || cells[endNode].cost2 == blockCost2) {
      blackArc = true;
    }
    else {
      if (arcType <= 1) {  // cost for arcType == 0 and arcType == 1 arcs
        cost1 = (cells[sN].cost1 + cells[eN].cost1) *lFactor / 2;
        cost2 = (cells[sN].cost2 + cells[eN].cost2) *lFactor / 2;
      }
      if (arcType == 2) {  // cost for arcType == 2 arcs
        if (abs(i2r(eN) - i2r(sN)) == 1) {     // if it's a horizontal r=2 arc
          middle = (i2c(sN) + i2c(eN)) / 2;
          middle1 = rc2i(i2r(sN), middle);
          middle2 = rc2i(i2r(eN), middle);
          if (cells[middle1].cost1 == blockCost1 || cells[middle2].cost1 == blockCost1 ||
              cells[middle1].cost2 == blockCost2 || cells[middle2].cost2 == blockCost2) {
            blackArc = true;
          } else {
            cost1 = (cells[sN].cost1 + cells[eN].cost1 + cells[middle1].cost1 + cells[middle2].cost1) * lFactor / 4;
            cost2 = (cells[sN].cost2 + cells[eN].cost2 + cells[middle1].cost2 + cells[middle2].cost2) * lFactor / 4;
          }
        }
        else {  // otherwise, if it's a vertical arcType=2 arc
          middle = (i2r(sN) + i2r(eN)) / 2;
          middle1 = rc2i(middle, i2c(sN));
          middle2 = rc2i(middle, i2c(eN));
          if (cells[middle1].cost1 == blockCost1 || cells[middle2].cost1 == blockCost1 ||
              cells[middle1].cost2 == blockCost2 || cells[middle2].cost2 == blockCost2) {
            blackArc = true;
          } else {
            cost1 = (cells[sN].cost1 + cells[eN].cost1 + cells[middle1].cost1 + cells[middle2].cost1) * lFactor / 4;
            cost2 = (cells[sN].cost2 + cells[eN].cost2 + cells[middle1].cost2 + cells[middle2].cost2) * lFactor / 4;
          }
        }
      }
    }
    
    // add the arc to the start and end nodes' edge list
    cells[startNode].ll.add(new Integer(index));
    //cells[endNode].ll.add(new Integer(index));
    
  }

  double wCost (double a) {
    return a*this.cost1 + (1-a)*this.cost2;
  }
  

  void display() {
    strokeWeight(2);
    stroke(arcColor);
    line(sx,sy,ex,ey);
    strokeWeight(1);
  }
  
//  void display2() {
//    strokeWeight(3);
//    stroke(arcColor2);
//    line(sx,sy,ex,ey);
//    strokeWeight(1);
//  }

}
