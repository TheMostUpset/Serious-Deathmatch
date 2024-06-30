EFFECT.mat = Material("sprites/serioussam/ray")

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.HitPos = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.WeaponOwner = IsValid(self.WeaponEnt) and self.WeaponEnt:GetOwner() or NULL
	self.Attachment = data:GetAttachment()
	
	self.pos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self.DieTime = 1
	self.BeamSize = 32
	self:SetRenderBoundsWS(self.Position, self.HitPos)
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	return self.DieTime > 0 and IsValid(self.WeaponEnt)
end

function EFFECT:Render()
	if !IsValid(self.WeaponEnt) or !IsValid(self.WeaponOwner) then return end
	local col = math.Clamp(self.DieTime * 2.5 * 255, 0, 255)
	render.SetMaterial(self.mat)
	render.DrawBeam(self.pos, self.HitPos, self.BeamSize, 0, 1, Color(255, 255, 255, col))
end