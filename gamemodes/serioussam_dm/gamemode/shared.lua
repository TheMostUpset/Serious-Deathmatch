
GM.Name = "Serious Deathmatch"
GM.Author = "wico."
GM.Email = "N/A"
GM.Website = "N/A"
include( "shared_killfeed.lua" )
include( "shared_gibs.lua" )


-- local soundplayed = true	
	
-- hook.Add("PlayerButtonDown", "CheckForRespawn", function(ply, button)
    -- if button == MOUSE_LEFT and ply:Alive() == false then
        -- timer.Simple(5, function()
            -- if IsValid(ply) and ply:Alive() == false then
                -- ply:Spawn()
            -- end
        -- end)
    -- end
-- end)

local nextStuckCheck = 0
function GM:PlayerTick(ply, mv)
	-- AntiBunnyHop
	if mv:KeyPressed(IN_JUMP) and ply:OnGround() then
		local vel = mv:GetVelocity()
		if vel:Length2D() > mv:GetMaxClientSpeed() + 1 then
			vel.z = 0
			mv:SetVelocity(vel * 0.85)
		end
	end
	if SERVER then
		-- CheckIfPlayerStuck который был в таймере
		if ply:Alive() and nextStuckCheck < CurTime() then
			if !ply:InVehicle() then
				local Offset = Vector(5, 5, 5)
				local Stuck = false
				
				if ply.Stuck == nil then
					ply.Stuck = false
				end
				
				if ply.Stuck then
					Offset = Vector(2, 2, 2) //This is because we don't want the script to enable when the players touch, only when they are inside eachother. So, we make the box a little smaller when they aren't stuck.
				end

				for _, ent in pairs(ents.FindInBox(ply:GetPos() + ply:OBBMins() + Offset, ply:GetPos() + ply:OBBMaxs() - Offset)) do
					if IsValid(ent) and ent != ply and ent:IsPlayer() and ent:Alive() then
					
						ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						ply:SetVelocity(Vector(-10, -10, 0) * 20)
						
						ent:SetVelocity(Vector(10, 10, 0) * 20)
						
						Stuck = true
					end
				end
			   
				if !Stuck then
					ply.Stuck = false
					ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end
				
			else
				ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			end
			nextStuckCheck = CurTime() + .5 -- перепроверяем каждые полсекунды
		end
	end
end

function GM:PlayerNoClip(ply, state)
	if ply:GetObserverMode() == OBS_MODE_ROAMING then return false end
	if !state then return true end
	
	return cvars.Bool("sv_cheats")
end