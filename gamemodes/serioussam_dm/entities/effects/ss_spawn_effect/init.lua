function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.DieTime = FrameTime() + .5
	self.Size = data:GetScale()
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	self.Size = self.Size + self.DieTime * 5
	return self.DieTime > 0	
end

local mat = Material( "sprites/effects/serioussam/EffectBase" )

function EFFECT:Render()
	local alpha = self.DieTime * 12
	alpha = math.Clamp(alpha, 0, 1)
	render.SetMaterial( mat )
	render.DrawSprite(self.Position, self.Size, self.Size, Color(255,255,255,255 * alpha))
end