AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invulnerability.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Protect	
end

function ENT:Pickup(ent)
    local pos = self:GetPos()
    local duration = CurTime() + self.PDuration
	if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration

	ent.SSPowerups.Protect = duration
	-- if self.PDuration >= 3 then
		-- ent.SSPowerups.ProtectOut = duration - 3
	-- end
	
	self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasProtect", true )

	timer.Simple(self.PDuration, function()
		ent:SetNW2Bool( "HasProtect", false )
	end)
end

hook.Add("PlayerShouldTakeDamage", "SSPowerups_Protect", function(ply)
	if !PowerupActive(ply) then return end
	return false
end)
