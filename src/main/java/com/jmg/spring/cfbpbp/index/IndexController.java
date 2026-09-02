package com.jmg.spring.cfbpbp.index;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {
	
    private final IndexRepository index;

	public IndexController(IndexRepository index) { 
    	this.index = index;
    }   
	
	@GetMapping("/")
	public String index(Model model) throws IOException {
		String teams = index.getTeamsBySpRanking();
		model.addAttribute("teams", teams);
		
		return "index";
	}
}
