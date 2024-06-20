AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/seriousspeed.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Speed and ply.SSPowerups.Speed > CurTime()
end

function ENT:Pickup(ent)
    local duration = CurTime() + self.PDuration
	-- ent:SetNW2Float("PickupTime", duration)
    ent.SSPowerups.Speed = duration
    -- if self.PDuration >= 3 then
        -- ent.SSPowerups.SpeedOut = duration - 3		
    -- end
	
	GAMEMODE:UpdatePlayerSpeed(ent)

    self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	
	-- ent:SetNW2Bool( "HasSSpeed", true )

	timer.Create("SeriousSpeedTime"..ent:EntIndex(), self.PDuration, 1, function()
		if IsValid(ent) and ent.SSPowerups then
			-- ent:SetNW2Bool( "HasSSpeed", false )
			ent.SSPowerups.Speed = nil
			GAMEMODE:UpdatePlayerSpeed(ent)
		end
	end)

end

-- hook.Add("SetupMove", "SSPowerups_SeriousSpeed", function(ply, mv)
	-- if ply:Alive() and PowerupActive(ply) then
	-- end
-- end)
