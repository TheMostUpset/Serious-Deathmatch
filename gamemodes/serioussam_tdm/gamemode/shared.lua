
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




