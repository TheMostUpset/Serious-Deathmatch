local endgamesoundplayed = false
AnnouncerSoundPlayed = CurTime()
local AnnouncerDelay = 1.5

local teamsplayerTable = vgui.Create("DPanel")
teamsplayerTable:SetPos(ScrW() / 2, 0)
teamsplayerTable:SetSize(ScrW(), ScrH())
teamsplayerTable.Players = {}

local cvar_announcer = CreateClientConVar( "sdm_announcer_enabled", 1, true, false) 
local announcer5 = false
local announcer1 = false

local frags_left1 = false
local frags_left2 = false
local frags_left3 = false

local newround_in = false

local three_in = false
local two_in = false
local one_in = false
local fight_in = false

hook.Add("PostCleanupMap", "ResetAnnouncerVars", function()
	announcer5 = false
	announcer1 = false
	frags_left1 = false
	frags_left2 = false
	frags_left3 = false
	newround_in = false
	three_in = false
	two_in = false
	one_in = false
	fight_in = false
end)


local blueleadtaken = "misc/serioussam/announcer/BlueTeamLeads.ogg"
local redleadtaken = "misc/serioussam/announcer/RedTeamLeads.ogg"

local minutesleft5 = "misc/serioussam/announcer/FiveMinutesLeft.ogg"
local minuteleft1 = "misc/serioussam/announcer/OneMinuteLeft.ogg"
local fragsleft3 = "misc/serioussam/announcer/ThreeFragsLeft.ogg"
local fragsleft2 = "misc/serioussam/announcer/TwoFragsLeft.ogg"
local fragleft1 = "misc/serioussam/announcer/OneFragLeft.ogg"

local newround = "misc/serioussam/announcer/NewRound.ogg"
local three = "misc/serioussam/announcer/Three.ogg"
local two = "misc/serioussam/announcer/Two.ogg"
local one = "misc/serioussam/announcer/One.ogg"
local fight = "misc/serioussam/announcer/Fight.ogg"


function teamsplayerTable:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)

    self.Players = GAMEMODE:GetPlayersSortedByFrags()


	local hudr, hudg, hudb = GAMEMODE:GetHUDColorFrame()
	
	local posY = 10
	local posX = ScrW() / 2 / 1.04
	local gap = 10 
    for _, ply in ipairs(self.Players) do
		local col = team.GetColor(ply:Team())
		local nick, frags, deaths = ply:Nick(), ply:Frags(), ply:Deaths()
		local frags_text = surface.GetTextSize(frags)
		
		draw.SimpleText(nick .. "    " ..  frags .. "  /  " .. deaths, "Scoreboard_Font", posX + 2, posY + 2, Color(0,0,0,150), TEXT_ALIGN_RIGHT)
		draw.SimpleText(nick .. "    " .. frags .. "  /  " .. deaths, "Scoreboard_Font", posX, posY, Color(col.r, col.g, col.b), TEXT_ALIGN_RIGHT)
		
		posY = posY + ScrH() / 28		
    end
end

if SeriousHUD then
	function SeriousHUD:Enabled()
		return true
	end
	function SeriousHUD:AmmoIconsEnabled()
		return true
	end
	function SeriousHUD:DrawAmmo()
		return !cvar_instagib:GetBool()
	end
	net.Receive("SSPickupText", function()
		local msg, amount = net.ReadString(), net.ReadUInt(8)
		SeriousHUD:ReceivePickupText(language.GetPhrase(msg), amount)
	end)
end

function GetOppositeTeamColor()
	if LocalPlayer():Team() == TEAM_RED then
		return 50, 155, 255
	elseif LocalPlayer():Team() == TEAM_BLUE then
		return 255, 50, 20
	else
		return 200, 200, 200
	end
end

function GetOppositeTeamFrags()
	if LocalPlayer():Team() == TEAM_RED then
		return team.TotalFrags(TEAM_BLUE)
	elseif LocalPlayer():Team() == TEAM_BLUE then
		return team.TotalFrags(TEAM_RED)
	else
		return "0"
	end
end

