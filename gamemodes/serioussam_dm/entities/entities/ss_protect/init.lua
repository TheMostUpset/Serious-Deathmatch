AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invulnerability.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Protect and ply.SSPowerups.Protect > CurTime()
end

function ENT:Pickup(ent)
	local duration = CurTime() + self.PDuration
	ent.SSPowerups.Protect = duration
end

hook.Add("PlayerShouldTakeDamage", "SSPowerups_Protect", function(ply)
	if !PowerupActive(ply) then return end
	return false
end)