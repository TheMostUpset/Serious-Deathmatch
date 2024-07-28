AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function GM:Initialize()
	RunConsoleCommand("ss_sv_dmrules", "1")
	RunConsoleCommand("sv_airaccelerate", "5")
end
	
function GM:SDMShowTeam( ply )

	if ( !GAMEMODE.TeamBased ) then return end

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 0.5
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return
	end

	-- For clientside see cl_pickteam.lua
	ply:SendLua( "GAMEMODE:SDMShowTeam()" )

end

function GM:PlayerInitialSpawn(ply)
	ply:AllowFlashlight(false)
	self:UpdatePlayerSpeed(ply)
	ply:SetModel("models/pechenko_121/samclassic.mdl")
	if player.GetCount() >=  GetConVarNumber("sdm_minplayers") and self:GetState() == STATE_GAME_WARMUP then
		self:GamePrepare()
	end
	ply:SetTeam(0)
	RunConsoleCommand("sdm_changeteam")
end

