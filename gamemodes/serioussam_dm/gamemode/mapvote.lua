MapVote = {}
MapVote.Config = {}

-- CONFIG (sort of)
    MapVote.Config = {
        MapLimit = 24,
        TimeLimit = 28,
        AllowCurrentMap = false,
    }
-- CONFIG

function MapVote.HasExtraVotePower(ply)
	-- Example that gives admins more voting power
	if ply:IsAdmin() then
		return true
	end

	return false
end


MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("cl_mapvote.lua")

    include("sv_mapvote.lua")
else
    include("cl_mapvote.lua")
end

/*MapVote.ChatCommands = {
	
	"!rtv",
	"/rtv",
	"rtv"

}*/