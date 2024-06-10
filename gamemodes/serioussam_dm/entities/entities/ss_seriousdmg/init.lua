AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/sdmg.mdl"




local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.QuadDamage
	
end

function ENT:Pickup(ent)
	local pos = self:GetPos()
    local duration = CurTime() + self.PDuration
  
    ent.SSPowerups.QuadDamage = duration
    if self.PDuration >= 3 then
        ent.SSPowerups.QuadDamageOut = duration - 3
		
    end

    self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
    self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasSDMG", true )
    self:Remove()
	timer.Simple(self.PDuration, function()
	ent:SetNW2Bool( "HasSDMG", false )
	end)
	
    timer.Simple(180, function()
    local ent = ents.Create("ss_seriousdmg")
    ent:SetPos(pos)
    ent:Spawn()
    end)


end

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
		if !ent.SSPowerups then
			ent.SSPowerups = {}
		end
		self:Pickup(ent)
		
	self:SendPickupMsg(ent, "Serious Damage")
	end

end


hook.Add("EntityTakeDamage", "SSPowerups_QuadDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsPlayer() and PowerupActive(attacker) then
		dmginfo:ScaleDamage(2)
	end
end)
