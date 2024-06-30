AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/sdmg.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.SeriousDamage and ply.SSPowerups.SeriousDamage > CurTime()
end

function ENT:Pickup(ent)
    local duration = CurTime() + self.PDuration  
    ent.SSPowerups.SeriousDamage = duration
end

hook.Add("EntityTakeDamage", "SSPowerups_SeriousDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and PowerupActive(attacker) then
		dmginfo:ScaleDamage(2)
	end
end)
