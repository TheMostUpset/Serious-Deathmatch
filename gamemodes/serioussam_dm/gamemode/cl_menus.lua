local showGameUI

local offset = 0
local speed = 5
local flashSpeed = 4

local PoseAnimations = {
		"pose_standing_01",
		"pose_standing_02",
		"pose_standing_03",
		"pose_standing_04",
		"idle_suitcase",
	}
	
local randompose = math.random(1, #PoseAnimations)

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

local cvar_music = GetConVar("sdm_music")

function GetMMFColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return SeriousHUD:GetColor()
	end
	if SeriousHUD and SeriousHUD:GetSkin() == 2 or SeriousHUD  then
		return 240, 155, 0
	end
end

function GetFrameMMFColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return SeriousHUD:GetColor()
	end
	if SeriousHUD and SeriousHUD:GetSkin() == 2 or SeriousHUD  then
		return 90, 130, 190
	end
end

function GetAccentColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return 255, 255, 255
	end
	if SeriousHUD and SeriousHUD:GetSkin() == 2 or SeriousHUD  then
		return 240, 200, 0
	end
end

function PaintBackground(self, w, h)
	local fourbythree = ScrW() / ScrH()
	local skin = GAMEMODE:GetHUDSkin()
	local hudr, hudg, hudb = GAMEMODE:GetHUDBGColor()
	
	local offsetX = math.sin(CurTime() * 1.5) * -22
	local offsetY = math.cos(CurTime() * 1.5) * -22
	surface.SetDrawColor(0,0,0)
	surface.DrawRect(0, 0, w, h)
	
	if skin == 2 then
		surface.SetTexture(ssbg_tse)
	else
		surface.SetTexture(ssbg)
	end
	
	surface.SetDrawColor(hudr, hudg, hudb, 75)
	local texW = 256
	local texH = 256
	surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w*1.5, h*1.5, 0, 0, w / texW, h / texH )
	
	if skin == 2 then
		surface.DrawTexturedRect(0,0,w,h)
	end
	
	if skin == 2 then
		surface.SetDrawColor(255,255,255)
		surface.SetTexture(pillar)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w-w*1.01575, h-h, w/6, h)
		else
			surface.DrawTexturedRect(w-w*1.0215, h-h, w/7.2, h)
		end
	end

	if skin == 1 then 
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 75)
	end
	
	if skin == 2 then 
		surface.SetDrawColor(0, 0, 0, 0)
	end
	
	local texW = 16
	local texH = 16
	surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, w / texW, h / texH )

	offset = offset + speed
	if offset > w then
		offset = 0
	end
	
	local texW = 256
	local texH = 128
	local offsetX = math.sin(CurTime() * 1.5) * 30
	local offsetY = math.cos(CurTime() * 1.5) * 30
	
	if skin == 2 then
		offsetX = math.sin(CurTime() * 1) * 28
		offsetY = math.cos(CurTime() * 1) * 28
	end
	
	if skin == 2 then
		surface.SetTexture(detailTexture_vtf_tse)
	else
		surface.SetTexture(detailTexture_vtf)
	end
	
	surface.SetDrawColor(hudr, hudg, hudb, 75)
	
	if skin == 1 then
		surface.DrawTexturedRectUV( offsetX-35, offsetY-35, w*2, h*2, 0, 0, w / texW, h / texH )
	end
	
	if skin == 2 then
		surface.SetTexture(detailTexture_vtf_tse_alpha)
		surface.DrawTexturedRectUV( offsetX-35, offsetY-35, w*5, h*5, 0, 0, w / texW, h / texH )
	end
	
	if skin == 2 then
		surface.SetDrawColor(255,255,255)
		surface.SetTexture(sam)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w/1.5, h/5.5, w/3.5, h/1.3)
		else
			surface.DrawTexturedRect(w/1.525, h/4.275, w/5, h/1.4)
		end
	end
end

function GetButtonColor()
	if GAMEMODE:GetHUDSkin() == 1 then
		return Color(GAMEMODE:GetHUDColor())
	end
	
	if GAMEMODE:GetHUDSkin() == 2 then
		return Color(240, 155, 0)
	end
end

function GetInactiveButtonColor()
	if GAMEMODE:GetHUDSkin() == 1 then
	local hudr, hudg, hudb = GAMEMODE:GetHUDColor()
		return Color(hudr / 2, hudg / 2, hudb / 2)
	end
	
	if GAMEMODE:GetHUDSkin() == 2 then
		return Color(170, 85, 00)
	end
end

function ButtonFlashing(button)
	local flashColor1 = Color(255,255,255)
	local flashColor2 = Color(255,255,255)
	
	if GAMEMODE:GetHUDSkin() == 2 then
		flashColor1 = Color(170, 85, 0)
		flashColor2 = Color(255, 200, 0)
	end
	
	if GAMEMODE:GetHUDSkin() == 1 then
		local hudr, hudg, hudb = GAMEMODE:GetHUDColor()
		flashColor1 = Color(hudr / 2, hudg / 2, hudb / 2)
		flashColor2 = color_white
	end
	
	local t = RealTime() * flashSpeed -- 4
	local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
	local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
	local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
   
	button:SetTextColor(Color(r, g, b))
end

function CreditsButtonFlashing(button)
	flashColor1 = Color(255 / 2, 255 / 2, 255 / 2)
	flashColor2 = color_white
	
	local t = RealTime() * flashSpeed -- 4
	local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
	local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
	local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
   
	button:SetTextColor(Color(r, g, b))
end

function UpdateButtonsSkin(t, skin)
	local col = Color(240, 155, 0, 255)
	
	if skin == 1 then
		local r, g, b = GetConVarNumber("ss_hud_color_r"), GetConVarNumber("ss_hud_color_g"), GetConVarNumber("ss_hud_color_b")
		col = Color(r, g, b, 255)
	end
	
	for k, v in ipairs(t) do
		if v:GetName() == "DButton" then
			v:SetTextColor(col)
		end
	end
end

function UpdateButtonsColor(t, col)
	col = col or Color(240, 155, 0, 255)
	for k, v in ipairs(t) do
		if v:GetName() == "DButton" then
			v:SetTextColor(col)
		end
	end
end

local EscMenu
local SettingsMenu
local QuitConfirmationMenu
local text = ""

local cursor = Material("vgui/serioussam/hud/pointer")
local cursor_tfe = Material("vgui/serioussam/hud/hud_tfe/pointer")

function draw.CustomCursor(panel)
	local material = cursor
	if GAMEMODE:GetHUDSkin() == 1 then
		material = cursor_tfe
	end

	local cursorX, cursorY = panel:LocalCursorPos()

	surface.SetDrawColor(255, 255, 255, 240)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(cursorX, cursorY, 32, 32)
end

