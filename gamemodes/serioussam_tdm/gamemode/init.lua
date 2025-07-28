AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menus.lua")

include( "shared.lua" )

local cvar_friendlyfire = CreateConVar("sdm_friendlyfire", 0, FCVAR_ARCHIVE, "Enable friendly fire", 0, 1)
local cvar_friendlyfire_scale = CreateConVar("sdm_friendlyfire_scale", 0.25, FCVAR_ARCHIVE, "Scale of friendly fire damage", 0)

function GM:Initialize()
	RunConsoleCommand("ss_sv_dmrules", "1")
	RunConsoleCommand("sv_airaccelerate", "5")
end

function GM:SDMShowTeam( ply )

	if ( !GAMEMODE.TeamBased ) then return end

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 0.5
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return
	end

	-- For clientside see cl_pickteam.lua
	ply:SendLua( "GAMEMODE:SDMShowTeam()" )

end

function GM:PlayerInitialSpawn(ply)
	ply:AllowFlashlight(false)
	self:UpdatePlayerSpeed(ply)
	if ply:Alive() then
		ply:KillSilent()
	end
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_FIXED)
	ply:ConCommand("sdm_changeteam")
end

function GM:PlayerLoadout(ply)
	if ply:Team() == TEAM_SPECTATOR then return end
	if self:IsInstagib() then
		ply:Give("weapon_ss_railgun")
		ply:Give("weapon_ss_knife")
	else
		ply:Give('weapon_ss_knife')
		ply:Give('weapon_ss_colt')
	end

	ply:SetModel("models/pechenko_121/redrick.mdl")
	if ply:Team() == 1 then
		ply:SetSkin(0)
	elseif ply:Team() == 2 then
		ply:SetSkin(5)
	end

	if GetConVar("sdm_holiday"):GetInt() == 0 then
		ply:SetBodygroup(0, 0)
		ply:ConCommand("sdm_playermodel_bodygroup 0")
	else
		ply:SetBodygroup(1, 1)
		ply:ConCommand("sdm_playermodel_bodygroup 1")
	end

	ply.SpawnProtection = CurTime() + 3
	--get this shitass outta here asap
	if player.GetCount() >=  GetConVarNumber("sdm_minplayers") and self:GetState() == STATE_GAME_WARMUP and team.NumPlayers(1) >= GetConVarNumber("sdm_minplayers") / 2 and team.NumPlayers(2) >= GetConVarNumber("sdm_minplayers") / 2  then
		self:GamePrepare()
	end

	EmitSound( "misc/serioussam/teleport.wav", ply:GetPos(), 0, CHAN_AUTO, 1, 150, 0, 100)
	ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
	local effectdata = EffectData()
	effectdata:SetOrigin(ply:GetPos())
	effectdata:SetScale(128)
	util.Effect("ss_spawn_effect", effectdata, true, true)
	ply:SetRenderFX(4)
	ply:EmitSound("misc/serioussam/powerupbeep.wav")
	
	ply:SetViewOffset(Vector(0,0,60))
	ply:SetViewOffsetDucked(Vector(0,0,24))
	
	ply:SetDuckSpeed(0.1)
	ply:SetUnDuckSpeed(0.1)
	
	timer.Create( ply:SteamID() .. " " .. ply:Team() .. " blinking_timer", 3, 1, function()
		ply:SetRenderFX(0)
		timer.Remove(ply:SteamID() .. " " .. ply:Team() .. " blinking_timer")
	end )
	return true
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ply:Team() == TEAM_SPECTATOR then return end
	if ( !dmginfo:IsDamageType( DMG_REMOVENORAGDOLL ) ) then
		ply:CreateRagdoll()
	end

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() && attacker:IsPlayer() ) then

		if ( attacker == ply ) then
			local attackerteam = attacker:Team()
			team.AddScore(attackerteam, -1)
			attacker:AddFrags( -1 )
		elseif ( attacker:Team() == ply:Team() ) then
			local attackerteam = attacker:Team()
			team.AddScore(attackerteam, -1)
			attacker:AddFrags( -1 )
		else
			local attackerteam = attacker:Team()
			team.AddScore(attackerteam, 1)
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

function GM:PlayerShouldTakeDamage(ply, attacker)
	if ply.SpawnProtection > CurTime() then return false end
	if cvar_friendlyfire:GetInt() == 0 then
		if attacker:IsPlayer() then
			if ply:Team() == attacker:Team() and attacker:IsPlayer() and not attacker:Nick() == ply:Nick() then
				return false
			else
				return true
			end
		end
	end
	return self:GetState() != STATE_GAME_END
