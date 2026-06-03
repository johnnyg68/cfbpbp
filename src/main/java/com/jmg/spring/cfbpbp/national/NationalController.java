package com.jmg.spring.cfbpbp.national;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/stats")
public class NationalController {

	private final NationalRepository nats;
	private static final int ASCENDING = 0;
	@SuppressWarnings("unused")
	private static final int DESCENDING = 1;
	private static final String MAX_YEAR = "2024";
	
    public NationalController(NationalRepository nats) {
    	this.nats = nats;
    }    
    
    @GetMapping("/index")
    public String showStatsIndex(Model model) throws IOException {
    	//TODO - make this dynamic i.e. MAX(game.year)
    	model.addAttribute("year", MAX_YEAR);    	
    	model.addAttribute("title", MAX_YEAR + " - " + "National Stats");
    	return "stats_index";
    }
	
    @GetMapping("/year/{year}/index")
    public String showStatsYear(@PathVariable String year, Model model) throws IOException {
    	model.addAttribute("year", year);    	
    	model.addAttribute("title", year + " - " + "National Stats");
    	return "stats_index";
    }
    
    @GetMapping("/rankings")
    public String showRankings(Model model) throws IOException {
    	String year = MAX_YEAR;

    	String apRankings = nats.getApRanking(year);
    	String spRankings = nats.getSpRanking(year);
    	
    	model.addAttribute("year", year);
    	model.addAttribute("title", year + " - " + "AP Poll & SP+ Rankings");
    	model.addAttribute("sortOrder", ASCENDING);
    	model.addAttribute("apRankings", apRankings);  
    	model.addAttribute("spRankings", spRankings);    	
    	return "rankings";
    }
    
    @GetMapping("/year/{year}/rankings")
    public String showRankings(@PathVariable String year, Model model) throws IOException {
    	String apRankings = nats.getApRanking(year);
    	String spRankings = nats.getSpRanking(year);
    	
    	model.addAttribute("year", year);
    	model.addAttribute("title", year + " - " + "AP Poll & SP+ Rankings");
    	model.addAttribute("sortOrder", ASCENDING);
    	model.addAttribute("apRankings", apRankings);  
    	model.addAttribute("spRankings", spRankings);    	
    	return "rankings";
    }
    
