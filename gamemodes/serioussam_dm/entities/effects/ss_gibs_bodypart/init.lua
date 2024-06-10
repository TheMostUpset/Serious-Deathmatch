function EFFECT:Init(data)
	self.GibModelType = data:GetMaterialIndex()
	local GibModel = "models/gibs/tfe_flesh.mdl"
	self.BloodType = "Blood"
	self.LifeTime = CurTime() + 10
	self.emitter = ParticleEmitter(self:GetPos())
	self:SetModel(GibModel)
	local ent = data:GetEntity()
	if self.GibModelType == 0 then
		local ignore = {
			[1] = true,
			[11] = true
		}
	end
	self:SetBodygroup(0, 1)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:PhysicsInit( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:SetMaterial("flesh")
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:AddAngleVelocity(VectorRand() * math.Rand(0, 100) * 2)
		phys:SetVelocity( data:GetNormal() + VectorRand() * math.Rand( 5, 300 ) )
	end
end

function EFFECT:Think()
	return self.LifeTime > CurTime()
end

function EFFECT:Render()
	local alpha = math.Clamp(255 * (self.LifeTime - CurTime()), 0, 255)
	self:SetColor(Color(255, 255, 255, alpha))
	self:DrawModel()
end

function EFFECT:PhysicsCollide(data, physobj)
	local start = data.HitPos + data.HitNormal
	local endpos = data.HitPos - data.HitNormal

	if data.Speed > 32 and data.DeltaTime > .2 then
		util.Decal(self.BloodType, start, endpos)
	end
end