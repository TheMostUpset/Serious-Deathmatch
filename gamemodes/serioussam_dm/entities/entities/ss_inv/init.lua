AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invisibility.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Invisibility and ply.SSPowerups.Invisibility > CurTime()
end

function ENT:Pickup(ent)
	-- if PowerupActive(ent) then return end
	
	local duration = CurTime() + self.PDuration

	ent.SSPowerups.Invisibility = duration
	-- if self.PDuration >= 3 then
		-- ent.SSPowerups.InvisibilityOut = duration - 3
	-- end
	
	self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	-- ent:SetNW2Bool( "HasInvis", true )
	--ent:SetNoDraw(true) 
	--ent:GetActiveWeapon():SetNoDraw(true)

	-- timer.Create("InvisTime"..ent:EntIndex(), self.PDuration, 1, function()
		-- ent:SetNW2Bool( "HasInvis", false )
	-- end)
end

-- hook.Add("PlayerPostThink", "SSPowerups_Invisibility", function(ply)
    -- if !PowerupActive(ply) then return end
    
    -- if ply.SSPowerups.InvisibilityOut and ply.SSPowerups.InvisibilityOut <= CurTime() then
        -- ply.SSPowerups.InvisibilityOut = nil
        -- if ply.inv3 then ply.inv3:Stop() end
    -- end    
    
    -- if ply.SSPowerups.Invisibility <= CurTime() then
        -- ply.SSPowerups.Invisibility = nil
        --ply:SetNoDraw(false)

    -- end
-- end)