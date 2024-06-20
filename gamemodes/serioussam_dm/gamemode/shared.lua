
GM.Name = "Serious Deathmatch"
GM.Author = "wico."
GM.Email = "N/A"
GM.Website = "N/A"

cvar_max_frags = GetConVar( "sdm_max_frags" )
cvar_max_time = GetConVar( "sdm_max_time" )
cvar_timer_enabled = GetConVar( "sdm_timer_enabled" )
if !cvar_max_frags then
	cvar_max_frags = CreateConVar("sdm_max_frags", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end
if !cvar_max_time then
	cvar_max_time = CreateConVar("sdm_max_time", 600, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end
if !cvar_timer_enabled then
	cvar_timer_enabled = CreateConVar("sdm_timer_enabled", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end

STATE_GAME_PREPARE = 0
STATE_GAME_PROGRESS = 1
STATE_GAME_END = 2

include( "shared_killfeed.lua" )
include( "shared_gibs.lua" )

function GM:GetState()
	return GetGlobalInt("State")
end
function GM:SetState(num)
	return SetGlobalInt("State", num)
end

function GM:GetPlayersSortedByFrags()
	local players = player.GetAll()
	table.sort(players, function(a, b)
        if a:Frags() > b:Frags() then
            return true
        elseif a:Frags() < b:Frags() then
            return false
        else
            return a:Deaths() < b:Deaths()
        end
    end)
	return players
end

function GM:GetWinner()
	local players = self:GetPlayersSortedByFrags()
	return players[1]
end

function GM:StartCommand(ply, cmd)
	if ply:GetMoveType() == MOVETYPE_WALK then
		if cmd:KeyDown(IN_DUCK) and !ply:IsOnGround() then
			cmd:RemoveKey(IN_DUCK)
		end
		if cmd:KeyDown(IN_JUMP) and (ply:Crouching() or cmd:KeyDown(IN_DUCK)) then
			cmd:RemoveKey(IN_JUMP)
			cmd:RemoveKey(IN_DUCK)
		end
	end
end

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