AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/seriousspeed.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Speed and ply.SSPowerups.Speed > CurTime()
end

function ENT:Pickup(ent)
    local duration = CurTime() + self.PDuration
    ent.SSPowerups.Speed = duration	
	GAMEMODE:UpdatePlayerSpeed(ent)
	timer.Create("SeriousSpeedTime"..ent:EntIndex(), self.PDuration, 1, function()
		if IsValid(ent) and ent.SSPowerups then
			ent.SSPowerups.Speed = nil
			GAMEMODE:UpdatePlayerSpeed(ent)
		end
	end)
end