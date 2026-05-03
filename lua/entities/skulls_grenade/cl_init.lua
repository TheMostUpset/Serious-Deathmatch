include('shared.lua')

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Draw()
	self:DrawModel()

	if self:WaterLevel() >= 2 or self:GetVelocity():Length() < 500 or (CurTime() - self:GetCreationTime()) < .06 then return end

	local particle = self.emitter:Add("particle/particle_smokegrenade", self:GetPos())
	if particle then
		particle:SetVelocity(VectorRand()*5)
		particle:SetAirResistance(0)
		particle:SetDieTime(.8)
		particle:SetStartAlpha(math.Rand(50, 75))
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(0, 0, 0)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end