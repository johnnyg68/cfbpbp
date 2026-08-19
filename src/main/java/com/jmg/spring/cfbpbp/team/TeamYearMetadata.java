package com.jmg.spring.cfbpbp.team;

// Holds the values produced by a single execution of team_year_record.sql:
// the full result serialized as JSON for the browser payload, plus the
// individual scalar values used for the page's <title>, <meta>, and JSON-LD.
public class TeamYearMetadata {
	private final String json;
	private final String name;
	private final String mascot;
	private final String year;

	public TeamYearMetadata(String json, String name, String mascot, String year) {
		this.json = json;
		this.name = name;
		this.mascot = mascot;
		this.year = year;
	}

	public String getJson() {
		return json;
	}

	public String getName() {
		return name;
	}

	public String getMascot() {
		return mascot;
	}

	public String getYear() {
		return year;
	}
}
