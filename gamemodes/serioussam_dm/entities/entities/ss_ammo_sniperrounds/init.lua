AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.AmmoType = "SniperRound"
ENT.AmmoAmount = 5
ENT.MaxAmmo = 50
ENT.model = "models/items/item_ss_sniperbullets.mdl"
function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(2.25, 0)
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