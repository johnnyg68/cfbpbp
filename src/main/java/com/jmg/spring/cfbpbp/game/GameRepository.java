package com.jmg.spring.cfbpbp.game;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jmg.spring.cfbpbp.sql.SqlFileReader; 

@Repository
public class GameRepository {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private NamedParameterJdbcTemplate namedJdbcTemplate;
	
	ColumnMapRowMapper mapper = new ColumnMapRowMapper(); 
	ObjectMapper om = new ObjectMapper(); 
//	om.registerModule(new JavaTimeModule());    
//	om.ObjectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
	
	
	List<Map<String, Object>> result;
	MapSqlParameterSource sqlParams = new MapSqlParameterSource(); 
	
	// Get Home and Away Team IDs for a game completed or not
	// This method should return a Map with only one row
	public Map<String, Object> getTeamIds(String gameId) throws DataAccessException, IOException {
		String sqlFile = "game/game_schedule_teamids.sql";
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		return jdbcTemplate.queryForMap(sql, gameId);
	}
	
	public String getScheduleYearWeekMap() throws IOException { 
		String sqlFile = "game/games_weeks_map.sql";
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper);
		String json = om.writeValueAsString(result);
		return json;
	}

	public String getGamesSchedule(String year, String week) throws IOException {
		String sqlFile = "game/games_schedule.sql";
		sqlParams.addValue("year", year).addValue("week", week);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}	
	
	public String getConferences() throws IOException {
		String sqlFile = "game/conferences.sql";
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper);
		String json = om.writeValueAsString(result);
		return json;
	}
	
	public String getMaxYear(String json) throws IOException {
		JsonNode schedule = om.readTree(json);
		return schedule.at("/0/Year").asText();
	}
	
	public String getMaxWeek(String json, String year) throws IOException {
		JsonNode schedule = om.readTree(json);
		String week = "";

		for(JsonNode node : schedule) {
			if(node.at("/Year").asText().equals(year)) {
				week = node.at("/Week").asText();
			} else {
				break;
			}			
		}
		return week;
	}

	public String getGameBoxscore(String gameId) throws IOException {
		String sqlFile = "game/game_boxscore.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}		

	public String getScoringPlays(String gameId) throws IOException {
		String sqlFile = "game/game_scoring_plays.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}
	
	public String getPlaySummary(String gameId) throws IOException {
		String sqlFile = "game/game_play_summary.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}
	
	public String getAllPlays(String gameId) throws IOException {
		String sqlFile = "game/game_all_plays.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}
	
	public String getDrivesAndPlays(String gameId) throws IOException {
		String sqlFile = "game/game_drives_and_plays.sql";
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("gameid", gameId);
		String json = resultAsJson(paramMap, sqlFile);
		return json;
	}
	
	public String getGameOdds(String gameId) throws IOException {
		String sqlFile = "game/game_odds.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}

	public String getGameBoxscoreHeader(String gameId) throws IOException {
		String sqlFile = "game/game_boxscore_header.sql";
		String json = resultAsJson(gameId, sqlFile);
		return json;
	}
	
	// Game Preview Header
	public String getGamePreviewHeader(String year, String gameId) throws IOException {
		String sqlFile = "game/game_preview_header.sql";
		sqlParams.addValue("year", year).addValue("gameid", gameId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}
	
	// SP+ Rankings
	public String getSpRankings(String year, String awayTeamId, String homeTeamId) throws IOException {
		String sqlFile = "game/game_preview_sprankings.sql";
		sqlParams.addValue("year", year).addValue("awayteamid", awayTeamId).addValue("hometeamid", homeTeamId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}

	// Offense
	public String getTeamOffense(String year, String teamId) throws IOException {
		String sqlFile = "game/game_preview_offense.sql";
		sqlParams.addValue("year", year).addValue("teamid", teamId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}
	
	// Defense
	public String getTeamDefense(String year, String teamId) throws IOException {
		String sqlFile = "game/game_preview_defense.sql";
		sqlParams.addValue("year", year).addValue("teamid", teamId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}
	
	// Game Preview All Team Stats
	public String getGamePreviewTeamGameStats(String year, String teamId) throws IOException {
		String sqlFile = "game/game_preview_team_stats.sql";
		sqlParams.addValue("year", year).addValue("teamid", teamId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}
	
	// Game Preview Games History
	public String getGameHistory(String awayTeamId, String homeTeamId) throws IOException {
		String sqlFile = "game/game_preview_game_history.sql";
		sqlParams.addValue("awayteamid", awayTeamId).addValue("hometeamid", homeTeamId);
		String json = resultAsJson(sqlParams, sqlFile);
		return json;
	}
	
	//Overloaded resultAsJson() methods for different use cases
	private String resultAsJson(MapSqlParameterSource sqlParams, String sqlFile) throws IOException  {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = namedJdbcTemplate.queryForList(sql, sqlParams);  	
		String json = om.writeValueAsString(result);
		return json;
	}
	
	private String resultAsJson(String gameId, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper, gameId);                
		String json = om.writeValueAsString(result);
		return json;
	}
	
	public String resultAsJson(Map<String, String> paramMap, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = namedJdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		return json;
	}



}