function LeadingSound()
if GAMEMODE:GetState() == STATE_GAME_PROGRESS and cvar_announcer:GetInt() == 1 then
	if CurTime() < AnnouncerSoundPlayed then return end
	if( LocalPlayer():Team() == TEAM_SPECTATOR ) then redlead = false bluelead = false return end
	
	--[[
	local killer = { }
	for k,v in ipairs( player.GetAll() ) do
		table.insert(killer, { k = v:Frags(), p = v } )		
	end
	table.SortByMember( killer, "k" )
	if( #killer <= 1 ) then return end
	--]]

	// red taken
	if team.TotalFrags(1) > team.TotalFrags(2) and !redlead then
		redlead = true 
		surface.PlaySound(redleadtaken)
		AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
	end
	
	// blue taken
	if team.TotalFrags(2) > team.TotalFrags(1) and !bluelead then
		bluelead = true 
		surface.PlaySound(blueleadtaken)
		AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
	end
end
end

hook.Add("Think", "combat_sound", LeadingSound)
function GM:GetHUDColor()
	if SeriousHUD then
		return SeriousHUD:GetColor()
	else
		return 255, 255, 255
	end
end
function GM:GetHUDColorFrame()
	if SeriousHUD then
		return SeriousHUD:GetFrameColor()
	else
		return 90, 120, 180
	end
end
function GM:GetHUDSkin()
	if SeriousHUD then
		return SeriousHUD:GetSkin()
	else
		return 2
	end
end

function SeriousHUD:GetFrameColor()
	local ply = LocalPlayer()
	if IsValid(ply) and GAMEMODE.TeamBased then
		local teamCol = team.GetColor(ply:Team())
		return teamCol.r, teamCol.g, teamCol.b
	end
	return 200, 200, 200
end

function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end

	local text = "ERROR"
	local font = "seriousHUDfont_targetid"

	if ( trace.Entity:IsPlayer() ) then
		text = trace.Entity:Nick()
	else
		--text = trace.Entity:GetClass()
		return
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = input.GetCursorPos()

	if ( MouseX == 0 && MouseY == 0 || !vgui.CursorVisible() ) then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY *1.15

	x = x - w / 2
	y = y + 30

	local col = team.GetColor(trace.Entity:Team())
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x + 2, y + 2, color_black )
	draw.SimpleText( text, font, x, y, Color(col.r, col.g, col.b))

	y = y + h + 5


end

local ITime = surface.GetTextureID("vgui/serioussam/hud/itimer")

local ISkull = surface.GetTextureID("vgui/serioussam/hud/iskull")



function GM:ShouldDrawTimer()
	return cvar_timer_enabled and cvar_timer_enabled:GetBool() and GetGlobalFloat("GameTime") > 0 and self:GetState() > 1
end

local fragMsgNick = ""
local fragMsgTime = 0
net.Receive("PlayerFrag", function()
	fragMsgNick = net.ReadString()
	fragMsgTime = CurTime() + 2
end)
local fragByMsgNick = ""
net.Receive("PlayerKilledBy", function()
	fragByMsgNick = net.ReadString()
end)
	
