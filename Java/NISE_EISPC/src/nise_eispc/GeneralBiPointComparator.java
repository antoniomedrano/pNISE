package nise_eispc;

import java.util.Comparator;
import nise_eispc.BiPoint;

// Lexicographically compares BiPoints first in order of increasing z1,
// then in order of increasing z2.
public class GeneralBiPointComparator implements Comparator<BiPoint> {

	public int compare (BiPoint Y, BiPoint X) {
System.out.println("BONK!");
		if (Y.getZ1() < X.getZ1()) {return -1;}
		if (Y.getZ1() > X.getZ1()) {return 1;}
		if (Y.getZ2() < X.getZ2()) {return -1;}
		if (Y.getZ2() > X.getZ2()) {return 1;}
		return 0;
	}
}
