package com.jmg.spring.cfbpbp.national;

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
public class NationalRepository {

	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;

	ColumnMapRowMapper mapper = new ColumnMapRowMapper();
    ObjectMapper om = new ObjectMapper(); 
	//List<Map<String, Object>> result;

	public String get3rdDownDefense(String year) throws IOException {
		String sqlFile = "national/national_3rd_down_defense.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String get3rdDownOffense(String year) throws IOException {
		String sqlFile = "national/national_3rd_down_offense.sql";
		return resultAsJson(year, sqlFile);
	}	
	
	public String getFirstDowns(String year) throws IOException {
		String sqlFile = "national/national_first_downs.sql";
		return resultAsJson(year, sqlFile);
	}	
	
	public String getPassDefense(String year) throws IOException {
		String sqlFile = "national/national_pass_defense.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getPassOffense(String year) throws IOException {
		String sqlFile = "national/national_pass_offense.sql";
		return resultAsJson(year, sqlFile);
	}	

	public String getPenalties(String year) throws IOException {
		String sqlFile = "national/national_penalties.sql";
		return resultAsJson(year, sqlFile);
	}

/*	public String getRedZoneDefense(String year) throws IOException {
		String sqlFile = "national/national_redzone_defense.sql";
		return resultAsJson(year, sqlFile);
	}*/

	public String getRedZoneOffense(String year) throws IOException {
		String sqlFile = "national/national_redzone_offense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getRushOffense(String year) throws IOException {
		String sqlFile = "national/national_rush_offense.sql";
		return resultAsJson(year, sqlFile);
	}	

	public String getRushDefense(String year) throws IOException {
		String sqlFile = "national/national_rush_defense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getScoringDefense(String year) throws IOException {
		String sqlFile = "national/national_scoring_defense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getScoringOffense(String year) throws IOException {
		String sqlFile = "national/national_scoring_offense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getTflAllowed(String year) throws IOException {
		String sqlFile = "national/national_tfl_allowed.sql";
		return resultAsJson(year, sqlFile);
	}	

	public String getTfl(String year) throws IOException  {
		String sqlFile = "national/national_tfl.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getTotalDefense(String year) throws IOException  {
		String sqlFile = "national/national_total_defense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getTotalOffense(String year) throws IOException  {
		String sqlFile = "national/national_total_offense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getTurnoverMargin(String year) throws IOException  {
		String sqlFile = "national/national_turnover_margin.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getPuntReturnOffense(String year) throws IOException {
		String sqlFile = "national/national_puntreturn_offense.sql";
		return resultAsJson(year, sqlFile);
	}	

	public String getPuntReturnDefense(String year) throws IOException {
		String sqlFile = "national/national_puntreturn_defense.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getKickReturnOffense(String year) throws IOException {
		String sqlFile = "national/national_kickreturn_offense.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getKickReturnDefense(String year) throws IOException {
		String sqlFile = "national/national_kickreturn_defense.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getApRanking(String year) throws IOException {
		String sqlFile = "national/national_ranking_ap.sql";
		return resultAsJson(year, sqlFile);
	}	
	
	public String getSpRanking(String year) throws IOException {
		String sqlFile = "national/national_ranking_sp.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getMovRanking(String year) throws IOException {
		String sqlFile = "national/national_ranking_mov.sql";		
		return resultAsJson(year, sqlFile);
	}

	public String getOffensePlaySuccess(String year) throws IOException {
		// String sqlFile = "national/national_offense_play_efficiency.sql";
		String sqlFile = "national/national_offense_play_efficiency_aggregate.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getOffensePointsPerPlay(String year) throws IOException {
		String sqlFile = "national/national_offense_points_per_play.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getOffenseDriveEfficiency(String year) throws IOException {
		String sqlFile = "national/national_offense_drive_efficiency.sql";
		return resultAsJson(year, sqlFile);
	}	

	public String getOffensePlayExplosiveness(String year) throws IOException {
		String sqlFile = "national/national_offense_play_explosiveness.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getDefensePlayExplosiveness(String year) throws IOException {
		String sqlFile = "national/national_defense_play_explosiveness.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getDefensePlaySuccess(String year) throws IOException {
		//String sqlFile = "national/national_defense_play_efficiency.sql";
		String sqlFile = "national/national_defense_play_efficiency_aggregate.sql";
		return resultAsJson(year, sqlFile);
	}	
	
	public String getDefensePointsPerPlay(String year) throws IOException {
		String sqlFile = "national/national_defense_points_per_play.sql";
		return resultAsJson(year, sqlFile);
	}
	
	public String getDefenseDriveEfficiency(String year) throws IOException {
		String sqlFile = "national/national_defense_drive_efficiency.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getRecordVsRanked(String year) throws IOException {
		String sqlFile = "national/national_record_vs_ranked.sql";
		return resultAsJson(year, sqlFile);
	}	
	
	public String getSos(String year) throws IOException {
		String sqlFile = "national/national_sos.sql";
		return resultAsJson(year, sqlFile);
	}

	public String getRecordAllTime() throws IOException {
		String sqlFile = "national/national_record_all_time.sql";
		return resultAsJson(sqlFile);
	}

	public String getWinsWith5Turnovers() throws IOException {
		String sqlFile = "game/games_winner_has5turnovers.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getWinsWithMorePointsThanYardsAllowed() throws IOException {
		String sqlFile = "game/games_winner_points_more_than_yards_allowed.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getFcsBeatsRankedFbs() throws IOException {
		String sqlFile = "game/games_winner_fcs_vs_ranked_fbs.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getRecordBowls() throws IOException {
		String sqlFile = "national/national_record_bowls.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getScorigami() throws IOException {
		String sqlFile = "game/games_scorigami.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getScorigamiTable() throws IOException {
		String sqlFile = "game/games_scorigami_table.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getScorigamiMaxWinnerScore() throws IOException {
		String sqlFile = "game/games_scorigami_max_winner_score.sql";
		return resultAsJson(sqlFile); 
	}
	
	public String getScorigamiMaxLoserScore() throws IOException {
		String sqlFile = "game/games_scorigami_max_loser_score.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getScorigamiByScore(String winner, String loser) throws IOException {
		String sqlFile = "game/games_by_score.sql";
		return resultAsJson(winner, loser, sqlFile);
	}
	
	public String getScorigamiMostCommon() throws IOException { 
		String sqlFile = "game/games_scorigami_most_common.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getScorigamiLeastCommon() throws IOException {
		String sqlFile = "game/games_scorigami_least_common.sql";
		return resultAsJson(sqlFile);
	}
	
	public String getUpsets() throws IOException {
		String sqlFile = "game/games_upsets.sql";
		return resultAsJson(sqlFile);
	}
	
	private String resultAsJson(String winner, String loser, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("winner", winner);
		paramMap.put("loser", loser);
		List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, paramMap);                
		String json = om.writeValueAsString(result);
		
		return json;
	}
	
	public String resultAsJson(String year, String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("year", year);
		List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}

	public String resultAsJson(String sqlFile) throws IOException {
		String sql = SqlFileReader.getSqlFromFile(sqlFile);
		Map<String,String> paramMap = new HashMap<>();
		paramMap.put("year", "");
		List<Map<String, Object>> result = jdbcTemplate.queryForList(sql, paramMap);       
		String json = om.writeValueAsString(result);
		
		return json;
	}

}
