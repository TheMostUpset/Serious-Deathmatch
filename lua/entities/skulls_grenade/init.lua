AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/projectiles/serioussam/grenade.mdl")
ENT.ExplodeOnWallHit = false -- enable explosion on wall hit
ENT.ExplodeOnWallHitSpeed = 1400 -- min speed to explode at wall

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local glow = ents.Create("env_sprite")
	glow:SetKeyValue("rendercolor","255 180 60")
	glow:SetKeyValue("GlowProxySize","2")
	glow:SetKeyValue("HDRColorScale","1")
	glow:SetKeyValue("renderfx","14")
	glow:SetKeyValue("rendermode","3")
	glow:SetKeyValue("renderamt","115")
	glow:SetKeyValue("model","sprites/flare1.spr")
	glow:SetKeyValue("scale","1.5")
	glow:Spawn()
	glow:SetParent(self)
	glow:SetPos(self:GetPos())

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(5)
		phys:Wake()
		phys:AddAngleVelocity(Vector(math.random(-1,1) *300,-200,0))
	end
end

function ENT:SetExplodeDelay(flDelay)
	self.delayExplode = CurTime() + flDelay
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
end

ENT.HitNormal = Vector(0,0,0)

function ENT:PhysicsCollide(data, phys)
	if self.didHit then return end
	self.HitNormal = data.HitNormal
	if self.ExplodeOnWallHit and data.HitEntity:IsWorld() and data.Speed >= self.ExplodeOnWallHitSpeed and cvar_dmrules:GetInt() == 0 then
		self.didHit = true
		self:Explode(data.HitPos, self.HitNormal)
	else
		if data.DeltaTime > 0.05 then self:EmitSound("weapons/serioussam/grenadelauncher/Bounce.wav") end
		local impulse = -data.Speed * data.HitNormal * 1.5
		phys:ApplyForceCenter(impulse)
	end
end

function ENT:Think()
	if !self.delayExplode || CurTime() < self.delayExplode then return end
	self.delayExplode = nil
	self:Explode()
end

function ENT:ExplosionEffects(pos, ang)
	local effectdata = EffectData()
	effectdata:SetAngles(Angle(0,0,0))
	effectdata:SetOrigin(pos)
	effectdata:SetScale(5)
	util.Effect("sdm_shockwave", effectdata)
	
	local explosion = EffectData()
	explosion:SetOrigin(pos)
	explosion:SetMagnitude(3)
	explosion:SetScale(2)
	explosion:SetRadius(4)
	util.Effect("Sparks", explosion)
	util.Effect("sdm_exprocket", explosion)
	util.Effect("sdm_expparticles", explosion)
end

function ENT:Explode(exppos, hitnorm)
	local pos = self:GetPos()
	exppos = exppos or pos
	
	local tr = util.TraceHull({
		start = pos,
		endpos = exppos,
		filter = self
	})
	
	pos = tr.HitPos
	
	self.delayExplode = nil

	self:ExplosionEffects(pos, self.HitNormal:Angle())
	
	if hitnorm then
		util.Decal("Scorch", pos + hitnorm, pos - hitnorm)
	else
		local trace = util.TraceLine({start = self:GetPos() + Vector(0,2,0), endpos = self:GetPos() - Vector(0,0,32), filter=self})
		util.Decal("Scorch", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
	end
	
	self:EmitSound("weapons/serioussam/Explosion02.wav", 100, 100)
	local owner = self:GetOwner()
	if !IsValid(owner) then owner = self end
	util.BlastDamage(self, owner, pos, 300, self.Damage)
	self:Remove()
end


ENT.Exploded = nil
