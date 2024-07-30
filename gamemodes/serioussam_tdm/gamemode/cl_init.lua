include( "shared.lua" )
include( "cl_hud.lua" )
include("cl_menus.lua")



concommand.Add( "sdm_changeteam", function( ply, cmd, args )
	OpenTeamMenu()
end )