function OpenSSMenu()
	showGameUI = true
	
	EscMenu = vgui.Create("DFrame")
	EscMenu:SetSize(ScrW(), ScrH())
	EscMenu:Center()
	EscMenu:SetTitle("")
	EscMenu:ShowCloseButton( false )
	EscMenu:SetDraggable(false)
	EscMenu:SetMouseInputEnabled(false)
	EscMenu:MakePopup()
	EscMenu:SetCursor("blank")
	EscMenu:SetMouseInputEnabled(true)
	EscMenu.Think  = nil

	local Continue_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Continue_Button:SetText("#sdm_resume")
	Continue_Button:SetSize(ScrW()/12, ScrH()/20)
	Continue_Button:SetFont("MainMenu_Font")
	Continue_Button:SetTextColor(GetButtonColor())
	
	Continue_Button.OnCursorEntered = function()
		Continue_Button:SetCursor( "blank" )
		isFlashing = true
		text = "#sdm_help_resume"
		surface.PlaySound("menus/select.wav")
	end

	Continue_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Continue_Button:SetTextColor(GetButtonColor())
	end

	Continue_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	Continue_Button.DoClick = function()
		EscMenu:Close()
		showGameUI = false
		surface.PlaySound("menus/press.wav")
	end
	
	Continue_Button:SizeToContents()
	Continue_Button:Center()
	Continue_Button:SetY(ScrH()/2.925)
	
	if LocalPlayer():Team() == 0 then
	local Spec_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Spec_Button:SetText("#sdm_spectate")
	Spec_Button:SetSize(ScrW()/12, ScrH()/20)
	Spec_Button:SetFont("MainMenu_Font")
	Spec_Button:SetTextColor(GetButtonColor())
	Spec_Button.OnCursorEntered = function()
		Spec_Button:SetCursor( "blank" )
		text = "#sdm_help_joinspec"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Spec_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Spec_Button:SetTextColor(GetButtonColor())
	end

	Spec_Button.Paint = function(self, w, h)
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	Spec_Button.DoClick = function()
		RunConsoleCommand("sdm_joinspec")
		EscMenu:Close()
		showGameUI = false
		surface.PlaySound("menus/press.wav")
	end
	
	Spec_Button:SizeToContents()
	Spec_Button:Center()
	Spec_Button:SetY(ScrH()/2.515)
	end
	
	if LocalPlayer():Team() == TEAM_SPECTATOR then
		local Return_Button = vgui.Create("DButton", EscMenu)
		local isFlashing = false
		Return_Button:SetText("#sdm_joingame")
		Return_Button:SetSize(ScrW()/6, ScrH()/20)
		Return_Button:Center()
		Return_Button:SetFont("MainMenu_Font")
		Return_Button:SetTextColor(GetButtonColor())
		
		Return_Button.Paint = function(self, w, h) 
			if isFlashing then
				ButtonFlashing(self)
			end
		end
		
		Return_Button.OnCursorEntered = function()
			Return_Button:SetCursor( "blank" )
			text = "#sdm_help_joingame"
			surface.PlaySound("menus/select.wav")
			isFlashing = true
			
		end

		Return_Button.OnCursorExited = function()
			text = ""
			isFlashing = false
			Return_Button:SetTextColor(GetButtonColor())
		end

		Return_Button.DoClick = function()
			RunConsoleCommand("sdm_joingame")
			EscMenu:Close()
			showGameUI = false
			surface.PlaySound("menus/press.wav")
		end
		
		Return_Button:SizeToContents()
		Return_Button:Center()
		Return_Button:SetY(ScrH()/2.515)
	end

	local Disconnect_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Disconnect_Button:SetText("#sdm_disconnect")
	Disconnect_Button:SetSize(ScrW()/8, ScrH()/20)
	Disconnect_Button:SetFont("MainMenu_Font")
	Disconnect_Button:SetTextColor(GetButtonColor())
	
	Disconnect_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Disconnect_Button.OnCursorEntered = function()
		Disconnect_Button:SetCursor( "blank" )
		isFlashing = true
		text = "#sdm_help_disconnect"
		surface.PlaySound("menus/select.wav")
	end

	Disconnect_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Disconnect_Button:SetTextColor(GetButtonColor())
	end


	Disconnect_Button.DoClick = function()
		OpenStopConfirmationMenu()
		surface.PlaySound("menus/press.wav")
		surface.PlaySound("menus/press.wav")
	end
	
	Disconnect_Button:SizeToContents()
	Disconnect_Button:Center()
	Disconnect_Button:SetY(ScrH()/1.7875)
	
	local Options_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Options_Button:SetText("#sdm_options")
	Options_Button:SetSize(ScrW()/8, ScrH()/20)
	Options_Button:SetFont("MainMenu_Font")
	Options_Button:SetTextColor(GetButtonColor())
	
	Options_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Options_Button.OnCursorEntered = function()
		Options_Button:SetCursor( "blank" )
		isFlashing = true
		text = "#sdm_help_options"
		surface.PlaySound("menus/select.wav")
	end

	Options_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Options_Button:SetTextColor(GetButtonColor())
	end

	Options_Button.DoClick = function()
		OpenSettingsMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Options_Button:SizeToContents()
	Options_Button:Center()
	Options_Button:SetY(ScrH()/1.9775)

	local Extras_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Extras_Button:SetText("#sdm_extras")
	Extras_Button:SetSize(ScrW()/6, ScrH()/20)
	Extras_Button:Center()
	Extras_Button:SetFont("MainMenu_Font")
	Extras_Button:SetTextColor(GetButtonColor())
	
	Extras_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Extras_Button.OnCursorEntered = function()
		Extras_Button:SetCursor( "blank" )
		text = "#sdm_help_extras"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Extras_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Extras_Button:SetTextColor(GetButtonColor())
	end

	Extras_Button.DoClick = function()
		OpenExtrasMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Extras_Button:SizeToContents()
	Extras_Button:Center()
	Extras_Button:SetY(ScrH()/2.215)
	
	local Quit_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Quit_Button:SetText("#sdm_exitgame")
	Quit_Button:SetSize(ScrW()/16, ScrH()/20)
	Quit_Button:Center()
	Quit_Button:SetFont("MainMenu_Font")
	Quit_Button:SetTextColor(GetButtonColor())

	Quit_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Quit_Button.OnCursorEntered = function()
		Quit_Button:SetCursor( "blank" )
		text = "#sdm_help_exitgame"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Quit_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Quit_Button:SetTextColor(GetButtonColor())
	end
	
	Quit_Button.DoClick = function()
		OpenQuitConfirmationMenu()
		surface.PlaySound("menus/press.wav")
	end
	
	Quit_Button:SizeToContents()
	Quit_Button:Center()
	Quit_Button:SetY(ScrH()/1.625)
	
	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_game", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("v1.92", "MainMenu_font_very_small", ScrW()/1.05, ScrH() - ScrH() + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH()-ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(255,255,255)
		surface.SetTexture(logoct)
		local fourbythree = ScrW() / ScrH()
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w-w/1.015, h/1.15, w/14, h/10)
		else
			surface.DrawTexturedRect(w-w/1.015, h/1.15, w/18, h/10)
		end
		
		surface.SetDrawColor(255,255,255)
		surface.SetTexture(logose)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w/1.085, h/1.15, w/14, h/10)
		else
			surface.DrawTexturedRect(w/1.075, h/1.15, w/18, h/10)
		end
	end
	
	EscMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
end

