AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/items/item_ss_seriouspack.mdl"

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then
		if game.SinglePlayer() then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		ent:EmitSound("items/serioussam/Ammo.wav", 85)
		local t = {}
		for k, v in pairs(self.MaxAmmo) do
			ent:SetAmmo(v, k)
			table.insert(t, v .. " " .. self.AmmoNames[k])
		end
		self:SendPickupMsg(ent, table.concat(t, ", "))
	end
end