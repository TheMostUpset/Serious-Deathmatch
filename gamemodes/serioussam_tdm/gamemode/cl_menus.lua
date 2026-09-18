local text = ""
local showGameUI = false

local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
local ssbg_tse = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")
local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
local detailTexture_vtf_tse = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
local detailTexture_vtf_tse_alpha = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail_alpha")
local modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
local sam = surface.GetTextureID("vgui/serioussam/mainmenu/sam")
local logoct = surface.GetTextureID("vgui/serioussam/mainmenu/logoct")
local logose = surface.GetTextureID("vgui/serioussam/mainmenu/logose")
local pillar = surface.GetTextureID("vgui/serioussam/mainmenu/pillar")
local stars01 = surface.GetTextureID("vgui/serioussam/mainmenu/stars01")

function OpenSSMenu()
	showGameUI = true
	
	EscMenu = vgui.Create("DFrame")
	EscMenu:ShowCloseButton( false )
	EscMenu:SetTitle("")
	EscMenu:SetSize(ScrW(), ScrH())
	EscMenu:Center()
	EscMenu:MakePopup()
	EscMenu:SetCursor("blank")
	EscMenu.Think = nil

	local isFlashing = false
	
	local Continue_Button = vgui.Create("DButton", EscMenu)
	Continue_Button:SetText("#sdm_resume")
	Continue_Button:SetFont("MainMenu_Font")
	Continue_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Continue_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_resume", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_resume", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Continue_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_resume"
		Continue_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Continue_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Continue_Button.CurrentTextColor = GetButtonColor()
	end

	Continue_Button.DoClick = function()
		showGameUI = false
		EscMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Continue_Button:SizeToContents()
	Continue_Button:CenterHorizontal()
	Continue_Button:CenterVertical(0.35)
	
	local isFlashing = false
		
	local Team_Button = vgui.Create("DButton", EscMenu)
	Team_Button:SetText("#sdm_changeteam")
	Team_Button:SetFont("MainMenu_Font")
	Team_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Team_Button.Paint = function(self, w, h)
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_changeteam", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_changeteam", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Team_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_joinspec"
		Team_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Team_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Team_Button.CurrentTextColor = GetButtonColor()
	end

	Team_Button.DoClick = function()
		OpenTeamMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Team_Button:SizeToContents()
	Team_Button:CenterHorizontal()
	Team_Button:CenterVertical(0.41)

	local isFlashing = false
	
	local Extras_Button = vgui.Create("DButton", EscMenu)
	Extras_Button:SetText("#sdm_extras")
	Extras_Button:SetFont("MainMenu_Font")
	Extras_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Extras_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_extras", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_extras", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Extras_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_extras"
		Extras_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Extras_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Extras_Button.CurrentTextColor = GetButtonColor()
	end

	Extras_Button.DoClick = function()
		OpenExtrasMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Extras_Button:SizeToContents()
	Extras_Button:CenterHorizontal()
	Extras_Button:CenterVertical(0.47)
	
	local isFlashing = false
	
	local Options_Button = vgui.Create("DButton", EscMenu)
	Options_Button:SetText("#sdm_options")
	Options_Button:SetFont("MainMenu_Font")
	Options_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Options_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_options", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_options", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Options_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_options"
		Options_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Options_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Options_Button.CurrentTextColor = GetButtonColor()
	end

	Options_Button.DoClick = function()
		OpenOptionsMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Options_Button:SizeToContents()
	Options_Button:CenterHorizontal()
	Options_Button:CenterVertical(0.53)

	local isFlashing = false

	local Disconnect_Button = vgui.Create("DButton", EscMenu)
	Disconnect_Button:SetText("#sdm_disconnect")
	Disconnect_Button:SetFont("MainMenu_Font")
	Disconnect_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Disconnect_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_disconnect", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_disconnect", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Disconnect_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_disconnect"
		Disconnect_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Disconnect_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Disconnect_Button.CurrentTextColor = GetButtonColor()
	end

	Disconnect_Button.DoClick = function()
		DisconnectConfirm = true
		OpenConfirmationMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Disconnect_Button:SizeToContents()
	Disconnect_Button:CenterHorizontal()
	Disconnect_Button:CenterVertical(0.59)

	local isFlashing = false
	
	local Quit_Button = vgui.Create("DButton", EscMenu)
	Quit_Button:SetText("#sdm_exitgame")
	Quit_Button:SetFont("MainMenu_Font")
	Quit_Button:SetTextColor(Color(0, 0, 0, 0))

	Quit_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_exitgame", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_exitgame", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Quit_Button.OnCursorEntered = function()
		text = "#sdm_help_exitgame"
		isFlashing = true
		Quit_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Quit_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Quit_Button.CurrentTextColor = GetButtonColor()
	end
	
	Quit_Button.DoClick = function()
		DisconnectConfirm = false
		OpenConfirmationMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Quit_Button:SizeToContents()
	Quit_Button:CenterHorizontal()
	Quit_Button:CenterVertical(0.65)
	
	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_game", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_game", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("v1.98", "MainMenu_MuchSmallerFont", ScrW() / 1.05 + 2, ScrH() - ScrH() + 25 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("v1.98", "MainMenu_MuchSmallerFont", ScrW() / 1.05, ScrH() - ScrH() + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(255, 255, 255)
		surface.SetTexture(logoct)
		local fourbythree = ScrW() / ScrH()
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w - w/ 1.015, h / 1.15, w / 14, h / 10)
		else
			surface.DrawTexturedRect(w - w/ 1.015, h / 1.15, w / 18, h / 10)
		end
		
		surface.SetDrawColor(255, 255, 255)
		surface.SetTexture(logose)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w / 1.085, h / 1.15, w / 14, h / 10)
		else
			surface.DrawTexturedRect(w / 1.075, h / 1.15, w / 18, h / 10)
		end
	end
	
	EscMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenTeamMenu()
	
	if ( IsValid( GAMEMODE.TeamSelectFrame ) ) then return end
	
	TeamMenu = vgui.Create("DFrame")
	TeamMenu:ShowCloseButton( false )
	TeamMenu:SetTitle("")
	TeamMenu:SetSize(ScrW(), ScrH())
	TeamMenu:Center()
	TeamMenu:MakePopup()
	TeamMenu:SetCursor("blank")
	TeamMenu.Think = nil

	local AllTeams = team.GetAllTeams()
	local y = 30

		if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED ) then

			local isFlashing = false

			local RED_Button = vgui.Create("DButton", TeamMenu)
			RED_Button:SetText(language.GetPhrase("sdm_joinred") .. " (" .. team.NumPlayers(TEAM_RED) .. ")")
			RED_Button:SetFont("MainMenu_Font")
			RED_Button:SetTextColor(Color(0, 0, 0, 0))

			RED_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				else
					self.CurrentTextColor = GetButtonColor()
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText((language.GetPhrase("sdm_joinred") .. " (" .. team.NumPlayers(TEAM_RED) .. ")"), "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText((language.GetPhrase("sdm_joinred") .. " (" .. team.NumPlayers(TEAM_RED) .. ")"), "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			RED_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_joinred"
				RED_Button:SetCursor( "blank" )
				surface.PlaySound("menus/select.wav")
			end

			RED_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				RED_Button.CurrentTextColor = GetButtonColor()
			end

			RED_Button.DoClick = function()
				RunConsoleCommand("changeteam", TEAM_RED)
				TeamMenu:Close()
				if EscMenu then
					EscMenu:Close()
				end
				showGameUI = false
				surface.PlaySound("menus/press.wav")
			end

			RED_Button:SizeToContents()
			RED_Button:CenterHorizontal()
			RED_Button:CenterVertical(0.44)
			
			local isFlashing = false
			
			local BLUE_Button = vgui.Create("DButton", TeamMenu)
			BLUE_Button:SetText(language.GetPhrase("sdm_joinblue") .. " (" .. team.NumPlayers(TEAM_BLUE) .. ")")
			BLUE_Button:SetFont("MainMenu_Font")
			BLUE_Button:SetTextColor(Color(0, 0, 0, 0))

			BLUE_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				else
					self.CurrentTextColor = GetButtonColor()
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText((language.GetPhrase("sdm_joinblue") .. " (" .. team.NumPlayers(TEAM_BLUE) .. ")"), "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText((language.GetPhrase("sdm_joinblue") .. " (" .. team.NumPlayers(TEAM_BLUE) .. ")"), "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			BLUE_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_joinblue"
				BLUE_Button:SetCursor( "blank" )
				surface.PlaySound("menus/select.wav")
			end

			BLUE_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				BLUE_Button.CurrentTextColor = GetButtonColor()
			end

			BLUE_Button.DoClick = function()
				RunConsoleCommand("changeteam", TEAM_BLUE)
				TeamMenu:Close()
				if EscMenu then
					EscMenu:Close()
				end
				showGameUI = false
				surface.PlaySound("menus/press.wav")
			end

			BLUE_Button:SizeToContents()
			BLUE_Button:CenterHorizontal()
			BLUE_Button:CenterVertical(0.5)
			
			local isFlashing = false
			
			local SPEC_Button = vgui.Create("DButton", TeamMenu)
			SPEC_Button:SetText(language.GetPhrase("sdm_joinspec") .. " (" .. team.NumPlayers(TEAM_SPECTATOR) .. ")")
			SPEC_Button:SetFont("MainMenu_Font")
			SPEC_Button:SetTextColor(Color(0, 0, 0, 0))

			SPEC_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				else
					self.CurrentTextColor = GetButtonColor()
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText((language.GetPhrase("sdm_joinspec") .. " (" .. team.NumPlayers(TEAM_SPECTATOR) .. ")"), "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText((language.GetPhrase("sdm_joinspec") .. " (" .. team.NumPlayers(TEAM_SPECTATOR) .. ")"), "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			SPEC_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_joinspec"
				SPEC_Button:SetCursor( "blank" )
				surface.PlaySound("menus/select.wav")
			end

			SPEC_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				SPEC_Button.CurrentTextColor = GetButtonColor()
			end

			SPEC_Button.DoClick = function()
				RunConsoleCommand("sdm_joinspec")
				TeamMenu:Close()
				if EscMenu then
					EscMenu:Close()
				end
				showGameUI = false
				surface.PlaySound("menus/press.wav")
			end

			SPEC_Button:SizeToContents()
			SPEC_Button:CenterHorizontal()
			SPEC_Button:CenterVertical(0.56)

			local isFlashing = false

			local Back_Button = vgui.Create("DButton", TeamMenu)
			Back_Button:SetText("#sdm_back")
			Back_Button:SetFont("MainMenu_Font")
			Back_Button:SetTextColor(Color(0, 0, 0, 0))
			
			Back_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				else
					self.CurrentTextColor = GetButtonColor()
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText("#sdm_back", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("#sdm_back", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			Back_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_back"
				Back_Button:SetCursor("blank")
				surface.PlaySound("menus/select.wav")
			end

			Back_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				Back_Button.CurrentTextColor = GetButtonColor()
			end

			Back_Button.DoClick = function()
				showGameUI = true
				text = ""
				TeamMenu:Close()
				surface.PlaySound("menus/press.wav")
			end
			
			Back_Button:SizeToContents()
			Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)


			if ( IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
				Team:SetEnabled( false )
			end

		end

	TeamMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_changeteam", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_changeteam", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	TeamMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

hook.Add( "OnPauseMenuShow", "SSMenu", function()
	local stored_music_cvar = GetConVarNumber("sdm_music")
	if not showGameUI then
		showGameUI = true
		OpenSSMenu()
	end
	return false
end )