
GM.Name = "Serious Deathmatch"
GM.Author = "wico. and upset"
GM.Email = "N/A"
GM.Website = "N/A"


cvar_max_frags = GetConVar( "sdm_max_frags" )
cvar_max_time = GetConVar( "sdm_max_time" )
cvar_timer_enabled = GetConVar( "sdm_timer_enabled" )


if !cvar_max_frags then
	cvar_max_frags = CreateConVar("sdm_max_frags", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end

if !cvar_frag_limit then
	cvar_frag_limit = CreateConVar("sdm_frag_limit", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Enables frags limit for match to end", 0, 1)
end

if !cvar_max_time then
	cvar_max_time = CreateConVar("sdm_max_time", 600, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end

if !cvar_timer_enabled then
	cvar_timer_enabled = CreateConVar("sdm_timer_enabled", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, 0, 1)
end

if !cvar_holiday then
	cvar_holiday = CreateConVar("sdm_holiday", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Christmas!!!!!!", 0, 1)
end

if !cvar_powerupduration then
	cvar_powerupduration = CreateConVar("sdm_powerupduration", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
end

if !cvar_instagib then
	cvar_instagib = CreateConVar("sdm_instagib", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Instagib mode", 0, 1)
end

STATE_GAME_WARMUP = 0
STATE_GAME_PREPARE = 1
STATE_GAME_PROGRESS = 2
STATE_GAME_END = 3

MAPVOTE_NOTVOTED  	= 0
MAPVOTE_VOTING		= 1
MAPVOTE_VOTED		= 2

include("shared_gibs.lua")
include("player_ext.lua")
include("mapvote.lua")

function GM:GetState()
	return GetGlobalInt("State")
end
function GM:SetState(num)
	return SetGlobalInt("State", num)
end

function GM:IsActiveMapVote()
	return GetGlobalInt("Mapvote_State") > 0
end

function GM:IsInstagib()
	return cvar_instagib:GetBool()
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

function GM:ShouldLockMovement()
	return self:GetState() == STATE_GAME_PREPARE
end

local INAIR

function GM:SetupMove(pl, move)
	if !pl:OnGround() then
		INAIR = true
	end
	if hook.Run("ShouldLockMovement") then
		move:SetMaxClientSpeed(0.1)
	end
end

local function Accelerate(move, wishdir, wishspeed, accel)
	local playerVelocity = move:GetVelocity()

	local currentspeed = playerVelocity:Dot(wishdir)
	local addspeed = wishspeed - currentspeed

	if(addspeed <= 0) then return end

	local accelspeed = accel * FrameTime() * wishspeed

	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end
	
	playerVelocity = playerVelocity + (wishdir * accelspeed)
	move:SetVelocity(playerVelocity)
end

function GM:FinishMove(pl, move)
	if INAIR then
		local aim = move:GetMoveAngles()
		local forward, right = aim:Forward(), aim:Right()
		local fmove = move:GetForwardSpeed()
		local smove = move:GetSideSpeed()
		
		forward[3], right[3] = 0, 0
		forward:Normalize()
		right:Normalize()

		local wishvel = forward * fmove + right * smove
		wishvel[3] = 0

		local wishspeed = wishvel:Length()
		local actualspeed = move:GetVelocity():Length()

		local maxspeed = move:GetMaxSpeed()
		if(wishspeed > maxspeed) then
			wishvel = wishvel * (maxspeed / wishspeed)
			wishspeed = maxspeed
		end
		if actualspeed > wishspeed then
			wishspeed = wishspeed / 4
		end

		local wishdir = wishvel:GetNormal()

		Accelerate(move, wishdir, wishspeed, 0.75)
	
		INAIR = nil
	end
end

function GM:PlayerTick(ply, mv)
	-- AntiBunnyHop
	if mv:KeyPressed(IN_JUMP) and ply:OnGround() then
		local vel = mv:GetVelocity()
		if vel:Length2D() > mv:GetMaxClientSpeed() + 1 then
			vel.z = 0
			mv:SetVelocity(vel * 0.8)
		end
	end
	if SERVER then
		-- CheckIfPlayerStuck which one was in timer
		if ply:Alive() and (!ply.nextStuckCheck or ply.nextStuckCheck < CurTime()) then
			ply.nextStuckCheck = CurTime() + 1 -- check every second
			if !ply:InVehicle() then
				local Offset = Vector(2, 2, 2) -- This is because we don't want the script to enable when the players touch, only when they are inside eachother. So, we make the box a little smaller when they aren't stuck.
				local pushDir = VectorRand()
				for i = 1, 2 do
					pushDir[i] = math.Round(pushDir[i])
				end
				pushDir[3] = 0
				pushDir = pushDir * 200
				local Stuck = false
				
				if ply.Stuck then
					Offset = Vector(0, 0, 0)
					ply.nextStuckCheck = CurTime() + .05 -- если действительно застряли, перепроеряем чаще
				end

				for _, ent in pairs(ents.FindInBox(ply:GetPos() + ply:OBBMins() + Offset, ply:GetPos() + ply:OBBMaxs() - Offset)) do
					if IsValid(ent) and ent != ply and ent:IsPlayer() and ent:Alive() then						
						ent:SetVelocity(-pushDir)
						ent.nextStuckCheck = CurTime() + .05
						Stuck = true
					end
				end
			   
				if Stuck then
					ply.Stuck = true
					ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					ply:SetVelocity(pushDir)
				else
					ply.Stuck = false
					if ply:GetCollisionGroup() != COLLISION_GROUP_PLAYER then
						ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
					end
				end				
			else
				ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			end
		end
	end
end

function GM:PlayerNoClip(ply, state)
	if ply:GetObserverMode() == OBS_MODE_ROAMING then return false end
	if !state then return true end
	
	return cvars.Bool("sv_cheats")
end

function GM:OnEntityCreated(ent)
	if SERVER and ent.Type == "anim" and ent.SendPickupMsg then
		function ent:SendPickupMsg(ply, msg, amount)
			ply:OnSeriousItemPickedUp(self, msg, amount)
		end
	end
end