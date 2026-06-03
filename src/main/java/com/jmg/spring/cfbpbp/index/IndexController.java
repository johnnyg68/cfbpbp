package com.jmg.spring.cfbpbp.index;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {
	
    private final IndexRepository index;
    String year = "2025";

	public IndexController(IndexRepository index) { 
    	this.index = index;
    }   

	@GetMapping("/")
	public String index(Model model) throws IOException {
		String teams = index.getTeamsBySpRanking(year);
		model.addAttribute("year", year);
		model.addAttribute("teams", teams);
		
		return "index";
	}
}
