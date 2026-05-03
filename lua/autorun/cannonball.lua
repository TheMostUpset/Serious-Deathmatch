function SpawnCannonball()
	local pos = Vector(1802.32, -1493.49, 67.75)
	local ang = Angle(-0.48, 160, 0)
	local damage = math.Clamp(500 *(CurTime() - 1.65), 500, 750)
	damage = math.Round(damage)
	if SERVER then
		local ent = ents.Create("yoddler_cannonball")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetExplodeDelay(9.5)
		ent:SetDamage(damage)
		ent:Spawn()
		ent:Activate()
		ent:SetModelScale(0.25)
		ent:PhysicsInitSphere(7)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(10000)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			local vel = ang:Forward() *1000 *(CurTime() - 1.7)*1.25 +ang:Up() *10
			phys:SetVelocity(vel)
		end
	end
end
