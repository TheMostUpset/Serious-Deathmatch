AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.SpawnHeight = 45
ENT.ResizeModel = true
ENT.RespawnTime = 30

ENT.MaxAmmo = {
	["buckshot"] = 100,
	["smg1"] = 500,
	["RPG_Round"] = 50,
	["Grenade"] = 50,
	["ar2"] = 400,
	["cannonball"] = 30,
	["napalm"] = 500,
	["sniperround"] = 50
}

ENT.AmmoNames = {
	["buckshot"] = "Shells",
	["smg1"] = "Bullets",
	["RPG_Round"] = "Rockets",
	["Grenade"] = "Grenades",
	["ar2"] = "Electricity",
	["cannonball"] = "Cannonballs",
	["napalm"] = "Napalm",
	["sniperround"] = "Sniper bullets"
}
function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(1.3, 0)
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
		local ammoCount = ent:GetAmmoCount(self.AmmoType)
		if ammoCount >= self.MaxAmmo then return end
		
		if game.SinglePlayer() then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		ent:EmitSound("items/serioussam/Ammo.wav", 85)
		if ammoCount < self.MaxAmmo then
			ent:SetAmmo(math.min(ammoCount + self.AmmoAmount, self.MaxAmmo), self.AmmoType)
			self:SendPickupMsg(ent, nil, self.AmmoAmount)
		end
	end
end