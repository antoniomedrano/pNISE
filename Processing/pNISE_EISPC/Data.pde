void importData() {
  String[] dataLoad;
  String[] dataLoad2 = {""};
  String[] dataLine;
  String[] dataLine2 = {""};
  int index = 0;
  final double SQRT2 = sqrt(2);
  final double SQRT5 = sqrt(5);

  r = 1;    // r=0  =>  orthagonal only   2048
            // r=1  =>  diagonal allowed
            // r=2  =>  knight moves allowed

  dataLoad = loadStrings("landcoverVal_1_10.txt");  dataLoad2 = loadStrings("slopeVal_1_10.txt"); rows = 1000; cols = 1000; 

  startingNode = rc2i(999,0); endingNode = rc2i(0,999);
//  startingNode = rc2i(0,0); endingNode = rc2i(999,999);
//  startingNode = rc2i(699,300); endingNode = rc2i(300,699);
//  startingNode = rc2i(599,400); endingNode = rc2i(400,599);
  
  // parse the 6th line to get the maximum value
  dataLine = splitTokens(dataLoad[5]," ");
  blockCost1 = int(dataLine[1]);
  blockCost2 = blockCost1;

  cells = new Cell[rows*cols];
  numNodes = cells.length;
    
  // if the second cost comes from a data layer
  // parse the rest of the lines to import the remaining data
  for (int i = 0; i < rows; i++) {
    dataLine  = splitTokens(dataLoad[i+6]," ");
    dataLine2  = splitTokens(dataLoad2[i+6]," ");
    for(int j = 0; j < cols; j++) {
      cells[index] = new Cell(index, i, j, float(dataLine[j]), float(dataLine2[j]));
      index++;
    }
  }
  dataLoad = null; dataLoad2 = null; dataLine = null; dataLine2 = null;
  // find the MinMax of the cost1 and cost2
  findMinMax2();

  // create directional arc objects
  if (r == 0)
    arcs = new Arc[2*(2*rows*cols - rows - cols)];
  else if (r==1)
    arcs = new Arc[2*(4*rows*cols - 3*rows - 3*cols + 2)];
  else if (r==2)
    arcs = new Arc[2*(8*rows*cols - 9*rows - 9*cols + 10)];
//  println("arcs: " + arcs.length);
  
  
  index = 0;
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      
      // R >=0 arcs
      if (i < rows-1) {
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j), 0, 1, index);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j), 0, 1, index);
        index++;
      }
      if (j < cols-1) {
        arcs[index] = new Arc(rc2i(i,j), rc2i(i,j+1), 0, 1, index);
        index++;
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i,j), 0, 1, index);
        index++;
      }
      
      // R >=1 arcs
      if ((r > 0) && (i < rows-1) && (j < cols-1)) {
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j+1), 1, SQRT2, index);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j+1), rc2i(i,j), 1, SQRT2, index);
        index++;
        
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j+1), 1, SQRT2, index);
        index++;
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i+1,j), 1, SQRT2, index);
        index++;
      }
      
      // R >= 2 arcs
      if ((r > 1) && (i < rows - 2) && (j < cols - 1)) {
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+2,j+1), 2, SQRT5, index);
        index++;
        arcs[index] = new Arc(rc2i(i+2,j+1), rc2i(i,j), 2, SQRT5, index);
        index++;
        
        arcs[index] = new Arc(rc2i(i,j+1), rc2i(i+2,j), 2, SQRT5, index);
        index++;
        arcs[index] = new Arc(rc2i(i+2,j), rc2i(i,j+1), 2, SQRT5, index);
        index++;
      }
      if ((r > 1) && (i < rows - 1) && (j < cols - 2)) {
        arcs[index] = new Arc(rc2i(i,j), rc2i(i+1,j+2), 2, SQRT5, index);
        index++;
        arcs[index] = new Arc(rc2i(i+1,j+2), rc2i(i,j), 2, SQRT5, index);
        index++;
        
        arcs[index] = new Arc(rc2i(i+1,j), rc2i(i,j+2), 2, SQRT5, index);
        index++;
        arcs[index] = new Arc(rc2i(i,j+2), rc2i(i+1,j), 2, SQRT5, index);
        index++;
      }
    }
  }
  
  colorBackground();

