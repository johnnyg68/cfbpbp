
function getTableHeader(row, columnsToExclude, sortColumns) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; }
	
	var html = "<tr>";
	for(col in row) {
		if(!columnsToExclude.includes(col)) {
			html += "<th>" + col + "</th>";
		}
	}
	html += "</tr>";	
	return html;
}

function getDivHeader(row, columnsToExclude, sortColumns) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; }
	
	var html = "<div class='divTableRow'>";
	for(col in row) {
		if(!columnsToExclude.includes(col)) {
			html += "<div class='divTableCell'>" + col + "</div>";
		}
	}
	html += "</div>";	
	return html;
}

function getTableHeaderScoringPlays(row, home, visitor) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; } 
	 
	var html = "<tr>";
	for(col in row) {
		value = col;
		
		if(col == "Home") {
			value = home;
		}
		
		if(col == "Visitor") {
			value = visitor;
		}
		
		html += "<th>" + value + "</th>";
	}
	html += "</tr>";	
	return html;
}


function getTableHeaderSortable(row, columnsToExclude) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; }
	
	//var html = "<tr>";  added thead tag
	var html = "<thead><tr>";
	for(col in row) {
		if(!columnsToExclude.includes(col)) {
			var link = `<a href="#sortBy=${col}" id="${col}">${col}</a>`;
			html += "<th>" + link + "</th>";
		}
	}
	//html += "</tr>";	
	html += "</tr></thead>";	
	return html;
}

//used in team_history.html
//requires a full table structure in the html including thead and tbody tags
function getTableHeaderSortableExt(row, columnsToExclude) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; }
	
	var html = "<tr>";
	for(col in row) {
		if(!columnsToExclude.includes(col)) {
			html += `<th>${col}</th>`;
		}
	}
	html += "</tr>";	
	return html;
}

function getTableRow(row, columnsToExclude, linkColumns, rowNum) {
	if (typeof columnsToExclude === 'undefined' || columnsToExclude == "") { columnsToExclude = []; }
	if (typeof linkColumns === 'undefined' || linkColumns == "") { linkColumns = []; }
	
	var html = "<tr>";
	for(var col in row) {
		if(!columnsToExclude.includes(col)) {
			if(col in linkColumns) {
				html += "<td>" + linkColumns[col] + "</td>";
			} else {
				if(col == "#" && rowNum !== undefined) {
					html += "<td>" + rowNum + "</td>";
				}
				else {
					html += "<td>" + row[col] + "</td>";
				}
			}
		}
	}
	html += "</tr>";
	return html;
}

function isValidData(data) {
	var result = 0;
	if(data === null) {return result;}	
	if(data === undefined || data.length == 0) {return result;}	
	if(data == "[]") {return result;}
	
	return 1;
}

// used by team.html only.  NOT used by boxcore.html
function setTeamPlayerStatTable(stats, teamName, heading, divName) {
	var noData = "<h3>" + teamName + " " + heading + "</h3>";
	noData += "<p>No data available</p>";

	if(isValidData(stats) == 0) {
		document.getElementById(divName).innerHTML = noData;
		return;
	}

	var json = JSON.parse(stats);
	
	var html = "<h3>" + teamName + " " + heading + "</h3>";
	html += "<table>";
	
	//add header
	var columnsToExclude = ["PlayerId", "teamid", "TeamId"];
	html += getTableHeader(json[0], columnsToExclude);
	
	//add rows
	for(i=0; i<json.length; i++) {
		var linkColumns = {Name : "<a href='/players/player/" + json[i].PlayerId + "'>" + json[i].Name + "</a>" };
		html += getTableRow(json[i], columnsToExclude, linkColumns);
	}
	html += "</table>";	
	
	document.getElementById(divName).innerHTML = html;	
}