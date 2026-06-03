package com.jmg.spring.cfbpbp.ranking;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = {"/rankings"})
public class RankingController {
	private final RankingRepository rankings;
	
    public RankingController(RankingRepository rankings) {
    	this.rankings = rankings;
    }

    @GetMapping("/year/{year}/week/{week}")
    public String showRankings(@PathVariable String year, @PathVariable String week, Model model) throws IOException {
    	String polls = rankings.geRankingByYearWeek(year, week);
    	String yearMaxWeek = rankings.getYearMaxWeek(year);
    	
    	model.addAttribute("year", year);
    	model.addAttribute("week", week);
    	model.addAttribute("yearMaxWeek", yearMaxWeek);
    	model.addAttribute("polls", polls);
    	
    	return "rankings_all";
    }
    
}