//  // for all arcs, associate them with the linked lists for their start and end nodes
//  for (int i = 0; i < arcs.length; i++) {
//        
//    if (cells[arcs[i].startNode].cost1 == blockCost1 || cells[arcs[i].endNode].cost1 == blockCost1 ||
//        cells[arcs[i].startNode].cost2 == blockCost1 || cells[arcs[i].endNode].cost2 == blockCost2) {
//      arcs[i].blackArc = true;
//      i++;
//      arcs[i].blackArc = true;
//      //println("boop");
//      continue;
//    }
//    if (arcs[i].arcType == 2) {
//      if (cells[arcs[i].middle1].cost1 == blockCost1 || cells[arcs[i].middle2].cost1 == blockCost1 ||
//          cells[arcs[i].middle1].cost2 == blockCost2 || cells[arcs[i].middle2].cost2 == blockCost2) {
//        arcs[i].blackArc = true;
//        i++;      // bi-directional arcs are made in groups of 4, if one has a black middle node, all do
//        arcs[i].blackArc = true;
//        i++;
//        arcs[i].blackArc = true;
//        i++;
//        arcs[i].blackArc = true;
//        continue;
//      }
//    }
//    
//    // add the arc to the start and end nodes' edge list
//    cells[arcs[i].startNode].ll.add(new Integer(i));
//    //cells[arcs[i].endNode].ll.add(new Integer(i));
//  }
}


void findMinMax2() {
  // determine the highest cost, 2nd highest cost, and lowest costs
  for (int i = 0; i < cells.length; i++) {
    if (cells[i].cost1 > maxCost1) {
      maxCost1 = cells[i].cost1;
    }
    else if (cells[i].cost1 < minCost1) {
      minCost1 = cells[i].cost1;
    }
    
    if (cells[i].cost2 > maxCost2) {
      maxCost2 = cells[i].cost2;
    }
    else if (cells[i].cost2 < minCost2) {
      minCost2 = cells[i].cost2;
    }
  }  
//  println("maxCost1 = " + maxCost1);
//  println("minCost1 = " + minCost1);
//  println("maxCost2 = " + maxCost2);
//  println("minCost2 = " + minCost2);
}


void colorBackground() {
  // color the nodes and cells according to their cost value
  for (int i = 0; i < cells.length; i++) {
    if (cells[i].cost1 == blockCost1) {
      //cells[i].nodeColor1 = cBlack;
      cells[i].fillColor1 = color(0);
    }
    else {
      cells[i].fillColor1 = color(255 * (1 - (cells[i].cost1 - minCost1) / (maxCost1 - minCost1)));
      //cells[i].fillColor1 = color(255 - (cells[i].cost1 - minCost1 + 1) * 180 / (maxCost1 - minCost1));
      //cells[i].fillColor = color(255 - cells[i].cost2 * 180 / (maxCost2 - minCost));
    }
    if (cells[i].cost2 == blockCost2) {
      //cells[i].nodeColor2 = cBlack;
      cells[i].fillColor2 = color(0);
    }
    else {
      cells[i].fillColor2 = color(255 * (1 - (cells[i].cost2 - minCost2) / (maxCost2 - minCost2)));
      //cells[i].fillColor2 = color(255 - (cells[i].cost2 - minCost2 + 1) * 180 / (maxCost2 - minCost2));
      //cells[i].fillColor = color(255 - cells[i].cost2 * 180 / (maxCost2 - minCost));
      //println(cells[i].cost2);
      //println(cells[i].fillColor2);
    }    
  }
}
