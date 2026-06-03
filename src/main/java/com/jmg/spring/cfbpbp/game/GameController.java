package com.jmg.spring.cfbpbp.game;

import java.io.IOException;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jmg.spring.cfbpbp.team.TeamRepository;


@Controller
@RequestMapping(value = {"/games", "/schedule"})
public class GameController {
	private final GameRepository games;
	private final GamePlayerRepository players;
	private final TeamRepository teams;
	
    public GameController(GameRepository games, GamePlayerRepository players, TeamRepository teams) {
    	this.games = games;
    	this.players = players; 
    	this.teams = teams;
    }
    
    @GetMapping("")
    public String showSchedule(Model model) throws IOException {
		String scheduleYearWeekMap = games.getScheduleYearWeekMap();
		String year = games.getMaxYear(scheduleYearWeekMap);
		String week = games.getMaxWeek(scheduleYearWeekMap, year);
		
		String conferences = games.getConferences();
		model.addAttribute("conferences", conferences);

		model.addAttribute("scheduleYearWeekMap", scheduleYearWeekMap);
		model.addAttribute("year", year);
		model.addAttribute("week", week);
		
		String schedule = games.getGamesSchedule(year, week);
		model.addAttribute("schedule", schedule);
		
		return "schedule";
    }

    @GetMapping("/year/{year}/week/{week}") 
    public String showScheduleYearWeek(@PathVariable String year, @PathVariable String week, Model model) throws IOException {
		String schedule = games.getGamesSchedule(year, week);
		model.addAttribute("schedule", schedule);
		
		String conferences = games.getConferences();
		model.addAttribute("conferences", conferences);
		
		String scheduleYearWeekMap = games.getScheduleYearWeekMap();
		model.addAttribute("scheduleYearWeekMap", scheduleYearWeekMap);

		return "schedule";
    } 
    
    @GetMapping("/game/{gameid}/boxscore")
    public String showBoxscore(@PathVariable("gameid") String gameId, Model model) throws IOException {
		String gameHeader = games.getGameBoxscoreHeader(gameId);
		model.addAttribute("gameHeader", gameHeader);
		
		String dataJson = games.getGameBoxscore(gameId);
		model.addAttribute("dataJson", dataJson);
		 
		//Scoring plays
		String scoringPlays = games.getScoringPlays(gameId);
		model.addAttribute("scoringPlays", scoringPlays);
		
		//All Plays
		String allPlays = games.getAllPlays(gameId);
		model.addAttribute("allPlays", allPlays);
		
		//Play summary -- TotalPlays, Successful, Explosive
		String playSummary = games.getPlaySummary(gameId);
		model.addAttribute("playSummary", playSummary);
		
		//All Drives and Plays
		String drivesAndPlays = games.getDrivesAndPlays(gameId);
		model.addAttribute("drivesAndPlays", drivesAndPlays);
			
		//Odds
		String odds = games.getGameOdds(gameId);
		model.addAttribute("odds", odds);
		
		//Player passing 
		String playerPassing = players.getGamePlayerPassing(gameId);
		model.addAttribute("playerPassing", playerPassing);
		
		//Player rushing 
		String playerRushing = players.getGamePlayerRushing(gameId);
		model.addAttribute("playerRushing", playerRushing);
		
		//Player receiving 
		String playerReceiving = players.getGamePlayerReceiving(gameId);
		model.addAttribute("playerReceiving", playerReceiving);
		
		//Player defense 
		String playerDefense = players.getGamePlayerDefense(gameId);
		model.addAttribute("playerDefense", playerDefense);
		
		//Player interceptions by defense 
		String playerInts = players.getGamePlayerInts(gameId);
		model.addAttribute("playerInts", playerInts);
		
		//Player Kickoff Returns 
		String playerKickReturns = players.getGamePlayerKickReturns(gameId);
		model.addAttribute("playerKickReturns", playerKickReturns);
		
		//Player Punt Returns
		String playerPuntReturns = players.getGamePlayerPuntReturns(gameId);
		model.addAttribute("playerPuntReturns", playerPuntReturns);
		
		//Player Kicking
		String playerKicking = players.getGamePlayerKicking(gameId);
		model.addAttribute("playerKicking", playerKicking);
		
		//Player Punting
		String playerPunting = players.getGamePlayerPunting(gameId);
		model.addAttribute("playerPunting", playerPunting);
		
		return "boxscore";
    }
    
    // Game Preview
    @GetMapping("/game/{gameid}/gamepreview")
    public String showGamePreview(@PathVariable("gameid") String gameId, Model model) throws IOException {
		String scheduleYearWeekMap = games.getScheduleYearWeekMap();
		String year = games.getMaxYear(scheduleYearWeekMap);
		
		Map<String,Object> teamIds = games.getTeamIds(gameId);
		String awayTeamId = (String) teamIds.get("awayteamid");
		String homeTeamId = (String) teamIds.get("hometeamid");
		
		// Header
		String gamePreviewHeader = games.getGamePreviewHeader(year, gameId);
    	model.addAttribute("gamePreviewHeader", gamePreviewHeader);
    	
    	// Odds
    	String odds = games.getGameOdds(gameId);
    	model.addAttribute("odds", odds);
    	
    	String spRankings = games.getSpRankings(year, awayTeamId, homeTeamId); 
    	model.addAttribute("spRankings", spRankings);

    	// Team Stats - Offense
    	String awayTeamOffense = games.getTeamOffense(year, awayTeamId);
    	model.addAttribute("awayTeamOffense", awayTeamOffense);
    	String homeTeamOffense = games.getTeamOffense(year, homeTeamId);
    	model.addAttribute("homeTeamOffense", homeTeamOffense);
    	
    	// Team Stats - Defense
    	String awayTeamDefense = games.getTeamDefense(year, awayTeamId);
    	model.addAttribute("awayTeamDefense", awayTeamDefense);
    	String homeTeamDefense = games.getTeamDefense(year, homeTeamId);
    	model.addAttribute("homeTeamDefense", homeTeamDefense);
    	
    	// Game History
    	String gameHistory = games.getGameHistory(awayTeamId, homeTeamId);
    	model.addAttribute("gameHistory", gameHistory);

    	// Away Team Stats
    	String gamePreviewAwayTeamStats = games.getGamePreviewTeamGameStats(year, awayTeamId);
    	model.addAttribute("gamePreviewAwayTeamStats", gamePreviewAwayTeamStats);
    	
    	// Home Team Stats
    	String gamePreviewHomeTeamStats = games.getGamePreviewTeamGameStats(year, homeTeamId);
    	model.addAttribute("gamePreviewHomeTeamStats", gamePreviewHomeTeamStats);

    	// Away Team Season Games
    	String awaySeasonResults = teams.getTeamGameResults(awayTeamId, year);
    	model.addAttribute("awaySeasonResults", awaySeasonResults);
    	
    	// Home Team Season Games
    	String homeSeasonResults = teams.getTeamGameResults(homeTeamId, year);
    	model.addAttribute("homeSeasonResults", homeSeasonResults);

    	return "gamepreview";
    }

}
