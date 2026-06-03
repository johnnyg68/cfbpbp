package com.jmg.spring.cfbpbp.player;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jmg.spring.cfbpbp.sql.SqlFileReader;

@Repository
public class PlayerRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
	ObjectMapper om = new ObjectMapper();
	List<Map<String, Object>> result;
	
	// Generic SQL driven player stat categories for a given year	
	public String getPlayerStats(String year, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper, year);
		String json = om.writeValueAsString(result);
		return json;
	}
	
	// Career Stats grouped by year
	public String getPlayerCareerPassing(String playerId) throws IOException {
		String sqlFile = "player/player_career_passing.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerRushing(String playerId) throws IOException {
		String sqlFile = "player/player_career_rushing.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerReceiving(String playerId) throws IOException {
		String sqlFile = "player/player_career_receiving.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerDefense(String playerId) throws IOException {
		String sqlFile = "player/player_career_defense.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerPunting(String playerId) throws IOException {
		String sqlFile = "player/player_career_punting.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerKicking(String playerId) throws IOException{
		String sqlFile = "player/player_career_kicking.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerPuntReturns(String playerId) throws IOException {
		String sqlFile = "player/player_career_puntreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerKickReturns(String playerId) throws IOException {
		String sqlFile = "player/player_career_kickreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	// Career Game Stats - Game Log
	public String getPlayerGamesPassing(String playerId) throws IOException {
		String sqlFile = "player/player_games_passing.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesRushing(String playerId) throws IOException {
		String sqlFile = "player/player_games_rushing.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesReceiving(String playerId) throws IOException {
		String sqlFile = "player/player_games_receiving.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesDefense(String playerId) throws IOException {
		String sqlFile = "player/player_games_defense.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesKickReturns(String playerId) throws IOException {
		String sqlFile = "player/player_games_kickreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesPuntReturns(String playerId) throws IOException {
		String sqlFile = "player/player_games_puntreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesPunting(String playerId) throws IOException {
		String sqlFile = "player/player_games_punting.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerGamesKicking(String playerId) throws IOException {
		String sqlFile = "player/player_games_kicking.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
// Career totals - aggregated over all years, i.e. not by year but all time stats
	public String getPlayerCareerTotalPassing(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_passing.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerCareerTotalRushing(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_rushing.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerCareerTotalReceiving(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_receiving.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerCareerTotalDefense(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_defense.sql";
		return resultAsJson(sqlFile, playerId);
	}
	
	public String getPlayerCareerTotalKickReturns(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_kickreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerTotalPuntReturns(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_puntreturns.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerTotalPunting(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_punting.sql";
		return resultAsJson(sqlFile, playerId);
	}

	public String getPlayerCareerTotalKicking(String playerId) throws IOException {
		String sqlFile = "player/player_career_total_kicking.sql";
		return resultAsJson(sqlFile, playerId);
	}
// UTILITY	
	private String resultAsJson(String sqlFile, String playerId) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper, playerId);                
		String json = om.writeValueAsString(result);
		return json;

	}

}
