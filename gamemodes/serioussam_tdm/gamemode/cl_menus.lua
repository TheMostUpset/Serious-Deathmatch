local showGameUI
local yes = true
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

local function PaintBackground(self, w, h)
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
	surface.SetDrawColor(hudr, hudg, hudb, 200)
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
	surface.SetDrawColor(hudr, hudg, hudb, 140)
	surface.DrawTexturedRectUV( offsetX-35, offsetY-35, w*5, h*5, 0, 0, w / texW, h / texH )
end

local function GetButtonColor()
	if GAMEMODE:GetHUDSkin() == 1 then
		return Color(GAMEMODE:GetHUDColor())
	end
	return Color(240, 155, 0)
end

local function ButtonFlashing(button)
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

local function UpdateButtonsSkin(t, skin)
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

local function UpdateButtonsColor(t, col)
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


	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("GAME", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_small", ScrW()/2, ScrH()-100, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end




	local Continue_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Continue_Button:SetText("RESUME")
	Continue_Button:SetSize(ScrW()/8, ScrH()/20)
	Continue_Button:Center()
	Continue_Button:SetY(ScrH()/2.58)
	Continue_Button:SetFont("MainMenu_Font")
	Continue_Button:SetTextColor(GetButtonColor())

	Continue_Button.OnCursorEntered = function()
		isFlashing = true
		text = "return to game"
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

	local Disconnect_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Disconnect_Button:SetText("STOP GAME")
	Disconnect_Button:SetSize(ScrW()/8, ScrH()/20)
	Disconnect_Button:Center()
	Disconnect_Button:SetY(ScrH()/1.8)
	Disconnect_Button:SetFont("MainMenu_Font")
	Disconnect_Button:SetTextColor(GetButtonColor())
	Disconnect_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Disconnect_Button.OnCursorEntered = function()
		isFlashing = true
		text = "stop currently running game"
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

	local Options_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Options_Button:SetText("OPTIONS")
	Options_Button:SetSize(ScrW()/8, ScrH()/20)
	Options_Button:Center()
	Options_Button:SetY(ScrH()/2)
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
		isFlashing = true
		text = "adjust playermodel, hud, and music volume"
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

	local LegacyM_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	LegacyM_Button:SetText("LEGACY MENU")
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
		text = "return to normal menu"
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


	local Quit_Button = vgui.Create("DButton", EscMenu)
	local isFlashing = false
	Quit_Button:SetText("QUIT")
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
		text = "exit game immediately"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Quit_Button.OnCursorExited = function()
		isFlashing = false
		Quit_Button:SetTextColor(GetButtonColor())
	end
	Quit_Button.DoClick = function()
		OpenConfirmationMenu()
		surface.PlaySound("menus/press.wav")
	end
end

--function OpenTeamMenu()
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


	TeamMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("CHOOSE TEAM", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_small", ScrW()/2, ScrH()-100, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	local RedTeam_Button = vgui.Create("DButton", TeamMenu)
	local isFlashing = false
	RedTeam_Button:SetText("JOIN RED")
	RedTeam_Button:SetSize(ScrW()/8, ScrH()/20)
	RedTeam_Button:Center()
	RedTeam_Button:SetY(ScrH()/2.12)
	RedTeam_Button:SetFont("MainMenu_Font")
	RedTeam_Button:SetTextColor(GetButtonColor())

	RedTeam_Button.OnCursorEntered = function()
		isFlashing = true
		text = "return to game"
		surface.PlaySound("menus/select.wav")
	end

	RedTeam_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		RedTeam_Button:SetTextColor(GetButtonColor())
	end

	RedTeam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	RedTeam_Button.DoClick = function()
		TeamMenu:Close()
		showGameUI = false
		surface.PlaySound("menus/press.wav")
	end
	
	local BlueTeam_Button = vgui.Create("DButton", TeamMenu)
	local isFlashing = false
	BlueTeam_Button:SetText("JOIN BLUE")
	BlueTeam_Button:SetSize(ScrW()/8, ScrH()/20)
	BlueTeam_Button:Center()
	BlueTeam_Button:SetY(ScrH()/1.88)
	BlueTeam_Button:SetFont("MainMenu_Font")
	BlueTeam_Button:SetTextColor(GetButtonColor())

	BlueTeam_Button.OnCursorEntered = function()
		isFlashing = true
		text = "return to game"
		surface.PlaySound("menus/select.wav")
	end

	BlueTeam_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		BlueTeam_Button:SetTextColor(GetButtonColor())
	end

	BlueTeam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	BlueTeam_Button.DoClick = function()
		TeamMenu:Close()
		showGameUI = false
		surface.PlaySound("menus/press.wav")
	end
--end


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

		draw.SimpleText("ARE YOU SERIOUS?", "MainMenu_Font", w/2, h/3, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	YesButton:SetText("YES")
	YesButton:SetSize(ScrW() / 5 / YesButton:GetTextSize()*3.5, ScrH() / 20)
	YesButton:SetX(ScrW() - ScrW()/1.25)
	YesButton:SetY(ScrH()- ScrH()/1.15)
	YesButton:SetFont("MainMenu_Font")
	YesButton:SetTextColor(GetButtonColor())
	YesButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	YesButton.OnCursorEntered = function()
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
	local NoButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	NoButton:SetText("NO")
	NoButton:SetSize(ScrW() / 5 / NoButton:GetTextSize()*3, ScrH() / 20)
	NoButton:SetX(ScrW()/3.55)
	NoButton:SetY(ScrH()- ScrH()/1.15)
	NoButton:SetFont("MainMenu_Font")
	NoButton:SetTextColor(GetButtonColor())
	NoButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	NoButton.OnCursorEntered = function()
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

	SettingsMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("OPTIONS", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_small", ScrW()/2, ScrH() - ScrH()/11, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local Playermodel_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Playermodel_Button:SetText("PLAYERMODEL SELECTOR")
	Playermodel_Button:SetSize(ScrW()/4, ScrH() / 20)
	Playermodel_Button:Center()
	Playermodel_Button:SetY(ScrH()/6.5)
	Playermodel_Button:SetFont("MainMenu_Font")
	Playermodel_Button:SetTextColor(GetButtonColor())
	Playermodel_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Playermodel_Button.OnCursorEntered = function()
		text = "change model for this player"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Playermodel_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Playermodel_Button:SetTextColor(GetButtonColor())
	end

	local Music_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if !cvar_music:GetBool() then
		Music_Button:SetText("ENABLE MUSIC")
	else
		Music_Button:SetText("DISABLE MUSIC")
	end
	Music_Button:SetSize(ScrW()/6.5, ScrH() / 20)
	Music_Button:Center()
	Music_Button:SetY(ScrH()/2.69)
	Music_Button:SetFont("MainMenu_Font")
	Music_Button:SetText("MUSIC VOLUME")
	Music_Button:SetTextColor(GetButtonColor())
	Music_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Music_Button.OnCursorEntered = function()
		text = "adjust volume of in-game music"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Music_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Music_Button:SetTextColor(GetButtonColor())
	end
	



	local Bob_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GetConVarNumber("ss_bob") == 0 then
		Bob_Button:SetText("ENABLE BOBBING")
	elseif GetConVarNumber("ss_bob") == 1 then
		Bob_Button:SetText("DISABLE BOBBING")
	end
	Bob_Button:SetSize(ScrW()/5.5, ScrH() / 20)
	Bob_Button:Center()
	Bob_Button:SetY(ScrH()/2.075)
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
				Bob_Button:SetText("DISABLE BOBBING")
				text = "disable weapon model bobbing"
			elseif state == 1 then
				RunConsoleCommand("ss_bob", "0")
				Bob_Button:SetText("ENABLE BOBBING")
				text = "enable weapon model bobbing"
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	Bob_Button.OnCursorEntered = function()
	if GetConVar("ss_bob"):GetInt() == 1 then
		text = "disable weapon model bobbing"
	elseif GetConVar("ss_bob"):GetInt() == 0 then
		text = "enable weapon model bobbing"
	end
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Bob_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Bob_Button:SetTextColor(GetButtonColor())
	end

	local Crosshair_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Crosshair_Button:SetText("CROSSHAIR")
	Crosshair_Button:SetSize(ScrW()/8.5, ScrH() / 20)
	Crosshair_Button:Center()
	Crosshair_Button:SetY(ScrH()/1.825)
	Crosshair_Button:SetFont("MainMenu_Font")
	Crosshair_Button:SetTextColor(GetButtonColor())
	Crosshair_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end

	Crosshair_Button.OnCursorEntered = function()
		text = "change crosshair icon"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Crosshair_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		Crosshair_Button:SetTextColor(GetButtonColor())
	end
	
	local Crosshair_Image = vgui.Create("DImage", SettingsMenu)	-- Add image to Frame
	Crosshair_Image:SetX(ScrW()/2.065)	-- Move it into frame
	Crosshair_Image:SetY(ScrH()/1.645)	-- Size it to 150x150
	Crosshair_Image:SetSize(ScrW()/32, ScrW() / 32)
	-- Set material relative to "garrysmod/materials/"
	Crosshair_Image:SetImage("vgui/serioussam/Crosshair".. GetConVarNumber("ss_crosshair"))
	
	local Forward_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Forward_Button:SetText(">")
	Forward_Button:SetSize(ScrW()/80, ScrH() / 20)
	Forward_Button:SetX(ScrW()/1.88)
	Forward_Button:SetY(ScrH()/1.655)
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
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Forward_Button.OnCursorExited = function()
		isFlashing = false
		Forward_Button:SetTextColor(GetButtonColor())
	end
	

	
	local Backwards_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Backwards_Button:SetText("<")
	Backwards_Button:SetSize(ScrW()/80, ScrH() / 20)
	Backwards_Button:SetX(ScrW()/2.195)
	Backwards_Button:SetY(ScrH()/1.655)
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
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Backwards_Button.OnCursorExited = function()
		isFlashing = false
		Backwards_Button:SetTextColor(GetButtonColor())
	end

	local HUD_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GAMEMODE:GetHUDSkin() == 2 then
		HUD_Button:SetText("TFE HUD")
	elseif GAMEMODE:GetHUDSkin() == 1 then
		HUD_Button:SetText("TSE HUD")
	end
	HUD_Button:SetSize(ScrW()/11, ScrH() / 20)
	HUD_Button:Center()
	HUD_Button:SetY(ScrH()/1.475)
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
				HUD_Button:SetText("TSE HUD")
				UpdateButtonsSkin(children, 1)
				text = "change hud theme to TSE"
			elseif skin == 1 then
				RunConsoleCommand("ss_hud_skin", "2")	
				HUD_Button:SetText("TFE HUD")
				UpdateButtonsSkin(children, 2)
				text = "change hud theme to TFE"
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	HUD_Button.OnCursorEntered = function()
	if GetConVar("ss_hud_skin"):GetInt() == 2 then
		text = "change hud theme to TFE"
	elseif GetConVar("ss_hud_skin"):GetInt() == 1 then
		text = "change hud theme to TSE"
	end
		isFlashing = true 
		surface.PlaySound("menus/select.wav")
	end

	HUD_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		HUD_Button:SetTextColor(GetButtonColor())
	end


	local TFE_Color_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	TFE_Color_Button:SetText("TFE HUD COLOR")
	TFE_Color_Button:SetSize(ScrW()/6.5, ScrH() / 20)
	TFE_Color_Button:Center()
	TFE_Color_Button:SetY(ScrH()/1.35)
	TFE_Color_Button:SetFont("MainMenu_Font")
	TFE_Color_Button:SetTextColor(GetButtonColor())

	TFE_Color_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	TFE_Color_Button.OnCursorEntered = function()
		text = "adjust accent color of TFE hud skin"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	TFE_Color_Button.OnCursorExited = function()
		text = ""
		isFlashing = false
		TFE_Color_Button:SetTextColor(GetButtonColor())
	end

	local Back_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Back_Button:SetText("BACK")
	Back_Button:SetSize(ScrW()/15, ScrH()/20)
	Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/11)
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(GetButtonColor())
	Back_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		end
	end
	Back_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text = "return to previous menu"
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

	function SKIN:PaintNumSlider( panel, w, h )
		return
	end
	
	local Music_Volume = vgui.Create( "DNumSlider", SettingsMenu )
	Music_Volume:SetX(ScrW()/2.33)
	Music_Volume:SetY(ScrH() / 2.34)
	Music_Volume:SetSize( ScrW()/7.1, ScrH()/22 )
	Music_Volume:SetText( "" )
	Music_Volume:SetMin( 0 )
	Music_Volume:SetMax( 1 )
	Music_Volume:SetDecimals( 2 )
	Music_Volume:SetConVar( "sdm_music" )
	Music_Volume:SetValue( cvar_music:GetFloat() )
	Music_Volume.Label:SetVisible(false)
	Music_Volume.TextArea:SetVisible(false)
	Music_Volume.Slider.Knob.Paint = function()
	end

	Music_Volume.Paint = function(self, w, h)
		local number = Music_Volume.TextArea:GetText()
		surface.SetDrawColor(SeriousHUD:GetFrameColor())
		surface.DrawOutlinedRect(0,0,w,h)
		local hudr,hudg,hudb = GetMMFColor()
		surface.SetDrawColor(hudr-35,hudg-35,hudb-35, 200)
		surface.DrawRect(1,1,number*w-2,h-2)
		draw.SimpleText( (number*100).."%", "MainMenu_font_small", w/2,-6, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER )
	end



	local TFE_Color_Mixer = vgui.Create("DColorMixer", SettingsMenu)
	TFE_Color_Mixer:SetSize(ScrW()/10, ScrH()/10)
	TFE_Color_Mixer:Center()
	TFE_Color_Mixer:SetY(ScrH()/1.25)
	TFE_Color_Mixer:SetPalette(false)  			-- Show/hide the palette 				DEF:true
	TFE_Color_Mixer:SetAlphaBar(false) 			-- Show/hide the alpha bar 				DEF:true
	TFE_Color_Mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
	TFE_Color_Mixer:SetColor(Color(30,100,160)) 	-- Set the default color
	TFE_Color_Mixer:SetConVarR("ss_hud_color_r")
	TFE_Color_Mixer:SetConVarG("ss_hud_color_g")
	TFE_Color_Mixer:SetConVarB("ss_hud_color_b")
	local children = SettingsMenu:GetChildren()
	table.Add(children, EscMenu:GetChildren())
	TFE_Color_Mixer.ValueChanged = function(self, col)
	if GAMEMODE:GetHUDSkin() == 2 then return false end
		UpdateButtonsColor(children, col)
	end

 
	local buttonKleiner = vgui.Create("DImageButton", SettingsMenu)
	buttonKleiner:SetImage("materials/icons/playermodels/samclassic.png")
	buttonKleiner:SetSize(ScrW()/30, ScrW()/30)
	buttonKleiner:SetPos(ScrW()/2 - ScrW()/13, ScrH()/4.45)
	buttonKleiner.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("0")
		net.WriteString("0")
		net.SendToServer()
	end
	buttonKleiner.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local buttonKleiner1 = vgui.Create("DImageButton", SettingsMenu)
	buttonKleiner1:SetImage("materials/icons/playermodels/samclassic_skin1.png")
	buttonKleiner1:SetSize(ScrW()/30, ScrW()/30)
	buttonKleiner1:SetPos(ScrW()/2 - ScrW()/26, ScrH()/4.45)
	buttonKleiner1.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonKleiner1.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	

	local buttonBarney = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney:SetImage("materials/icons/playermodels/redrick.png")
	buttonBarney:SetSize(ScrW()/30, ScrW()/30)
	buttonBarney:SetPos(ScrW()/1.99, ScrH()/4.45)
	buttonBarney.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("0")
		net.WriteString("1")
		net.SendToServer()
	end
		buttonBarney.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney2 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney2:SetImage("materials/icons/playermodels/redrick_skin1.png")
	buttonBarney2:SetSize(ScrW()/30, ScrW()/30)
	buttonBarney2:SetPos(ScrW()/1.85, ScrH()/4.45)
	buttonBarney2.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
		buttonBarney2.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney3 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney3:SetImage("materials/icons/playermodels/redrick_skin2.png")
	buttonBarney3:SetSize(ScrW()/30, ScrW()/30)
	buttonBarney3:SetPos(ScrW()/2 - ScrW()/13, ScrH()/2 /1.7)
	buttonBarney3.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("2")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonBarney3.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney4 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney4:SetImage("materials/icons/playermodels/redrick_skin3.png")
	buttonBarney4:SetSize(ScrW()/30, ScrW()/30)
	buttonBarney4:SetPos(ScrW()/2 - ScrW()/26, ScrH()/2 /1.7)
	buttonBarney4.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("3")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonBarney4.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		

        

	local buttonAlyx = vgui.Create("DImageButton", SettingsMenu)
	buttonAlyx:SetImage("materials/icons/playermodels/beheadedben.png")
	buttonAlyx:SetSize(ScrW()/30, ScrW()/30)
	buttonAlyx:SetPos(ScrW()/1.99, ScrH()/2 /1.7)
	buttonAlyx.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/beheadedben.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonAlyx.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	
	SettingsMenu:MakePopup()
	
	local buttonSteve = vgui.Create("DImageButton", SettingsMenu)
	buttonSteve:SetImage("materials/icons/playermodels/steelsteve.png")
	buttonSteve:SetSize(ScrW()/30, ScrW()/30)
	buttonSteve:SetPos(ScrW()/1.85, ScrH()/2 /1.7)
	buttonSteve.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/steelsteve.mdl")
		net.WriteString("1")
		net.WriteString("1")			
		net.SendToServer()
	end
	buttonSteve.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(GetMMFColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	SettingsMenu:MakePopup()
    
end


hook.Add( "Think", "ESCMenuOverride", function()
	if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
		gui.HideGameUI()
		if not showGameUI then
			showGameUI = true
			OpenSSMenu()
		elseif SettingsMenu and SettingsMenu:IsVisible() then
			SettingsMenu:Close()
		elseif EscMenu and EscMenu:IsVisible() and (!ConfirmationMenu or !ConfirmationMenu:IsVisible()) then
			EscMenu:Close()
			showGameUI = false
		end
	end
end )