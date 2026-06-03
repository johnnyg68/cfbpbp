package com.jmg.spring.cfbpbp.sql;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.util.FileCopyUtils;

public class SqlFileReader {
	
	public static String getSqlFromFile(String fileName) {		
		Resource resource = new ClassPathResource("sql/" + fileName);
		byte[] bdata = null;

		try {
			InputStream inputStream = resource.getInputStream();
			bdata = FileCopyUtils.copyToByteArray(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}

	    return new String(bdata, StandardCharsets.UTF_8);
	}
}