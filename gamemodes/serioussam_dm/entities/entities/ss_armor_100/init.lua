AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.ArmorAmount = 100
ENT.MaxArmor = 100
ENT.RespawnTime = 60
ENT.model = "models/items/item_ss_armor_100.mdl"
function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(1.5, 0)
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