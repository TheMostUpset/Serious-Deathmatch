local showGameUI

local offset = 0
local speed = 5
local flashSpeed = 4

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

function GetAccentColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return 255, 255, 255
	end
	return 255, 190, 0
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

local EscMenu
local SettingsMenu
local ConfirmationMenu

local cursor = Material("vgui/serioussam/hud/pointer")
local cursor_tfe = Material("vgui/serioussam/hud/hud_tfe/pointer")

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
	
	local Team_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Team_Button:SetText("#sdm_changeteam")
	Team_Button:SetSize(ScrW()/12, ScrH()/20)
	Team_Button:SetFont("MainMenu_Font")
	Team_Button:SetTextColor(GetButtonColor())

	Team_Button.OnCursorEntered = function()
		Team_Button:SetCursor( "blank" )
		isFlashing = true
		text = "#sdm_help_changeteam"
		surface.PlaySound("menus/select.wav")
	end

	Team_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Team_Button:SetTextColor(GetButtonColor())
	end

	Team_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	Team_Button.DoClick = function()
		OpenTeamMenu()
		surface.PlaySound("menus/press.wav")
	end
	Team_Button:SizeToContents()
	Team_Button:Center()
	Team_Button:SetY(ScrH()/2.5)

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
		draw.SimpleText("v1.91", "MainMenu_font_very_small", ScrW()/1.05, ScrH() - ScrH() + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
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

function OpenSettingsMenu()
	local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
	local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
	local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
	local text = ""
	showGameUI = true
	if GetConVarNumber("ss_hud_skin") == 2 then
		ssbg_tse = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf_tse = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
	end
	SettingsMenu = vgui.Create("DFrame")
	SettingsMenu:SetSize(ScrW(), ScrH())
	SettingsMenu:Center()
	SettingsMenu:SetTitle("")
	SettingsMenu:ShowCloseButton( false )
	SettingsMenu:SetDraggable(false)
	SettingsMenu:MakePopup()
	SettingsMenu.Think = nil
	SettingsMenu:SetCursor("blank")
	
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

function OpenTeamMenu()

	if ( IsValid( GAMEMODE.TeamSelectFrame ) ) then return end

	-- Simple team selection box
	showGameUI = true
	local text = ""
	TeamMenu = vgui.Create("DFrame")
	TeamMenu:SetSize(ScrW(), ScrH())
	TeamMenu:Center()
	TeamMenu:SetTitle("")
	TeamMenu:ShowCloseButton( false )
	TeamMenu:SetDraggable(false)
	TeamMenu:SetMouseInputEnabled(false)
	TeamMenu:MakePopup()
	TeamMenu:SetCursor("blank")
	TeamMenu:SetMouseInputEnabled(true)
	TeamMenu.Think  = nil

	local AllTeams = team.GetAllTeams()
	local y = 30

		if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED ) then

			local RED_Button = vgui.Create("DButton", TeamMenu)
			local isFlashing = false
			RED_Button:SetText(language.GetPhrase("sdm_joinred") .. " (" .. team.NumPlayers(TEAM_RED) .. ")")
			RED_Button:SetSize(ScrW()/12, ScrH()/20)
			RED_Button:SetFont("MainMenu_Font")
			RED_Button:SetTextColor(GetButtonColor())

			RED_Button.OnCursorEntered = function()
				RED_Button:SetCursor("blank")
				isFlashing = true
				text = "#sdm_help_joinred"
				surface.PlaySound("menus/select.wav")
			end

			RED_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				RED_Button:SetTextColor(GetButtonColor())
			end

			RED_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end
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
			RED_Button:Center()
			RED_Button:SetY(ScrH()/2.25)
			
			local BLUE_Button = vgui.Create("DButton", TeamMenu)
			local isFlashing = false
			BLUE_Button:SetText(language.GetPhrase("sdm_joinblue") .. " (" .. team.NumPlayers(TEAM_BLUE) .. ")")
			BLUE_Button:SetSize(ScrW()/12, ScrH()/20)
			BLUE_Button:SetFont("MainMenu_Font")
			BLUE_Button:SetTextColor(GetButtonColor())

			BLUE_Button.OnCursorEntered = function()
				BLUE_Button:SetCursor("blank")
				isFlashing = true
				text = "#sdm_help_joinblue"
				surface.PlaySound("menus/select.wav")
			end

			BLUE_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				BLUE_Button:SetTextColor(GetButtonColor())
			end

			BLUE_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end
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
			BLUE_Button:Center()
			BLUE_Button:SetY(ScrH()/2)
			
			local SPEC_Button = vgui.Create("DButton", TeamMenu)
			local isFlashing = false
			SPEC_Button:SetText(language.GetPhrase("sdm_joinspec") .. " (" .. team.NumPlayers(TEAM_SPECTATOR) .. ")")
			SPEC_Button:SetSize(ScrW()/12, ScrH()/20)
			SPEC_Button:SetFont("MainMenu_Font")
			SPEC_Button:SetTextColor(GetButtonColor())

			SPEC_Button.OnCursorEntered = function()
				SPEC_Button:SetCursor("blank")
				isFlashing = true
				text = "#sdm_help_joinspec"
				surface.PlaySound("menus/select.wav")
			end

			SPEC_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				SPEC_Button:SetTextColor(GetButtonColor())
			end

			SPEC_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end
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
			SPEC_Button:Center()
			SPEC_Button:SetY(ScrH()/1.8)

			local Back_Button = vgui.Create("DButton", TeamMenu)
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
				TeamMenu:Close()
				showGameUI = true
				surface.PlaySound("menus/press.wav")
			end
	
			Back_Button:SizeToContents()
			Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/10)


			if ( IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
				Team:SetEnabled( false )
			end

		end

	TeamMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_changeteam", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH()-ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	TeamMenu.PaintOver = function(self, w, h)
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
	if input.IsKeyDown(KEY_ESCAPE) and TeamMenu and TeamMenu:IsVisible() then
		TeamMenu:Close()
	end
	
	--[[ needs to be fixed
	elseif input.IsKeyDown(KEY_ESCAPE) and EscMenu and EscMenu:IsVisible() and not showGameUI then
		showGameUI = true
		EscMenu:Close()
	end
	--]]
	
	return false
end )