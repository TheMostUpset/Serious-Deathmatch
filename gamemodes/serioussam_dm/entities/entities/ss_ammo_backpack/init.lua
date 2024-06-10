AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.model = "models/items/item_ss_backpack.mdl"

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then	
		local AddAmmo = {
			{"buckshot", math.random(1,10)},
			{"RPG_Round", math.random(.5,5)},
			{"Grenade", math.random(.5,5)},
			{"sniperround", math.random(.5,5)},
			{"smg1", math.random(5,50)},
			{"cannonball", math.random(.4,3)},
			{"ar2", math.random(5,40)},
			{"napalm", math.random(1,50)},
		}
	
		if game.SinglePlayer() then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		ent:EmitSound("items/serioussam/Ammo.wav", 85)
		local t = {}
		for k, v in pairs(AddAmmo) do
			local ammoCount = ent:GetAmmoCount(v[1])
			local ammogive = v[2]*10
			ent:SetAmmo(math.min(ammoCount + ammogive, self.MaxAmmo[v[1]]), v[1])
			table.insert(t, ammogive .. " " .. self.AmmoNames[v[1]])
		end
		self:SendPickupMsg(ent, table.concat(t, ", "))
	end
end