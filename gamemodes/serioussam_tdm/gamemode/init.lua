AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_mapvote.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_weaponselection.lua")
AddCSLuaFile("shared.lua")
-- AddCSLuaFile("shared_killfeed.lua")
AddCSLuaFile("sb.lua")
AddCSLuaFile("shared_gibs.lua")
AddCSLuaFile("player_ext.lua")

local cvar_hitboxes = CreateConVar("sdm_use_hitboxes", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Use player hitboxes to scale damage", 0, 1)
local cvar_mapvote = CreateConVar("sdm_mapvote_enabled", 1, FCVAR_ARCHIVE, "Enable map vote at the end of match", 0, 1)
local cvar_minplayers = CreateConVar("sdm_minplayers", 2, FCVAR_ARCHIVE, "Minimum player count to start a match", 0)

include("shared.lua")
include("sb.lua")
include("sv_mapvote_init.lua")
include("sv_mapvote_vote.lua")

util.AddNetworkString("FMenu")
util.AddNetworkString("PlayerFrag")
util.AddNetworkString("PlayerKilledBy")

resource.AddFile( "resource/fonts/Mytupi.ttf" )
resource.AddFile( "resource/fonts/Franklin Gothic Bold.ttf" )

PLAYER_WALKSPEED = 380
PLAYER_RUNSPEED = 250
PLAYER_JUMPPOWER = 290

PLAYER_WALKSPEED_KNIFE = 500
PLAYER_JUMPPOWER_KNIFE = 330

cvars.AddChangeCallback("sdm_instagib", function(name, value_old, value_new)
	if GAMEMODE:GetState() == STATE_GAME_END or GAMEMODE:IsActiveMapVote() then return end
	value_new = tobool(value_new)
	for k, ply in ipairs(player.GetAll()) do
		ply:StripWeapons()
		ply:StripAmmo()
		GAMEMODE:PlayerLoadout(ply)
	end
	GAMEMODE:ToggleMapPickups(!value_new)
	if value_new then	
		GAMEMODE:ReplaceSDMGPickup()
	else
		GAMEMODE:RestoreSDMGPickup()
	end
end)

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

	self:ReplacePickupEntities()
	
	if self:IsInstagib() then
		self:ToggleMapPickups(false)
		self:ReplaceSDMGPickup()
	end
end

function GM:ToggleMapPickups(on)
	local pickups = ents.FindByClass("ss_pickup_*")
	table.Add(pickups, ents.FindByClass("ss_health_*"))
	table.Add(pickups, ents.FindByClass("ss_armor_*"))
	table.Add(pickups, ents.FindByClass("ss_ammo_*"))
	for k, v in pairs(pickups) do
		if on then
			v.ReEnabled = nil
			v.Available = true
			v:SetNoDraw(false)
		else
			v.ReEnabled = nil
			v.Available = false
			v:SetNoDraw(true)
		end
	end
end

function GM:ReplaceSDMGPickup()
	local sdmg = ents.FindByClass("ss_seriousdmg")
	for k,v in ipairs(sdmg) do
		local speed = ents.Create("ss_seriousspeed")
		if IsValid(speed) then
			speed:SetPos(v:GetPos())
			speed:Spawn()
			v:Remove()
		end
	end
end
function GM:RestoreSDMGPickup()
	local speed = ents.FindByClass("ss_seriousspeed")
	for k,v in ipairs(speed) do
		local sdmg = ents.Create("ss_seriousdmg")
		if IsValid(sdmg) then
			sdmg:SetPos(v:GetPos())
			sdmg:Spawn()
			v:Remove()
		end
	end
end

local replaceQ3Ents = {
	["q3_pickup_shotgun"] = "ss_pickup_doubleshotgun",
	["q3_pickup_grenadelauncher"] = "ss_pickup_grenadel",
	["q3_pickup_rocketlauncher"] = "ss_pickup_rocketl",
	["q3_pickup_lightninggun"] = "ss_pickup_ghostbuster",
	["q3_pickup_railgun"] = "ss_pickup_sniper",
	["q3_pickup_plasmagun"] = "ss_pickup_laser",
	["q3_pickup_bfg10k"] = "ss_pickup_cannon",
	["q3_pickup_chaingun"] = "ss_pickup_minigun",
	["q3_pickup_machinegun_ammo"] = "ss_ammo_bullets",
	["q3_pickup_shotgun_ammo"] = "ss_ammo_shells",
	["q3_pickup_grenade_ammo"] = "ss_ammo_grenades",
	["q3_pickup_rocket_ammo"] = "ss_ammo_rockets",
	["q3_pickup_railgun_ammo"] = "ss_ammo_sniperrounds",
	["q3_pickup_plasma_ammo"] = "ss_ammo_electricity",
	["q3_pickup_light_ammo"] = "ss_ammo_electricity",
	["q3_pickup_bfg_ammo"] = "ss_ammo_cannonballs",
	["q3_pickup_chaingun_ammo"] = "ss_ammo_bullets",
	["q3_pickup_armorred"] = "ss_armor_100",
	["q3_pickup_armoryellow"] = "ss_armor_50",
	["q3_pickup_armorgreen"] = "ss_armor_25",
	["q3_pickup_armorshard"] = "ss_armor_1",
	["q3_pickup_5hp"] = "ss_health_pill",
	["q3_pickup_25hp"] = "ss_health_medium",
	["q3_pickup_50hp"] = "ss_health_large",
	["q3_item_health_mega"] = "ss_health_super"
}
local replaceQ2Ents = {
	["q2_pickup_shotgun"] = "ss_pickup_shotgun",
	["q2_pickup_shotgun2"] = "ss_pickup_doubleshotgun",
	["q2_pickup_machinegun"] = "ss_pickup_tommygun",
	["q2_pickup_chaingun"] = "ss_pickup_minigun",
	["q2_pickup_grenadel"] = "ss_pickup_grenadel",
	["q2_pickup_rocket"] = "ss_pickup_rocketl",
	["q2_pickup_railgun"] = "ss_pickup_sniper",
	["q2_pickup_hyperb"] = "ss_pickup_laser",
	["q2_pickup_bfg"] = "ss_pickup_cannon",
	["q2_ammo_bullets"] = "ss_ammo_bullets",
	["q2_ammo_shells"] = "ss_ammo_shells",
	["q2_ammo_grenades"] = "ss_ammo_grenades",
	["q2_ammo_rockets"] = "ss_ammo_rockets",
	["q2_ammo_slugs"] = "ss_ammo_sniperrounds",
	["q2_ammo_cells"] = "ss_ammo_electricity",
	["q2_item_armor_body"] = "ss_armor_100",
	["q2_item_armor_combat"] = "ss_armor_50",
	["q2_item_armor_jacket"] = "ss_armor_25",
	["q2_item_armor_shard"] = "ss_armor_1",
	["q2_item_health_small"] = "ss_health_pill",
	["q2_item_health"] = "ss_health_medium",
	["q2_item_health_large"] = "ss_health_large",
	["q2_item_health_mega"] = "ss_health_super"
}
local replaceUT99Ents = {
	["ut99_pickup_biorifle"] = "ss_pickup_grenadel",
	["ut99_pickup_shock"] = "ss_pickup_tommygun",
	["ut99_pickup_pulsegun"] = "ss_pickup_laser",
	["ut99_pickup_ripper"] = "ss_pickup_shotgun",
	["ut99_pickup_minigun"] = "ss_pickup_minigun",
	["ut99_pickup_flak"] = "ss_pickup_doubleshotgun",
	["ut99_pickup_rocket"] = "ss_pickup_rocketl",
	["ut99_pickup_rifle"] = "ss_pickup_sniper",
	["ut99_pickup_redeemer"] = "ss_pickup_cannon",
	["ut99_ammo_biosludge"] = "ss_ammo_grenades",
	["ut99_ammo_shockcore"] = "ss_ammo_bullets",
	["ut99_ammo_pulsecell"] = "ss_ammo_electricity",
	["ut99_ammo_bladehopper"] = "ss_ammo_shells",
	["ut99_ammo_minigun"] = "ss_ammo_bullets",
	["ut99_ammo_flakshells"] = "ss_ammo_shells",
	["ut99_ammo_rocketpack"] = "ss_ammo_rockets",
	["ut99_ammo_bulletbox"] = "ss_ammo_sniperrounds",
	["ut99_shieldbelt"] = "ss_armor_100",
	["ut99_armor"] = "ss_armor_50",
	["ut99_thighpads"] = "ss_armor_25",
	["ut99_health_vial"] = "ss_health_pill",
	["ut99_health_medkit"] = "ss_health_medium",
	["ut99_health_box"] = "ss_health_super",
	["ut99_udamage"] = "ss_seriousdmg",
	["ut99_jumpboots"] = "ss_seriousspeed"
}
function GM:ReplacePickupEntities()
	if string.StartsWith(game.GetMap(), "q3") then
		for k, ent in ipairs(ents.FindByClass("q3_*")) do
			if replaceQ3Ents[ent:GetClass()] then
				local newEnt = ents.Create(replaceQ3Ents[ent:GetClass()])
				if IsValid(newEnt) then
					newEnt:SetPos(ent:GetPos())
					newEnt:Spawn()
					ent:Remove()
				end
			end
		end
		if game.GetMap() == "q3dm2" then
			local speed = ents.Create("ss_seriousspeed")
			if IsValid(speed) then
				speed:SetPos(Vector(-1920, -960, 5))
				speed:Spawn()
			end
		end
		if game.GetMap() == "q3dm17" then
			local sdmg = ents.Create("ss_seriousdmg")
			if IsValid(sdmg) then
				sdmg:SetPos(Vector(115, 64, 1288))
				sdmg:Spawn()
			end
		end
		if game.GetMap() == "q3tourney7" then
			local sdmg = ents.Create("ss_seriousdmg")
			if IsValid(sdmg) then
				sdmg:SetPos(Vector(-2240, -559, 3))
				sdmg:Spawn()
			end
		end
	elseif string.StartsWith(game.GetMap(), "q2") then
		for k, ent in ipairs(ents.FindByClass("q2_*")) do
			if replaceQ2Ents[ent:GetClass()] then
				local newEnt = ents.Create(replaceQ2Ents[ent:GetClass()])
				if IsValid(newEnt) then
					local pos = ent:GetPos()
					if !string.StartsWith(ent:GetClass(), "q2_pickup_") then
						pos = pos + Vector(0,0,8)
					end
					newEnt:SetPos(pos)
					newEnt:Spawn()
					ent:Remove()
				end
			end
		end
	else
		for k, ent in ipairs(ents.FindByClass("ut99_*")) do
			if replaceUT99Ents[ent:GetClass()] then
				local newEnt = ents.Create(replaceUT99Ents[ent:GetClass()])
				if IsValid(newEnt) then
					local pos = ent:GetPos()
					if ent:GetClass() != "ut99_udamage" and ent:GetClass() != "ut99_jumpboots" then
						pos = pos + Vector(0,0,24)
						if string.StartsWith(ent:GetClass(), "ut99_pickup_") then
							pos = pos + Vector(0,0,8)
						end
					end
					newEnt:SetPos(pos)
					newEnt:Spawn()
					ent:Remove()
				end
			end
		end
	end
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
	if self:GetState() == STATE_GAME_PREPARE and GetGlobalFloat("GameTime") <= CurTime() then
		self:GameStart()
	end
	if self:GetState() == STATE_GAME_END then
		local getGameTime = GetGlobalFloat("GameTime")
		if getGameTime > 0 and getGameTime <= CurTime() then
			SetGlobalFloat("GameTime", 0)
			if cvar_mapvote:GetBool() then
				Mapvote.startVote(30)
			else
				self:GameRestart()
			end
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
	
	net.Start("PlayerKilledBy")
	net.WriteString(IsValid(attacker) and attacker:IsPlayer() and attacker:Nick() or "")
	net.Send(ply)
	
	local actWep = ply:GetActiveWeapon()
	if IsValid(actWep) then
		self:SpawnPickupOnDeath(ply, actWep)
	end

end

function GM:PlayerDeath( ply, inflictor, attacker )	
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
			ent:SetPos(ply:GetPos() + Vector(0,0,35))
			ent:SetDropped(true)
			ent.AmmoToGive = ply:GetAmmoCount(actWep:GetPrimaryAmmoType())
			ent:Spawn()
		end
	end
end

function GM:OnPlayerKilledByPlayer(ply, attacker, dmginfo)
	if self:GetState() == STATE_GAME_PROGRESS then
		net.Start("PlayerFrag")
		net.WriteString(ply:Nick())
		net.Send(attacker)
		if attacker:Frags() >= cvar_max_frags:GetInt() then
			self:GameEnd()
		end
	end
end

-- отключаем урон после конца игры, чтобы ничего не сломать
function GM:PlayerShouldTakeDamage(ply, attacker)
	return self:GetState() != STATE_GAME_END
end

function GM:EntityTakeDamage(ent, dmginfo)
	if self:IsInstagib() then
		dmginfo:ScaleDamage(100)
	end
	if ent.SS_Flamer_ignite and dmginfo:GetAttacker():GetClass() == "entityflame" then
		local data = ent.SS_Flamer_ignite
		if data[3] > CurTime() then
			local attacker = data[1]
			local inflictor = data[2]
			if IsValid(attacker) then
				dmginfo:SetAttacker(attacker)
			end
			if IsValid(inflictor) then
				dmginfo:SetInflictor(inflictor)
			end
		end
	end
end

function GM:StartGameTimer()
	SetGlobalFloat("GameTime", CurTime()) -- создаем глобальный float с текущим временем
end

function GM:OnGameTimerEnd()
	self:GameEnd()
end

function GM:GamePrepare()
	self:SetState(STATE_GAME_PREPARE)
	SetGlobalFloat("GameTime", CurTime() + 5)
end

function GM:GameStart()
	self:StartGameTimer()
	self:SetState(STATE_GAME_PROGRESS)
	game.CleanUpMap(true)
	self:ReplacePickupEntities()
	for k, v in ipairs(player.GetAll()) do
		v:KillSilent()
		v:SetFrags(0)
		v:SetDeaths(0)
		v:Spawn()
	end
	if self:IsInstagib() then
		self:ToggleMapPickups(false)
		self:ReplaceSDMGPickup()
	end
end

function GM:GameEnd()
	self:SetState(STATE_GAME_END)
	SetGlobalFloat("GameTime", CurTime() + 5)
	local winner = self:GetWinner()
	if IsValid(winner) then
		SetGlobalString("WinnerName", winner:Nick())
	end
end

function GM:ResetGameState()
	self:SetState(STATE_GAME_WARMUP)
	SetGlobalFloat("GameTime", 0)
end

function GM:GameRestart()
	game.CleanUpMap()
	self:ResetGameState()
	-- hook.Run("InitPostEntity")
	self:ReplacePickupEntities()
	if self:IsInstagib() then
		self:ToggleMapPickups(false)
		self:ReplaceSDMGPickup()
	end
	for k, v in ipairs(player.GetAll()) do
		v:KillSilent()
		v:SetFrags(0)
		v:SetDeaths(0)
		v:Spawn()
	end
	
	if player.GetCount() >= cvar_minplayers:GetInt() then
		timer.Simple(1, function()
			if player.GetCount() >= cvar_minplayers:GetInt() then
				self:GamePrepare()
			end
		end)
	end
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
		if v != ply and v.SSPowerups then
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
	if player.GetCount() >= cvar_minplayers:GetInt() and self:GetState() == STATE_GAME_WARMUP then
		self:GamePrepare()
	end
end

function GM:PlayerDisconnected(ply)
	if player.GetCount() <= cvar_minplayers:GetInt() and self:GetState() != STATE_GAME_END then
		self:ResetGameState()
	end
end

function GM:PlayerLoadout(ply)
	if self:IsInstagib() then
		ply:Give("weapon_ss_railgun")
		ply:Give("weapon_ss_knife")
	else
		ply:Give('weapon_ss_knife')
		ply:Give('weapon_ss_colt_dual')
		ply:Give('weapon_ss_singleshotgun')
	end
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
	-- net.Start("FMenu")
	-- net.Send(ply)
end

function GM:AcceptInput(ent, input, activator, caller, value)
	if ent:GetClass() == "info_teleport_destination" and caller:GetClass() == "trigger_teleport" and activator:IsValid() and activator:IsPlayer() then
		-- caller:EmitSound("q3/teleout.wav", 85, 100)
		activator:EmitSound("misc/serioussam/teleport.wav", 80, 100)
		local ang = ent:GetAngles()
		//local vel = activator:GetVelocity():Length2D()
		activator:SetLocalVelocity(ang:Forward() * 350)
		activator:ScreenFade(SCREENFADE.IN, Color(100, 100, 100, 200), .05, 0)
		
		local pos = activator:GetPos()
		
		-- local effectdata = EffectData()
		-- effectdata:SetOrigin(pos)
		-- util.Effect("q3spawneffect", effectdata, true, true)
		
		-- telefrag
		local Ents = ents.FindInBox( pos + activator:OBBMins(), pos + activator:OBBMaxs() )
		for k, v in pairs( Ents ) do
			if IsValid( v ) && v != activator && v:IsPlayer() && v:Alive() then
				v:TakeDamage(999, activator, ent)
			end
		end
	end
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