function OpenExtrasMenu()
	showGameUI = true
	
	ExtrasMenu = vgui.Create("DFrame")
	ExtrasMenu:SetSize(ScrW(), ScrH())
	ExtrasMenu:Center()
	ExtrasMenu:SetTitle("")
	ExtrasMenu:ShowCloseButton( false )
	ExtrasMenu:SetDraggable(false)
	ExtrasMenu:MakePopup()
	ExtrasMenu.Think = nil
	ExtrasMenu:SetCursor("blank")

		local Credits_Button = vgui.Create("DButton", ExtrasMenu)
	local isFlashing = false
	Credits_Button:SetText("#sdm_credits")
	Credits_Button:SetSize(ScrW()/8, ScrH()/20)
	Credits_Button:SetFont("MainMenu_Font")
	Credits_Button:SetTextColor(GetButtonColor())
	Credits_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Credits_Button.OnCursorEntered = function()
		Credits_Button:SetCursor( "blank" )
		isFlashing = true
		text = "#sdm_help_credits"
		surface.PlaySound("menus/select.wav")
	end

	Credits_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Credits_Button:SetTextColor(GetButtonColor())
	end

	Credits_Button.DoClick = function()
		OpenCreditsMenu()

		surface.PlaySound("menus/press.wav")

	end
	Credits_Button:SizeToContents()
	Credits_Button:Center()
	Credits_Button:SetY(ScrH()/2.515)
	

	local LegacyM_Button = vgui.Create("DButton", ExtrasMenu)
	local isFlashing = false
	LegacyM_Button:SetText("#sdm_lmenu")
	LegacyM_Button:SetSize(ScrW()/6, ScrH()/20)
	LegacyM_Button:Center()
	LegacyM_Button:SetFont("MainMenu_Font")
	LegacyM_Button:SetTextColor(GetButtonColor())
	
	LegacyM_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	LegacyM_Button.OnCursorEntered = function()
		LegacyM_Button:SetCursor( "blank" )
		text = "#sdm_help_lmenu"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	LegacyM_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		LegacyM_Button:SetTextColor(GetButtonColor())
	end

	LegacyM_Button.DoClick = function()
		EscMenu:Close()
		ExtrasMenu:Close()
		showGameUI = false
		gui.ActivateGameUI()
		surface.PlaySound("menus/press.wav")
	end
	
	LegacyM_Button:SizeToContents()
	LegacyM_Button:Center()
	LegacyM_Button:SetY(ScrH()/2.215)
	
	local Docs_Button = vgui.Create("DButton", ExtrasMenu)
	local isFlashing = false
	Docs_Button:SetText("#sdm_docs")
	Docs_Button:SetSize(ScrW()/8, ScrH()/20)
	Docs_Button:SetFont("MainMenu_Font")
	Docs_Button:SetTextColor(GetInactiveButtonColor())
	
	Docs_Button.Paint = function(self, w, h) 
		--if isFlashing then
		--	ButtonFlashing(self)
		--end
	end
	
	Docs_Button.OnCursorEntered = function()
		Docs_Button:SetCursor( "blank" )
		--isFlashing = true
		--text = "#sdm_help_docs"
		--surface.PlaySound("menus/select.wav")
	end

	Docs_Button.OnCursorExited = function()
		--isFlashing = false
		text = ""
		--Docs_Button:SetTextColor(GetButtonColor())
	end

	Docs_Button.DoClick = function()
		--surface.PlaySound("menus/press.wav")
	end
	
	Docs_Button:SizeToContents()
	Docs_Button:Center()
	Docs_Button:SetY(ScrH()/1.9775)

	local Back_Button = vgui.Create("DButton", ExtrasMenu)
	local isFlashing = false
	Back_Button:SetText("#sdm_back")
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(GetButtonColor())
	
	Back_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Back_Button.OnCursorEntered = function()
		Back_Button:SetCursor("blank")
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text = "#sdm_help_back"
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button:SetTextColor(GetButtonColor())
		text = ""
	end

	Back_Button.DoClick = function()
		text = ""
		ExtrasMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH()/10)

	ExtrasMenu:MakePopup()
    
	ExtrasMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_extras", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH() - ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	ExtrasMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenCreditsMenu()
	showGameUI = true

	CreditsMenu = vgui.Create("DFrame")
	CreditsMenu:SetSize(ScrW(), ScrH())
	CreditsMenu:Center()
	CreditsMenu:SetTitle("")
	CreditsMenu:ShowCloseButton( false )
	CreditsMenu:SetDraggable(false)
	CreditsMenu:SetMouseInputEnabled(false)
	CreditsMenu:MakePopup()
	CreditsMenu:SetCursor("blank")
	CreditsMenu:SetMouseInputEnabled(true)
	CreditsMenu.Think  = nil

	local music
	local stored_music_cvar = GetConVarNumber("sdm_music")
	RunConsoleCommand("sdm_music", "0")

	music = CreateSound(LocalPlayer(), "music/croteamcredits.mp3")
	
	if music then
        music:Play()
    end

	local creditsText = [[
		CREDITS
		ㅤ
		[SEPARATOR]
		CROTEAM:
		ㅤ
		[SEPARATOR]
		PROGRAMMING
		[SEPARATOR]
		Alen Ladavac
		Davor Hunski
		Dean Sekulic
		ㅤ
		[SEPARATOR]	
		2D ART
		[SEPARATOR]
		Dinko Pavicic
		Petar Ivancek
		Davor Hunski
		ㅤ
		[SEPARATOR]
		3D ART
		[SEPARATOR]
		Admir Elezovic
		Tomislav Pongrac
		Davor Hunski
		ㅤ
		[SEPARATOR]
		GAME DESIGN
		[SEPARATOR]
		Davor Hunski
		Davor Tomicic
		Roman Ribaric
		ㅤ
		[SEPARATOR]
		LEVEL DESIGN
		[SEPARATOR]
		Davor Tomicic
		Davor Hunski
		Dean Sekulic
		ㅤ
		[SEPARATOR]
		MUSIC
		[SEPARATOR]
		Damjan Mravunac
		ㅤ
		[SEPARATOR]
		SOUND
		[SEPARATOR]
		Damjan Mravunac
		Roman Ribaric
		ㅤ
		[SEPARATOR]
		OTHER:
		[SEPARATOR]
		Serious Sam Voice by John J. Dick aka "Booger"
		ㅤ
		[SEPARATOR]
		SERIOUS DEATHMATCH:
		ㅤ
		[SEPARATOR]
		PROGRAMMING
		[SEPARATOR]
		upset
		wico.
		ㅤ
		[SEPARATOR]
		GAME ASSETS PORT
		[SEPARATOR]
		wico.
		ㅤ
		[SEPARATOR]
		GAMEMODE LOCALIZATION
		[SEPARATOR]
		wico.
		Erick_Maksimets
		ㅤ
		[SEPARATOR]	
		Serious Testing by
		[SEPARATOR]
		An mast, boblikutt, 
		DenDi85, denomito, 
		Erick_Maksimets, 
		Europa_Teles_BTR, 
		FosFor, Lo Stesso, 
		MakiSedo, RoboKnife, 
		Sereganeon, sigmadud, 
		Skitcher, Sokira, 
		Windows_TAHK, Winterskin
		ㅤ
		[SEPARATOR]		
		Special thanks goes to:
		[SEPARATOR]
		An mast 
		FosterZ
		GrechHerald
		pibab
		NextOrange2704TheSlayer
		omletus
		o u t l a w
		Windows_TAHK
		and all other Serious Deathmatch contributors.
		ㅤ
		[SEPARATOR]
		Thanks for the support.
		ㅤ
		[SEPARATOR]
		Mega serious special thanks goes to Stefano.
	]]

	local scrollPanel = vgui.Create("DPanel", CreditsMenu)
	scrollPanel:SetSize(ScrW(), ScrH())
	scrollPanel:SetPos(0, ScrH() * 0.01)
	scrollPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
	end
	
	scrollPanel.OnCursorEntered = function()
		scrollPanel:SetCursor("blank")
	end

	local creditsLabel = vgui.Create("DPanel", scrollPanel)

	local font = "Credits_Font_64"
	surface.SetFont(font)

	local function trim(s)
		return s:match("^%s*(.-)%s*$")
	end

	local lines = {}
	for line in creditsText:gmatch("[^\r\n]+") do
		table.insert(lines, trim(line))
	end

	local groups = {}
	local currentGroup = {}

	for _, line in ipairs(lines) do
		if line == "[SEPARATOR]" then
			if #currentGroup > 0 then
				table.insert(groups, currentGroup)
				currentGroup = {}
			end
		else
			table.insert(currentGroup, line)
		end
	end

	if #currentGroup > 0 then
		table.insert(groups, currentGroup)
	end

	local _, lineHeight = surface.GetTextSize("Ay")
	lineHeight = lineHeight + 5 -- add some padding
	local separatorHeight = 50

	local totalHeight = 0
	for i, group in ipairs(groups) do
		totalHeight = totalHeight + (#group * lineHeight)
		if i ~= #groups then
			totalHeight = totalHeight + separatorHeight
		end
	end

	creditsLabel:SetSize(scrollPanel:GetWide(), totalHeight)
	creditsLabel:SetPos(0, scrollPanel:GetTall())

	creditsLabel.Paint = function(self, w, h)
		local y = 0
		for i, group in ipairs(groups) do
			for _, line in ipairs(group) do
				draw.SimpleText(line, font, w / 2, y, color_white, TEXT_ALIGN_CENTER)
				y = y + lineHeight
			end
			if i ~= #groups then
				y = y + separatorHeight
			end
		end
	end
	
	creditsLabel.OnCursorEntered = function()
		creditsLabel:SetCursor("blank")
	end

	local scrollDuration = 70
	local startY = scrollPanel:GetTall()
	local endY = -creditsLabel:GetTall()

	local startTime = SysTime()

	CreditsMenu.Think = function(self)
		local elapsed = SysTime() - startTime
		local progress = elapsed / scrollDuration

		if progress > 1 then
			startTime = SysTime()
			progress = 0
		end

		local y = Lerp(progress, startY, endY)
		local x, _ = creditsLabel:GetPos()
		creditsLabel:SetPos(x, y)
	end
	
	local Back_Button = vgui.Create("DButton", CreditsMenu)
	local isFlashing = false
	Back_Button:SetText(" ")
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(color_white)
	
	Back_Button.Paint = function(self, w, h)
		if isFlashing then
			CreditsButtonFlashing(self)
		end
	end
	
	Back_Button.OnCursorEntered = function()
		Back_Button:SetCursor("blank")
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text = "#sdm_help_back"
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button:SetTextColor(color_white)
		text = ""
	end

	Back_Button.DoClick = function()
		CreditsMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
        if music then
			music:Stop()
			music = nil
		end
		RunConsoleCommand("sdm_music", stored_music_cvar)
		text = ""
	end
	
	Back_Button:SetSize(ScrW(), ScrH())
	Back_Button:Center()

	CreditsMenu.Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255)
		surface.SetTexture(stars01)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

