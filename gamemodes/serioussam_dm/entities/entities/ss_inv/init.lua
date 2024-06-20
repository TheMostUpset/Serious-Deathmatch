AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invisibility.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Invisibility	
end

function ENT:Pickup(ent)
    local pos = self:GetPos()
    local duration = CurTime() + self.PDuration
	if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration

	ent.SSPowerups.Invisibility = duration
	-- if self.PDuration >= 3 then
		-- ent.SSPowerups.InvisibilityOut = duration - 3
	-- end
	
	self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasInvis", true )
	--ent:SetNoDraw(true) 
	--ent:GetActiveWeapon():SetNoDraw(true)

	timer.Simple(self.PDuration, function()
		ent:SetNW2Bool( "HasInvis", false )
	end)
end
