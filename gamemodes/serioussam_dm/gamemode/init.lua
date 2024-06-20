AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_mapvote.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_weaponselection.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("shared_killfeed.lua")
AddCSLuaFile("sb.lua")
AddCSLuaFile("shared_gibs.lua")
AddCSLuaFile("player_ext.lua")

local cvar_hitboxes = CreateConVar("sdm_use_hitboxes", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Use player hitboxes to scale damage", 0, 1)
local cvar_mapvote = CreateConVar("sdm_mapvote_enabled", 1, FCVAR_ARCHIVE, "Enable map vote at the end of match", 0, 1)

include("shared.lua")
include("sb.lua")
include("sv_mapvote_init.lua")
include("sv_mapvote_vote.lua")

util.AddNetworkString("FMenu")
-- util.AddNetworkString("set")

resource.AddFile( "resource/fonts/Mytupi.ttf" )
resource.AddFile( "resource/fonts/Franklin Gothic Bold.ttf" )

PLAYER_WALKSPEED = 380
PLAYER_RUNSPEED = 250
PLAYER_JUMPPOWER = 290

PLAYER_WALKSPEED_KNIFE = 500
PLAYER_JUMPPOWER_KNIFE = 330

function GM:Initialize()
	RunConsoleCommand("ss_sv_dmrules", "1")
	RunConsoleCommand("sv_airaccelerate", "5")
end

function GM:ShutDown()
	-- revert to default values
	RunConsoleCommand("sv_airaccelerate", "10")
end

-- хук который вызывается после создания всех энтитей, но игроков в этот момент еще может не быть
function GM:InitPostEntity()
	local weapon_ss_doubleshotgun = weapons.GetStored("weapon_ss_doubleshotgun")
	if weapon_ss_doubleshotgun then weapon_ss_doubleshotgun.Primary.AnimSpeed = 1.5 end
	local weapon_ss_singleshotgun = weapons.GetStored("weapon_ss_singleshotgun")
	if weapon_ss_singleshotgun then weapon_ss_singleshotgun.Primary.AnimSpeed = 1.5 end
	-- local ammo_base = scripted_ents.GetStored("ss_ammo_base")
	-- if ammo_base then ammo_base.ModelScale = 10 end
end

-- вызывается каждый фрейм
function GM:Think()
	if cvar_timer_enabled:GetBool() and self:GetState() == STATE_GAME_PROGRESS then
		local getGameTime = GetGlobalFloat("GameTime")
		local activeTimer = CurTime() - getGameTime
		if activeTimer >= cvar_max_time:GetInt() then
			self:OnGameTimerEnd()
		end
	end
end

--[[---------------------------------------------------------
	Name: gamemode:DoPlayerDeath( )
	Desc: Carries out actions when the player dies
	
	взято из base gamemode, чтобы добавить своё
-----------------------------------------------------------]]
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if ( !dmginfo:IsDamageType( DMG_REMOVENORAGDOLL ) ) then
		ply:CreateRagdoll()
	end

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() && attacker:IsPlayer() ) then

		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
			self:OnPlayerKilledByPlayer(ply, attacker, dmginfo)
		end

	end
	
	local actWep = ply:GetActiveWeapon()
	if IsValid(actWep) then
		self:SpawnPickupOnDeath(ply, actWep)
	end

end

