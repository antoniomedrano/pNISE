package nise_eispc;

import java.util.List;
import java.util.concurrent.Callable;
//import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutionException;
//import java.util.concurrent.ExecutorService;
//import java.util.concurrent.Executors;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.Future;
import java.util.concurrent.RecursiveTask;
import java.util.ArrayList; 
//import java.util.Collection;
import java.util.PriorityQueue;
import java.util.ListIterator;
import java.util.Iterator;
//import java.util.Properties;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardOpenOption;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;

import static java.lang.Math.sqrt;
import static java.lang.Math.abs;
import static java.lang.Math.ceil;


public class nise_eispc {

	/**nise_eispc.java
	 *
	 * This program solves a multi-objective shortest path problem. For the moment, it just does 2 objectives.
	 *
	 * It solves for the supported Pareto optimal solutions using the NISE method on the EISPC data
	 *
	 * NEW FROM PREVIOUS VERSION:
	 * 100% Java now
	 * Right now, deleted black arc and pareto arc stuff
	 * Some packages aren't imported because they're not being used
	 */

	public static Cell[] cells;
	public static Arc[] arcs;
	static RCConverter c;

	static int numNodes;
	static int startingNode;
	static int endingNode;
	static int count = 0;

	/* args[0] = r-value. The radius of the network
	 * args[1] = OD pair (1 and 2 corner to corner; 3 medium; 4 small)
	 * args[3] = parallelism
	 */

	
	public static void main(String[] args) {

		int r = -1;
		int od = -1;
		int p = -1;
		
		if (args.length > 0) {
		    try {
		        r = Integer.parseInt(args[0]);
		    } catch (NumberFormatException e) {
		        System.err.println("First Argument" + " must be an integer");
		        System.exit(1);
		    }
		} else {
			r = 0;
		}
		if (args.length > 1) {
		    try {
		        od = Integer.parseInt(args[1]);
		    } catch (NumberFormatException e) {
		        System.err.println("Second Argument" + " must be an integer");
		        System.exit(1);
		    }
		} else {
			od = 4;
		}
		if (args.length > 2) {
		    try {
		        p = Integer.parseInt(args[2]);
		    } catch (NumberFormatException e) {
		        System.err.println("Third Argument" + " must be an integer");
		        System.exit(1);
		    }
		} else {
			p = Runtime.getRuntime().availableProcessors();
		}

		doSomething(r, od, p);
		System.out.println("COMPLETE");
		
//		String[] pro = {"java.version", "java.vm.version", "java.runtime.version"};
//		Properties properties = System.getProperties();
//		for (int i = 0; i < pro.length; i++) {
//			System.out.print(pro[i]+"\t\t: ");
//			System.out.println(properties.getProperty(pro[i]));
//		}
	}
	
	public static class Arc {
		private int startNode;
		private int endNode;
		private int index;
		private double cost1, cost2;
//		private boolean blackArc = false;
//		private boolean paretoArc = false;

