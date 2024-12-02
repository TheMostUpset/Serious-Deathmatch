local showGameUI

local offset = 0
local speed = 5
local flashSpeed = 4

local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
local ssbg_tse = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
local detailTexture_vtf_tse = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
local sam = surface.GetTextureID("vgui/serioussam/mainmenu/sam")
local pillar = surface.GetTextureID("vgui/serioussam/mainmenu/pillar")

local cvar_music = GetConVar("sdm_music")

function GetMMFColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return SeriousHUD:GetColor()
	end
	return 240, 155, 0
end

function GetAccentColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return 255, 255, 255
	end
	return 255, 190, 0
end

function PaintBackground(self, w, h)
	local fourbythree = ScrW() / ScrH()
	local skin = GAMEMODE:GetHUDSkin()
	local hudr, hudg, hudb = GAMEMODE:GetHUDColor()
	
	local offsetX = math.sin(CurTime() * 1.5) * -22
	local offsetY = math.cos(CurTime() * 1.5) * -22
	surface.SetDrawColor(0,0,0)
	surface.DrawRect(0, 0, w, h)
	
	if skin == 2 then
		surface.SetTexture(ssbg_tse)
	else
		surface.SetTexture(ssbg)
	end
	surface.SetDrawColor(hudr, hudg, hudb, 150)
	local texW = 256
	local texH = 256
	surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
	if skin == 2 then
		surface.DrawTexturedRect(0,0,w,h)
	end
	
	if skin == 2 then
		surface.SetDrawColor(255,255,255)
		surface.SetTexture(sam)
	if fourbythree < 1.5 then
		surface.DrawTexturedRect(w/1.5, h/5.5, w/3.5, h/1.3)
	else
		surface.DrawTexturedRect(w/1.5, h/5.5, w/4.5, h/1.3)
	end
	
	surface.SetDrawColor(255,255,255)
	surface.SetTexture(pillar)
	if fourbythree < 1.5 then
		surface.DrawTexturedRect(w-w, h-h, w/6, h)
	else
		surface.DrawTexturedRect(w-w, h-h, w/8, h)
	end
	end

	if skin == 1 then 
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 125)
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
		offsetX = math.sin(CurTime() * 0.6) * 28
		offsetY = math.cos(CurTime() * 0.6) * 28
	end
	if skin == 2 then
		surface.SetTexture(detailTexture_vtf_tse)
	else
		surface.SetTexture(detailTexture_vtf)
	end
	surface.SetDrawColor(hudr, hudg, hudb, 125)
	surface.DrawTexturedRectUV( offsetX-35, offsetY-35, w*5, h*5, 0, 0, w / texW, h / texH )
	
end

function GetButtonColor()
	if GAMEMODE:GetHUDSkin() == 1 then
		return Color(GAMEMODE:GetHUDColor())
	end
	return Color(240, 155, 0)
end

function ButtonFlashing(button)
	local flashColor1 = Color(170, 85, 0)
	local flashColor2 = Color(255, 200, 0)
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
local ConfirmationMenu

local cursor = Material("vgui/serioussam/hud/pointer")
local cursor_tfe = Material("vgui/serioussam/hud/hud_tfe/pointer")

function draw.CustomCursor(panel)
	local material = cursor
	if SeriousHUD:GetSkin() == 1 then
		material = cursor_tfe
	end
	-- Paint the custom cursor
	local cursorX, cursorY = panel:LocalCursorPos()

	surface.SetDrawColor(255, 255, 255, 240)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(cursorX, cursorY, 32, 32)
end

function OpenSSMenu()

	showGameUI = true
	local text = ""
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


	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_game", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH()-ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end




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
	Continue_Button:SetY(ScrH()/2.58)

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
		RunConsoleCommand("disconnect")
		surface.PlaySound("menus/press.wav")
		surface.PlaySound("menus/press.wav")
	end
	Disconnect_Button:SizeToContents()
	Disconnect_Button:Center()
	Disconnect_Button:SetY(ScrH()/1.8)
	
	local Options_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Options_Button:SetText("#sdm_options")
	Options_Button:SetSize(ScrW()/8, ScrH()/20)
	Options_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Options_Button:SetTextColor(GetButtonColor())
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Options_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
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
	Options_Button:SetY(ScrH()/2)

	local LegacyM_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	LegacyM_Button:SetText("#sdm_lmenu")
	LegacyM_Button:SetSize(ScrW()/6, ScrH()/20)
	LegacyM_Button:Center()
	LegacyM_Button:SetY(ScrH()/2.25)
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
		showGameUI = false
		gui.ActivateGameUI()

	surface.PlaySound("menus/press.wav")

	end
	LegacyM_Button:SizeToContents()
	LegacyM_Button:Center()
	LegacyM_Button:SetY(ScrH()/2.25)

	local Quit_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Quit_Button:SetText("#sdm_exitgame")
	Quit_Button:SetSize(ScrW()/16, ScrH()/20)
	Quit_Button:Center()
	Quit_Button:SetY(ScrH()/1.635)
	Quit_Button:SetFont("MainMenu_Font")
	Quit_Button:SetTextColor(GetButtonColor())
	Quit_Button.Paint = function(self, w, h)
	end

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
		OpenConfirmationMenu()
		surface.PlaySound("menus/press.wav")
	end
	Quit_Button:SizeToContents()
	Quit_Button:Center()
	Quit_Button:SetY(ScrH()/1.635)
	
	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_game", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH()-ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	EscMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
