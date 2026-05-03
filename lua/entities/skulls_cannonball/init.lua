AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/projectiles/serioussam/cannonball.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInitSphere(28)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:SetExplodeDelay(flDelay)
	self.delayExplode = CurTime() +flDelay
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
	self:SetPower(dmg)
end

function ENT:PhysicsCollide(data, phys)
	if data.DeltaTime > 0.1 then self:EmitSound("weapons/serioussam/cannon/Bounce.wav") end
	
	if IsValid(data.HitEntity) and !(data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) then
		if data.HitEntity:GetClass() == "phys_bone_follower" then
			local ownerEnt = data.HitEntity:GetOwner()
			if IsValid(ownerEnt) then
				local class = ownerEnt:GetClass()
				if class == "npc_helicopter" then
					if data.Speed >= 1570 then
						self:Explode()
					else
						ownerEnt:SetVelocity(data.OurOldVelocity / 3) -- push it
					end
				elseif class == "npc_strider" then
					self:Explode()
				end
			end
		end
		local entphys = data.HitEntity:GetPhysicsObject()
		if IsValid(entphys) then
			entphys:ApplyForceOffset((phys:GetVelocity() * entphys:GetMass())/16, data.HitPos)
		end
	end
end

function ENT:Think()
	if !self.delayExplode || CurTime() < self.delayExplode then return end
	self.delayExplode = nil
	self:Explode()
end

function ENT:ExplosionEffects(pos, ang)
	local effectdata = EffectData()
	effectdata:SetAngles(Angle(90,0,0))
	effectdata:SetOrigin(pos)
	effectdata:SetScale(8)
	util.Effect("sdm_cannon_shockwave", effectdata)
	
	local explosion = EffectData()
	explosion:SetOrigin(pos)
	explosion:SetMagnitude(5)
	explosion:SetScale(4)
	explosion:SetRadius(4)
	util.Effect("Sparks", explosion)
	util.Effect("sdm_expcannon", explosion)
end

function ENT:Explode(exppos)
	local pos = self:GetPos()
	exppos = exppos or pos
	
	local tr = util.TraceHull({
		start = pos,
		endpos = exppos,
		filter = self
	})
	
	pos = tr.HitPos

	self:ExplosionEffects(pos, pos:Angle())	
	self:EmitSound("weapons/serioussam/Explosion02.wav", 100, 100)
	local owner = IsValid(self.Owner) and self.Owner or self
	local dmg = DamageInfo()
	dmg:SetInflictor(self)
	dmg:SetAttacker(owner)
	dmg:SetDamage(self.Damage)
	dmg:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT))
	util.BlastDamageInfo(dmg, pos, 128)
	self:Remove()
end

function ENT:StartTouch(ent)
	if IsValid(ent) then
		if self:GetClass() == ent:GetClass() then
			self:Explode()
		elseif ent:Health() > 0 then
			if ent:GetMaxHealth() >= 500 or self:GetVelocity():Length() < 180 or ent:IsPlayer() then
				self:Explode(ent:GetPos())
			else
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(self:GetOwner())
				dmginfo:SetInflictor(self)
				//dmginfo:SetDamageType(DMG_ALWAYSGIB)
				dmginfo:SetDamage(self.Damage)
				ent:TakeDamageInfo(dmginfo)
			end
		end
	end
end