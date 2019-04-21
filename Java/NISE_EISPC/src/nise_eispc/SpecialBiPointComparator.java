package nise_eispc;

import java.util.Comparator;
import nise_eispc.BiPoint;

// returns 0 if X is dominated by Y
// returns -1 if X is greater than Y
// returns 1 if X is less than Y

// This uses the fact that Collections.java uses key in the second argument of the comparison in their
// indexedBinarySearch routine

public class SpecialBiPointComparator implements Comparator<BiPoint> {
	
	public int compare (BiPoint Y, BiPoint X) {
		if (X.getZ1() >= Y.getZ1() && X.getZ2() >= Y.getZ2()) {return 0;}
		if (Y.getZ1() < X.getZ1()) {return -1;}
		return 1;
	}
}
