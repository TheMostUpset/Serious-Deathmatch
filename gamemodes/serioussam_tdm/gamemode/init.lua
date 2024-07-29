AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

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
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_FIXED)
	ply:ConCommand("sdm_changeteam")
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
	
	ply:SetModel("models/pechenko_121/redrick.mdl")
	if ply:Team() == 1 then
		ply:SetSkin(0)
	elseif ply:Team() == 2 then
		ply:SetSkin(1)
	end
	
	--get this shitass outta here asap
	if player.GetCount() >=  GetConVarNumber("sdm_minplayers") and self:GetState() == STATE_GAME_WARMUP and team.NumPlayers(1) >= GetConVarNumber("sdm_minplayers") / 2 and team.NumPlayers(2) >= GetConVarNumber("sdm_minplayers") / 2  then
		self:GamePrepare()
	end
	
	EmitSound( "misc/serioussam/teleport.wav", ply:GetPos(), 0, CHAN_AUTO, 1, 150, 0, 100)
	local effectdata = EffectData()
	effectdata:SetOrigin(ply:GetPos())
	effectdata:SetScale(128)
	util.Effect("ss_spawn_effect", effectdata, true, true)
	return true
	

	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if ( !dmginfo:IsDamageType( DMG_REMOVENORAGDOLL ) ) then
		ply:CreateRagdoll()
	end

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() && attacker:IsPlayer() ) then

		if ( attacker == ply ) then
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

function GM:OnPlayerKilledByPlayer(ply, attacker, dmginfo)
	if self:GetState() == STATE_GAME_PROGRESS then
		net.Start("PlayerFrag")
		net.WriteString(ply:Nick())
		net.Send(attacker)
		if team.TotalFrags(attacker:Team()) >= cvar_max_frags:GetInt() then
			self:GameEnd()
		end
	end
end