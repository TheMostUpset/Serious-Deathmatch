AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invulnerability.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Protect and ply.SSPowerups.Protect > CurTime()
end

function ENT:Pickup(ent)
	-- if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration

	ent.SSPowerups.Protect = duration
	-- if self.PDuration >= 3 then
		-- ent.SSPowerups.ProtectOut = duration - 3
	-- end
	
	self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasProtect", true )

	timer.Create("ProtectTime"..ent:EntIndex(), self.PDuration, 1, function()
		ent:SetNW2Bool( "HasProtect", false )
	end)
end

hook.Add("PlayerShouldTakeDamage", "SSPowerups_Protect", function(ply)
	if !PowerupActive(ply) then return end
	return false
end)

-- hook.Add("PlayerPostThink", "SSPowerups_Protect", function(ply)
    -- if !PowerupActive(ply) then return end
    
    -- if ply.SSPowerups.ProtectOut and ply.SSPowerups.ProtectOut <= CurTime() then
        -- ply.SSPowerups.ProtectOut = nil

    -- end    
    
    -- if ply.SSPowerups.Protect <= CurTime() then
        -- ply.SSPowerups.Protect = nil
    -- end
-- end)