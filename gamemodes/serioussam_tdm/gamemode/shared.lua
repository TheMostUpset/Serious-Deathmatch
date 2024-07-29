
GM.Name = "Serious Team Deathmatch"
GM.Author = "wico."
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

DeriveGamemode( "serioussam_dm" )


team.SetUp(1, "Red Team", Color(255,50,20), true)
team.SetUp(2, "Blue Team", Color(50,155,255), true)

team.SetSpawnPoint(1, {"info_player_terrorist"})
team.SetSpawnPoint(2, {"info_player_counterterrorist"})



function GM:CreateTeams()
	TEAM_RED = 1
	team.SetUp(TEAM_RED, "Red Team", Color(255,50,20))
	team.SetSpawnPoint(TEAM_RED, "info_player_terrorist")
	
	TEAM_BLUE = 2
	team.SetUp(TEAM_BLUE, "Blue Team", Color(50,155,255))
	team.SetSpawnPoint(TEAM_BLUE, "info_player_counterterrorist")

	TEAM_SPECTATOR = 4
	team.SetUp(TEAM_SPECTATOR, "Spectator", Color(125, 125, 125, 255))
	team.SetSpawnPoint(TEAM_SPECTATOR, "info_player_start")
end

function GM:PlayerBindPress(ply, bind, pressed)
	if bind == "gm_showteam" then
		return true
	end
end