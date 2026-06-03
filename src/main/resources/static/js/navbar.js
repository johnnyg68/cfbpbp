
function gotoYearRankings(year) {
	var url;
	if(year == undefined || year == "") {
		url = "/stats/rankings";
	} else {
		url = "/stats/year/" + year + "/rankings";
	}
	window.location = url;
}

function gotoYearStats(year) {
	var url;
	if(year == undefined || year == "") {
		url = "/stats/index";   
	} else {
		url = "/stats/year/" + year + "/index";
	}
	window.location = url;
}

// http://localhost:8080/games/year/2016/week/bowl or /schedule
function gotoYearSchedule(year) {
	var url;
	if(year == undefined || year == "") {
		url = "/schedule";     
	} else {
		url = "/games/year/" + year + "/week/1";
	}
	window.location = url;
}

function gotoYearRecruiting(year) {
	var url;
	if(year == undefined || year == "") {
		url = "/recruiting/year/2024";     
	} else {
		url = "/recruiting/year/" + year ;
	}
	window.location = url;
}