function GM:PlayerDeath( ply, inflictor, attacker )
	-- ply:SetNW2Bool( "HasInvis", false )
	-- ply:SetNW2Bool( "HasSDMG", false )
	
	-- Don't spawn for at least 2 seconds
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
	

	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end

	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then

		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end

	end

	-- player_manager.RunClass( ply, "Death", inflictor, attacker )

	if ( attacker == ply ) then

		self:SendDeathNotice( nil, "suicide", ply, 0 )

		MsgAll( attacker:Nick() .. " suicided!\n" )

	return end

	if ( attacker:IsPlayer() ) then

		self:SendDeathNotice( attacker, inflictor:GetClass(), ply, 0 )

		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )

	return end

	local flags = 0
	if ( attacker:IsNPC() and attacker:Disposition( ply ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_ATTACKER end

	self:SendDeathNotice( self:GetDeathNoticeEntityName( attacker ), inflictor:GetClass(), ply, 0 )

	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDeathThink( player )
	Desc: Called when the player is waiting to respawn
-----------------------------------------------------------]]
function GM:PlayerDeathThink( ply )

	if ply.NextSpawnTime && ply.NextSpawnTime > CurTime() then return end
	
	if ply:IsBot() or ply:KeyPressed(IN_ATTACK) then
		ply:Spawn()
	end

end




local pickupTable = {
	["weapon_ss_colt"] = "ss_pickup_colt",
	["weapon_ss_colt_dual"] = "ss_pickup_colt",
	["weapon_ss_cannon"] = "ss_pickup_cannon",
	["weapon_ss_doubleshotgun"] = "ss_pickup_doubleshotgun",
	["weapon_ss_flamer"] = "ss_pickup_flamer",
	["weapon_ss_ghostbuster"] = "ss_pickup_ghostbuster1",
	["weapon_ss_grenadelauncher"] = "ss_pickup_grenadel",
	["weapon_ss_laser"] = "ss_pickup_laser",
	["weapon_ss_minigun"] = "ss_pickup_minigun",
	["weapon_ss_rocketlauncher"] = "ss_pickup_rocketl",
	["weapon_ss_singleshotgun"] = "ss_pickup_shotgun",
	["weapon_ss_sniper"] = "ss_pickup_sniper",
	["weapon_ss_tommygun"] = "ss_pickup_tommygun"
}

function GM:SpawnPickupOnDeath(ply, actWep)
	local drop = pickupTable[actWep:GetClass()] or actWep.EntityPickup
	if drop then
		local ent = ents.Create(drop)
		if IsValid(ent) then
			ent:SetPos(ply:GetPos() + Vector(0,0,30))
			ent:SetDropped(true)
			ent.AmmoToGive = ply:GetAmmoCount(actWep:GetPrimaryAmmoType())
			ent:Spawn()
		end
	end
end

function GM:OnPlayerKilledByPlayer(ply, attacker, dmginfo)
	if self:GetState() == STATE_GAME_PROGRESS and attacker:Frags() >= cvar_max_frags:GetInt() then
		self:GameEnd()
	end
end

-- отключаем урон после конца игры, чтобы ничего не сломать
function GM:PlayerShouldTakeDamage(ply, attacker)
	return self:GetState() != STATE_GAME_END
end

function GM:StartGameTimer()
	SetGlobalFloat("GameTime", CurTime()) -- создаем глобальный float с текущим временем
end

function GM:OnGameTimerEnd()
	self:GameEnd()
end

function GM:GamePrepare()
	self:SetState(STATE_GAME_PREPARE)
	timer.Create("TimerGameStart", 5, 1, function()
		if self:GetState() == STATE_GAME_PREPARE then
			self:GameStart()
		end
	end)
end

function GM:GameStart()
	self:StartGameTimer()
	self:SetState(STATE_GAME_PROGRESS)
	for k, v in ipairs(player.GetAll()) do
		v:KillSilent()
		v:SetFrags(0)
		v:SetDeaths(0)
		v:Spawn()
	end
end

function GM:GameEnd()
	self:SetState(STATE_GAME_END)
	local winner = self:GetWinner()
	if IsValid(winner) then
		SetGlobalString("WinnerName", winner:Nick())
	end
	timer.Simple(5, function()
		if cvar_mapvote:GetBool() then
			Mapvote.startVote(30)
		else
			self:GameRestart()
		end
	end)
end

