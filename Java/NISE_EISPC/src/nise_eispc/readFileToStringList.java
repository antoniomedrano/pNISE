package nise_eispc;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class readFileToStringList {

	readFileToStringList(){}
	
	public List<String> read(String name) {

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
}