    @GetMapping("/year/{year}/team/3rddowndefense")
    public String show3rdDownDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.get3rdDownDefense(year);
		model.addAttribute("title", year + " - " + "3rd Down Defense");
		model.addAttribute("sortOrder", ASCENDING);
		model.addAttribute("stats", stats);		
		return "stats";
    }
    
    @GetMapping("/year/{year}/team/3rddownoffense")
    public String show3rdDownOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.get3rdDownOffense(year);
		model.addAttribute("title", year + " - " + "3rd Down Offense");
		model.addAttribute("stats", stats);
		return "stats";
    }
    
    @GetMapping(value = "/firstdowns")
    public String showFirstDowns(@PathVariable String year, Model model) throws IOException {
		String dataJson = nats.getFirstDowns(year);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
    @GetMapping(value = "/year/{year}/team/passingoffense")
    public String showPassOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getPassOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Passing Offense");
		return "stats";
    }
    
    @GetMapping(value = "/penalties")
    public String showPenalties(@PathVariable String year, Model model) throws IOException {
		String dataJson = nats.getPenalties(year);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
/*    @GetMapping(value = "/redzonedefense")
    public String showRedzoneDefense(@PathVariable("year") String year, Model model) throws IOException {
		String dataJson = nats.getRedZoneDefense(year);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }*/
    
    @GetMapping(value = "/redzoneoffense")
    public String showRedZoneOffense(@PathVariable String year, Model model) throws IOException {
		String dataJson = nats.getRedZoneOffense(year);
		model.addAttribute("dataJson", dataJson);
		return "result";
    }
    
    @GetMapping(value = "/year/{year}/team/rushingdefense")
    public String showRushDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getRushDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Rushing Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/passingdefense")
    public String showPassDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getPassDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Passing Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/rushingoffense")
    public String showRushOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getRushOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Rushing Offense");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/scoringdefense")
    public String showScoringDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getScoringDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Scoring Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/tacklesforloss")
    public String showTfl(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getTfl(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Sacks and TFL");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/tacklesforlossallowed")
    public String showTflAllowed(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getTflAllowed(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Sacks and TFL Allowed");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/totaldefense")
    public String showTotalDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getTotalDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Total Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/totaloffense")
    public String showTotalOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getTotalOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Total Offense");
		return "stats";
    }

    @GetMapping(value = "/year/{year}/team/scoringoffense")
    public String showScoringOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getScoringOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Scoring Offense");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/turnovermargin")
    public String showTurnoverMargin(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getTurnoverMargin(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Turnover Margin");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/puntreturnoffense")
    public String showPuntReturnOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getPuntReturnOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Punt Return Offense");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/puntreturndefense")
    public String showPuntReturnDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getPuntReturnDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Punt Return Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/kickreturnoffense")
    public String showKickReturnOffense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getKickReturnOffense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Kick Return Offense");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/kickreturndefense")
    public String showKickReturnDefense(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getKickReturnDefense(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Kick Return Defense");
		model.addAttribute("sortOrder", ASCENDING);
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/offenseplaysuccess")
    public String showOffensePlaySuccess(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getOffensePlaySuccess(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Offensive Play Success");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/offensepointsperplay")
    public String showOffensePontsPerPlay(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getOffensePointsPerPlay(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Offensive Points Per Play");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/defensepointsperplay")
    public String showDefensePontsPerPlay(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getDefensePointsPerPlay(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Defensive Points Per Play");
		return "stats";
    }

    @GetMapping(value = "/year/{year}/team/offensedriveefficiency")
    public String showOffenseDriveEfficiency(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getOffenseDriveEfficiency(year);
		model.addAttribute("stats", stats);
		//TODO - fix this
		model.addAttribute("title", year + " - " + "Team Offensive Drive Efficiency");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/offenseplayexplosiveness")
    public String showOffensePlayExplosiveness(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getOffensePlayExplosiveness(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Explosive Plays");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/defenseplayexplosiveness")
    public String showDefensePlayExplosiveness(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getDefensePlayExplosiveness(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Explosive Plays Allowed");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/defenseplaysuccess")
    public String showDefensePlaySuccess(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getDefensePlaySuccess(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Team Defensive Play Success");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/defensedriveefficiency")
    public String showDefenseDriveEfficiency(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getDefenseDriveEfficiency(year);
		model.addAttribute("stats", stats);
		//TODO - fix this
		model.addAttribute("title", year + " - " + "Team Defensive Drive Efficiency");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/spranking")
    public String showSpRanking(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getSpRanking(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "SP+ Ranking");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/movranking")
    public String showMovRanking(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getMovRanking(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Avg Margin of Victory Excluding FCS teams");
		return "stats";
    }
    
    @GetMapping(value = "/winswith5turnovers")
    public String showWinsWith5Turnovers(Model model) throws IOException {
		String stats = nats.getWinsWith5Turnovers();
		model.addAttribute("statType", "game");
		model.addAttribute("stats", stats);
		model.addAttribute("title", "Wins with 5+ Turnovers");
		return "stats";
    }
    
    @GetMapping(value = "/winswithmorepointsthanyardsallowed")
    public String showWinsWithMorePointsThanYardsAllowed(Model model) throws IOException {
		String stats = nats.getWinsWithMorePointsThanYardsAllowed();
		model.addAttribute("statType", "game");
		model.addAttribute("stats", stats);
		model.addAttribute("title", "Games where winner has more points than yards allowed");
		return "stats";
    }
    
    @GetMapping(value = "/fcsbeatsrankedfbs")
    public String showWFcsBeatsRankedFbs(Model model) throws IOException {
		String stats = nats.getFcsBeatsRankedFbs();
		model.addAttribute("statType", "game");
		model.addAttribute("stats", stats);
		model.addAttribute("title", "FCS wins over ranked FBS");
		return "stats";
    }
    
    @GetMapping(value = "/bowlrecordhistory")
    public String showBowlRecordHistory(Model model) throws IOException {
		String stats = nats.getRecordBowls();
		model.addAttribute("stats", stats);
		model.addAttribute("title", "Bowl Win/Loss Records");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/recordvsranked")
    public String showWinLossVsRanked(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getRecordVsRanked(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Record vs Ranked Teams (Based on rankings at game time)");
		return "stats";
    }
    
    @GetMapping(value = "/year/{year}/team/sos")
    public String showSos(@PathVariable String year, Model model) throws IOException {
		String stats = nats.getSos(year);
		model.addAttribute("stats", stats);
		model.addAttribute("title", year + " - " + "Strength of Schedule (SOS)");
		return "stats";
    }
    
    @GetMapping(value = "/team/recordalltime")
    public String showRecordAllTime(String year, Model model) throws IOException {
		String stats = nats.getRecordAllTime();
		model.addAttribute("stats", stats);
		model.addAttribute("title", "All Time (since 2001) Record");
		return "stats";
    }
    
    @GetMapping(value = "/scorigami")
    public String showScorigami(Model model) throws IOException {
		String stats = nats.getScorigami();
		model.addAttribute("statType", "game");
		model.addAttribute("stats", stats);
		model.addAttribute("title", "Scorigami (unique scores) since 2000");
		return "stats";
    }
    
    @GetMapping(value = "/games/byscore/winner/{winner}/loser/{loser}")
    public String showScorigamiGamesByScores(@PathVariable String winner, @PathVariable String loser, Model model) throws IOException {
		String stats = nats.getScorigamiByScore(winner, loser);
		model.addAttribute("statType", "game");
		model.addAttribute("stats", stats);
		model.addAttribute("title", "Games Since 2001 - Winner Score=" + winner + " Loser Score=" + loser);
		return "stats";
    }
    
    @GetMapping(value = "/scorigami/table")
    public String showScorigamiTable(Model model) throws IOException {
		String stats = nats.getScorigamiTable();
		String maxWinnerScore = nats.getScorigamiMaxWinnerScore();
		String maxLoserScore = nats.getScorigamiMaxLoserScore();
		
//		String mostCommonScores = nats.getScorigamiMostCommon();
//		String leastCommonScores = nats.getScorigamiLeastCommon();
		
		model.addAttribute("stats", stats);
		model.addAttribute("maxWinnerScore", maxWinnerScore);
		model.addAttribute("maxLoserScore", maxLoserScore);
		
//		model.addAttribute("mostCommonScores", mostCommonScores);
//		model.addAttribute("leastCommonScores", leastCommonScores);
		
		model.addAttribute("title", "Scorigami Table since 2001");
		return "scorigami_table";
    }
    
    @GetMapping(value = "/upsets")
    public String showUpsets(Model model) throws IOException {
    	String stats = nats.getUpsets();
    	model.addAttribute("stats", stats);
    	model.addAttribute("title", "Upsets");
    	return "stats";
    }

}
