AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.SpawnHeight = 25
ENT.ResizeModel = true
ENT.RespawnTime = 25

function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(1.15, 0)
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
		local armorCount = ent:Armor()
		if armorCount >= self.MaxArmor then return end
		
		if game.SinglePlayer() then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		ent:EmitSound(self.ArmorSound, 85)
		if armorCount < self.MaxArmor then
			ent:SetArmor(math.min(armorCount + self.ArmorAmount, self.MaxArmor))
		end
		self:SendPickupMsg(ent, "Armor", self.ArmorAmount)
	end
end