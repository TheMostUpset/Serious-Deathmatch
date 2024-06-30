AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invisibility.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Invisibility and ply.SSPowerups.Invisibility > CurTime()
end

function ENT:Pickup(ent)
	local duration = CurTime() + self.PDuration
	ent.SSPowerups.Invisibility = duration
end