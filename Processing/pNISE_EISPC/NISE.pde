ArrayList<BiPoint> doNiseThings () {

  ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
  BiPoint bP1, bP2, bP3;
  DijkstraWrapper dW;
  
  // Creates a ForkJoinPool with parallelism equal to Runtime.availableProcessors()
  ForkJoinPool pool = new ForkJoinPool();

  // forward dijkstra for a=1 and a=0
  dW = new DijkstraWrapper(true,-1);
  
  ll.addAll(pool.invoke(dW));
  dW= null;
  count++;
  count++;
  bP1 = ll.get(0);
  bP2 = ll.remove(1);

  // Ensure bP1 != bP2
  if(bP1.z1 != bP2.z1 || bP1.z2 != bP2.z2) {
    // Divide and Conquer
    RecursiveNISE RN = new RecursiveNISE(bP1, bP2);
    bP1=null; bP2=null;
    ll.addAll(pool.invoke(RN));
  }
  
  // if there's a repeat point
  if (ll.get(0).z1 == ll.get(1).z1) {
    ll.remove(0);
  }
  return ll;
}

// do NISE to find intermediate supported non-dominated points
class RecursiveNISE extends RecursiveTask<ArrayList> {

  ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
  BiPoint bP1, bP2, bP3;
  Double a;                      // weight
  CLabel[] cLabels;
  
  RecursiveNISE(BiPoint biPnt1, BiPoint biPnt2) {
    bP1 = biPnt1;
    bP2 = biPnt2;
  }
  
  ArrayList<BiPoint> compute(){
  //  w1 = (bP1.z2 - bP2.z2); w2 = (bP2.z1 - bP1.z1); a = w1 / (w1+w2);
    a = (bP1.z2 - bP2.z2) / ((bP1.z2 - bP2.z2)+(bP2.z1 - bP1.z1));
//    if (a > 1.0) {
//      a=(double) 1.0;
//      println("maybe fixed?");
//    }
    //println("\na = "+ a);    
  
    // forward dijkstra
    bP3 = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
    count++;
    a = null;

    //System.out.println(bP3.z1 + "\t" + bP3.z2);

  
    // if point returned is the same as one of the previous points, move on to the next pair
    // otherwise, add point to linked list and repeat on the new point
    if (bP3.z1 <= bP1.z1) {
      if (bP3.z2 >= bP1.z2) { // if bP3 == bP1
        ll.add(bP2);
      } 
      else {  // else if BP3 is a vertical improvement on bP1
        ll.add(bP3);
        bP1 = null;
        RecursiveNISE left = new RecursiveNISE(bP3, bP2);
        ll.addAll(left.compute());
      }
    }
    else if (bP3.z2 <= bP2.z2) {
      if (bP3.z1 >= bP2.z1) { // if bP3 == bP2
        ll.add(bP2);
      } 
      else { // else if BP3 is a horzontal improvement on bP2
        bP2 = null;
        RecursiveNISE right = new RecursiveNISE(bP1, bP3);
        ll.addAll(right.compute());
      }
    }
    else {
      // Divide and Conquer Right
      RecursiveNISE right = new RecursiveNISE(bP3, bP2);
      right.fork();
      bP2=null;      

      // Divide and Conquer Left
      RecursiveNISE left = new RecursiveNISE(bP1, bP3);
      ll.addAll(left.compute());
      
      // Join with Right result
      ll.addAll(right.join());
    }
    return ll;
  }
}


// exports NISE points to excel file
void exportSupportedBiObjectivePoints(List<BiPoint> ll) {

  //println("export begun");
  ListIterator<BiPoint> it = ll.listIterator(0);
  BiPoint bp;
  int k = ll.size();
  int i = 0;

  String filename = new String("biObjParetoSP_supported"+rows+cols+".csv");
  String[] lines = new String[k];
  //lines[0] = new String("a,zc,z1,z2");

  while (it.hasNext ()) {
    bp = it.next();
    lines[i] = new String(bp.a + "," + bp.zc + "," + bp.z1 + "," + bp.z2);
    i++;
  }

  saveStrings(filename, lines);
  println("Supported export complete, there are " + k + " supported solutions");
}



void printList(List<BiPoint> ss) {
  
  Iterator<BiPoint> it;
  BiPoint bp;

  println("Size = " + ss.size());
  it = ss.iterator();
 
  while (it.hasNext()) {
    bp = it.next();
    println(bp.getZ1() + "\t" + bp.getZ2());
  }
//  println("Size = " + gwArcPaths.size());
}