function GM:HUDPaint()
	local game_state = self:GetState()
	
	if SeriousHUD:GetSkin() == 1 then
		ISkull = surface.GetTextureID("vgui/serioussam/hud/hud_tfe/iskull")
	elseif SeriousHUD:GetSkin() == 2 then
		ISkull = surface.GetTextureID("vgui/serioussam/hud/iskull")
	end
	
	--draw.SimpleText( "Red team: " .. team.GetScore(1) , "TargetID", 12, 200, color_white )
	--draw.SimpleText( "Blue team: " .. team.GetScore(2) , "TargetID", 12, 225, color_white )
	
	hook.Run( "HUDDrawTargetID" )
    teamsplayerTable:PaintManual()
	if self:ShouldDrawTimer() then
		local timeLimit = cvar_max_time:GetInt()

		local countdown = timeLimit - (CurTime() - GetGlobalFloat("GameTime"))
		if countdown < 0 then
			countdown = 0
		end
		local timer = string.FormattedTime(countdown, "%02i:%02i")
		if game_state == STATE_GAME_END then
			timer = "00:00"
		end


		local hudr, hudg, hudb = self:GetHUDColor()
		local hudr_e, hudg_e, hudb_e = self:GetHUDColorFrame()
		
		draw.RoundedBox(0, ScrH() / 80 , ScrH() /  14.75 / 5 , ScrH() / 14.75 /1.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
		
		surface.SetDrawColor(hudr_e, hudg_e, hudb_e, 255)		
		surface.DrawOutlinedRect(ScrH() / 80 , ScrH() /  14.75 / 5, ScrH() / 14.75 / 1.25, ScrH() / 14.75 / 1.25)
		
		surface.SetTexture(ITime)
		surface.SetDrawColor(hudr, hudg, hudb, 255)		
		surface.DrawTexturedRect(ScrH() / 80 * 1.35 , ScrH() /  14.75 / 5 * 1.2, ScrH() / 14.75 /1.4, ScrH() / 14.75 /1.4)	
		draw.RoundedBox(0, ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
		
		surface.SetDrawColor(hudr_e, hudg_e, hudb_e, 255)
		surface.DrawOutlinedRect(ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 / 1.25)

		draw.SimpleText(timer, "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 + 2 ,ScrH() /  14.75 / 10 + 2, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER)			
		draw.SimpleText(timer, "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 ,ScrH() /  14.75 / 10, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER)	
	
		if countdown <= 0 and !endgamesoundplayed then
			surface.PlaySound( "misc/serioussam/churchbell.wav" )
			endgamesoundplayed = true
		end
		
		if cvar_announcer:GetBool() and AnnouncerSoundPlayed <= CurTime() then
			local countdown_rnd = math.Round(countdown - .5)
			if countdown_rnd == 300 and !announcer5 then
				announcer5 = true
				surface.PlaySound( minutesleft5 )
				AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
			elseif countdown_rnd == 60 and !announcer1 then
				announcer1 = true
				surface.PlaySound( minuteleft1 )
				AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
			end
		end
		
		
	
	end
		local hudr_e, hudg_e, hudb_e = GetOppositeTeamColor()
		local hudr, hudg, hudb = self:GetHUDColor()
		
		local y = ScrH() /  80
		
		--opposite team kill counter
		draw.RoundedBox(0, ScrW() / 2.36 , y, ScrH() / 14.75 /1.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
		
		surface.SetDrawColor(hudr_e, hudg_e, hudb_e, 255)		
		surface.DrawOutlinedRect(ScrW() / 2.36 , y, ScrH() / 14.75 / 1.25, ScrH() / 14.75 / 1.25)
		
		surface.SetTexture(ISkull)
		surface.SetDrawColor(hudr, hudg, hudb, 255)		
		surface.DrawTexturedRect(ScrW() / 2.36 * 1.005 , y * 1.3, ScrH() / 14.75 /1.4, ScrH() / 14.75 /1.4)	
		draw.RoundedBox(0, ScrW() / 2.2 + 5.5 , y , ScrH() / 14.75 * 2.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
		
		surface.SetDrawColor(hudr_e, hudg_e, hudb_e, 255)
		surface.DrawOutlinedRect(ScrW() / 2.2 + 5.5 , y , ScrH() / 14.75 * 2.25, ScrH() / 14.75 / 1.25)

		draw.SimpleText(GetOppositeTeamFrags(), "seriousHUDfont_timer", ScrW() / 2 + 2 , y / 2 + 2, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER)			
		draw.SimpleText(GetOppositeTeamFrags(), "seriousHUDfont_timer", ScrW() / 2, y / 2, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER)	
	
	if game_state == STATE_GAME_WARMUP then
		local x, y = ScrW() / 2, ScrH() / 4
		local text = "#sdm_waitplys"
		draw.SimpleText( text, "GameEnd_Font", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
	elseif game_state == STATE_GAME_PREPARE then
		local countdown = GetGlobalFloat("GameTime") - CurTime()
		local countdown_rnd = math.Round(countdown + .6)
		if cvar_announcer:GetBool() and AnnouncerSoundPlayed <= CurTime() then
			if !newround_in then
				surface.PlaySound(newround)
				newround_in = true
				AnnouncerSoundPlayed = CurTime() + .5
			end
			if countdown_rnd == 3 and !three_in then
				surface.PlaySound(three)
				three_in = true
				AnnouncerSoundPlayed = CurTime() + .5
			end
			if countdown_rnd == 2 and !two_in then
				surface.PlaySound(two)
				two_in = true
				AnnouncerSoundPlayed = CurTime() + .5
			end
			if countdown_rnd == 1 and !one_in then
				surface.PlaySound(one)
				one_in = true
				AnnouncerSoundPlayed = CurTime() + .4
			end
			if countdown <= 0 and !fight_in then
				surface.PlaySound(fight)
				fight_in = true
				AnnouncerSoundPlayed = CurTime() + 1
			end
		end		
		local x, y = ScrW() / 2, ScrH() / 4
		local text = "#sdm_roundstart"
		if countdown_rnd < 4 then
		text = language.GetPhrase( "sdm_roundstart" ) .. " " .. countdown_rnd
		end
		draw.SimpleText( text, "GameEnd_Font", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
	elseif game_state == STATE_GAME_END then
		if !endgamesoundplayed then
			surface.PlaySound( "misc/serioussam/boioing.wav" )
			endgamesoundplayed = true
		end
		if !Mapvote.frame or !Mapvote.frame:IsVisible() then
			local x, y = ScrW() / 2, ScrH() / 4
			local text = "#sdm_gameend"
			draw.SimpleText( text, "GameEnd_Font", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )			
			
			local winner = GetGlobalString("WinnerName")
			if winner and string.len(winner) > 0 then
				local text = winner.. " " .. language.GetPhrase( "sdm_wins" )
				local x, y = ScrW() / 2, ScrH()/3.6
				draw.SimpleText( text, "GameEnd_Font", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER )
				draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
			end
		end
	elseif game_state == STATE_GAME_PROGRESS then
		local firstplayer = LocalPlayer()
		if teamsplayerTable and teamsplayerTable.Players then
			firstplayer = teamsplayerTable.Players[1]
		end
		if IsValid(firstplayer) and cvar_max_frags then
		
			local max_frags = cvar_max_frags:GetInt()
			local frags_left = math.min(max_frags - firstplayer:Frags(), max_frags)
			if frags_left > 0 then
				local text = language.GetPhrase( "sdm_fragsleft" ) .. " " .. frags_left
				local x, y = ScrH() / 80, ScrH() /  14
				if !self:ShouldDrawTimer() then
					y = ScrH() / 70
				end
				draw.SimpleText(text, "seriousHUDfont_fragsleft", x + 2, y + 2, Color(0,0,0,200), TEXT_ALIGN_LEFT)
				draw.SimpleText(text, "seriousHUDfont_fragsleft", x, y, color_white, TEXT_ALIGN_LEFT)
				
				if cvar_announcer:GetBool() and AnnouncerSoundPlayed <= CurTime() then
					if frags_left == 3 and !frags_left3 then
						frags_left3 = true
						surface.PlaySound( fragsleft3 )
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
					elseif frags_left == 2 and !frags_left2 then
						frags_left2 = true
						surface.PlaySound( fragsleft2 )
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
					elseif frags_left == 1 and !frags_left1 then
						frags_left1 = true
						surface.PlaySound( fragleft1 )	
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay						
					end
				end
			end
		end
		if !LocalPlayer():Alive() then
			local x, y = ScrW() / 2, ScrH() / 4
			local text = "#sdm_respawn"
			local font = "Death_Font"
			draw.SimpleText( text, font, x + 2, y + 2, color_black, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, font, x, y, color_white, TEXT_ALIGN_CENTER)
			if fragByMsgNick != "" then
				local y = ScrH() / 5
				local text = language.GetPhrase( "sdm_fraggedby" ) .. " " ..fragByMsgNick
				if fragByMsgNick == LocalPlayer():Nick() then
					text = "#sdm_kys"
				end
				draw.SimpleText( text, font, x + 2, y + 2, color_black, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, font, x, y, color_white, TEXT_ALIGN_CENTER)
			end
		end		
	end
	if fragMsgTime > CurTime() then
		local x, y = ScrW() / 2, ScrH() / 3.25
		local text = language.GetPhrase( "sdm_youfragged" ) .. " " .. fragMsgNick
		local font = "Frag_Font"
		local fadeSpeed = 3
		local alpha = 255 * math.Clamp((fragMsgTime - CurTime())*fadeSpeed, 0, 1)
		draw.SimpleText( text, font, x + 2, y + 2, Color(0,0,0,alpha), TEXT_ALIGN_CENTER)
		draw.SimpleText( text, font, x, y, Color(255,255,255,alpha), TEXT_ALIGN_CENTER)
	end
end

function GM:HUDItemPickedUp()
    return true
end