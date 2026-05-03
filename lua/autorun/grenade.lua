function SpawnGrenadeRoom1_1()
	local pos = Vector(-350, 1760, -480)
	local ang = Angle(math.Rand(25, 30), 0, 0)
	local damage = 100
	if SERVER then
		local ent = ents.Create("skulls_grenade")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetExplodeDelay(2.5)
		ent:SetDamage(damage)
		ent:Spawn()
		ent:Activate()
		ent:SetModelScale(2)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			local vel = ang:Forward() * 15 + ang:Up() * 2500
			phys:SetVelocity(vel)
		end
	end
end

function SpawnGrenadeRoom1_2()
	local pos = Vector(350, 1760, -480)
	local ang = Angle(math.Rand(25, 30), -180, 0)
	local damage = 100
	if SERVER then
		local ent = ents.Create("skulls_grenade")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetExplodeDelay(2.5)
		ent:SetDamage(damage)
		ent:Spawn()
		ent:Activate()
		ent:SetModelScale(2)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			local vel = ang:Forward() * 15 + ang:Up() * 2500
			phys:SetVelocity(vel)
		end
	end
end

function SpawnGrenadeRoom2_1()
	local pos = Vector(-350, -1760, -480)
	local ang = Angle(math.Rand(25, 30), 0, 0)
	local damage = 100
	if SERVER then
		local ent = ents.Create("skulls_grenade")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetExplodeDelay(2.5)
		ent:SetDamage(damage)
		ent:Spawn()
		ent:Activate()
		ent:SetModelScale(2)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			local vel = ang:Forward() * 15 + ang:Up() * 2500
			phys:SetVelocity(vel)
		end
	end
end

function SpawnGrenadeRoom2_2()
	local pos = Vector(350, -1760, -480)
	local ang = Angle(math.Rand(25, 30), -180, 0)
	local damage = 100
	if SERVER then
		local ent = ents.Create("skulls_grenade")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetExplodeDelay(2.5)
		ent:SetDamage(damage)
		ent:Spawn()
		ent:Activate()
		ent:SetModelScale(2)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			local vel = ang:Forward() * 15 + ang:Up() * 2500
			phys:SetVelocity(vel)
		end
	end
end

