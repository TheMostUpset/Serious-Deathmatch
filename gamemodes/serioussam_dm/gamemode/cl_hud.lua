local endgamesoundplayed = false
AnnouncerSoundPlayed = CurTime()
local AnnouncerDelay = 1.5
local playerTable = vgui.Create("DPanel")
playerTable:SetPos(ScrW() / 2, 0)
playerTable:SetSize(ScrW(), ScrH())
playerTable.Players = {}
local cvar_announcer = CreateClientConVar( "sdm_announcer_enabled", 1, true, false) 
local announcer5 = false
local announcer1 = false
local announcer_lead = false
local announcer_lostlead = false
local frags_left1 = false
local frags_left2 = false
local frags_left3 = false
local leadtaken = "misc/serioussam/announcer/TakenTheLead.ogg"
local leadlost = "misc/serioussam/announcer/LostTheLead.ogg"
local leadtied = "misc/serioussam/announcer/TiedForALead.ogg"

local minutesleft5 = "misc/serioussam/announcer/FiveMinutesLeft.ogg"
local minuteleft1 = "misc/serioussam/announcer/OneMinuteLeft.ogg"
local fragsleft3 = "misc/serioussam/announcer/ThreeFragsLeft.ogg"
local fragseleft2 = "misc/serioussam/announcer/TwoFragsLeft.ogg"
local fragleft1 = "misc/serioussam/announcer/OneFragLeft.ogg"

util.PrecacheSound(leadtaken)
util.PrecacheSound(leadlost)
util.PrecacheSound(leadtied)
util.PrecacheSound(minutesleft5)
util.PrecacheSound(minuteleft1)
util.PrecacheSound(fragsleft3)
util.PrecacheSound(fragseleft2)
util.PrecacheSound(fragleft1)

function playerTable:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)

    self.Players = GAMEMODE:GetPlayersSortedByFrags()

	local posX = ScrW() / 2 / 1.215
    local posY = 10
	local hudr, hudg, hudb = GAMEMODE:GetHUDColorFrame()


    for _, ply in ipairs(self.Players) do
		local nick, frags, deaths = ply:Nick(), ply:Frags(), ply:Deaths()
		
		draw.SimpleText(nick, "Scoreboard_Font", posX + 1, posY + 1, color_black, TEXT_ALIGN_RIGHT)
		draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2  / 1.04  + 1, posY +1, color_black, TEXT_ALIGN_RIGHT)
		
		draw.SimpleText(nick, "Scoreboard_Font", posX, posY, Color(hudr, hudg, hudb), TEXT_ALIGN_RIGHT)
		if ply == LocalPlayer() then
		draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2 / 1.04 , posY, Color(hudr, hudg, hudb), TEXT_ALIGN_RIGHT)
		else
		draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2 / 1.04 , posY, color_white, TEXT_ALIGN_RIGHT)
		end
		
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
end
function LeadingSound()
--q3 code
if GAMEMODE:GetState() == STATE_GAME_PROGRESS and cvar_announcer:GetInt() == 1 then
	if CurTime() < AnnouncerSoundPlayed then return end
	if( LocalPlayer():Team() == TEAM_SPECTATOR ) then lead = false tied = false lost = false return end
	
	local killer = { }
	for k,v in ipairs( player.GetAll() ) do
		table.insert(killer, { k = v:Frags(), p = v } )		
	end
	table.SortByMember( killer, "k" )
	if( #killer <= 1 ) then return end

	 //taken
	if( killer[1].p == LocalPlayer() and !lead and killer[2].p != LocalPlayer() and killer[1].k != killer[2].k ) then
		lead = true 
		tied = false
		lost = false
		surface.PlaySound(leadtaken)
		AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
		//lost
	elseif( killer[1].p != LocalPlayer() and !lost and killer[1].k != killer[2].k and (lead or tied) ) then
		lost = true
		lead = false
		tied = false
		surface.PlaySound(leadlost)
		AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
		//tied
	elseif( !tied and killer[1].k == killer[2].k ) then
		if( LocalPlayer() == killer[2].p or LocalPlayer() == killer[1].p  ) then
			tied = true
			lead = false
			lost = false
			surface.PlaySound(leadtied)
			AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
		end
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

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 255 ) )
	draw.SimpleText( text, font, x, y, Color(self:GetHUDColorFrame()))

	y = y + h + 5


end

local ITime = surface.GetTextureID("vgui/serioussam/hud/itimer")

function GM:ShouldDrawTimer()
	return cvar_timer_enabled and cvar_timer_enabled:GetBool() and GetGlobalFloat("GameTime") > 0
end
	
