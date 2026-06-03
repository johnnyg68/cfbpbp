package com.jmg.spring.cfbpbp.game;

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
public class GamePlayerRepository {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
    ObjectMapper om = new ObjectMapper();    
	List<Map<String, Object>> result;

	public String getGamePlayerDefense(String gameId) throws IOException {
		String sqlFile = "game/game_player_defense.sql";
		return resultAsJson(gameId, sqlFile);
	}	

	public String getGamePlayerInts(String gameId) throws IOException {
		String sqlFile = "game/game_player_interceptions.sql"; 
		return resultAsJson(gameId, sqlFile);
	}
	
	public String getGamePlayerKickReturns(String gameId) throws IOException {
		String sqlFile = "game/game_player_kickreturns.sql";
		return resultAsJson(gameId, sqlFile);
	}
	
	public String getGamePlayerPassing(String gameId) throws IOException {
		String sqlFile = "game/game_player_passing_offense.sql";
		return resultAsJson(gameId, sqlFile);
	}	

	public String getGamePlayerReceiving(String gameId) throws IOException {
		String sqlFile = "game/game_player_receiving_offense.sql";
		return resultAsJson(gameId, sqlFile);
	}	

	public String getGamePlayerRushing(String gameId) throws IOException {
		String sqlFile = "game/game_player_rushing_offense.sql";
		return resultAsJson(gameId, sqlFile);
	}
	
	public String getGamePlayerPuntReturns(String gameId) throws IOException {
		String sqlFile = "game/game_player_puntreturns.sql";
		return resultAsJson(gameId, sqlFile);
	}

	public String getGamePlayerKicking(String gameId) throws IOException {
		String sqlFile = "game/game_player_kicking.sql";
		return resultAsJson(gameId, sqlFile);
	}

	public String getGamePlayerPunting(String gameId) throws IOException {
		String sqlFile = "game/game_player_punting.sql";
		return resultAsJson(gameId, sqlFile);
	}
	
	public String resultAsJson(String gameId, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper, gameId);    
		String json = om.writeValueAsString(result);
		return json;
	}
}
