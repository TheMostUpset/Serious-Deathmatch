function EFFECT:Init(data)
end

local mat = Material( "sprites/effects/serioussam/EffectBase" )

local alpha = 0

function EFFECT:Render()
	render.SetMaterial( mat )
	local pos = LocalPlayer():GetPos()
	alpha = ( CurTime() * -255 ) % 255
	local tr = LocalPlayer():GetEyeTrace()

	render.DrawQuadEasy( pos + Vector( 0, 0, 40 ), Vector( 0, 90, 0 ), ( CurTime() * 32 ) % 255, ( CurTime() * 32 ) % 255, Color( 255, 255, 255, alpha ) )
end