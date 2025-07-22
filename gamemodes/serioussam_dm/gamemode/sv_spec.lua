concommand.Add( "sdm_joinspec", function( ply, cmd, args )
	if !ply or !IsValid(ply) or ply:Team() == TEAM_SPECTATOR or GAMEMODE:GetState() == STATE_GAME_END or GAMEMODE:IsActiveMapVote() then return end

	if ply.joindelay and ply.joindelay >= CurTime() then
		ply:ChatPrint("#sdm_timewait")
		return
	end

	ply:KillSilent()
	ply:SetFrags(0)
	ply:SetDeaths(0)
	ply:StripWeapons()
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	local pos = ply:EyePos()
	ply:SetPos(pos)
	ply.joindelay = CurTime() +4
	ply:SetNWString("spectator_selfnick", "")
	ply.keyLastPressed = nil
	ply:SetNWInt("team_color_r", 200)
	ply:SetNWInt("team_color_g", 200)
	ply:SetNWInt("team_color_b", 200)
end )

concommand.Add( "sdm_joingame", function( ply, cmd, args )
	if !ply or !IsValid(ply) or ply:Team() == 0 or GAMEMODE:GetState() == STATE_GAME_END or GAMEMODE:IsActiveMapVote() then return end

	if ply.joindelay and ply.joindelay >= CurTime() then
		ply:ChatPrint("#sdm_timewait")
		return
	end
	ply:Spawn()
	ply:SetTeam(0)
	ply.joindelay = CurTime() +4
	ply.keyLastPressed = nil
	GAMEMODE:PlayerLoadout(ply)
end )

--stolen code from q3gmod (i'm allowed to i guess)
GM.specplys = {}

function GM:UpdatePlayerList()
	self.specplys = {}
	table.Empty(self.specplys)
	for k, v in ipairs(player.GetAll()) do
		if IsValid(v) and v:Alive() then
			table.insert(self.specplys, v)
		end
	end
end

function GM:NextPrevPlayer(curply, where)
	self:UpdatePlayerList()
	if #self.specplys == 0 then return end
	if !IsValid(curply) or !curply:Alive() then
		curply = self.specplys[1]
	end

	local asd = table.KeyFromValue(self.specplys, curply)
	asd = asd +where

	if !IsValid(self.specplys[asd]) then
		if where == 1 then
			asd = 1
		elseif where == -1 then
			asd = #self.specplys
		end
	end

	return self.specplys[asd]
end

function GM:SpectatorKeyPress(ply, key)
	local obsTarget = ply:GetObserverTarget()
	if !ply.specmode then ply.specmode = OBS_MODE_CHASE end

	if key == IN_DUCK and IsValid(obsTarget) then
		if ply.specmode != OBS_MODE_IN_EYE then
			ply.specmode = OBS_MODE_IN_EYE
		else
			ply.specmode = OBS_MODE_CHASE
		end
		ply:SetObserverMode(ply.specmode)
	end

	if key == IN_ATTACK then
		local nextply = self:NextPrevPlayer(obsTarget, 1)

		if IsValid(nextply) then
			ply:Spectate(ply.specmode)
			ply:SpectateEntity(nextply)
			if nextply:Team() == 1 then
				ply:SetNWInt("team_color_r", 255)
				ply:SetNWInt("team_color_g", 50)
				ply:SetNWInt("team_color_b", 20)
			elseif nextply:Team() == 2 then
				ply:SetNWInt("team_color_r", 50)
				ply:SetNWInt("team_color_g", 155)
				ply:SetNWInt("team_color_b", 255)
			else
				ply:SetNWInt("team_color_r", 200)
				ply:SetNWInt("team_color_g", 200)
				ply:SetNWInt("team_color_b", 200)
			end
			ply:SetNWString("spectator_plynick", nextply:Nick())
		end
	elseif key == IN_ATTACK2 then
		local prevply = self:NextPrevPlayer(obsTarget, -1)

		if IsValid(prevply) then
			ply:Spectate(ply.specmode)
			ply:SpectateEntity(prevply)
			if prevply:Team() == 1 then
				ply:SetNWInt("team_color_r", 255)
				ply:SetNWInt("team_color_g", 50)
				ply:SetNWInt("team_color_b", 20)
			elseif prevply:Team() == 2 then
				ply:SetNWInt("team_color_r", 50)
				ply:SetNWInt("team_color_g", 155)
				ply:SetNWInt("team_color_b", 255)
			else
				ply:SetNWInt("team_color_r", 200)
				ply:SetNWInt("team_color_g", 200)
				ply:SetNWInt("team_color_b", 200)
			end
			ply:SetNWString("spectator_plynick", prevply:Nick())
		end
	elseif key == IN_JUMP then
		if ply:GetObserverMode() != OBS_MODE_ROAMING then
			if IsValid(obsTarget) then
				local pos = obsTarget:GetPos()
				ply:SetPos(pos)
			end
			ply:SetNWInt("team_color_r", 200)
			ply:SetNWInt("team_color_g", 200)
			ply:SetNWInt("team_color_b", 200)
			ply:Spectate(OBS_MODE_ROAMING)
			ply:SetNWString("spectator_plynick", "")
		end
	end
end