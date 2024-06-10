AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.SpawnHeight = 25
ENT.ResizeModel = true
ENT.RespawnTime = 25
function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(1.7, 0)
	end
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self.Available = true
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, self.TriggerBounds)
end
function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then
		local hpCount = ent:Health()
		if hpCount >= self.MaxHealth then return end
		
		if game.SinglePlayer() then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		ent:EmitSound(self.HealthSound, 85)
		if hpCount < self.MaxHealth then
			ent:SetHealth(math.min(hpCount + self.HealthAmount, self.MaxHealth))
		end
		self:SendPickupMsg(ent, "Health", self.HealthAmount)
	end
end