package nise_eispc;

public class RCConverter {
	
	@SuppressWarnings("unused")
	private int rows;
	private int cols;
	
	public RCConverter (int r, int c) {
		rows = r;
		cols = c;
	}
	
	public int rc2i(int row, int col) {
		return row * (cols) + col;
	}

	public int i2r(int index) {
		return index / (cols);
	}

	public int i2c(int index) {
		return index % (cols);
	}

}
