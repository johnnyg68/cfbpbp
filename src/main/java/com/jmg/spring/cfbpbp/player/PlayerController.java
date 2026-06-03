package com.jmg.spring.cfbpbp.player;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = {"/stats/year/{year}/players", "/players/player/{playerid}"})
public class PlayerController {
	private final PlayerRepository players;
	
    public PlayerController(PlayerRepository players) {
    	this.players = players;
    }
    
    // Career stats for a given player
    @GetMapping(value = "") 
    public String showCareerStats(@PathVariable("playerid") String playerId, Model model) throws IOException {
    	
    	String passing = players.getPlayerCareerPassing(playerId);
    	String rushing = players.getPlayerCareerRushing(playerId);
    	String receiving = players.getPlayerCareerReceiving(playerId);    	
    	String defense = players.getPlayerCareerDefense(playerId);
    	String puntReturns = players.getPlayerCareerPuntReturns(playerId);
    	String kickReturns = players.getPlayerCareerKickReturns(playerId);    	
    	String punting = players.getPlayerCareerPunting(playerId);
    	String kicking = players.getPlayerCareerKicking(playerId);
    	
    	// Games Stats
    	String passingGames = players.getPlayerGamesPassing(playerId);
    	String rushingGames = players.getPlayerGamesRushing(playerId);
    	String receivingGames = players.getPlayerGamesReceiving(playerId);
    	String defenseGames = players.getPlayerGamesDefense(playerId);
    	String kickReturnsGames = players.getPlayerGamesKickReturns(playerId); 
    	String puntReturnsGames = players.getPlayerGamesPuntReturns(playerId);
    	String puntingGames = players.getPlayerGamesPunting(playerId);
    	String kickingGames = players.getPlayerGamesKicking(playerId);
    	
    	// Career Totals (aggregated across all years)
    	String passingTotal = players.getPlayerCareerTotalPassing(playerId);
    	String rushingTotal = players.getPlayerCareerTotalRushing(playerId);
    	String receivingTotal = players.getPlayerCareerTotalReceiving(playerId);
    	String defenseTotal = players.getPlayerCareerTotalDefense(playerId);
    	String kickReturnsTotal = players.getPlayerCareerTotalKickReturns(playerId);
    	String puntReturnsTotal = players.getPlayerCareerTotalPuntReturns(playerId);
    	String puntingTotal = players.getPlayerCareerTotalPunting(playerId);
    	String kickingTotal = players.getPlayerCareerTotalKicking(playerId);
    	
    	model.addAttribute("playerId", playerId);
    	model.addAttribute("passing", passing);
    	model.addAttribute("rushing", rushing);
    	model.addAttribute("receiving", receiving);
    	model.addAttribute("defense", defense);
    	model.addAttribute("puntReturns", puntReturns);
    	model.addAttribute("kickReturns", kickReturns);
    	model.addAttribute("punting", punting);
    	model.addAttribute("kicking", kicking);
    	
    	//Add Game States
    	model.addAttribute("passingGames", passingGames);
    	model.addAttribute("rushingGames", rushingGames);
    	model.addAttribute("receivingGames", receivingGames);
    	model.addAttribute("defenseGames", defenseGames);
    	model.addAttribute("kickReturnsGames", kickReturnsGames);
    	model.addAttribute("puntReturnsGames", puntReturnsGames);
    	model.addAttribute("puntingGames", puntingGames);
    	model.addAttribute("kickingGames", kickingGames);
    	
    	//Add Career Totals
		model.addAttribute("passingTotal", passingTotal);
		model.addAttribute("rushingTotal", rushingTotal);
		model.addAttribute("receivingTotal", receivingTotal);
		model.addAttribute("defenseTotal", defenseTotal);
		model.addAttribute("kickReturnsTotal", kickReturnsTotal);
		model.addAttribute("puntReturnsTotal", puntReturnsTotal);
		model.addAttribute("puntingTotal", puntingTotal);
		model.addAttribute("kickingTotal", kickingTotal);
		
		return "player";    	

    }
    
    // Year stats relative to all other players in FBS
    
    @GetMapping(value = "/allpurposeoffense")
    public String showAllPurposeOffense(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_all_purpose_offense.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player All Purpose Offense");
    	return "stats";
    }
    
    @GetMapping(value = "/totaloffense")
    public String showTotalOffense(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_total_offense.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Total Offense");
    	return "stats";
    }
    
    @GetMapping(value = "/passingoffense")
    public String showPlayerPassingOffense(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_passing_offense.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Passing Offense");
    	return "stats";
    }
    
    @GetMapping(value = "/rushingoffense")
    public String showPlayerRushingOffense(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_rushing_offense.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Rushing Offense");
    	return "stats";
    }
    
    @GetMapping(value = "/receivingoffense")
    public String showPlayerReceivingOffense(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_receiving_offense.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Receiving Offense");
    	return "stats";
    }
    
    @GetMapping(value = "/fieldgoals")
    public String showFieldGoals(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_field_goals.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
    	return "stats";
    }
    
    @GetMapping(value = "/puntreturns")
    public String showPuntReturns(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_puntreturns.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Punt Returns");
    	return "stats";
    }
    
    @GetMapping(value = "/kickreturns")
    public String showKickReturns(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_kickreturns.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Kick Returns");
    	return "stats";
    }
    
    @GetMapping(value = "/tackles")
    public String showTackles(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_tackles.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Tackles");
    	return "stats";
    }
    
    @GetMapping(value = "/tacklesforloss")
    public String showTacklesForLoss(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_tacklesforloss.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Player Tackles For Loss");
    	return "stats";
    }
    
    @GetMapping(value = "/interceptions")
    public String showInts(@PathVariable String year, Model model) throws IOException {
    	String sqlFile = "player/player_interceptions.sql";
		String data = players.getPlayerStats(year, sqlFile);
		model.addAttribute("stats", data);
		model.addAttribute("title", year + " - Interceptions");
    	return "stats";
    }
    
/*    @RequestMapping(value = "/fieldgoals", method = RequestMethod.GET)
    @ResponseBody
    public  List<Map<String,Object>> showFieldGoals(@PathVariable("year") String year) throws IOException {
    	String sqlFile = "player_field_goals.sql";
    	List<Map<String,Object>> data = players.getPlayerStats(year, sqlFile);
    	return data;
    }*/
    
}