function OpenQuitConfirmationMenu()
	showGameUI = true

	if GAMEMODE:GetHUDSkin() == 2 then
		ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
	end
	
	local DarkOverlayMenu = vgui.Create("DFrame")
	DarkOverlayMenu:SetTitle("")
	DarkOverlayMenu:SetSize(ScrW(), ScrH())
	DarkOverlayMenu:SetPos(0, 0)
	DarkOverlayMenu:MakePopup()
	DarkOverlayMenu:SetMouseInputEnabled(false)
	DarkOverlayMenu:SetKeyboardInputEnabled(false)
	DarkOverlayMenu:ShowCloseButton(false)
	
	DarkOverlayMenu.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 180))
	end

	ConfirmationMenu = vgui.Create("DFrame")
	ConfirmationMenu:SetSize(ScrW()/2.01, ScrH()/4.5)
	ConfirmationMenu:SetTitle("")
	ConfirmationMenu:SetVisible(true)
	ConfirmationMenu:SetDraggable(false)
	ConfirmationMenu:ShowCloseButton(false)
	ConfirmationMenu:Center()
	ConfirmationMenu:MakePopup()
	ConfirmationMenu.Think = nil
	ConfirmationMenu:SetCursor("blank")
	
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	YesButton:SetText("#sdm_yes")
	YesButton:SetFont("MainMenu_Font")
	YesButton:SetTextColor(GetButtonColor())
	
	YesButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	YesButton.OnCursorEntered = function()
		YesButton:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	YesButton.OnCursorExited = function()
		isFlashing = false
		YesButton:SetTextColor(GetButtonColor())
	end

	YesButton.DoClick = function()
		RunConsoleCommand("gamemenucommand", "quit")
		surface.PlaySound("menus/press.wav")
	end
	
	local w, h = ConfirmationMenu:GetSize()
	YesButton:SizeToContents()
	YesButton:SetX(w/2.45)
	YesButton:SetY(h-h/2)
	
	local NoButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	NoButton:SetText("#sdm_no")
	NoButton:SetFont("MainMenu_Font")
	NoButton:SetTextColor(GetButtonColor())
	
	NoButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	NoButton.OnCursorEntered = function()
		NoButton:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	NoButton.OnCursorExited = function()
		isFlashing = false
		NoButton:SetTextColor(GetButtonColor())
	end

	NoButton.DoClick = function()
		ConfirmationMenu:Close()
		DarkOverlayMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	local w, h = ConfirmationMenu:GetSize()
	NoButton:SizeToContents()
	NoButton:SetX(w/1.95)
	NoButton:SetY(h-h/2)
	
	ConfirmationMenu.Paint = function(self, w, h)
		local hudr, hudg, hudb = GetFrameMMFColor()

		local offsetX = math.sin(CurTime() * 1.5) * -22
		local offsetY = math.cos(CurTime() * 1.5) * -22
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
		
		surface.SetTexture(ssbg)
		local hudr, hudg, hudb = GAMEMODE:GetHUDBGColor()
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		local texW = 256
		local texH = 256
		
		if GAMEMODE:GetHUDSkin() == 2 then
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w-500, h-500, 0, 0, w / texW, h / texH )
		else
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
		end
		
		if GAMEMODE:GetHUDSkin() == 2 then
			surface.DrawTexturedRect(1,1,w-2,h-2)
		end
		
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		if GAMEMODE:GetHUDSkin() == 2 then 
			surface.SetDrawColor(0, 0, 0, 0)
		end
		local texW = 16
		local texH = 16
		surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, w / texW, h / texH )

		offset = offset + speed
		if offset > w then
			offset = 0
		end

		local texW = 256
		local texH = 128
		local offsetX = math.sin(CurTime() * 1.5) * 30
		local offsetY = math.cos(CurTime() * 1.5) * 30
		
		if GetConVarNumber("ss_hud_skin") == 2 then
			offsetX = math.sin(CurTime() * 1.5) * 10
			offsetY = math.cos(CurTime() * 1.5) * 10
		end
		
		surface.SetTexture(detailTexture_vtf)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		surface.DrawTexturedRectUV( offsetX-50, offsetY-50, w*4, h*4, 0, 0, w / texW, h / texH )

		draw.SimpleText("#sdm_areyouserious", "MainMenu_Font", w/2, h/3, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	DarkOverlayMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
	ConfirmationMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenStopConfirmationMenu()
	showGameUI = true

	if GAMEMODE:GetHUDSkin() == 2 then
		ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
	end
	
	local DarkOverlayMenu = vgui.Create("DFrame")
	DarkOverlayMenu:SetTitle("")
	DarkOverlayMenu:SetSize(ScrW(), ScrH())
	DarkOverlayMenu:SetPos(0, 0)
	DarkOverlayMenu:MakePopup()
	DarkOverlayMenu:SetMouseInputEnabled(false)
	DarkOverlayMenu:SetKeyboardInputEnabled(false)
	DarkOverlayMenu:ShowCloseButton(false)
	
	DarkOverlayMenu.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 180))
	end

	ConfirmationMenu = vgui.Create("DFrame")
	ConfirmationMenu:SetSize(ScrW()/2.01, ScrH()/4.5)
	ConfirmationMenu:SetTitle("")
	ConfirmationMenu:SetVisible(true)
	ConfirmationMenu:SetDraggable(false)
	ConfirmationMenu:ShowCloseButton(false)
	ConfirmationMenu:Center()
	ConfirmationMenu:MakePopup()
	ConfirmationMenu.Think = nil
	ConfirmationMenu:SetCursor("blank")
	
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	YesButton:SetText("#sdm_yes")
	YesButton:SetFont("MainMenu_Font")
	YesButton:SetTextColor(GetButtonColor())
	
	YesButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	YesButton.OnCursorEntered = function()
		YesButton:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	YesButton.OnCursorExited = function()
		isFlashing = false
		YesButton:SetTextColor(GetButtonColor())
	end

	YesButton.DoClick = function()
		RunConsoleCommand("disconnect")
		surface.PlaySound("menus/press.wav")
	end
	
	local w, h = ConfirmationMenu:GetSize()
	YesButton:SizeToContents()
	YesButton:SetX(w/2.45)
	YesButton:SetY(h-h/2)
	
	local NoButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	NoButton:SetText("#sdm_no")
	NoButton:SetFont("MainMenu_Font")
	NoButton:SetTextColor(GetButtonColor())
	
	NoButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	NoButton.OnCursorEntered = function()
		NoButton:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	NoButton.OnCursorExited = function()
		isFlashing = false
		NoButton:SetTextColor(GetButtonColor())
	end

	NoButton.DoClick = function()
		ConfirmationMenu:Close()
		DarkOverlayMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	local w, h = ConfirmationMenu:GetSize()
	NoButton:SizeToContents()
	NoButton:SetX(w/1.95)
	NoButton:SetY(h-h/2)
	
	ConfirmationMenu.Paint = function(self, w, h)
		local hudr, hudg, hudb = GetFrameMMFColor()
		local offsetX = math.sin(CurTime() * 1.5) * -22
		local offsetY = math.cos(CurTime() * 1.5) * -22
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
		
		surface.SetTexture(ssbg)
		local hudr, hudg, hudb = GAMEMODE:GetHUDBGColor()
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		local texW = 256
		local texH = 256
		
		if GAMEMODE:GetHUDSkin() == 2 then
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w-500, h-500, 0, 0, w / texW, h / texH )
		else
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
		end
		
		if GAMEMODE:GetHUDSkin() == 2 then
			surface.DrawTexturedRect(1,1,w-2,h-2)
		end
		
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		if GAMEMODE:GetHUDSkin() == 2 then 
			surface.SetDrawColor(0, 0, 0, 0)
		end
		local texW = 16
		local texH = 16
		surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, w / texW, h / texH )

		offset = offset + speed
		if offset > w then
			offset = 0
		end

		local texW = 256
		local texH = 128
		local offsetX = math.sin(CurTime() * 1.5) * 30
		local offsetY = math.cos(CurTime() * 1.5) * 30
		
		if GetConVarNumber("ss_hud_skin") == 2 then
			offsetX = math.sin(CurTime() * 1.5) * 10
			offsetY = math.cos(CurTime() * 1.5) * 10
		end
		
		surface.SetTexture(detailTexture_vtf)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		surface.DrawTexturedRectUV( offsetX-50, offsetY-50, w*4, h*4, 0, 0, w / texW, h / texH )

		draw.SimpleText("#sdm_areyouserious", "MainMenu_Font", w/2, h/3, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	DarkOverlayMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
	ConfirmationMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenSettingsMenu()	
	showGameUI = true
	
	SettingsMenu = vgui.Create("DFrame")
	SettingsMenu:SetSize(ScrW(), ScrH())
	SettingsMenu:Center()
	SettingsMenu:SetTitle("")
	SettingsMenu:ShowCloseButton( false )
	SettingsMenu:SetDraggable(false)
	SettingsMenu:MakePopup()
	SettingsMenu.Think = nil
	SettingsMenu:SetCursor("blank")
	
	local ModelBack = vgui.Create("DImage", SettingsMenu)
	ModelBack:SetX(ScrW()/1.5)
	ModelBack:SetY(ScrH()/6.85)
	ModelBack:SetSize(ScrW()/3.25+2, ScrW()/2.65+2)
	ModelBack.Paint = function(self, w, h)
		local offsetx = math.sin(CurTime() * 1.5) * 30
		local offsety = math.cos(CurTime()* 1.5) * 30
		
		local offsetx2 = math.sin(CurTime()* -0.5) * 15
		local offsety2 = math.cos(CurTime()* -0.5) * 15
		
		local hudr, hudg, hudb = GAMEMODE:GetHUDBGColor()
		
		if GAMEMODE:GetHUDSkin() == 2 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/ModelBack")
		elseif GAMEMODE:GetHUDSkin() == 1 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
		end
		
		surface.SetDrawColor(GAMEMODE:GetHUDColorFrame())
		surface.DrawRect(0, 0, ScrW()/3.25+2, ScrW()/2.65+2)
		surface.SetTexture( modelbg )
		surface.DrawTexturedRect( 1, 1, ScrW()/3.25, ScrW()/2.65 )
		
		if GAMEMODE:GetHUDSkin() == 2 then
			return
		elseif GAMEMODE:GetHUDSkin() == 1 then
			surface.SetTexture(ssbg)
		end
		
		surface.SetDrawColor(hudr, hudg, hudb, 60)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV( offsetx-48, offsety-48, 2048, 2048, 0, 0, 2048 / texW, 2048 / texH )
		
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		surface.DrawTexturedRectUV( offsetx2-48, offsety2-48, 1024, 1024, 0, 0, 2048 / texW, 2048 / texH )
	end
	
	local ModelFrame = vgui.Create( "DModelPanel", SettingsMenu )
	ModelFrame:SetSize(ScrW()/2.7,ScrW()/2.7)
	ModelFrame:SetModel( GetConVarString("sdm_playermodel") )
	ModelFrame:SetX(ScrW()/1.565)
	ModelFrame:SetY(ScrH()/6.25)
	
	function ModelFrame:LayoutEntity( Entity )		
		ModelFrame:RunAnimation()
		Entity:SetSequence(PoseAnimations[randompose])
		Entity:SetSkin(GetConVarNumber("sdm_playermodel_skin"))
		Entity:SetBodygroup(GetConVarString("sdm_playermodel_bodygroup"), 1)
		Entity:SetModel(GetConVarString("sdm_playermodel"))
	end

	ModelFrame.OnCursorEntered = function()
		ModelFrame:SetCursor("blank")
	end

	local PMSelect_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	PMSelect_Button:SetFont("MainMenu_Font_32")
	PMSelect_Button:SetText("#sdm_selectpm")
	PMSelect_Button:SetTextColor(GetButtonColor())
	PMSelect_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	PMSelect_Button.DoClick = function()
		surface.PlaySound("menus/press.wav")
		OpenModelMenu()	
	end
	
	PMSelect_Button.OnCursorEntered = function()
		PMSelect_Button:SetCursor( "blank" )
		text = "#sdm_help_pmselect"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	PMSelect_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		PMSelect_Button:SetTextColor(GetButtonColor())
	end
	
	PMSelect_Button:SizeToContents()
	local boundx, boundy, boundw, boundh = PMSelect_Button:GetBounds()
	PMSelect_Button:SetX(ScrW()/1.5)
	PMSelect_Button:SetY(ScrH()/1.215)

	local ModelButton = vgui.Create( "DButton", SettingsMenu )
	local isFlashing = false
	ModelButton:SetText( "" )
	ModelButton:SetPos( ScrW()/1.5, ScrH()/6.5 )
	ModelButton:SetSize( ScrW()/3.25, ScrW()/2.5 )					
	ModelButton.DoClick = function()
		surface.PlaySound("menus/press.wav")
		OpenModelMenu()
	end
	
	ModelButton.Paint = function(self, w, h)
		if isFlashing then
			ButtonFlashing(PMSelect_Button)
		end
	end

	ModelButton.OnCursorEntered = function()
		ModelButton:SetCursor("blank")
		text = "#sdm_help_pmselect"
		surface.PlaySound("menus/select.wav")
		isFlashing = true
	end
	
	ModelButton.OnCursorExited = function()
		text = ""
		isFlashing = false
		PMSelect_Button:SetTextColor(GetButtonColor())
	end
	
	local Music_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Music_Button:SetFont("MainMenu_Font")
	Music_Button:SetText("#sdm_mvolume")
	Music_Button:SetTextColor(GetButtonColor())
	Music_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Music_Button.OnCursorEntered = function()
		Music_Button:SetCursor( "blank" )
		text = "#sdm_help_mvolume"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Music_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Music_Button:SetTextColor(GetButtonColor())
	end
	Music_Button:SizeToContents()
	Music_Button:Center()
	Music_Button:SetY(ScrH()/4.15)
	
	function SKIN:PaintNumSlider( panel, w, h )
	panel:SetCursor("blank")
		return false
	end

	local Music_Volume = vgui.Create( "DNumSlider", SettingsMenu )
	Music_Volume:SetX(ScrW()/2.33)
	Music_Volume:SetY(ScrH() / 3.2)
	Music_Volume:SetSize( ScrW()/7.1, ScrH()/22 )
	Music_Volume:SetText( "" )
	Music_Volume:SetMin( 0 )
	Music_Volume:SetMax( 1 )
	Music_Volume:SetDecimals( 2 )
	Music_Volume:SetConVar( "sdm_music" )
	Music_Volume:SetValue( cvar_music:GetFloat() )

	Music_Volume.Label:SetVisible(false)
	Music_Volume.TextArea:SetVisible(false)
	Music_Volume.Slider.Knob.Paint = function(self)
		self:SetCursor("blank")
	end
	Music_Volume.Slider.Paint = function(self)
		self:SetCursor("blank")
	end
	
	Music_Volume.Paint = function(self, w, h)
		local number = Music_Volume.TextArea:GetText()
		Music_Volume:SetCursor( "blank" )
		surface.SetDrawColor(GetFrameMMFColor())
		surface.DrawOutlinedRect(0,0,w,h)
		local hudr,hudg,hudb = GetMMFColor()
		surface.SetDrawColor(hudr-35,hudg-35,hudb-35, 200)
		surface.DrawRect(1,1,number*w-2,h-2)
		draw.SimpleText( (number*100).."%", "MainMenu_font_small", w/2,-1, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER )
	end
	
	local Bob_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GetConVarNumber("ss_bob") == 0 then
		Bob_Button:SetText("#sdm_enablebob")
	elseif GetConVarNumber("ss_bob") == 1 then
		Bob_Button:SetText("#sdm_disablebob")
	end
	Bob_Button:SetFont("MainMenu_Font")
	Bob_Button:SetTextColor(GetButtonColor())

	Bob_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Bob_Button.DoClick = function()
		local cvar = GetConVar("ss_bob")
		if cvar then
			local state = cvar:GetInt()
			if state == 0 then
				RunConsoleCommand("ss_bob", "1")
				Bob_Button:SetText("#sdm_disablebob")
				text = "#sdm_help_disablebob"
				Bob_Button:SizeToContents()
			elseif state == 1 then
				RunConsoleCommand("ss_bob", "0")
				Bob_Button:SetText("#sdm_enablebob")
				text = "#sdm_help_enablebob"
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Bob_Button.OnCursorEntered = function()
	Bob_Button:SetCursor( "blank" )
	if GetConVar("ss_bob"):GetInt() == 1 then
		text = "#sdm_help_disablebob"
	elseif GetConVar("ss_bob"):GetInt() == 0 then
		text = "#sdm_help_enablebob"
	end
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Bob_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Bob_Button:SetTextColor(GetButtonColor())
	end
	
	Bob_Button:SizeToContents()
	Bob_Button:Center()
	Bob_Button:SetY(ScrH()/2.7)

	local Crosshair_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Crosshair_Button:SetText("#sdm_crosshair")
	Crosshair_Button:SetFont("MainMenu_Font")
	Crosshair_Button:SetTextColor(GetButtonColor())
	
	Crosshair_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	Crosshair_Button.OnCursorEntered = function()
		Crosshair_Button:SetCursor( "blank" )
		text = "#sdm_help_crosshair"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Crosshair_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Crosshair_Button:SetTextColor(GetButtonColor())
	end
	
	Crosshair_Button:SizeToContents()
	Crosshair_Button:Center()
	Crosshair_Button:SetY(ScrH()/2.28)
	
	local Crosshair_Image = vgui.Create("DImage", SettingsMenu)
	Crosshair_Image:SetX(ScrW()/2.075)
	Crosshair_Image:SetY(ScrH()/1.975)
	Crosshair_Image:SetSize(ScrW()/32, ScrW() / 32)
	
	if GetConVarNumber("ss_crosshair") < 0 then
		Crosshair_Image:SetImage("vgui/serioussam/CrosshairError")
	else
		Crosshair_Image:SetImage("vgui/serioussam/Crosshair".. GetConVarNumber("ss_crosshair"))
	end
	
	local Forward_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Forward_Button:SetText(">")
	Forward_Button:SetFont("MainMenu_Font")
	Forward_Button:SetTextColor(GetButtonColor())

	Forward_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Forward_Button.DoClick = function()
	surface.PlaySound("menus/press.wav")
		local crosshair_value = GetConVarNumber("ss_crosshair") + 1
		if crosshair_value > 7 then
			return false
		else
			RunConsoleCommand("ss_crosshair", crosshair_value)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_value)
		end
	end
	
	Forward_Button.OnCursorEntered = function()
		Forward_Button:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Forward_Button.OnCursorExited = function()
		isFlashing = false
		Forward_Button:SetTextColor(GetButtonColor())
	end
	
	Forward_Button:SizeToContents()
	Forward_Button:SetX(ScrW()/1.9)
	Forward_Button:SetY(ScrH()/2)

	
	local Backwards_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Backwards_Button:SetText("<")
	Backwards_Button:SetFont("MainMenu_Font")
	Backwards_Button:SetTextColor(GetButtonColor())
	
	Backwards_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	
	Backwards_Button.DoClick = function()
		surface.PlaySound("menus/press.wav")
		local crosshair_value = GetConVarNumber("ss_crosshair") - 1
		if crosshair_value < 0 then
			return false
		else
			RunConsoleCommand("ss_crosshair", crosshair_value)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_value)
		end	
	end
	
	Backwards_Button.OnCursorEntered = function()
		Backwards_Button:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Backwards_Button.OnCursorExited = function()
		isFlashing = false
		Backwards_Button:SetTextColor(GetButtonColor())
	end
	
	Backwards_Button:SizeToContents()
	Backwards_Button:SetX(ScrW()/2.189)
	Backwards_Button:SetY(ScrH()/2)
	
	
	local HUD_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GAMEMODE:GetHUDSkin() == 2 then
		HUD_Button:SetText("#sdm_tfehud")
	elseif GAMEMODE:GetHUDSkin() == 1 then
		HUD_Button:SetText("#sdm_tsehud")
	end
	HUD_Button:SetFont("MainMenu_Font")
	HUD_Button:SetTextColor(GetButtonColor())

	HUD_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	HUD_Button.DoClick = function()
		local cvar = GetConVar("ss_hud_skin")
		if cvar then
			local skin = cvar:GetInt()
			local children = SettingsMenu:GetChildren()
			table.Add(children, EscMenu:GetChildren())
			if skin == 2 then
				RunConsoleCommand("ss_hud_skin", "1")
				HUD_Button:SetText("#sdm_tsehud")
				UpdateButtonsSkin(children, 1)
				text = "#sdm_help_tsehud"
			elseif skin == 1 then
				RunConsoleCommand("ss_hud_skin", "2")	
				HUD_Button:SetText("#sdm_tfehud")
				UpdateButtonsSkin(children, 2)
				text = "#sdm_help_tfehud"
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	HUD_Button.OnCursorEntered = function()
	HUD_Button:SetCursor( "blank" )
	if GetConVar("ss_hud_skin"):GetInt() == 2 then
		text = "#sdm_help_tfehud"
	elseif GetConVar("ss_hud_skin"):GetInt() == 1 then
		text = "#sdm_help_tsehud"
	end
		isFlashing = true 
		surface.PlaySound("menus/select.wav")
	end

	HUD_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		HUD_Button:SetTextColor(GetButtonColor())
	end

	HUD_Button:SizeToContents()
	HUD_Button:Center()
	HUD_Button:SetY(ScrH()/1.75)
	
	
	--[[
	local HUD_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GAMEMODE:GetHUDSkin() == 2 then
		HUD_Button:SetText("#sdm_tfehud")
	elseif GAMEMODE:GetHUDSkin() == 1 then
		HUD_Button:SetText("#sdm_tsehud")
	end
	HUD_Button:SetFont("MainMenu_Font")
	HUD_Button:SetTextColor(GetButtonColor())

	HUD_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	HUD_Button.DoClick = function()
		local cvar = GetConVar("ss_hud_skin")
		if cvar then
			local skin = cvar:GetInt()
			local children = SettingsMenu:GetChildren()
			table.Add(children, EscMenu:GetChildren())
			if skin == 2 then
				RunConsoleCommand("ss_hud_skin", "1")
				HUD_Button:SetText("#sdm_tsehud")
				UpdateButtonsSkin(children, 1)
				text = "#sdm_help_tsehud"
			elseif skin == 1 then
				RunConsoleCommand("ss_hud_skin", "2")	
				HUD_Button:SetText("#sdm_tfehud")
				UpdateButtonsSkin(children, 2)
				text = "#sdm_help_tfehud"
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	HUD_Button.OnCursorEntered = function()
	HUD_Button:SetCursor( "blank" )
	if GetConVar("ss_hud_skin"):GetInt() == 2 then
		text = "#sdm_help_tfehud"
	elseif GetConVar("ss_hud_skin"):GetInt() == 1 then
		text = "#sdm_help_tsehud"
	end
		isFlashing = true 
		surface.PlaySound("menus/select.wav")
	end

	HUD_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		HUD_Button:SetTextColor(GetButtonColor())
	end

	HUD_Button:SizeToContents()
	HUD_Button:Center()
	HUD_Button:SetY(ScrH()/1.75)
	--]]

	local TFE_Color_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	TFE_Color_Button:SetText("#sdm_tfehudcolor")
	TFE_Color_Button:SetFont("MainMenu_Font")
	TFE_Color_Button:SetTextColor(GetButtonColor())

	TFE_Color_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	TFE_Color_Button.OnCursorEntered = function()
		TFE_Color_Button:SetCursor("blank")
		text = "#sdm_help_tfehudcolor"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	TFE_Color_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		TFE_Color_Button:SetTextColor(GetButtonColor())
	end
	
	TFE_Color_Button:SizeToContents()
	TFE_Color_Button:Center()
	TFE_Color_Button:SetY(ScrH()/1.57)

	local Back_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Back_Button:SetText("#sdm_back")
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(GetButtonColor())
	Back_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Back_Button.OnCursorEntered = function()
		Back_Button:SetCursor("blank")
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text = "#sdm_help_back"
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button:SetTextColor(GetButtonColor())
		text = ""
	end

	Back_Button.DoClick = function()
		text = ""
		SettingsMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH()/10)

	local TFE_Color_Mixer = vgui.Create("DColorMixer", SettingsMenu)
	TFE_Color_Mixer:SetSize(ScrW()/10, ScrH()/10)
	TFE_Color_Mixer:Center()
	TFE_Color_Mixer:SetY(ScrH()/1.4)
	TFE_Color_Mixer:SetPalette(false)
	TFE_Color_Mixer:SetAlphaBar(false)
	TFE_Color_Mixer:SetWangs(true)
	TFE_Color_Mixer:SetColor(Color(30,100,160))
	TFE_Color_Mixer:SetConVarR("ss_hud_color_r")
	TFE_Color_Mixer:SetConVarG("ss_hud_color_g")
	TFE_Color_Mixer:SetConVarB("ss_hud_color_b")
	TFE_Color_Mixer:SetCursor("blank")
	
	TFE_Color_Mixer.txtR.OnCursorEntered = function()
		TFE_Color_Mixer.txtR:SetCursor("blank")
	end
	
	TFE_Color_Mixer.txtG.OnCursorEntered = function()
		TFE_Color_Mixer.txtG:SetCursor("blank")
	end
	
	TFE_Color_Mixer.txtB.OnCursorEntered = function()
		TFE_Color_Mixer.txtB:SetCursor("blank")
	end
	
	TFE_Color_Mixer.HSV.OnCursorEntered = function()
		TFE_Color_Mixer.HSV:SetCursor("blank")
	end
	
	TFE_Color_Mixer.RGB.OnCursorEntered = function()
		TFE_Color_Mixer.RGB:SetCursor("blank")
	end
	
	TFE_Color_Mixer.Alpha.OnCursorEntered = function()
		TFE_Color_Mixer.Alpha:SetCursor("blank")
	end
	
	TFE_Color_Mixer.WangsPanel.OnCursorEntered = function()
		TFE_Color_Mixer.WangsPanel:SetCursor("blank")
	end
	
	local children = SettingsMenu:GetChildren()
	table.Add(children, EscMenu:GetChildren())
	TFE_Color_Mixer.ValueChanged = function(self, col)
	
	if GAMEMODE:GetHUDSkin() == 2 then return false end
		UpdateButtonsColor(children, col)
	end
	
	SettingsMenu:MakePopup()
    
	SettingsMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_options", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH() - ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	SettingsMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
