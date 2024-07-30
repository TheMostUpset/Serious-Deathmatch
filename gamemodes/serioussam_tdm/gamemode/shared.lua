
GM.Name = "Serious Team Deathmatch"
GM.Author = "wico."
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

DeriveGamemode( "serioussam_dm" )



function GM:CreateTeams()
	TEAM_RED = 1
	team.SetUp(TEAM_RED, language.GetPhrase( "sdm_redteam" ), Color(255,50,20, 255))
	team.SetSpawnPoint(TEAM_RED, "info_player_terrorist")
	
	TEAM_BLUE = 2
	team.SetUp(TEAM_BLUE, language.GetPhrase( "sdm_blueteam" ), Color(50,155,255, 255))
	team.SetSpawnPoint(TEAM_BLUE, "info_player_counterterrorist")

	TEAM_SPECTATOR = 4
	team.SetUp(TEAM_SPECTATOR, language.GetPhrase( "sdm_specteam" ), Color(200, 200, 200, 255))
	team.SetSpawnPoint(TEAM_SPECTATOR, "info_player_start")
end

function GM:PlayerBindPress(ply, bind, pressed)
	if bind == "gm_showteam" then
		return true
	end
end