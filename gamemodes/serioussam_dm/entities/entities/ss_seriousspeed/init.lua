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

    self:EmitSound("items/serioussam/powerup.wav", 75, 100, 1, CHAN_AUTO)
    self:SendToClient(ent, ent.SSPowerups)
	ent:SetNW2Bool( "HasSSpeed	", true )

	timer.Simple(self.PDuration, function()
		ent:SetNW2Bool( "HasSSpeed", false )
	end)

end

-- hook.Add("SetupMove", "SSPowerups_SeriousSpeed", function(ply, mv)
	-- if ply:Alive() and PowerupActive(ply) then
	-- end
-- end)
