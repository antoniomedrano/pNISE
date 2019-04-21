/******************************************************************************************** 
 *  DIJKSTRA                                                                                *
 ********************************************************************************************
 */

double[] runDijkstra(int sNode, int eNode, double a) {
  
  int tempSNode, tempENode, newPArc;
  double tempDist;
  double Lsp = -1;
  double Lz1 = -1;
  double Lz2 = -1;
  int newPNode = -1;
  int u = sNode;
  int v;
  boolean found = false;
  boolean pathShown = false;
  PriorityQueue<CLabel> tNodes = new PriorityQueue<CLabel>(ceil(sqrt(numNodes))*(r+3), new CellComparator());
  CLabel bestCell;
  CLabel[] cLabels = new CLabel[numNodes];
  
  // INITIALIZE
  // clear the nodes
  for (int i = 0; i < numNodes; i++) {
    cLabels[i] = new CLabel(i);
  }

  // color and label the starting node appropriately
  cLabels[sNode].prevNode = sNode;  // set itself as previous node (because it's a starting node)
  cLabels[sNode].pNode = true;
  cLabels[sNode].pathCostF = 0;  

  // begin iteration
  while (!pathShown) {

    if (!found) {
      
      // find all arcs emanating from last permanently marked node and mark them temprorary
      //llsize = cells[u].ll.size();   // start at index 0
  
      for (int uv : cells[u].ll) {
        
        //uv = cells[u].ll.get(i);
        v = arcs[uv].endNode;
        // update the node if not labeled permanent
        if (cLabels[v].pNode == false) {
          tempDist = arcs[uv].wCost(a) + cLabels[u].pathCostF;
          if (tempDist < cLabels[v].pathCostF) {
            if (cLabels[v].tNode == true) {
              tNodes.remove(cLabels[v]);
              cLabels[v].pathCostF = tempDist;
              cLabels[v].prevNode = u;
              cLabels[v].prevArc = uv;
              tNodes.offer(cLabels[v]);
            }
            else {
              cLabels[v].pathCostF = tempDist;
              cLabels[v].prevNode = u;
              cLabels[v].prevArc = uv;
              cLabels[v].tNode = true;                   // set node as temporarily labeled
              tNodes.offer(cLabels[v]);
            }
          }
        }
      }

      // pop the best node from the tNodes binary heap
      bestCell = tNodes.poll();
      newPNode = bestCell.index;

      // permanently label the node and arc
      newPArc = bestCell.prevArc;
      tempSNode = bestCell.prevNode;
     
      cLabels[newPNode].pathCost1 = arcs[newPArc].cost1 + cLabels[tempSNode].pathCost1;
      cLabels[newPNode].pathCost2 = arcs[newPArc].cost2 + cLabels[tempSNode].pathCost2;
      cLabels[newPNode].pNode = true;

      // designate newPNode as u for next calculation
      u = newPNode;
            
      // stop when ending node is found
      if (u == eNode) {
        found = true;
        tNodes = null;
      }
    }
    
    // backtrack from the end to display the shortest path
    else {
      tempENode = eNode;
      while (!pathShown) {
        tempSNode = cLabels[tempENode].prevNode;            
          if (tempENode == sNode) {
            pathShown = true;
          }
          else {
            arcs[cLabels[tempENode].prevArc].arcColor = cRed;
            arcs[cLabels[tempENode].prevArc].paretoArc = true;
            tempENode = tempSNode;
          }
      }
      Lsp = cLabels[eNode].pathCostF;
      Lz1 = cLabels[eNode].pathCost1;
      Lz2 = cLabels[eNode].pathCost2;
      cLabels = null;
//      println("SP cost = " + Lsp);
//      println("Z1 cost = " + Lz1);
//      println("Z2 cost = " + Lz2);
    }

  }
  double[] out = {Lsp, Lz1, Lz2};
  return out;
}

class DijkstraWrapper extends RecursiveTask<ArrayList> {

  ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
  BiPoint bP;
  Double a;
  boolean b;
  CLabel[] cLabels;
  
  DijkstraWrapper(boolean in, double aIn){
    b = in;
    a = aIn;
  }
  
  ArrayList<BiPoint> compute() {
    if (b == false) {
      bP = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
      ll.add(bP);
    }
    else {
      // Divide and Conquer Right
      DijkstraWrapper right = new DijkstraWrapper(false, 0);
      right.fork();

      // Divide and Conquer Left
      DijkstraWrapper left = new DijkstraWrapper(false, 1);
      ll.addAll(left.compute());

      // Join with Right result
      ll.addAll(right.join());
    }
    return ll;
  }
}