		Arc (Cell sN, Cell eN, int aType, double lFactor, int n) {
			int middle;
			int middle1;
			int middle2;  
			int arcType = aType;
			
			index = n;
			startNode = sN.getI();
			endNode = eN.getI();

			if (cells[startNode].blackNode == true || cells[endNode].blackNode == true) {
//				blackArc = true;
			}
			else {
				if (arcType <= 1) {  // cost for arcType == 0 and arcType == 1 arcs
					cost1 = (sN.cost1 + eN.cost1) *lFactor / 2;
					cost2 = (sN.cost2 + eN.cost2) *lFactor / 2;
				}
				if (arcType == 2) {  // cost for arcType == 2 arcs
					if (abs(eN.getR() - sN.getR()) == 1) {     // if it's a horizontal r=2 arc
						middle = (sN.getC() + eN.getC()) / 2;
						middle1 = c.rc2i(sN.getR(), middle);
						middle2 = c.rc2i(eN.getR(), middle);
						if (cells[middle1].blackNode == true || cells[middle2].blackNode == true) {
//							blackArc = true;
						} else {
							cost1 = (sN.cost1 + eN.cost1 + cells[middle1].cost1 + cells[middle2].cost1) * lFactor / 4;
							cost2 = (sN.cost2 + eN.cost2 + cells[middle1].cost2 + cells[middle2].cost2) * lFactor / 4;
						}
					}
					else {  // otherwise, if it's a vertical arcType=2 arc
						middle = (sN.getR() + eN.getR()) / 2;
						middle1 = c.rc2i(middle, sN.getC());
						middle2 = c.rc2i(middle, eN.getC());
						if (cells[middle1].blackNode == true || cells[middle2].blackNode == true) {
//							blackArc = true;
						} else {
							cost1 = (sN.cost1 + eN.cost1 + cells[middle1].cost1 + cells[middle2].cost1) * lFactor / 4;
							cost2 = (sN.cost2 + eN.cost2 + cells[middle1].cost2 + cells[middle2].cost2) * lFactor / 4;
						}
					}
				}
			}

			// add the arc to the start and end nodes' edge list
			sN.ll.add(new Integer(index));
			//cells[endNode].ll.add(new Integer(index));
		}

		public double wCost (double a) {
			return a*this.cost1 + (1-a)*this.cost2;
		}

	}

	
	public static class Cell {
		private int row;      // which row it's located in the array, 0 indexing
		private int col;      // which column it's located in the array, 0 indexing
		private int index = -1;
		private float cost1;
		private float cost2;
		private boolean blackNode = false;

		private ArrayList<Integer> ll = new ArrayList<Integer>();

//		public Cell(int i, int r, int c, float penalty) {
//			index = i;
//			row = r;
//			col = c;
//			cost1 = penalty;
//		}

		public Cell(int i, int r, int c, float penalty1, float penalty2) {
			index = i;
			row = r;
			col = c;
			cost1 = penalty1;
			cost2 = penalty2;
		}
		
		public void setBlackTrue() {
			this.blackNode = true;
		}
		
		public int getC() {
			return col;
		}
		
		public int getR() {
			return row;
		}
		
		public int getI() {
			return index;
		}
		
		public float getC1() {
			return cost1;
		}
		
		public float getC2() {
			return cost2;
		}
	}


