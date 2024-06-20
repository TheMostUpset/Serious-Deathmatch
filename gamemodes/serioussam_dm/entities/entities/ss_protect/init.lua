AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/serioussam/powerups/invulnerability.mdl"

function ENT:Initialize()

	self:SetModel(self.model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, 24)
	self.PDuration = 30
	self:SetModelScale( self:GetModelScale() * 1.25, 1 )
	
    self.StartPos = self:GetPos()

end

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

hook.Add("PlayerPostThink", "SSPowerups_Protect", function(ply)
	if !PowerupActive(ply) then return end
	
	-- if ply.SSPowerups.ProtectOut and ply.SSPowerups.ProtectOut <= CurTime() then
		-- ply.SSPowerups.ProtectOut = nil

	-- end	
	
	if ply.SSPowerups.Protect <= CurTime() then
		ply.SSPowerups.Protect = nil
	end
end)

hook.Add("PlayerShouldTakeDamage", "SSPowerups_Protect", function(ply)
	if !PowerupActive(ply) then return end
	return false
end)
