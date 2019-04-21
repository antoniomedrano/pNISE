package nise_eispc;

// This version uses doubles for the BP values
public class BiPoint {

	private double a;
	private double zc;
	private double z1;
	private double z2;

	BiPoint (double aIn, double[] input) {
		if (aIn < 0 || aIn > 1) {
			System.out.println("ERROR!!!!");
		}
		a = aIn;
		zc = input[0];
		z1 = input[1];
		z2 = input[2];
	}

	public void setZees(double[] input) {
		zc = input[0];
		z1 = input[1];
		z2 = input[2];
	}

	public double getZ1() {return z1;}
	public double getZ2() {return z2;}
	public double getZC() {return zc;}
	public double getA() {return a;}	
}


//This version uses floats for the BP values
//public class BiPoint {
//
//	private double a;
//	private float zc;
//	private float z1;
//	private float z2;
//
//	BiPoint (double aIn, double[] input) {
//		if (aIn < 0 || aIn > 1) {
//			System.out.println("ERROR!!!!");
//		}
//		a = aIn;
//		zc = (float)input[0];
//		z1 = (float)input[1];
//		z2 = (float)input[2];
//	}
//
//	public void setZees(double[] input) {
//		zc = (float)input[0];
//		z1 = (float)input[1];
//		z2 = (float)input[2];
//	}
//
//	public float getZ1() {return z1;}
//	public float getZ2() {return z2;}
//	public float getZC() {return zc;}
//	public double getA() {return a;}
//}