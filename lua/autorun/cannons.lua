local positions = {
    Vector(2662, -3686, 1000),
    Vector(-2662, 3686, 1000),
    Vector(-2662, -3686, 1000),
    Vector(2662, 3686, 1000)
}
local cannons_active = false
local activation_time = 0

if SERVER then
    util.AddNetworkString("SSPickupText")
end

local function SendSSMsg(ply, msg)
    if not SERVER then return end
    net.Start("SSPickupText")
    net.WriteString(msg)
    net.Send(ply)
end

local function GetRandomAlivePlayer()
    local players = player.GetAll()
    local alive_players = {}
    for _, ply in ipairs(players) do
        if ply:Alive() then
            table.insert(alive_players, ply)
        end
    end
    if #alive_players > 0 then
        return alive_players[math.random(1, #alive_players)]
    end
    return nil
end

local function ShootFromPosition(pos, ply)
    damage = 250
    if SERVER and IsValid(ply) then
        local target_pos = ply:GetPos()
        local dir = (target_pos - pos)
        local dist = dir:Length()
        dir:Normalize()
        local ang = dir:Angle()
        ang.pitch = ang.pitch - 4
        
        local ent = ents.Create("skulls_cannonball")
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
            local base_speed = 1000 * (CurTime() - 1.7) * 1.25
            local speed = base_speed * (dist / 1000)
            local vel = ang:Forward() * speed + ang:Up() * 10
            phys:SetVelocity(vel)
        end
    end
end

function SpawnCannonballs()
    cannons_active = true
    activation_time = CurTime()
    local msg = "#skulls_cannons_active"
	if ConVarExists("ss_hud") then
		for _, ply in ipairs(player.GetAll()) do
			SendSSMsg(ply, msg)
		end
	end
end

local function RotateCannons()
    if cannons_active then
        local cannons = ents.FindByName("cannons")
        for i, cannon in ipairs(cannons) do
            if IsValid(cannon) then
                if not cannon.target_ply or not IsValid(cannon.target_ply) or not cannon.target_ply:Alive() then
                    cannon.target_ply = GetRandomAlivePlayer()
                end
                local ply = cannon.target_ply
                if IsValid(ply) then
                    local cannon_pos = cannon:GetPos()
                    local dir = (ply:GetPos() - cannon_pos)
                    dir.z = 0
                    dir:Normalize()
                    local target_ang = dir:Angle()
                    target_ang.yaw = target_ang.yaw - 90
                    
                    local current_ang = cannon:GetAngles()
                    local diff = math.AngleDifference(target_ang.yaw, current_ang.yaw)
                    local rotate_speed = 45
                    local max_rotate = rotate_speed * FrameTime()
                    current_ang.yaw = current_ang.yaw + math.Clamp(diff, -max_rotate, max_rotate)
                    cannon:SetAngles(current_ang)
                    
                    if math.abs(math.AngleDifference(target_ang.yaw, current_ang.yaw)) < 5 then
                        if not cannon.is_shooting then
                            cannon.is_shooting = true
                            cannon.shoot_start = CurTime()
                            cannon.last_shot = CurTime() - 3
                            cannon.target_ply = GetRandomAlivePlayer()
                            cannon.target_acquired_time = CurTime()
                            ply = cannon.target_ply
                        end
                    end
                    
                    if cannon.is_shooting then
						local msg = "#skulls_cannons_notactive"
                        if CurTime() - cannon.shoot_start > 60 then
							cannons_active = false
							activation_time = 0
							if ConVarExists("ss_hud") then
								for _, ply in ipairs(player.GetAll()) do
									SendSSMsg(ply, msg)
								end
							end
                            for _, c in ipairs(cannons) do
                                if IsValid(c) then
                                    c.is_shooting = false
                                    c.reroll_timer = nil
                                    c.obstructed_time = nil
                                    c.target_ply = nil
                                    c.target_acquired_time = nil
                                end
                            end
                            return
                        end
                        if cannon.target_acquired_time and CurTime() - cannon.target_acquired_time > 15 then
                            local found = false
                            local attempts = 0
                            while not found and attempts < 10 do
                                local new_ply = GetRandomAlivePlayer()
                                if not IsValid(new_ply) then
                                    break
                                end
                                local new_trace = util.TraceLine({
                                    start = positions[i],
                                    endpos = new_ply:GetPos(),
                                    filter = cannon,
                                    mask = MASK_SOLID
                                })
                                if not new_trace.HitWorld and (not new_trace.HitEntity or new_trace.HitEntity == new_ply) then
                                    cannon.target_ply = new_ply
                                    cannon.target_acquired_time = CurTime()
                                    found = true
                                    ply = new_ply
                                end
                                attempts = attempts + 1
                            end
                            if not found then
                                cannon.target_ply = GetRandomAlivePlayer()
                                cannon.target_acquired_time = CurTime()
                                ply = cannon.target_ply
                            end
                            cannon.last_shot = CurTime() - 3
                        end
                        
                        if CurTime() - cannon.last_shot > 3 then
                            local pos = positions[i]
                            if pos and cannons_active and IsValid(ply) then
                                local trace = util.TraceLine({
                                    start = pos,
                                    endpos = ply:GetPos(),
                                    filter = cannon,
                                    mask = MASK_SOLID
                                })
                                local obstructed = trace.HitWorld or (trace.HitEntity and trace.HitEntity ~= ply)
                                local target_invalid = not IsValid(ply) or not ply:Alive()
                                
                                if obstructed or target_invalid then
                                    if not cannon.reroll_timer then
                                        cannon.reroll_timer = CurTime()
                                    end
                                    if CurTime() - cannon.reroll_timer >= 1.5 then
                                        local found = false
                                        local attempts = 0
                                        while not found and attempts < 10 do
                                            local new_ply = GetRandomAlivePlayer()
                                            if not IsValid(new_ply) then
                                                break
                                            end
                                            local new_trace = util.TraceLine({
                                                start = pos,
                                                endpos = new_ply:GetPos(),
                                                filter = cannon,
                                                mask = MASK_SOLID
                                            })
                                            if not new_trace.HitWorld and (not new_trace.HitEntity or new_trace.HitEntity == new_ply) then
                                                cannon.target_ply = new_ply
                                                cannon.target_acquired_time = CurTime()
                                                found = true
                                                cannon.reroll_timer = nil
                                                ply = new_ply
                                            end
                                            attempts = attempts + 1
                                        end
                                        if found then
                                            if CurTime() - activation_time >= 1.5 then
												EmitSound( "weapons/serioussam/cannon/fire.wav", positions[i], 1, CHAN_AUTO, 1, 10, 0, 100 )
												ShootFromPosition(pos, ply)
                                                cannon.last_shot = CurTime()
                                                cannon.target_acquired_time = CurTime()
                                            end
                                        end
                                    end
                                else
                                    cannon.reroll_timer = nil
                                    if CurTime() - activation_time >= 1.5 then
										EmitSound( "weapons/serioussam/cannon/fire.wav", positions[i], 1, CHAN_AUTO, 1, 10, 0, 100 )
                                        ShootFromPosition(pos, ply)
                                        cannon.last_shot = CurTime()
                                        cannon.target_acquired_time = CurTime()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function CleanUpCannons()
	local cannons = ents.FindByName("cannons")
	for _, c in ipairs(cannons) do
		if IsValid(c) then
			cannons_active = false
			c.is_shooting = false
			c.reroll_timer = nil
			c.obstructed_time = nil
			c.target_ply = nil
			c.target_acquired_time = nil
		end
	end
	return
end

if SERVER then
    hook.Add("Think", "RotateCannons", RotateCannons)
    hook.Add("PostCleanupMap", "CleanUpCannons", CleanUpCannons)
end