package com.jmg.spring.cfbpbp.recruiting;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = {"/recruiting"})
public class RecruitingController {
	private final RecruitingRepository recs;
	
    public RecruitingController(RecruitingRepository recs) {
    	this.recs = recs;
    }

    @GetMapping("/year/{year}")
    public String showRecruitingByYear(@PathVariable String year, Model model) throws IOException {
    	String recruiting = recs.getRecruitingByYear(year);
    	String teams = recs.getTeamsList();
    	model.addAttribute("recruiting", recruiting);
    	model.addAttribute("teams", teams);
    	model.addAttribute("year", year);
    	model.addAttribute("type", "Year");
    	model.addAttribute("title", year + " - " + "Recruiting");
    	return "recruiting";
    }
    
    @GetMapping("/team/{teamId}")
    public String showRecruitingByTeam(@PathVariable String teamId, Model model) throws IOException {
    	String recruiting = recs.getRecruitingByTeam(teamId);
    	String teams = recs.getTeamsList();
    	model.addAttribute("recruiting", recruiting);
    	model.addAttribute("teams", teams);
    	model.addAttribute("teamId", teamId);
    	model.addAttribute("type", "Team");
    	model.addAttribute("title", teamId + " - " + "Recruiting");
    	return "recruiting";
    }

}
