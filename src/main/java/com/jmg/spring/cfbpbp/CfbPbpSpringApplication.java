package com.jmg.spring.cfbpbp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class CfbPbpSpringApplication {

	public static void main(String[] args) {
		SpringApplication.run(CfbPbpSpringApplication.class, args);
	}
}
