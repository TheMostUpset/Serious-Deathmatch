local endgamesoundplayed = false

local playerTable = vgui.Create("DPanel")
playerTable:SetPos(ScrW() / 2, 0)
playerTable:SetSize(ScrW(), ScrH())
playerTable.Players = {}

function TSEHud()
if GetConVarNumber("ss_hud_skin") == 2 then 
return true end
end

function playerTable:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)

    self.Players = GAMEMODE:GetPlayersSortedByFrags()

	local posX = ScrW() / 2 / 1.215
    local posY = 10

    for _, ply in ipairs(self.Players) do
		local nick, frags, deaths = ply:Nick(), ply:Frags(), ply:Deaths()
		local hudr, hudg, hudb = SeriousHUD:GetColor()
		
			draw.SimpleText(nick, "Scoreboard_Font", posX + 1, posY + 1, color_black, TEXT_ALIGN_RIGHT)
			draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2  / 1.04  + 1, posY +1, color_black, TEXT_ALIGN_RIGHT)
			
			if SeriousHUD:GetSkin() == 2 then
				draw.SimpleText(nick, "Scoreboard_Font", posX, posY, Color(90, 121, 181), TEXT_ALIGN_RIGHT)
			else
				draw.SimpleText(nick, "Scoreboard_Font", posX, posY, Color(hudr, hudg, hudb), TEXT_ALIGN_RIGHT)
			end
				
			draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2 / 1.04 , posY, Color(hudr, hudg, hudb), TEXT_ALIGN_RIGHT)

			posY = posY + ScrH() / 28
			
			--draw.SimpleText(nick, "Scoreboard_Font", posX + 1, posY + 1, color_black, TEXT_ALIGN_RIGHT)
			--draw.SimpleText(frags .. "  /  " .. deaths, "Scoreboard_Font", ScrW() /2  / 1.04  + 1, posY +1, color_black, TEXT_ALIGN_RIGHT)
    	
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

local ITime = surface.GetTextureID("vgui/serioussam/hud/itimer")
	
function GM:HUDPaint()
    playerTable:PaintManual()
	if cvar_timer_enabled:GetBool() then
		local timeLimit = cvar_max_time:GetInt()
		local timer = "%02i:%02i"
		local countdown = timeLimit - (CurTime() - GetGlobalFloat("GameTime"))
		local hudr, hudg, hudb = SeriousHUD:GetColor()
		
			draw.RoundedBox(0, ScrH() / 80 , ScrH() /  14.75 / 5 , ScrH() / 14.75 /1.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
			
			if SeriousHUD:GetSkin() == 2 then
				surface.SetDrawColor(90, 121, 181, 255)
			else
				surface.SetDrawColor(hudr, hudg, hudb, 255)
			end
			
			surface.DrawOutlinedRect(ScrH() / 80 , ScrH() /  14.75 / 5, ScrH() / 14.75 / 1.25, ScrH() / 14.75 / 1.25)
			surface.SetTexture(ITime)
			
			surface.SetDrawColor(hudr, hudg, hudb, 255)
			
			surface.DrawTexturedRect(ScrH() / 80 * 1.35 , ScrH() /  14.75 / 5 * 1.2, ScrH() / 14.75 /1.4, ScrH() / 14.75 /1.4)

		
		
			draw.RoundedBox(0, ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 100))
			
			if SeriousHUD:GetSkin() == 2 then
				surface.SetDrawColor(90, 121, 181, 255)
			else
				surface.SetDrawColor(hudr, hudg, hudb, 255)
			end
			
			surface.DrawOutlinedRect(ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 / 1.25)

			draw.SimpleText(string.FormattedTime(countdown, "%02i:%02i"), "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 + 2 ,ScrH() /  14.75 / 10 + 2, color_black, TEXT_ALIGN_CENTER)			
			draw.SimpleText(string.FormattedTime(countdown, "%02i:%02i"), "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 ,ScrH() /  14.75 / 10, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER)		

	

		if countdown <= 0 and !endgamesoundplayed then
			countdown = 0
			surface.PlaySound( "misc/serioussam/churchbell.wav" )
			endgamesoundplayed = true
		end
	end
	
	if GetGlobalBool("GameEnded") then
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
	else
		local firstplayer = LocalPlayer()
		if playerTable and playerTable.Players then
			firstplayer = playerTable.Players[1]
		end
		if IsValid(firstplayer) then
			local max_frags = cvar_max_frags:GetInt()
			local frags_left = math.min(max_frags - firstplayer:Frags(), max_frags)
			if frags_left > 0 then
				local text = "FRAGS LEFT: " .. frags_left
				local x, y = ScrH() / 45, ScrH() /  13.5
				if GetConVarNumber("sdm_timer_enabled") == 1 then
					draw.SimpleText(text, "seriousHUDfont_fragsleft", x + 2, y + 2, color_black, TEXT_ALIGN_LEFT)
					draw.SimpleText(text, "seriousHUDfont_fragsleft", x, y, color_white, TEXT_ALIGN_LEFT)
				else
					local x, y = ScrH() / 45, ScrH() / 70
					draw.SimpleText(text, "seriousHUDfont_fragsleft", x + 2, y + 2, color_black, TEXT_ALIGN_LEFT)
					draw.SimpleText(text, "seriousHUDfont_fragsleft", x, y, color_white, TEXT_ALIGN_LEFT)
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