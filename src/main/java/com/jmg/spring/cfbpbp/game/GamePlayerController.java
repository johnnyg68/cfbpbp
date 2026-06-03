package com.jmg.spring.cfbpbp.game;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/game/{gameId}")
public class GamePlayerController {
	
	private final GamePlayerRepository games;
	
    public GamePlayerController(GamePlayerRepository games) {
    	this.games = games;
    }
    
    @GetMapping(value = "/playerdefense")
    public String showDefense(@PathVariable String gameId, Model model) throws IOException {
		String dataJson = games.getGamePlayerDefense(gameId);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
    @GetMapping("/playerpassing")
    public String showPlayerPassing(@PathVariable String gameId, Model model) throws IOException {
		String dataJson = games.getGamePlayerPassing(gameId);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
    @GetMapping(value = "/playerreceiving")
    public String showReceiving(@PathVariable String gameId, Model model) throws IOException {
		String dataJson = games.getGamePlayerReceiving(gameId);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
    @GetMapping(value = "/playerrushing")
    public String showRushing(@PathVariable String gameId, Model model) throws IOException {
		String dataJson = games.getGamePlayerRushing(gameId);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
}