	public static void importData(int r, int od) {
		List<String> dataLoad = null;
		List<String> dataLoad2 = null;
		String[] dataLine = null;
		String[] dataLine2 = null;
		String userPath = "";
		String filePath = "";
		String fileName1 = "";
		String fileName2 = "";
		int index = 0;
		final double SQRT2 = sqrt(2);
		final double SQRT5 = sqrt(5);
		float p1, p2;
		float blockCost1;
		float blockCost2;
		int cols;
		int rows;

		// r is an input argument
		//        // r=0  =>  orthagonal only   2048
				  // r=1  =>  diagonal allowed
				  // r=2  =>  knight moves allowed 

		fileName1 = "landcoverVal.txt"; fileName2 = "slopeVal.txt"; rows = 1000; cols = 1000;

		//System.out.println(userPath = System.getProperty("user.home"));
		//System.out.println(/*filePath = */System.getProperty("user.dir"));
		//filePath = userPath + "/Data/EISPC";
		
		System.out.println(filePath = System.getProperty("user.dir"));
		filePath = filePath + "/data";
		System.out.println(filePath);

		fileName1 = filePath + File.separator + fileName1;
		fileName2 = filePath + File.separator + fileName2;

		dataLoad = readTextFile(fileName1);
		dataLoad2 = readTextFile(fileName2);

		// parse first lines for columns
		dataLine = dataLoad.get(0).split(" +");
		cols = Integer.parseInt(dataLine[1]);

		// parse second line for rows
		dataLine = dataLoad.get(1).split(" +");
		rows = Integer.parseInt(dataLine[1]);

		// sixth line gives nodata_value
		dataLine = dataLoad.get(5).split(" +");
		blockCost1 = Float.parseFloat(dataLine[1]);
		blockCost2 = blockCost1;
		
		numNodes = rows*cols;
		c = new RCConverter(rows, cols);
		cells = new Cell[numNodes];
		
		// the second cost comes from a data layer
		// parse the rest of the lines to import the remaining data
		for (int i = 0; i < rows; i++) {
		    dataLine = dataLoad.get(i+6).split(" +");
		    dataLine2 = dataLoad2.get(i+6).split(" +");
			for (int j = 0; j < cols; j++) {
				p1 = Float.parseFloat(dataLine[j]);
				p2 = Float.parseFloat(dataLine2[j]);
				cells[index] = new Cell(index, i, j, p1, p2);
				if (p1 == blockCost1 || p2 == blockCost2) {
					cells[index].setBlackTrue();
				}
				index++;
			}
		}
		dataLoad = null; dataLoad2 = null; dataLine = null; dataLine2 = null;
		// find the MinMax of the cost1 and cost2

		// create directional arc objects
		if (r == 0)
			arcs = new Arc[2*(2*rows*cols - rows - cols)];
		else if (r==1)
			arcs = new Arc[2*(4*rows*cols - 3*rows - 3*cols + 2)];
		else if (r==2)
			arcs = new Arc[2*(8*rows*cols - 9*rows - 9*cols + 10)];

		index = 0;

		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {

				// R >=0 arcs
				if (i < rows-1) {
					arcs[index] = new Arc(cells[c.rc2i(i,j)], cells[c.rc2i(i+1,j)], 0, 1, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i+1,j)], cells[c.rc2i(i,j)], 0, 1, index);
					index++;
				}
				if (j < cols-1) {
					arcs[index] = new Arc(cells[c.rc2i(i,j)], cells[c.rc2i(i,j+1)], 0, 1, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i,j+1)], cells[c.rc2i(i,j)], 0, 1, index);
					index++;
				}

				// R >=1 arcs
				if ((r > 0) && (i < rows-1) && (j < cols-1)) {
					arcs[index] = new Arc(cells[c.rc2i(i,j)], cells[c.rc2i(i+1,j+1)], 1, SQRT2, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i+1,j+1)], cells[c.rc2i(i,j)], 1, SQRT2, index);
					index++;

					arcs[index] = new Arc(cells[c.rc2i(i+1,j)], cells[c.rc2i(i,j+1)], 1, SQRT2, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i,j+1)], cells[c.rc2i(i+1,j)], 1, SQRT2, index);
					index++;
				}

				// R >= 2 arcs
				if ((r > 1) && (i < rows - 2) && (j < cols - 1)) {
					arcs[index] = new Arc(cells[c.rc2i(i,j)], cells[c.rc2i(i+2,j+1)], 2, SQRT5, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i+2,j+1)], cells[c.rc2i(i,j)], 2, SQRT5, index);
					index++;

					arcs[index] = new Arc(cells[c.rc2i(i,j+1)], cells[c.rc2i(i+2,j)], 2, SQRT5, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i+2,j)], cells[c.rc2i(i,j+1)], 2, SQRT5, index);
					index++;
				}
				if ((r > 1) && (i < rows - 1) && (j < cols - 2)) {
					arcs[index] = new Arc(cells[c.rc2i(i,j)], cells[c.rc2i(i+1,j+2)], 2, SQRT5, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i+1,j+2)], cells[c.rc2i(i,j)], 2, SQRT5, index);
					index++;

					arcs[index] = new Arc(cells[c.rc2i(i+1,j)], cells[c.rc2i(i,j+2)], 2, SQRT5, index);
					index++;
					arcs[index] = new Arc(cells[c.rc2i(i,j+2)], cells[c.rc2i(i+1,j)], 2, SQRT5, index);
					index++;
				}
			}
		}
		
		// select the OD pair
		switch(od) {
			case 1:	startingNode = c.rc2i(999,0); endingNode = c.rc2i(0,999); break;
			case 2: startingNode = c.rc2i(0,0); endingNode = c.rc2i(999,999); break;
			case 3: startingNode = c.rc2i(699,300); endingNode = c.rc2i(300,699); break;
			case 4: startingNode = c.rc2i(599,400); endingNode = c.rc2i(400,599); break;
			default:startingNode = 0; endingNode = numNodes-1; break;
		}
	}


	/******************************************************************************************** 
	 *  DIJKSTRA                                                                                *
	 ********************************************************************************************
	 */

	public static double[] runDijkstra(int sNode, int eNode, double a) {

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
		PriorityQueue<CLabel> tNodes = new PriorityQueue<CLabel>((int)ceil(sqrt(numNodes))*5/*(r+3)*/);
		CLabel bestCell;
		CLabel[] cLabels = new CLabel[numNodes];

		// increment counter
		count++;
		
		// INITIALIZE
		// clear the nodes
		for (int i = 0; i < numNodes; i++) {
			cLabels[i] = new CLabel(i);
		}

		// color and label the starting node appropriately
		cLabels[sNode].setPrevNode(sNode);  // set itself as previous node (because it's a starting node)
		cLabels[sNode].setPNode(true);
		cLabels[sNode].setPCF(0);  

		// begin iteration
		while (!pathShown) {

			if (!found) {

				// for each arc adjacent to cell[u]
				for (int uv : cells[u].ll) {

					//uv = cells[u].ll.get(i);
					v = arcs[uv].endNode;
					// update the node if not labeled permanent
					if (cLabels[v].getPNode() == false) {
						tempDist = arcs[uv].wCost(a) + cLabels[u].getPCF();
						if (tempDist < cLabels[v].getPCF()) {
							if (cLabels[v].getTNode() == true) {
								tNodes.remove(cLabels[v]);
								cLabels[v].setPCF(tempDist);
								cLabels[v].setPrevNode(u);
								cLabels[v].setPrevArc(uv);
								tNodes.offer(cLabels[v]);
							}
							else {
								cLabels[v].setPCF(tempDist);
								cLabels[v].setPrevNode(u);
								cLabels[v].setPrevArc(uv);
								cLabels[v].setTNode(true);  // set node as temporarily labeled
								tNodes.offer(cLabels[v]);
							}
						}
					}
				}

				// pop the best node from the tNodes binary heap
				bestCell = tNodes.poll();
				newPNode = bestCell.getI();

				// permanently label the node and arc
				newPArc = bestCell.getPrevArc();
				tempSNode = bestCell.getPrevNode();

				cLabels[newPNode].setPC1(arcs[newPArc].cost1 + cLabels[tempSNode].getPC1());
				cLabels[newPNode].setPC2(arcs[newPArc].cost2 + cLabels[tempSNode].getPC2());
				cLabels[newPNode].setPNode(true);

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
					tempSNode = cLabels[tempENode].getPrevNode();            
					if (tempENode == sNode) {
						pathShown = true;
					}
					else {
//						arcs[cLabels[tempENode].getPrevArc()].paretoArc = true;
						tempENode = tempSNode;
					}
				}
				Lsp = cLabels[eNode].getPCF();
				Lz1 = cLabels[eNode].getPC1();
				Lz2 = cLabels[eNode].getPC2();
				cLabels = null;
				//      System.out.println("SP cost = " + Lsp);
				//      System.out.println("Z1 cost = " + Lz1);
				//      System.out.println("Z2 cost = " + Lz2);
			}

		}
		double[] out = {Lsp, Lz1, Lz2};
		return out;
	}

	@SuppressWarnings("serial")
	public static class DijkstraWrapper extends RecursiveTask<ArrayList<BiPoint>> {

		private ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		private BiPoint bP;
		private Double a;
		private boolean b;

		DijkstraWrapper(boolean in, double aIn){
			b = in;
			a = aIn;
		}

		@Override
		public ArrayList<BiPoint> compute() {
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
	
	
	public static class DijkstraThread extends Thread{

		private BiPoint bP;
		private Double a;
		
		public DijkstraThread(double aIn) {
			a = aIn;
		}
		
		@Override
		public void run()
		{
			bP = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
		}

		public BiPoint getBP() {
			return bP;
		}
	}
	
	
	public static ArrayList<BiPoint> doNiseThings (int p) {

		ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		
		ll = standardInitFJ_NISE(p);
		//ll = parallelInitFJ_NISE(p);		
		//ll = serial_NISE(p);
		
		//printList(ll);
		
		return ll;
	}

	
	public static ArrayList<BiPoint> standardInitFJ_NISE (int p) {

		ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		BiPoint bP1, bP2;
		ForkJoinPool pool = new ForkJoinPool(p);
		RecursiveNISE RN;
		
		if (p == 1) {
			bP1 = new BiPoint(1, runDijkstra(startingNode, endingNode, 1));
			bP2 = new BiPoint(0, runDijkstra(startingNode, endingNode, 0));
			ll.add(bP1);
		}
		else {
//			// forward Dijkstra for a=1 and a=0 using fork/join
//			DijkstraWrapper dW = new DijkstraWrapper(true,-1);
//			ll.addAll(pool.invoke(dW));
//			dW=null;
//			bP1 = ll.get(0);
//			bP2 = ll.remove(1);
			
			// forward Dijkstra for a=1 and a=0 using threads
			DijkstraThread dT1 = new DijkstraThread(1);
			dT1.start();
			DijkstraThread dT2 = new DijkstraThread(0);
			dT2.start();
			try {
				dT1.join();
				dT2.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			bP1 = dT1.getBP();
			bP2 = dT2.getBP();
			ll.add(bP1);
			dT1 = null; dT2=null;
		}
		
		// Ensure bP1 != bP2
		if(bP1.getZ1() != bP2.getZ1() || bP1.getZ2() != bP2.getZ2()) {
			// Divide and Conquer
			RN = new RecursiveNISE(bP1, bP2);
			bP1=null; bP2=null;
			ll.addAll(pool.invoke(RN));
		}
		//pool.shutdown();
		
		// if there's a repeat point
		if (ll.size() > 1 && ll.get(0).getZ1() == ll.get(1).getZ1()) {
			ll.remove(0);
		}
		return ll;
	}

	public static ArrayList<BiPoint> parallelInitFJ_NISE (int p) {
		
		ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		ArrayList<DijkstraThread> threads = new ArrayList<DijkstraThread>();
		DijkstraThread thread;
		ArrayList<RecursiveNISE> RNS = new ArrayList<RecursiveNISE>();
		RecursiveNISE RN;

		BiPoint bP1 = null;
		BiPoint bP2 = null;
		ForkJoinPool pool = new ForkJoinPool(p);

		if (p == 1) {
			bP1 = new BiPoint(1, runDijkstra(startingNode, endingNode, 1));
			bP2 = new BiPoint(0, runDijkstra(startingNode, endingNode, 0));
			ll.add(bP1);
			
			// Ensure bP1 != bP2
			if(bP1.getZ1() != bP2.getZ1() || bP1.getZ2() != bP2.getZ2()) {
				// Divide and Conquer
				RN = new RecursiveNISE(bP1, bP2);
				bP1=null; bP2=null;
				ll.addAll(pool.invoke(RN));
			}
		}
		else {

			// forward dijkstra for interval a values with interval 1/p-1 using threads
			for (int i = 0; i < p; i++) {
				thread = new DijkstraThread(1-i/(p-1.0));
				thread.start();
				threads.add(thread);
				count++;
			}
			try {
				for(Thread t : threads) {
					t.join();
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			// Create RecursiveNISE instances with results of above
			bP2 = threads.get(0).getBP();
			for (int i = 1; i < threads.size(); i++) {
				bP1 = bP2;
				bP2 = threads.get(i).getBP();
				//if there are repeat points, skip
				if (bP1.getZ1() == bP2.getZ1()){
					continue;
				}
				RNS.add(new RecursiveNISE(bP1, bP2));
			}
			if (bP1.getZ2() == bP2.getZ2()){
				RNS.remove( RNS.size() - 1 );
			}
			//System.out.println("RNS size = " + RNS.size());
			
			// Invoke all RecursiveNISE instances, and store output to Future list
			List<Future<ArrayList<BiPoint>>> resultList = null;
			try {
				resultList = pool.invokeAll(RNS);
			} catch (NullPointerException e) {
				e.printStackTrace();
			}
			//pool.shutdown();
			//System.out.println(pool.isShutdown());
			//System.out.println(resultList.size());

			// get results from Future list
			for (Future<ArrayList<BiPoint>> f : resultList) {
				try {
					ll.addAll(f.get());
				} catch (InterruptedException | ExecutionException e) {
					e.printStackTrace();
				}
			}
		}
		
		// if there's a repeat point
		if (ll.size() > 1 && ll.get(0).getZ1() == ll.get(1).getZ1()) {
			ll.remove(0);
		}
		
		return ll;
	}
	
	
	// do NISE to find intermediate supported non-dominated points
	@SuppressWarnings("serial")
	public static class RecursiveNISE extends RecursiveTask<ArrayList<BiPoint>> implements Callable<ArrayList<BiPoint>> {

		private ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		private BiPoint bP1, bP2, bP3;
		private Double a;                      // weight

		RecursiveNISE(BiPoint biPnt1, BiPoint biPnt2) {
			bP1 = biPnt1;
			bP2 = biPnt2;
		}

		public ArrayList<BiPoint> compute(){
			//  w1 = (bP1.z2 - bP2.z2); w2 = (bP2.z1 - bP1.z1); a = w1 / (w1+w2);
			a = (double) (bP1.getZ2() - bP2.getZ2()) / ((bP1.getZ2() - bP2.getZ2())+(bP2.getZ1() - bP1.getZ1()));
			//System.out.println("\na = "+ a);    
			//printBP(bP1); printBP(bP3); printBP(bP2);
			//System.out.println();
			
			// forward dijkstra
			bP3 = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
			a = null;
			
			// EASIER TO UNDERSTAND, BUT LESS EFFICIENT THAN WHAT'S BELOW
			// if point returned is lexicographically between the previous points,
			if (bP3.getZ2() < bP1.getZ2() && bP3.getZ1() < bP2.getZ1()) {
				// if BP3 is a horizontal improvement on bP2
				if (bP3.getZ2() == bP2.getZ2()) {
					bP2 = null;
					RecursiveNISE left = new RecursiveNISE(bP1, bP3);
					ll.addAll(left.compute());
				}
				// else if BP3 is a vertical improvement on bP1
				else if (bP3.getZ1() == bP1.getZ1()){
					ll.add(bP3);
					bP1 = null;
					RecursiveNISE right = new RecursiveNISE(bP3, bP2);
					ll.addAll(right.compute());
				}
				// else divide the problem in two and repeat				
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
			}
			// otherwise, simply return bP2
			else {	
				ll.add(bP2);
			}
			
			// MORE EFFICIENT, BUT HAS A BUG WHERE LAST TWO ANSWERS COULD BE (z1,z2+delta)(z1,z2)
//			// if point returned is the same as one of the previous points, move on to the next pair
//			// otherwise, add point to linked list and repeat on the new point
//			if (bP3.getZ1() <= bP1.getZ1()) {
//				if (bP3.getZ2() >= bP1.getZ2()) { // if bP3 == bP1
//					ll.add(bP2);
//				} 
//				else {  // else BP3 is a vertical improvement on bP1
//					ll.add(bP3);
//					bP1 = null;
//					RecursiveNISE right = new RecursiveNISE(bP3, bP2);
//					ll.addAll(right.compute());
//				}
//			}
//			else if (bP3.getZ2() <= bP2.getZ2()) {
//				if (bP3.getZ1() >= bP2.getZ1()) { // if bP3 == bP2
//					ll.add(bP2);
//				} 
//				else { // else BP3 is a horizontal improvement on bP2
//					bP2 = null;
//					RecursiveNISE left = new RecursiveNISE(bP1, bP3);
//					ll.addAll(left.compute());
//				}
//			}
//			else {
//				// Divide and Conquer Right
//				RecursiveNISE right = new RecursiveNISE(bP3, bP2);
//				right.fork();
//				bP2=null;      
//
//				// Divide and Conquer Left
//				RecursiveNISE left = new RecursiveNISE(bP1, bP3);
//				ll.addAll(left.compute());
//
//				// Join with Right result
//				ll.addAll(right.join());
//			}
			return ll;
		}

		@Override
		public ArrayList<BiPoint> call() throws Exception {
			return compute();
		}
	}
	
//	@SuppressWarnings("serial")
	public static class RecursiveNISESerial {

		private ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
		private BiPoint bP1, bP2, bP3;
		private Double a;                      // weight

		RecursiveNISESerial(BiPoint biPnt1, BiPoint biPnt2) {
			bP1 = biPnt1;
			bP2 = biPnt2;
		}

		public ArrayList<BiPoint> compute(){
			//  w1 = (bP1.z2 - bP2.z2); w2 = (bP2.z1 - bP1.z1); a = w1 / (w1+w2);
			a = (double) (bP1.getZ2() - bP2.getZ2()) / ((bP1.getZ2() - bP2.getZ2())+(bP2.getZ1() - bP1.getZ1()));
			//System.out.println("\na = "+ a);    
			//printBP(bP1); printBP(bP2);
			
			// forward dijkstra
			bP3 = new BiPoint(a, runDijkstra(startingNode, endingNode, a));
			count++;
			a = null;

			// if point returned is the same as one of the previous points, move on to the next pair
			// otherwise, add point to linked list and repeat on the new point
			if (bP3.getZ1() <= bP1.getZ1()) {
				if (bP3.getZ2() >= bP1.getZ2()) { // if bP3 == bP1
					ll.add(bP2);
				} 
				else {  // else if BP3 is a vertical improvement on bP1
					ll.add(bP3);
					bP1 = null;
					RecursiveNISESerial left = new RecursiveNISESerial(bP3, bP2);
					ll.addAll(left.compute());
				}
			}
			else if (bP3.getZ2() <= bP2.getZ2()) {
				if (bP3.getZ1() >= bP2.getZ1()) { // if bP3 == bP2
					ll.add(bP2);
				} 
				else { // else if BP3 is a horizontal improvement on bP2
					bP2 = null;
					RecursiveNISESerial right = new RecursiveNISESerial(bP1, bP3);
					ll.addAll(right.compute());
				}
			}
			else {
				// Divide and Conquer Left
				RecursiveNISESerial left = new RecursiveNISESerial(bP1, bP3);
				ll.addAll(left.compute());
				bP1=null;
				
				// Divide and Conquer Right
				RecursiveNISESerial right = new RecursiveNISESerial(bP3, bP2);
				ll.addAll(right.compute());
			}
			return ll;
		}
	}


	// exports NISE points to excel file
	public static void exportSupportedBiObjectivePoints(List<BiPoint> ll, int r, int od, int p) {

		//System.out.println("export begun");
		ListIterator<BiPoint> it = ll.listIterator(0);
		BiPoint bp;
		int k = ll.size();

		String filename = new String("NISEr" + r + "od" + od + "p" + p + ".csv");
		ArrayList<String> lines = new ArrayList<String>(k);
		//lines[0] = new String("a,zc,z1,z2");

		while (it.hasNext ()) {
			bp = it.next();
			lines.add(new String(bp.getZC() + "," + bp.getZ1() + "," + bp.getZ2()));
		}
		//saveStrings(filename, lines);
		try{
			Files.write(FileSystems.getDefault().getPath("", filename), lines, Charset.defaultCharset(), StandardOpenOption.CREATE);
		}   catch (IOException ioe) {
			ioe.printStackTrace();
		}
		System.out.println("Supported export complete, there are " + k + " supported solutions");
	}



	public static void printList(List<BiPoint> ss) {

		Iterator<BiPoint> it;
		BiPoint bp;

		System.out.println("Size = " + ss.size());
		it = ss.iterator();

		while (it.hasNext()) {
			bp = it.next();
			System.out.println(bp.getZ1() + "\t" + bp.getZ2());
		}
		//  System.out.println("Size = " + gwArcPaths.size());
	}

	public static void printBP(BiPoint bp) {
		System.out.format("%.15f\t%.15f\n",bp.getZ1(),bp.getZ2());
	}
	
	
	public static void doSomething(int r, int od, int p){
		
		long start, elapsed;
		//int sup;

		// run the importData() function
		start = System.currentTimeMillis();
		importData(r, od);
		elapsed = System.currentTimeMillis() - start;
		System.out.print("LOAD DATA: ");
		printRuntime(elapsed);
		
		System.out.println("Processors Available = " + Runtime.getRuntime().availableProcessors());
		System.out.println("Parallelism = " + p);
		System.out.println("Start: " + startingNode);
		System.out.println("End: " + endingNode);
		
		start = System.currentTimeMillis();
		ArrayList<BiPoint> ll = doNiseThings(p);
		elapsed = System.currentTimeMillis() - start;

		exportSupportedBiObjectivePoints(ll, r, od , p);
		//printList(ll);

		if (count > 0)
			System.out.println("NISE Completed, Dijkstra ran " + count + " times");
		else
			System.out.println("There's an error somewhere");    

		System.out.print("COMPUTE: ");
		printRuntime(elapsed);
	}

	public static void printRuntime(long elapsed) {

		int days = (int) elapsed/86400000;
		int rem = (int) (elapsed%86400000);
		int hours = rem / 3600000;
		rem = rem % 3600000;
		int minutes = rem / 60000;
		rem = rem % 60000;
		float seconds = rem / 1000.0f;

		float t_sec = elapsed / 1000.0f;

		System.out.println("runtime took " + days + " days, " + hours + " hours, " + minutes + " minutes, and " +
				seconds + " seconds (" + t_sec + " total seconds)");
	}

//	static List<String> readTextFile(String fileName) {
//		try {
//			Path path = Paths.get(fileName);
//			return Files.readAllLines(path, Charset.defaultCharset());
//		}
//		catch (IOException ioe) {
//			ioe.printStackTrace();
//		}       
//		return null;
//	}
	
	public static List<String> readTextFile(String name) {
		try {
			BufferedReader reader =
					Files.newBufferedReader(
							FileSystems.getDefault().getPath("", name),
							Charset.defaultCharset() );

			List<String> lines = new ArrayList<>();
			String line = null;
			while ( (line = reader.readLine()) != null ) {
				lines.add(line);
			}
			return lines;
		}
		catch (IOException ioe) {
			ioe.printStackTrace();
		}       
		return null;
	}


	public static ArrayList<BiPoint> serial_NISE (int p) {
	
			ArrayList<BiPoint> ll = new ArrayList<BiPoint>();
			BiPoint bP1, bP2;
	
			// forward dijkstra for a=1 and a=0
			bP1 = new BiPoint(1, runDijkstra(startingNode, endingNode, 1));
			bP2 = new BiPoint(0, runDijkstra(startingNode, endingNode, 0));
			ll.add(bP1);
			
			// Ensure bP1 != bP2
			if(bP1.getZ1() != bP2.getZ1() || bP1.getZ2() != bP2.getZ2()) {
				// Divide and Conquer
				RecursiveNISESerial RN = new RecursiveNISESerial(bP1, bP2);
				bP1=null; bP2=null;
				ll.addAll(RN.compute());
			}
	
			// if there's a repeat point
			if (ll.size() > 1 && ll.get(0).getZ1() == ll.get(1).getZ1()) {
				ll.remove(0);
			}
	
			return ll;
		}
}