package com.jmg.spring.cfbpbp.team;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jmg.spring.cfbpbp.recruiting.RecruitingRepository;

@Controller
@RequestMapping("/teams")
public class TeamController {
	private final TeamRepository teams;
	private RecruitingRepository recs;

	public TeamController(TeamRepository teams, RecruitingRepository recs) {
		this.teams = teams;
		this.recs = recs;
	}

	@GetMapping("")
	public String showTeamsConference(Model model) throws IOException {
		String dataJson = teams.getTeamsConference();
		model.addAttribute("dataJson", dataJson);

		return "teams";
	}

	@GetMapping("/team/{teamId}/year/{year}")
	public String showTeam(@PathVariable String teamId, @PathVariable String year, Model model) throws IOException {
		// long startTime = System.nanoTime();

		// *************************
		// TEAM data
		// *************************
		String teamYearRecord = teams.getTeamYearRecord(teamId, year);
		model.addAttribute("teamYearRecord", teamYearRecord);

		String scheduleResults = teams.getTeamGameResults(teamId, year);
		model.addAttribute("scheduleResults", scheduleResults);

		String teamScoring = teams.getTeamScoring(teamId, year);
		model.addAttribute("teamScoring", teamScoring);

		String teamYards = teams.getTeamYards(teamId, year);
		model.addAttribute("teamYards", teamYards);

		/*
		 * String teamDownSuccessRate = teams.getTeamDownSuccessRate(teamId, year);
		 * model.addAttribute("teamDownSuccessRate", teamDownSuccessRate);
		 */
		String teamDownSuccessRate = teams.getTeamDownSuccessRateAggregate(teamId, year);
		model.addAttribute("teamDownSuccessRate", teamDownSuccessRate);

		String teamPassing = teams.getTeamPassing(teamId, year);
		model.addAttribute("teamPassing", teamPassing);

		String teamRushing = teams.getTeamRushing(teamId, year);
		model.addAttribute("teamRushing", teamRushing);

		String team3rdDowns = teams.getTeam3rdDowns(teamId, year); // this fails
		model.addAttribute("team3rdDowns", team3rdDowns);

		String teamTurnoverMargin = teams.getTeamTurnoverMargin(teamId, year); // this works
		model.addAttribute("teamTurnoverMargin", teamTurnoverMargin);

		// String teamOpponentRecord = teams.getTeamOpponentRecord(teamId, year);
		// model.addAttribute("teamOpponentRecord", teamOpponentRecord);

		String teamSos = teams.getTeamSos(teamId, year);
		model.addAttribute("teamSos", teamSos);

		// *************************
		// PLAYER data for a year
		// *************************
		String playerPassing = teams.getTeamPlayerPassing(teamId, year);
		model.addAttribute("playerPassing", playerPassing);

		String playerRushing = teams.getTeamPlayerRushing(teamId, year);
		model.addAttribute("playerRushing", playerRushing);

		String playerReceiving = teams.getTeamPlayerReceiving(teamId, year);
		model.addAttribute("playerReceiving", playerReceiving);

		String playerDefense = teams.getTeamPlayerDefense(teamId, year);
		model.addAttribute("playerDefense", playerDefense);

		String playerInts = teams.getTeamPlayerInts(teamId, year);
		model.addAttribute("playerInts", playerInts);

		String playerKickReturns = teams.getTeamPlayerKickReturns(teamId, year);
		model.addAttribute("playerKickReturns", playerKickReturns);

		String playerPuntReturns = teams.getTeamPlayerPuntReturns(teamId, year);
		model.addAttribute("playerPuntReturns", playerPuntReturns);

		String playerKicking = teams.getTeamPlayerKicking(teamId, year);
		model.addAttribute("playerKicking", playerKicking);

		String playerPunting = teams.getTeamPlayerPunting(teamId, year);
		model.addAttribute("playerPunting", playerPunting);

		// System.out.println("Boxscore elapsed time=" + ((System.nanoTime() -
		// startTime)) / 1000000);

		return "team";
	}

	// *************************
	// TEAM HISTORY data
	// *************************
	@GetMapping("/team/{teamId}/history")
	public String showTeamHistory(@PathVariable String teamId, Model model) throws IOException {

		String metadata = teams.getTeamMetaData(teamId);
		model.addAttribute("metadata", metadata);

		String rankings = teams.getTeamRankings(teamId);
		model.addAttribute("rankings", rankings);

		String bowls = teams.getTeamBowls(teamId);
		model.addAttribute("bowls", bowls);

		String bowlsRecord = teams.getTeamBowlsRecord(teamId);
		model.addAttribute("bowlsRecord", bowlsRecord);

		String vsOpponent = teams.getTeamRecordVsOpponent(teamId);
		model.addAttribute("vsOpponent", vsOpponent);

		String yearAvgOffense = teams.getTeamYearAvgOffense(teamId);
		model.addAttribute("yearAvgOffense", yearAvgOffense);

		String yearAvgDefense = teams.getTeamYearAvgDefense(teamId);
		model.addAttribute("yearAvgDefense", yearAvgDefense);

		// player data by year
		String playerPassing = teams.getTeamHistoryPlayerPassing(teamId);
		model.addAttribute("playerPassing", playerPassing);

		String playerRushing = teams.getTeamHistoryPlayerRushing(teamId);
		model.addAttribute("playerRushing", playerRushing);

		String playerReceiving = teams.getTeamHistoryPlayerReceiving(teamId);
		model.addAttribute("playerReceiving", playerReceiving);

		// player data over career
		String playerPassingCareer = teams.getTeamHistoryPlayerPassingCareer(teamId);
		model.addAttribute("playerPassingCareer", playerPassingCareer);

		String playerRushingCareer = teams.getTeamHistoryPlayerRushingCareer(teamId);
		model.addAttribute("playerRushingCareer", playerRushingCareer);

		String playerReceivingCareer = teams.getTeamHistoryPlayerReceivingCareer(teamId);
		model.addAttribute("playerReceivingCareer", playerReceivingCareer);

		// recruiting
		String teamRecruiting = recs.getRecruitingByTeam(teamId);
		model.addAttribute("teamRecruiting", teamRecruiting);

		String playerRecruiting = recs.getRecruitingPlayersForTeam(teamId);
		model.addAttribute("playerRecruiting", playerRecruiting);

		return "team_history";
	}
}