end

function GM:EntityTakeDamage(ent, dmginfo)
	if cvar_friendlyfire:GetInt() == 1 then
		if dmginfo:GetAttacker():IsPlayer() and ent:IsPlayer() and dmginfo:GetAttacker():Team() == ent:Team() and not dmginfo:GetAttacker():Nick() == ent:Nick() then
			dmginfo:ScaleDamage(cvar_friendlyfire_scale:GetFloat())
		end
	end
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
	if dmginfo:GetInflictor():GetClass() == "point_hurt" and dmginfo:GetInflictor():GetName() == "worlddamage_sand" then
		ent:SetLocalVelocity(Vector(0,0,250))
	end
end

function GM:OnPlayerKilledByPlayer(ply, attacker, dmginfo)
	if self:GetState() == STATE_GAME_PROGRESS then
		net.Start("PlayerFrag")
		net.WriteString(ply:Nick())
		net.Send(attacker)
		if team.TotalFrags(attacker:Team()) >= cvar_max_frags:GetInt() then
			self:GameEnd()
		end
	end

	if team.TotalFrags(2) > team.TotalFrags(1) then
		SetGlobalBool("bluelead", false)
	elseif team.TotalFrags(1) > team.TotalFrags(2) then
		SetGlobalBool("redlead", false)
	end

end

function GM:PlayerSelectSpawn( pl, transiton )
	-- If we are in transition, do not reset player's position
	if ( transiton ) then return end

	if ( self.TeamBased ) then

		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid( ent ) ) then return ent end

	end

	-- Save information about all of the spawn points
	-- in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then

		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )

		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )

	end

	local Count = table.Count( self.SpawnPoints )

	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end

	-- If any of the spawnpoints have a MASTER flag then only use that one.
	-- This is needed for single player maps.
	for k, v in pairs( self.SpawnPoints ) do

		if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, v, true ) ) then
			return v
		end

	end

	local ChosenSpawnPoint = nil

	-- Try to work out the best, random spawnpoint
	for i = 1, Count do

		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( ( ChosenSpawnPoint == pl:GetVar( "LastSpawnpoint" ) || ChosenSpawnPoint == self.LastSpawnPoint ) && Count > 1 ) then continue end

			if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count ) ) then

				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint

			end

		end

	end

	return ChosenSpawnPoint

end

function GM:GameRestart()
	game.CleanUpMap()
	self:ResetGameState()
	team.SetScore(TEAM_RED, 0)
	team.SetScore(TEAM_BLUE, 0)
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

	if player.GetCount() >= GetConVarNumber("sdm_minplayers") then
		timer.Simple(1, function()
			if player.GetCount() >= GetConVarNumber("sdm_minplayers") then
				self:GamePrepare()
			end
		end)
	end
end

function GM:GameEnd()
	self:SetState(STATE_GAME_END)
	SetGlobalFloat("GameTime", CurTime() + 5)
	local winner = self:GetWinner()
	if IsValid(winner) then
		SetGlobalString("WinnerName", winner:Team())
			if winner:Team() == 1 then
				SetGlobalString("WinnerName", "Red Team")
			elseif winner:Team() == 2 then
				SetGlobalString("WinnerName", "Blue Team")
			end
	end
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	-- Here's an immediate respawn thing by default. If you want to
	-- re-create something more like CS or some shit you could probably
	-- change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then

		-- If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )

	elseif ( oldteam == TEAM_SPECTATOR ) then

		-- If we're changing from spectator, join the game
		ply:Spawn()

	else

		-- If we're straight up changing teams just hang
		-- around until we're ready to respawn onto the
		-- team that we chose

	end

	if ply:Team() == 1 then
		self:BroadcastChatMessage({ply:Nick(), "#sdm_redjoinedteam", ""})
	elseif ply:Team() == 2 then
		self:BroadcastChatMessage({ply:Nick(), "#sdm_bluejoinedteam", ""})
	elseif ply:Team() == 4 then
		self:BroadcastChatMessage({ply:Nick(), "#sdm_specjoinedteam", ""})
	end
end

function GM:PlayerCanJoinTeam( ply, teamid )

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint("#sdm_timewait")
		return false
	end

	-- Already on this team!
	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "#sdm_teamwarning" )
		return false
	end

	return true

end