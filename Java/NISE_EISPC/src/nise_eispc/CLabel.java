package nise_eispc;

public class CLabel implements Comparable<CLabel> {

	private int prevNode = -1;
	private int prevArc = -1;
	private double pathCostF = Double.POSITIVE_INFINITY;
	private double pathCost1 = 0;
	private double pathCost2 = 0;
	private boolean pNode = false;
	private boolean tNode = false;
	private int index = -1;

	CLabel(int i) {
		index = i;
	}
	
	public void setPrevNode(int pn) {prevNode = pn;}
	public int getPrevNode() {return prevNode;}

	public void setPrevArc(int pa) {prevArc = pa;}
	public int getPrevArc() {return prevArc;}

	public void setPCF(double pcf) {pathCostF = pcf;}
	public double getPCF() {return pathCostF;}
	
	public void setPC1(double pc1) {pathCost1 = pc1;}
	public double getPC1() {return pathCost1;}
	
	public void setPC2(double pc2) {pathCost2 = pc2;}
	public double getPC2() {return pathCost2;}
	
	public void setPNode(boolean p) {pNode = p;}
	public boolean getPNode() {return pNode;}

	public void setTNode(boolean t) {tNode = t;}
	public boolean getTNode() {return tNode;}
	
	public int getI() {return index;}
	
	@Override
	public int compareTo(CLabel o) {
        return Double.compare(pathCostF, o.getPCF());
	}

}
