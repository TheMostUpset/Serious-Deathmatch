function EFFECT:Init(data)
	self:SetAngles(data:GetAngles() + Angle(90,0,0))
	self:SetModel("models/effects/serioussam/shockwave.mdl")
	self.DieTime = 1
	self.Size = 0
	self.Scale = data:GetScale()
end

function EFFECT:Think()
	self.DieTime = self.DieTime + FrameTime()
	self.Size = self.Scale * self.DieTime^(5)
	if self.DieTime >= 1.7 then return false end
	
	return true
end

function EFFECT:Render()
	local col = 255 * -self.DieTime *5 +2166
	local scale = math.max(self.Size - 3, .000001)
	self:SetModelScale(scale, 0)
	self:SetColor(Color(col,col,col))
	self:DrawModel()
end