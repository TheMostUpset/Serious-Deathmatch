AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/sdmg.mdl"

local function PowerupActive(ply)
	return ply.SSPowerups and ply.SSPowerups.Speed and ply.SSPowerups.Speed > CurTime()
end

function ENT:Pickup(ent)
    local duration = CurTime() + self.PDuration
  
    ent.SSPowerups.Speed = duration
    -- if self.PDuration >= 3 then
        -- ent.SSPowerups.SpeedOut = duration - 3		
    -- end
	
	ent:SetWalkSpeed(PLAYER_WALKSPEED * 2)
	-- ent:SetJumpPower(PLAYER_RUNSPEED)
	ent:SetRunSpeed(PLAYER_RUNSPEED * 2)

    self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
	
    self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasSSpeed", true )

	timer.Create("SeriousSpeedTime"..ent:EntIndex(), self.PDuration, 1, function()
		ent:SetNW2Bool( "HasSSpeed", false )
		
		ent:SetWalkSpeed(PLAYER_WALKSPEED)
		-- ent:SetJumpPower(PLAYER_RUNSPEED)
		ent:SetRunSpeed(PLAYER_RUNSPEED)
	end)

end

-- hook.Add("SetupMove", "SSPowerups_SeriousSpeed", function(ply, mv)
	-- if ply:Alive() and PowerupActive(ply) then
	-- end
-- end)
