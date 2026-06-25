package com.jmg.spring.cfbpbp.team;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.jmg.spring.cfbpbp.sql.SqlFileReader;

@Repository
public class TeamRepository {

	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;

	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
	// List<Map<String, Object>> result;
	// ObjectMapper om = new ObjectMapper();
	// om.registerModule(new JavaTimeModule());

	ObjectMapper om = JsonMapper.builder().addModule(new JavaTimeModule()).build();
	MapSqlParameterSource sqlParams = new MapSqlParameterSource();

	boolean debug = false;

	// ALL TEAMS BY CONFERENCE

	// @Cacheable("TeamsByConference")
	public String getTeamsConference() throws IOException {
		String sqlFile = "team/team_conference.sql";
		return resultAsJson(sqlFile);
	}

	// TEAM METADATA

	public String getTeamMetaData(String teamId) throws IOException {
		String sqlFile = "team/team_metadata.sql";
		return resultAsJson(sqlFile, teamId);
	} 

	// PLAYER STATS

	public String getTeamPlayerPassing(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_passing.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerRushing(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_rushing.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerReceiving(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_receiving.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerDefense(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_defense.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerInts(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_ints.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerKickReturns(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_kickreturns.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerPuntReturns(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_puntreturns.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerKicking(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_kicking.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPlayerPunting(String teamId, String year) throws IOException {
		String sqlFile = "team/team_player_punting.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	// TEAM STATS

	public String getTeamGameResults(String teamId, String year) throws IOException {
		String sqlFile = "team/team_game_results.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamYearRecord(String teamId, String year) throws IOException {
		String sqlFile = "team/team_year_record.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamYearRank(String teamId, String year) throws IOException {
		String sqlFile = "team/team_year_ap_rank.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamScoring(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_scoring.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamYards(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_yards.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamDownSuccessRate(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_down_success_rate.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamDownSuccessRateAggregate(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_down_success_rate_aggregate.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamPassing(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_passing.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamRushing(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_rushing.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeam3rdDowns(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_3rd_downs.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamTurnoverMargin(String teamId, String year) throws IOException {
		String sqlFile = "team/team_total_turnover_margin.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	public String getTeamSos(String teamId, String year) throws IOException {
		String sqlFile = "team/team_year_sos.sql";
		return resultAsJson(sqlFile, teamId, year);
	}

	// TEAM HISTORY

	public String getTeamRankings(String teamId) throws IOException {
		String sqlFile = "team/team_history_rankings.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamBowls(String teamId) throws IOException {
		String sqlFile = "team/team_history_bowls.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamBowlsRecord(String teamId) throws IOException {
		String sqlFile = "team/team_history_bowls_record.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamRecordVsOpponent(String teamId) throws IOException {
		String sqlFile = "team/team_history_vs_opponent.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamYearAvgOffense(String teamId) throws IOException {
		String sqlFile = "team/team_history_offense_by_year.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamYearAvgDefense(String teamId) throws IOException {
		String sqlFile = "team/team_history_defense_by_year.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamHistoryPlayerPassing(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_passing.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamHistoryPlayerRushing(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_rushing.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamHistoryPlayerReceiving(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_receiving.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	// Player career stats, i.e. grouped by team, player over career
	public String getTeamHistoryPlayerPassingCareer(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_passing_career.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamHistoryPlayerRushingCareer(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_rushing_career.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	public String getTeamHistoryPlayerReceivingCareer(String teamId) throws IOException {
		String sqlFile = "team/team_history_player_receiving_career.sql";
		return resultAsJson(sqlFile, teamId, "");
	}

	// RETURN RESULTS AS JSON

	// generic map results
	private String resultAsJson(String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);

		long startTime = 0;
		if (debug) {
			startTime = System.currentTimeMillis();
		}

		List<Map<String, Object>> result = jdbcTemplate.query(sql, mapper);

		if (debug) {
			System.out.println(
					"sqlFile: " + sqlFile + " elapsed time=" + (System.currentTimeMillis() - startTime) + " ms");
		}
		return om.writeValueAsString(result);
	}

	// for Team History or team queries without year
	private String resultAsJson(String sqlFile, String teamId) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("teamid", teamId);

		long startTime = 0;
		if (debug) {
			startTime = System.currentTimeMillis();
		}

		List<Map<String, Object>> result = jdbcTemplate.query(sql, paramMap, mapper);

		if (debug) {
			System.out.println(
					"sqlFile: " + sqlFile + " elapsed time=" + (System.currentTimeMillis() - startTime) + " ms");
		}

		return om.writeValueAsString(result);
	}

	private String resultAsJson(String sqlFile, String teamId, String year) throws IOException, DataAccessException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		SqlParameterSource params = new MapSqlParameterSource().addValue("teamid", teamId).addValue("year", year);

		long startTime = 0;
		if (debug) {
			startTime = System.currentTimeMillis();
		}

		List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, params);

		if (debug) {
			System.out.println(
					"sqlFile: " + sqlFile + " elapsed time=" + (System.currentTimeMillis() - startTime) + " ms");
		}

		return om.writeValueAsString(result);
	}

}