function GM:HUDPaint()
	local game_state = self:GetState()

	
	hook.Run( "HUDDrawTargetID" )
    playerTable:PaintManual()
	if self:ShouldDrawTimer() then
		local timeLimit = cvar_max_time:GetInt()
		local timer = "%02i:%02i"
		local countdown = timeLimit - (CurTime() - GetGlobalFloat("GameTime"))
		if countdown < 0 then
			countdown = 0
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

		draw.SimpleText(string.FormattedTime(countdown, "%02i:%02i"), "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 + 2 ,ScrH() /  14.75 / 10 + 2, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER)			
		draw.SimpleText(string.FormattedTime(countdown, "%02i:%02i"), "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 ,ScrH() /  14.75 / 10, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER)		

		if countdown <= 0 and !endgamesoundplayed then
			surface.PlaySound( "misc/serioussam/churchbell.wav" )
			endgamesoundplayed = true
		end
		
		if cvar_announcer:GetInt() == 1 then
		if countdown == 300 and !announcer5 then
		if CurTime() < AnnouncerSoundPlayed then return end
			announcer5 = true
			surface.PlaySound( minutesleft5 )
			AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
		elseif countdown == 60 and !announcer1 then
		if CurTime() < AnnouncerSoundPlayed then return end
			announcer1 = true
			surface.PlaySound( minuteleft1 )
			AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
		end
		end
	end
	
	if game_state == STATE_GAME_WARMUP then
		local x, y = ScrW() / 2, ScrH() / 4
		local text = "Waiting for all players to connect"
		draw.SimpleText( text, "GameEnd_Font", x + 1, y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
	elseif game_state == STATE_GAME_PREPARE then
		local x, y = ScrW() / 2, ScrH() / 4
		local text = "Game starts now..."
		draw.SimpleText( text, "GameEnd_Font", x + 1, y + 1, color_black, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
	elseif game_state == STATE_GAME_END then
		if !endgamesoundplayed then
			surface.PlaySound( "misc/serioussam/boioing.wav" )
			endgamesoundplayed = true
		end
		if !Mapvote.frame or !Mapvote.frame:IsVisible() then
			local x, y = ScrW() / 2, ScrH() / 4
			local text = "The game has ended!"
			draw.SimpleText( text, "GameEnd_Font", x + 1, y + 1, color_black, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )			
			
			local winner = GetGlobalString("WinnerName")
			if winner and string.len(winner) > 0 then
				local text = winner.." wins!"
				local x, y = ScrW() / 2, ScrH()/3.6
				draw.SimpleText( text, "GameEnd_Font", x + 1, y + 1, color_black, TEXT_ALIGN_CENTER )
				draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
			end
		end
	elseif game_state == STATE_GAME_PROGRESS then
		local firstplayer = LocalPlayer()
		if playerTable and playerTable.Players then
			firstplayer = playerTable.Players[1]
		end
		if IsValid(firstplayer) and cvar_max_frags then
			local max_frags = cvar_max_frags:GetInt()
			local frags_left = math.min(max_frags - firstplayer:Frags(), max_frags)
			if frags_left > 0 then
				local text = "FRAGS LEFT: " .. frags_left
				local x, y = ScrH() / 45, ScrH() /  13.5
				if !self:ShouldDrawTimer() then
					y = ScrH() / 70
				end
				draw.SimpleText(text, "seriousHUDfont_fragsleft", x + 2, y + 2, color_black, TEXT_ALIGN_LEFT)
				draw.SimpleText(text, "seriousHUDfont_fragsleft", x, y, color_white, TEXT_ALIGN_LEFT)
				
				if cvar_announcer:GetInt() == 1 then
					if frags_left == 3 and !frags_left3 then
					if CurTime() < AnnouncerSoundPlayed then return end
						frags_left3 = true
						surface.PlaySound( fragsleft3 )
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
					elseif frags_left == 2 and !frags_left2 then
					if CurTime() < AnnouncerSoundPlayed then return end
						frags_left2 = true
						surface.PlaySound( fragsleft2 )
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay
					elseif frags_left == 1 and !frags_left1 then
					if CurTime() < AnnouncerSoundPlayed then return end
						frags_left1 = true
						surface.PlaySound( fragleft1 )	
						AnnouncerSoundPlayed = CurTime() + AnnouncerDelay						
					end
				end
			end
		end
		if !LocalPlayer():Alive() then
			local x, y = ScrW() / 2, ScrH() / 4
			local text = "Press FIRE to respawn"
			draw.SimpleText( text, "Death_Font", x + 1.5, y + 1.5, color_black, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "Death_Font", x, y, color_white, TEXT_ALIGN_CENTER)
		end
		
	end
end

function GM:HUDItemPickedUp()
    return true
end