function GM:GameRestart()
	game.CleanUpMap()
	self:SetState(STATE_GAME_WARMUP)
	SetGlobalFloat("GameTime", 0)
	-- hook.Run("InitPostEntity")
	for k, v in ipairs(player.GetAll()) do
		v:KillSilent()
		v:SetFrags(0)
		v:SetDeaths(0)
		v:Spawn()
	end
	
	timer.Simple(1, function()
		self:GamePrepare()
	end)
end

function GM:GetFallDamage(ply, speed)
	return 0
end

function GM:UpdatePlayerSpeed(ply, wep)
	wep = wep or ply:GetActiveWeapon()
	local hasSeriousSpeed = ply:HasSeriousSpeed()
	local mul = hasSeriousSpeed and 2 or 1
	
	ply:SetRunSpeed(PLAYER_RUNSPEED * mul)	
   -- ply:SetSlowWalkSpeed( 380 )
	if IsValid(wep) and wep:GetClass() == "weapon_ss_knife" then
		mul = hasSeriousSpeed and 1.315 or 1
		ply:SetWalkSpeed(PLAYER_WALKSPEED_KNIFE * mul)
		mul = hasSeriousSpeed and 1.1 or 1
		ply:SetJumpPower(PLAYER_JUMPPOWER_KNIFE * mul)
	else
		mul = hasSeriousSpeed and 1.63 or 1
		ply:SetWalkSpeed(PLAYER_WALKSPEED * mul)
		mul = hasSeriousSpeed and 1.1 or 1
		ply:SetJumpPower(PLAYER_JUMPPOWER * mul)
	end   
end

function GM:UpdatePowerupTable(ply)
	for k, v in ipairs(player.GetAll()) do
		if v.SSPowerups then
			net.Start("SSPowerupsClient")
			net.WriteEntity(v)
			net.WriteTable(v.SSPowerups)
			net.Send(ply)
		end
	end
end

function GM:PlayerInitialSpawn(ply)
	ply:AllowFlashlight(false)
	self:UpdatePlayerSpeed(ply)
	ply:SetModel("models/pechenko_121/samclassic.mdl")
	if player.GetCount() > 1 and self:GetState() == STATE_GAME_WARMUP then
		self:GamePrepare()
	end
end

function GM:PlayerLoadout(ply)
   ply:Give('weapon_ss_knife')
   ply:Give('weapon_ss_colt_dual')
   ply:Give('weapon_ss_singleshotgun')
   EmitSound( "misc/serioussam/teleport.wav", ply:GetPos(), 0, CHAN_AUTO, 1, 150, 0, 100)
   return true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	if !cvar_hitboxes:GetBool() then return end

	-- More damage if we're shot in the head
	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 2 )
	end
	-- Less damage if we're shot in the arms or legs
	if hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		 hitgroup == HITGROUP_LEFTLEG or
		 hitgroup == HITGROUP_RIGHTLEG or
		 hitgroup == HITGROUP_GEAR then

		dmginfo:ScaleDamage( 0.25 )
	end
end

function GM:OnDamagedByExplosion()
end

function GM:PlayerSwitchWeapon(ply, oldwep, newwep)
	if ply:Alive() and IsValid(newwep) then
		self:UpdatePlayerSpeed(ply, newwep)
	end
end

function GM:ShowSpare2(ply)
	net.Start("FMenu")
	net.Send(ply)
end

--[[net.Receive( "set", function( len, ply ) -- len is the net message length, which we don't care about, ply is the player who sent it.
	 local color = net.ReadTable()
	 local model = net.ReadString()
	 ply:SetPlayerColor(Vector(color.r/255, color.g/255, color.b/255))
	 ply:SetModel(model)
	 local oldhands = ply:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		ply:SetHands( hands )
		hands:SetOwner( ply )

		-- Which hands should we use?
		local cl_playermodel = ply:GetInfo( "cl_playermodel" )
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = ply:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		ply:DeleteOnRemove( hands )

		hands:Spawn()
	end
	
	
end )]]