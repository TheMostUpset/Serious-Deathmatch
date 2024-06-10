function EFFECT:Init(data)
	local Type = data:GetFlags()
	local GibModelType = data:GetMaterialIndex()
	local Pos = data:GetOrigin()
	local Force = data:GetNormal()
	local Magnitude = data:GetMagnitude()
	if Magnitude == 0 then Magnitude = 1 end
	local GibAmount = data:GetScale()
	local Ent = data:GetEntity()
	
	if Type == 1 then
		for i = 0, GibAmount do
			local effectdata = EffectData()
			effectdata:SetOrigin(Pos + i * Vector(0,0,1))
			effectdata:SetNormal(Force)
			effectdata:SetMaterialIndex(GibModelType)
			effectdata:SetEntity(Ent)
			util.Effect("ss_gibs_bodypart", effectdata)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end