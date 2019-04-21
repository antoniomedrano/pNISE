public class BiPoint {
  private double a;
  private double zc;
  private double z1;
  private double z2;

  BiPoint (double aIn) {
    if (aIn < 0 || aIn > 1) {
      println(aIn);
      println("ERROR!");
    }
    a = aIn;
  }
  
  BiPoint (double aIn, double[] input) {
    if (aIn < 0 || aIn > 1) {
      println(aIn);
      println("ERROR!!!!");
    }
    a = aIn;
    zc = input[0];
    z1 = input[1];
    z2 = input[2];
  }

  void setZees(double[] input) {
    zc = input[0];
    z1 = input[1];
    z2 = input[2];
  }
  
  double getZ1() {return z1;}
  double getZ2() {return z2;}
  double getZC() {return zc;}
}



// Lexigraphically compares BiPoints first in order of increasing z1, then in order of increasing z2.
public class GeneralBiPointComparator implements Comparator<BiPoint> {
  
  public int compare (BiPoint Y, BiPoint X) {
    
    if (Y.z1 < X.z1) {return -1;}
    if (Y.z1 > X.z1) {return 1;}
    if (Y.z2 < X.z2) {return -1;}
    if (Y.z2 > X.z2) {return 1;}
    return 0;
  }
}

// This uses the fact that Collections.java uses key in the second argument of the comparison in their
// indexedBinarySearch routine
public class SpecialBiPointComparator implements Comparator<BiPoint> {
  
  public int compare (BiPoint Y, BiPoint X) {
    
    if (X.z1 >= Y.z1 && X.z2 >= Y.z2) {return 0;}
    if (Y.z1 < X.z1) {return -1;}
    return 1;
  }
}


public class CellComparator implements Comparator<CLabel> {
  
//  public int compare (Cell node1, Cell node2) {
//    return Double.compare(node1.pathCostF, node2.pathCostF);
//  }

  public int compare (CLabel node1, CLabel node2) {
    return Double.compare(node1.pathCostF, node2.pathCostF);
  }
}
