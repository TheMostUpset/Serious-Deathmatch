AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/sdmg.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.QuadDamage	and ply.SSPowerups.QuadDamage > CurTime()
end

function ENT:Pickup(ent)
    local duration = CurTime() + self.PDuration
  
    ent.SSPowerups.QuadDamage = duration
    -- if self.PDuration >= 3 then
        -- ent.SSPowerups.QuadDamageOut = duration - 3		
    -- end

    self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
    self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasSDMG", true )

	timer.Create("SeriousDamageTime"..ent:EntIndex(), self.PDuration, 1, function()
		ent:SetNW2Bool( "HasSDMG", false )
	end)

end

hook.Add("EntityTakeDamage", "SSPowerups_QuadDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and PowerupActive(attacker) then
		dmginfo:ScaleDamage(2)
	end
end)