end

function OpenModelMenu()

	text = ""
	
	local inital_model = GetConVar("sdm_playermodel"):GetString()
	local inital_skin = GetConVar("sdm_playermodel_skin"):GetInt()
	local inital_bodygroup = GetConVar("sdm_playermodel_bodygroup"):GetInt()
	
	ModelMenu = vgui.Create("DFrame")
	ModelMenu:SetSize(ScrW(), ScrH())
	ModelMenu:Center()
	ModelMenu:SetTitle("")
	ModelMenu:ShowCloseButton( false )
	ModelMenu:SetDraggable(false)
	ModelMenu:MakePopup()
	ModelMenu.Think = nil
	ModelMenu:SetCursor("blank")

	local Back_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Back_Button:SetText("#sdm_back")
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(GetButtonColor())
	Back_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Back_Button.OnCursorEntered = function()
		Back_Button:SetCursor("blank")
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text = "#sdm_help_back"
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button:SetTextColor(GetButtonColor())
		text = ""
	end

	Back_Button.DoClick = function()
		text = ""
		ModelMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end

	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH()/10)

	local ModelBack = vgui.Create("DImage", ModelMenu)
	ModelBack:SetX(ScrW()/1.5)
	ModelBack:SetY(ScrH()/6.85)
	ModelBack:SetSize(ScrW()/3.25+2, ScrW()/2.5+2)
	ModelBack.Paint = function(self, w, h)
		local offsetx = math.sin(CurTime() * 1.5) * 30
		local offsety = math.cos(CurTime()* 1.5) * 30
		
		local offsetx2 = math.sin(CurTime()* -0.5) * 15
		local offsety2 = math.cos(CurTime()* -0.5) * 15
	
		local hudr, hudg, hudb = GAMEMODE:GetHUDBGColor()
		
		if GAMEMODE:GetHUDSkin() == 2 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/ModelBack")
		elseif GAMEMODE:GetHUDSkin() == 1 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
		end
		
		surface.SetDrawColor(GAMEMODE:GetHUDColorFrame())
		surface.DrawRect(0, 0, ScrW()/3.25+2, ScrW()/2.5+2)
		surface.SetTexture( modelbg )
		surface.DrawTexturedRect( 1, 1, ScrW()/3.25, ScrW()/2.5 )
		
		if GAMEMODE:GetHUDSkin() == 2 then
			return
		elseif GAMEMODE:GetHUDSkin() == 1 then
			surface.SetTexture(ssbg)
		end
		
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV( offsetx-48, offsety-48, 2048, 2048, 0, 0, 2048 / texW, 2048 / texH )
		
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		surface.DrawTexturedRectUV( offsetx2-48, offsety2-48, 1024, 1024, 0, 0, 2048 / texW, 2048 / texH )
	end
	
	local ModelFrame = vgui.Create( "DModelPanel", ModelMenu )
	ModelFrame:SetSize(ScrW()/2.7,ScrW()/2.7)
	ModelFrame:SetModel( GetConVarString("sdm_playermodel") )
	ModelFrame:SetX(ScrW()/1.565)
	ModelFrame:SetY(ScrH()/6.25)
	
	function ModelFrame:LayoutEntity( Entity )		
		ModelFrame:RunAnimation()
		Entity:SetSequence(PoseAnimations[randompose])
		Entity:SetSkin(GetConVarNumber("sdm_playermodel_skin"))
		Entity:SetBodygroup(GetConVarString("sdm_playermodel_bodygroup"), 1)
		Entity:SetModel(GetConVarString("sdm_playermodel"))
	end

	ModelFrame.OnCursorEntered = function()
		ModelFrame:SetCursor("blank")
	end

	--Beheaded Ben
	local Beheaded_Ben_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Beheaded_Ben_Button:SetFont("MainMenu_Font_Models")
	Beheaded_Ben_Button:SetText("#sdm_beheadedben")
	Beheaded_Ben_Button:SetTextColor(GetButtonColor())
	Beheaded_Ben_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Beheaded_Ben_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/beheadedben.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)		
		
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		
		Beheaded_Ben_Button:SetCursor( "blank" )
		text = "#sdm_help_beheadedben"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end
	
	Beheaded_Ben_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Beheaded_Ben_Button:SetTextColor(GetButtonColor())
	end
	
	Beheaded_Ben_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/beheadedben.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/beheadedben.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Beheaded_Ben_Button:SizeToContents()
	Beheaded_Ben_Button:Center()
	Beheaded_Ben_Button:SetY(ScrH() / 11)
	
	--Blue Bill
	local Blue_Bill_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Blue_Bill_Button:SetFont("MainMenu_Font_Models")
	Blue_Bill_Button:SetText("#sdm_bluebill")
	Blue_Bill_Button:SetTextColor(GetButtonColor())
	Blue_Bill_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Blue_Bill_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Blue_Bill_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots1"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Blue_Bill_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Blue_Bill_Button:SetTextColor(GetButtonColor())
	end
	
	Blue_Bill_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("1")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Blue_Bill_Button:SizeToContents()
	Blue_Bill_Button:Center()
	Blue_Bill_Button:SetY(ScrH() / 7.95)
	
	--Boxer Barry
	local Boxer_Barry_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Boxer_Barry_Button:SetFont("MainMenu_Font_Models")
	Boxer_Barry_Button:SetText("#sdm_boxerbarry")
	Boxer_Barry_Button:SetTextColor(GetButtonColor())
	Boxer_Barry_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Boxer_Barry_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/boxerbarry.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Boxer_Barry_Button:SetCursor( "blank" )
		text = "#sdm_help_boxerbarry"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Boxer_Barry_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Boxer_Barry_Button:SetTextColor(GetButtonColor())
	end
	
	Boxer_Barry_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/boxerbarry.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/boxerbarry.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Boxer_Barry_Button:SizeToContents()
	Boxer_Barry_Button:Center()
	Boxer_Barry_Button:SetY(ScrH() / 6.25) -- 1.3125
	
	--Commander Cliff
	local Comm_Cliff_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Comm_Cliff_Button:SetFont("MainMenu_Font_Models")
	Comm_Cliff_Button:SetText("#sdm_commcliff")
	Comm_Cliff_Button:SetTextColor(GetButtonColor())
	Comm_Cliff_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Comm_Cliff_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(2)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Comm_Cliff_Button:SetCursor( "blank" )
		text = "#sdm_help_commcliff"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Comm_Cliff_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Comm_Cliff_Button:SetTextColor(GetButtonColor())
	end
	
	Comm_Cliff_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/skinlessstan.mdl")
		net.WriteString("2")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(2)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Comm_Cliff_Button:SizeToContents()
	Comm_Cliff_Button:Center()
	Comm_Cliff_Button:SetY(ScrH() / 5.125) -- 6
	
	--Dancing Denzell
	local Dancing_Den_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Dancing_Den_Button:SetFont("MainMenu_Font_Models")
	Dancing_Den_Button:SetText("#sdm_dancingden")
	Dancing_Den_Button:SetTextColor(GetButtonColor())
	Dancing_Den_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Dancing_Den_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/dancingden.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Dancing_Den_Button:SetCursor( "blank" )
		text = "#sdm_help_dancingden"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Dancing_Den_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Dancing_Den_Button:SetTextColor(GetButtonColor())
	end
	
	Dancing_Den_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/dancingden.mdl")
		net.WriteString("1")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/dancingden.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Dancing_Den_Button:SizeToContents()
	Dancing_Den_Button:Center()
	Dancing_Den_Button:SetY(ScrH() / 4.35)
	
	--FastFinger Freddy
	local FastFinger_Freddy_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	FastFinger_Freddy_Button:SetFont("MainMenu_Font_Models")
	FastFinger_Freddy_Button:SetText("#sdm_fastfingerfreddy")
	FastFinger_Freddy_Button:SetTextColor(GetButtonColor())
	FastFinger_Freddy_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	FastFinger_Freddy_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/fastfingerfreddy.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		FastFinger_Freddy_Button:SetCursor( "blank" )
		text = "#sdm_help_fastfingerfreddy"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	FastFinger_Freddy_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		FastFinger_Freddy_Button:SetTextColor(GetButtonColor())
	end
	
	FastFinger_Freddy_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/fastfingerfreddy.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/fastfingerfreddy.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	FastFinger_Freddy_Button:SizeToContents()
	FastFinger_Freddy_Button:Center()
	FastFinger_Freddy_Button:SetY(ScrH() / 3.775) -- 1.2
	
	--Green Gary
	local Green_Gary_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Green_Gary_Button:SetFont("MainMenu_Font_Models")
	Green_Gary_Button:SetText("#sdm_greengary")
	Green_Gary_Button:SetTextColor(GetButtonColor())
	Green_Gary_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Green_Gary_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(2)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Green_Gary_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots1"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Green_Gary_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Green_Gary_Button:SetTextColor(GetButtonColor())
	end
	
	Green_Gary_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("2")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(2)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Green_Gary_Button:SizeToContents()
	Green_Gary_Button:Center()
	Green_Gary_Button:SetY(ScrH() / 3.325)
	
	--Groovy Greg
	local Groovy_Greg_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Groovy_Greg_Button:SetFont("MainMenu_Font_Models")
	Groovy_Greg_Button:SetText("#sdm_groovygreg")
	Groovy_Greg_Button:SetTextColor(GetButtonColor())
	Groovy_Greg_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Groovy_Greg_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/dancingden.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Groovy_Greg_Button:SetCursor( "blank" )
		text = "#sdm_help_groovygreg"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Groovy_Greg_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Groovy_Greg_Button:SetTextColor(GetButtonColor())
	end
	
	Groovy_Greg_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/dancingden.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/dancingden.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Groovy_Greg_Button:SizeToContents()
	Groovy_Greg_Button:Center()
	Groovy_Greg_Button:SetY(ScrH() / 2.985)
	
	--Hilarious Harry
	local Hilly_Harry_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Hilly_Harry_Button:SetFont("MainMenu_Font_Models")
	Hilly_Harry_Button:SetText("#sdm_hillyharry")
	Hilly_Harry_Button:SetTextColor(GetButtonColor())
	Hilly_Harry_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Hilly_Harry_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/hillyharry.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Hilly_Harry_Button:SetCursor( "blank" )
		text = "#sdm_help_hillyharry"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Hilly_Harry_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Hilly_Harry_Button:SetTextColor(GetButtonColor())
	end
	
	Hilly_Harry_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/hillyharry.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/hillyharry.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Hilly_Harry_Button:SizeToContents()
	Hilly_Harry_Button:Center()
	Hilly_Harry_Button:SetY(ScrH() / 2.705)
	
	--Karate Ken
	local Karate_Ken_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Karate_Ken_Button:SetFont("MainMenu_Font_Models")
	Karate_Ken_Button:SetText("#sdm_karateken")
	Karate_Ken_Button:SetTextColor(GetButtonColor())
	Karate_Ken_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Karate_Ken_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Karate_Ken_Button:SetCursor( "blank" )
		text = "#sdm_help_karateken"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Karate_Ken_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Karate_Ken_Button:SetTextColor(GetButtonColor())
	end
	
	Karate_Ken_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/skinlessstan.mdl")
		net.WriteString("1")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Karate_Ken_Button:SizeToContents()
	Karate_Ken_Button:Center()
	Karate_Ken_Button:SetY(ScrH() / 2.475)
	
	--Kleer Kurt
	local Kleer_Kurt_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Kleer_Kurt_Button:SetFont("MainMenu_Font_Models")
	Kleer_Kurt_Button:SetText("#sdm_kleerkurt")
	Kleer_Kurt_Button:SetTextColor(GetButtonColor())
	Kleer_Kurt_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Kleer_Kurt_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/kleerkurt.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Kleer_Kurt_Button:SetCursor( "blank" )
		text = "#sdm_help_kleerkurt"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Kleer_Kurt_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Kleer_Kurt_Button:SetTextColor(GetButtonColor())
	end
	
	Kleer_Kurt_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/kleerkurt.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/kleerkurt.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Kleer_Kurt_Button:SizeToContents()
	Kleer_Kurt_Button:Center()
	Kleer_Kurt_Button:SetY(ScrH() / 2.275)
	
	-- Mental Mate
	local Mental_Mate_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Mental_Mate_Button:SetFont("MainMenu_Font_Models")
	Mental_Mate_Button:SetText("#sdm_mentalmate")
	Mental_Mate_Button:SetTextColor(GetButtonColor())
	Mental_Mate_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Mental_Mate_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_mental.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Mental_Mate_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Mental_Mate_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Mental_Mate_Button:SetTextColor(GetButtonColor())
	end
	
	Mental_Mate_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic_mental.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_mental.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Mental_Mate_Button:SizeToContents()
	Mental_Mate_Button:Center()
	Mental_Mate_Button:SetY(ScrH() / 2.105) -- 2.095
	
	--Mighty Marvin
	local Mighty_Marvin_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Mighty_Marvin_Button:SetFont("MainMenu_Font_Models")
	Mighty_Marvin_Button:SetText("#sdm_mightymarvin")
	Mighty_Marvin_Button:SetTextColor(GetButtonColor())
	Mighty_Marvin_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Mighty_Marvin_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/mightymarvin.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Mighty_Marvin_Button:SetCursor( "blank" )
		text = "#sdm_help_mightymarvin"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Mighty_Marvin_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Mighty_Marvin_Button:SetTextColor(GetButtonColor())
	end
	
	Mighty_Marvin_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/mightymarvin.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/mightymarvin.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Mighty_Marvin_Button:SizeToContents()
	Mighty_Marvin_Button:Center()
	Mighty_Marvin_Button:SetY(ScrH() / 1.955) -- 1.255
	
	--Pirate Pete
	local Pirate_Pete_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Pirate_Pete_Button:SetFont("MainMenu_Font_Models")
	Pirate_Pete_Button:SetText("#sdm_piratepete")
	Pirate_Pete_Button:SetTextColor(GetButtonColor())
	Pirate_Pete_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Pirate_Pete_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_pirate.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Pirate_Pete_Button:SetCursor( "blank" )
		text = "#sdm_help_piratepete"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Pirate_Pete_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Pirate_Pete_Button:SetTextColor(GetButtonColor())
	end
	
	Pirate_Pete_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic_pirate.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_pirate.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Pirate_Pete_Button:SizeToContents()
	Pirate_Pete_Button:Center()
	Pirate_Pete_Button:SetY(ScrH() / 1.825) -- 2.275
	
	--Red Rick
	local Red_Rick_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Red_Rick_Button:SetFont("MainMenu_Font_Models")
	Red_Rick_Button:SetText("#sdm_redrick")
	Red_Rick_Button:SetTextColor(GetButtonColor())
	Red_Rick_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Red_Rick_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Red_Rick_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots2"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Red_Rick_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Red_Rick_Button:SetTextColor(GetButtonColor())
	end
	
	Red_Rick_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Red_Rick_Button:SizeToContents()
	Red_Rick_Button:Center()
	Red_Rick_Button:SetY(ScrH() / 1.715) -- 2.095
	
	--Rocking Ryan
	local Rocking_Ryan_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Rocking_Ryan_Button:SetFont("MainMenu_Font_Models")
	Rocking_Ryan_Button:SetText("#sdm_rockingryan")
	Rocking_Ryan_Button:SetTextColor(GetButtonColor())
	Rocking_Ryan_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Rocking_Ryan_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/rockingryan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Rocking_Ryan_Button:SetCursor( "blank" )
		text = "#sdm_help_rockingryan"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Rocking_Ryan_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Rocking_Ryan_Button:SetTextColor(GetButtonColor())
	end
	
	Rocking_Ryan_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/rockingryan.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/rockingryan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Rocking_Ryan_Button:SizeToContents()
	Rocking_Ryan_Button:Center()
	Rocking_Ryan_Button:SetY(ScrH() / 1.6225) -- 1.15
	
	--Santa Sam
	local Santa_Sam_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Santa_Sam_Button:SetFont("MainMenu_Font_Models")
	Santa_Sam_Button:SetText("#sdm_santasam")
	Santa_Sam_Button:SetTextColor(GetButtonColor())
	Santa_Sam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Santa_Sam_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_santa.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Santa_Sam_Button:SetCursor( "blank" )
		text = "#sdm_help_santasam"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Santa_Sam_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Santa_Sam_Button:SetTextColor(GetButtonColor())
	end
	
	Santa_Sam_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic_santa.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_santa.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Santa_Sam_Button:SizeToContents()
	Santa_Sam_Button:Center()
	Santa_Sam_Button:SetY(ScrH() / 1.535) -- 1.95
	
	--Skinless Stan
	local Skinless_Stan_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Skinless_Stan_Button:SetFont("MainMenu_Font_Models")
	Skinless_Stan_Button:SetText("#sdm_skinlessstan")
	Skinless_Stan_Button:SetTextColor(GetButtonColor())
	Skinless_Stan_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Skinless_Stan_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Skinless_Stan_Button:SetCursor( "blank" )
		text = "#sdm_help_skinlessstan"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Skinless_Stan_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Skinless_Stan_Button:SetTextColor(GetButtonColor())
	end
	
	Skinless_Stan_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/skinlessstan.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Skinless_Stan_Button:SizeToContents()
	Skinless_Stan_Button:Center()
	Skinless_Stan_Button:SetY(ScrH() / 1.46) -- 1.825
	
	--Stainless Steve
	local Steel_Steve_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Steel_Steve_Button:SetFont("MainMenu_Font_Models")
	Steel_Steve_Button:SetText("#sdm_steelsteve")
	Steel_Steve_Button:SetTextColor(GetButtonColor())
	Steel_Steve_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Steel_Steve_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/steelsteve.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Steel_Steve_Button:SetCursor( "blank" )
		text = "#sdm_help_steelsteve"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Steel_Steve_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Steel_Steve_Button:SetTextColor(GetButtonColor())
	end
	
	Steel_Steve_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/steelsteve.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/steelsteve.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Steel_Steve_Button:SizeToContents()
	Steel_Steve_Button:Center()
	Steel_Steve_Button:SetY(ScrH() / 1.385) -- 1.715
	
	--TFE Sam
	local Sam_TFE_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_TFE_Button:SetFont("MainMenu_Font_Models")
	Sam_TFE_Button:SetText("#sdm_tfeserioussam")
	Sam_TFE_Button:SetTextColor(GetButtonColor())
	Sam_TFE_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Sam_TFE_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_tfe.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Sam_TFE_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Sam_TFE_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Sam_TFE_Button:SetTextColor(GetButtonColor())
	end
	
	Sam_TFE_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic_tfe.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic_tfe.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Sam_TFE_Button:SizeToContents()
	Sam_TFE_Button:Center()
	Sam_TFE_Button:SetY(ScrH() / 1.315) -- 1.615
	
	--TSE Sam
	local Sam_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_Button:SetFont("MainMenu_Font_Models")
	Sam_Button:SetText("#sdm_tseserioussam")
	Sam_Button:SetTextColor(GetButtonColor())
	Sam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Sam_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		Sam_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
	end

	Sam_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Sam_Button:SetTextColor(GetButtonColor())
	end
	
	Sam_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("0")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Sam_Button:SizeToContents()
	Sam_Button:Center()
	Sam_Button:SetY(ScrH() / 1.2555) -- 1.525
	
	--Vegetable Vaughn
	local Veggie_Vaughn_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Veggie_Vaughn_Button:SetFont("MainMenu_Font_Models")
	Veggie_Vaughn_Button:SetText("#sdm_veggievaughn")
	Veggie_Vaughn_Button:SetTextColor(GetButtonColor())
	Veggie_Vaughn_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Veggie_Vaughn_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Veggie_Vaughn_Button:SetCursor( "blank" )
		text = "#sdm_help_veggievaughn"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Veggie_Vaughn_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Veggie_Vaughn_Button:SetTextColor(GetButtonColor())
	end
	
	Veggie_Vaughn_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/skinlessstan.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/skinlessstan.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Veggie_Vaughn_Button:SizeToContents()
	Veggie_Vaughn_Button:Center()
	Veggie_Vaughn_Button:SetY(ScrH() / 1.2025) -- 1.4475
	
	--Yellow Yarek
	local Yellow_Yarek_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Yellow_Yarek_Button:SetFont("MainMenu_Font_Models")
	Yellow_Yarek_Button:SetText("#sdm_yellowyarek")
	Yellow_Yarek_Button:SetTextColor(GetButtonColor())
	Yellow_Yarek_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Yellow_Yarek_Button.OnCursorEntered = function()
		randompose = math.random(1, #PoseAnimations)
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		Yellow_Yarek_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots2"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Yellow_Yarek_Button.OnCursorExited = function()
		GetConVar("sdm_playermodel"):SetString(inital_model)
		GetConVar("sdm_playermodel_skin"):SetInt(inital_skin)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(inital_bodygroup)
		text = ""
		isFlashing = false
		Yellow_Yarek_Button:SetTextColor(GetButtonColor())
	end
	
	Yellow_Yarek_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("3")
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			net.WriteString("0")
		else
			net.WriteString("1")
		end
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(3)
		if GetConVar("sdm_holiday"):GetInt() == 0 then
			GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		else
			GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		end
		surface.PlaySound("menus/press.wav")
		ModelMenu:Close()
	end
	
	Yellow_Yarek_Button:SizeToContents()
	Yellow_Yarek_Button:Center()
	Yellow_Yarek_Button:SetY(ScrH() / 1.15) -- 1.375
	
	ModelMenu:MakePopup()
    
	ModelMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_pmselect", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH() - ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	ModelMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
end

hook.Add( "OnPauseMenuShow", "SSMenu", function()
	if not showGameUI then
		showGameUI = true
		OpenSSMenu()
	end
	if input.IsKeyDown(KEY_ESCAPE) and SettingsMenu and SettingsMenu:IsVisible() then
		SettingsMenu:Close()
	end
	
	if input.IsKeyDown(KEY_ESCAPE) and ModelMenu and ModelMenu:IsVisible() then
		ModelMenu:Close()
	end
	
	return false
end )