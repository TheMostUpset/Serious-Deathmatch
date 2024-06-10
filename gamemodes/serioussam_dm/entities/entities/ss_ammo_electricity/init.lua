AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.AmmoType = "AR2"
ENT.AmmoAmount = 50
ENT.MaxAmmo = 400
ENT.model = "models/items/item_ss_electricity.mdl"
function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(1.6, 0)
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