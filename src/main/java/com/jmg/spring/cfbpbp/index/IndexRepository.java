package com.jmg.spring.cfbpbp.index;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jmg.spring.cfbpbp.sql.SqlFileReader;

@Repository
public class IndexRepository {
	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;
	ObjectMapper om = new ObjectMapper();

	String getTeamsBySpRanking() throws IOException {
		String sqlFile = "national/national_ranking_sp_lite.sql";
		// return resultAsJson(year, sqlFile);
		return resultAsJson(sqlFile);
	}
	
	private String resultAsJson(String year, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("year", year);
		List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}
	
	// use updated national/national_ranking_sp_lite.sql 
	// always returns the most recent year of SP+ rankings, i.e. no parameter for year is needed.
	private String resultAsJson(String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
	    List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, new MapSqlParameterSource());       
	    String json = om.writeValueAsString(result);
		
		return json;
	}
}
