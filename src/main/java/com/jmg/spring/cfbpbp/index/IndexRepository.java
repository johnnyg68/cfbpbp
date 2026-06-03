package com.jmg.spring.cfbpbp.index;

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
public class IndexRepository {
	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;
	
	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
	List<Map<String, Object>> result;
	ObjectMapper om = new ObjectMapper();

	String getTeamsBySpRanking(String year) throws IOException {
		String sqlFile = "national/national_ranking_sp_lite.sql";
		return resultAsJson(year, sqlFile);
	}
	
	private String resultAsJson(String year, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("year", year);
		result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}
}
