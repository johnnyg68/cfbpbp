package com.jmg.spring.cfbpbp.ranking;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jmg.spring.cfbpbp.sql.SqlFileReader;

@Repository
public class RankingRepository {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private NamedParameterJdbcTemplate namedJdbcTemplate;
	
	Map<String, String> paramMap = new HashMap<>();
	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
	ObjectMapper om = new ObjectMapper();
	List<Map<String, Object>> result;
	
	public String geRankingByYearWeek(String year, String week) throws IOException {
		String sqlFile = "ranking/rankings_year_week.sql";		
		return resultAsJson(sqlFile, year, week);
	}
	
	public String getYearMaxWeek(String year) throws IOException {
		String sqlFile = "ranking/rankings_year_max_week.sql";		
		return resultAsJson(sqlFile);
	} 
	
	//generic map results
	private String resultAsJson(String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		result = jdbcTemplate.query(sql, mapper);
		return om.writeValueAsString(result);
	}
	
	private String resultAsJson(String sqlFile, String year, String week) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		
		paramMap.put("year", year);
		paramMap.put("week", week);

		result = namedJdbcTemplate.queryForList(sql, paramMap);  		
		return om.writeValueAsString(result);
		
	}
}
