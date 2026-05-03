include('shared.lua')

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Draw()
	self:DrawModel()
	if self:WaterLevel() >= 2 or self:GetPower() < 505 or self:GetVelocity():Length() < 2200 or (CurTime() - self:GetCreationTime()) < .04 then return end
	
	local pos = self:GetPos()
	local vel = self:GetVelocity()
	
	local flame = self.emitter:Add("effects/fire_cloud1", pos)
	if flame then
		flame:SetVelocity(VectorRand()*400)
		flame:SetAirResistance(0)
		flame:SetGravity(Vector(0, 0, 500))
		flame:SetDieTime(math.Rand(.1, .15))
		flame:SetStartAlpha(math.Rand(100, 200))
		flame:SetEndAlpha(0)
		flame:SetStartSize(35)
		flame:SetEndSize(math.Rand(10, 30))
		flame:SetRoll(math.Rand(-90, 90))
		flame:SetRollDelta(math.Rand(-.25, .25))
		flame:SetColor(255, 180, 0)
	end

	local particle = self.emitter:Add("particle/particle_smokegrenade", pos)
	if particle then
		particle:SetVelocity(VectorRand()*200)
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, 400))
		particle:SetDieTime(math.Rand(.1, .3))
		particle:SetStartAlpha(math.Rand(50, 80))
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(math.Rand(60, 100))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(100, 100, 100)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end