end

function OpenConfirmationMenu()
	showGameUI = true
	local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
	local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
	local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
	local text = ""
	if GetConVarNumber("ss_hud_skin") == 2 then
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
		local hudr, hudg, hudb = GetMMFColor()
		local offsetX = math.sin(CurTime() * 1.5) * -22
		local offsetY = math.cos(CurTime() * 1.5) * -22
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(hudr, hudg, hudb, 255)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
		
		surface.SetTexture(ssbg)
		local hudr, hudg, hudb = SeriousHUD:GetColor()
		surface.SetDrawColor(hudr, hudg, hudb, 145)
		local texW = 256
		local texH = 256
		if GetConVarNumber("ss_hud_skin") == 2 then
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w-500, h-500, 0, 0, w / texW, h / texH )
		else
			surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
		end
		if GetConVarNumber("ss_hud_skin") == 2 then
			surface.DrawTexturedRect(1,1,w-2,h-2)
		end
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		if GetConVarNumber("ss_hud_skin") == 2 then 
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
		surface.SetDrawColor(hudr, hudg, hudb, 140)
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

	local PoseAnimations = {
		"pose_standing_01",
		"pose_standing_02",
		"pose_standing_03",
		"pose_standing_04",
	}
	
	local randompose = math.random(1, #PoseAnimations)
	
	local modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
	
	local text = ""
	
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
	ModelBack:SetX(ScrW()/1.545)
	ModelBack:SetY(ScrH()/4.75)
	ModelBack:SetSize(1024, 1024)
	ModelBack.Paint = function(self, w, h)
		local offsetx = math.sin(CurTime() * 1.5) * 30
		local offsety = math.cos(CurTime()* 1.5) * 30
		
		local offsetx2 = math.sin(CurTime()* -0.5) * 15
		local offsety2 = math.cos(CurTime()* -0.5) * 15
	
		local hudr, hudg, hudb = GAMEMODE:GetHUDColor()
		
		if GAMEMODE:GetHUDSkin() == 2 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/ModelBack")
		elseif GAMEMODE:GetHUDSkin() == 1 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
		end
		
		
		surface.SetDrawColor(GetMMFColor())
		surface.DrawRect(0, 0, ScrW()/3.15+2, ScrW()/2.9+2)
		surface.SetTexture( modelbg )
		surface.DrawTexturedRect( 1, 1, ScrW()/3.15, ScrW()/2.9 )
		
		if GAMEMODE:GetHUDSkin() == 2 then
			return
		elseif GAMEMODE:GetHUDSkin() == 1 then
			surface.SetTexture(ssbg)
		end
		
		surface.SetDrawColor(hudr, hudg, hudb, 50)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV( offsetx-48, offsety-48, 1024, 1024, 0, 0, 2048 / texW, 2048 / texH )
		
		surface.SetDrawColor(hudr, hudg, hudb, 25)
		surface.DrawTexturedRectUV( offsetx2-48, offsety2-48, 1024, 1024, 0, 0, 2048 / texW, 2048 / texH )
	end
	
	local ModelFrame = vgui.Create( "DModelPanel", SettingsMenu )
	ModelFrame:SetSize(ScrW()/2.5,ScrW()/2.5)
	ModelFrame:SetModel( GetConVarString("sdm_playermodel") )
	ModelFrame:SetX(ScrW()/1.675)
	ModelFrame:SetY(ScrH()/8)
	
	function ModelFrame:LayoutEntity( Entity )		
		ModelFrame:RunAnimation()
		Entity:SetSequence(PoseAnimations[randompose])
		Entity:SetSkin(GetConVarNumber("sdm_playermodel_skin"))
		Entity:SetBodygroup(GetConVarNumber("sdm_playermodel_bodygroup"), GetConVarNumber("sdm_playermodel_bodygroup"))
		Entity:SetModel(GetConVarString("sdm_playermodel"))
	end

	ModelFrame.OnCursorEntered = function()
		ModelFrame:SetCursor("blank")
	end

	local ModelButton = vgui.Create( "DButton", SettingsMenu )
	local isFlashing = false
	ModelButton:SetText( "" )
	ModelButton:SetPos( ScrW()/1.545, ScrH()/4.75 )
	ModelButton:SetSize( ScrW()/3.125, ScrW()/2.65 )					
	ModelButton.DoClick = function()		
		OpenModelMenu()
	end
	
	ModelButton.Paint = function(self, w, h)
		draw.SimpleText( "Serious Sam", "MainMenu_Font_32", 0, ScrW()/2.85, GetButtonColor(), TEXT_ALIGN_LEFT )
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
		surface.SetDrawColor(GetMMFColor())
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
	Crosshair_Image:SetImage("vgui/serioussam/Crosshair".. GetConVarNumber("ss_crosshair"))
	
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
		if crosshair_value < 1 then
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
		SettingsMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/10)

	local TFE_Color_Mixer = vgui.Create("DColorMixer", SettingsMenu)
	TFE_Color_Mixer:SetSize(ScrW()/10, ScrH()/10)
	TFE_Color_Mixer:Center()
	TFE_Color_Mixer:SetY(ScrH()/1.4)
	TFE_Color_Mixer:SetPalette(false)  			-- Show/hide the palette 				DEF:true
	TFE_Color_Mixer:SetAlphaBar(false) 			-- Show/hide the alpha bar 				DEF:true
	TFE_Color_Mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
	TFE_Color_Mixer:SetColor(Color(30,100,160)) 	-- Set the default color
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
	
	--TFE_Color_Mixer.ColorCube.Knob.OnCursorEntered = function()
	--	TFE_Color_Mixer.WangsPanel:SetCursor("blank")
	--end
	
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
		ModelMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end

	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/10)

	local Sam_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_Button:SetFont("MainMenu_Font")
	Sam_Button:SetText("TSE SERIOUS SAM")
	Sam_Button:SetTextColor(GetButtonColor())
	Sam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Sam_Button.OnCursorEntered = function()
		Sam_Button:SetCursor( "blank" )
		text = "#sdm_help_mvolume"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Sam_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Sam_Button:SetTextColor(GetButtonColor())
	end
	
	Sam_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("0")
		net.WriteString("0")
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		
		ModelMenu:Close()
	end
	
	Sam_Button:SizeToContents()
	Sam_Button:Center()
	Sam_Button:SetY(ScrH()/6.95)
	
	local Sam_TFE_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_TFE_Button:SetFont("MainMenu_Font")
	Sam_TFE_Button:SetText("TFE SERIOUS SAM")
	Sam_TFE_Button:SetTextColor(GetButtonColor())
	Sam_TFE_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Sam_TFE_Button.OnCursorEntered = function()
		Sam_TFE_Button:SetCursor( "blank" )
		text = "#sdm_help_mvolume"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Sam_TFE_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Sam_TFE_Button:SetTextColor(GetButtonColor())
	end
	
	Sam_TFE_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/samclassic.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(1)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(1)
		
		ModelMenu:Close()
	end
	
	Sam_TFE_Button:SizeToContents()
	Sam_TFE_Button:Center()
	Sam_TFE_Button:SetY(ScrH()/4.75)
	
	local Red_Rick_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Red_Rick_Button:SetFont("MainMenu_Font")
	Red_Rick_Button:SetText("RED RICK")
	Red_Rick_Button:SetTextColor(GetButtonColor())
	Red_Rick_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Red_Rick_Button.OnCursorEntered = function()
		Red_Rick_Button:SetCursor( "blank" )
		text = "#sdm_help_mvolume"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Red_Rick_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Red_Rick_Button:SetTextColor(GetButtonColor())
	end
	
	Red_Rick_Button.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("0")
		net.WriteString("0")
		net.SendToServer()
		
		GetConVar("sdm_playermodel"):SetString("models/pechenko_121/redrick.mdl")
		GetConVar("sdm_playermodel_skin"):SetInt(0)
		GetConVar("sdm_playermodel_bodygroup"):SetInt(0)
		
		ModelMenu:Close()
	end
	
	Red_Rick_Button:SizeToContents()
	Red_Rick_Button:Center()
	Red_Rick_Button:SetY(ScrH() / 3.65)
	
	ModelMenu:MakePopup()
    
	ModelMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_pmselect", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
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
	
	--[[ needs to be fixed
	elseif input.IsKeyDown(KEY_ESCAPE) and EscMenu and EscMenu:IsVisible() and not showGameUI then
		showGameUI = true
		EscMenu:Close()
	end
	--]]
	
	return false
end )