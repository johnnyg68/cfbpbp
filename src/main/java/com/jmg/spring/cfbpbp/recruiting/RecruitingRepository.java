package com.jmg.spring.cfbpbp.recruiting;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jmg.spring.cfbpbp.sql.SqlFileReader;

@Repository
public class RecruitingRepository {
	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;
	
	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
	ObjectMapper om = new ObjectMapper();
	List<Map<String, Object>> result;

	public String getRecruitingByYear(String year) throws IOException {
		String sqlFile = "recruiting/recruiting_by_year.sql";
		String json = resultAsJson("year", year, sqlFile);
		return json;
	}
	
	public String getRecruitingByTeam(String teamId) throws IOException {
		String sqlFile = "recruiting/recruiting_by_team.sql";
		String json = resultAsJson("teamid", teamId, sqlFile);
		return json;
	}
	
	public String getTeamsList() throws IOException {
		String sqlFile = "team/teams_unique_by_name.sql";
		String json = resultAsJson(sqlFile);
		return json;
	}

	public String getRecruitingPlayersForTeam(String teamId) throws IOException {
		String sqlFile = "recruiting/recruiting_players_team_by_year.sql";
		String json = resultAsJson("committedtoteamid", teamId, sqlFile);
		return json;
	}

	private String resultAsJson(String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper);
		return om.writeValueAsString(result);
	}
	
	public String resultAsJson(String year, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("year", year);
		result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}
	
	public String resultAsJson(String key, String keyValue, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put(key, keyValue);
		result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}
	
}



