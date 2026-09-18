local showGameUI = false

local offset = 0
local speed = 5
local flashSpeed = 4

local PoseAnimations = {
	"pose_standing_01",
	"pose_standing_02",
	"pose_standing_03",
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
	
	local offsetX = math.sin(CurTime() * 1.5) * -25
	local offsetY = math.cos(CurTime() * 1.5) * -20
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
	
	if skin == 2 then
		surface.SetTexture(ssbg_tse)
	else
		surface.SetTexture(ssbg)
	end
	
	surface.SetDrawColor(hudr, hudg, hudb, 50)
	local texW = 256
	local texH = 256
	surface.DrawTexturedRectUV( offsetX - 25, offsetY - 25, w * 1.5, h * 1.5, 0, 0, w / texW, h / texH )
	
	if skin == 2 then
		surface.DrawTexturedRect(0, 0, w, h)
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
	local offsetX = math.sin(CurTime() * 1.5) * 35
	local offsetY = math.cos(CurTime() * 1.5) * 25
	
	if skin == 2 then
		offsetX = math.sin(CurTime() * 1) * 25
		offsetY = math.cos(CurTime() * 1) * 25
	end
	
	if skin == 2 then
		surface.SetTexture(detailTexture_vtf_tse)
	else
		surface.SetTexture(detailTexture_vtf)
	end
	
	surface.SetDrawColor(hudr, hudg, hudb, 100)
	
	if skin == 1 then
		surface.DrawTexturedRectUV( offsetX - 125, offsetY - 125, w * 3, h * 3, 0, 0, w / texW, h / texH )
	end
	
	if skin == 2 then
		surface.SetTexture(detailTexture_vtf_tse_alpha)
		surface.DrawTexturedRectUV( offsetX - 125, offsetY - 125, w * 5, h * 5, 0, 0, w / texW, h / texH )
	end
	
	if skin == 2 then
		surface.SetDrawColor(255, 255, 255)
		surface.SetTexture(sam)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w / 1.5, h / 5.5, w / 3.5, h / 1.3)
		else
			surface.DrawTexturedRect(w / 1.525, h / 4.275, w / 5, h / 1.4)
		end
	end
	
	if skin == 2 then
		surface.SetDrawColor(255, 255, 255)
		surface.SetTexture(pillar)
		if fourbythree < 1.5 then
			surface.DrawTexturedRect(w - w * 1.01575, h - h, w / 6, h)
		else
			surface.DrawTexturedRect(w - w * 1.0215, h - h, w / 7.2, h)
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
	local flashColor1 = Color(255, 255, 255)
	local flashColor2 = Color(255, 255, 255)
	
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
   
	button.CurrentTextColor = Color(r, g, b)
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
			v.CurrentTextColor = col
		end
	end
end

function UpdateButtonsColor(t, col)
	col = col or Color(240, 155, 0, 255)
	for k, v in ipairs(t) do
		if v:GetName() == "DButton" then
			v.CurrentTextColor = col
		end
	end
end

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
	surface.DrawTexturedRect(cursorX, cursorY, ScrH() / 33.75, ScrH() / 33.75)
end

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
	
	if engine.ActiveGamemode() == "serioussam_dm" then
		if LocalPlayer():Team() == 0 then
			local isFlashing = false
			
			local Spec_Button = vgui.Create("DButton", EscMenu)
			Spec_Button:SetText("#sdm_spectate")
			Spec_Button:SetFont("MainMenu_Font")
			Spec_Button:SetTextColor(Color(0, 0, 0, 0))
			
			Spec_Button.Paint = function(self, w, h)
				if isFlashing then
					ButtonFlashing(self)
				else
					self.CurrentTextColor = GetButtonColor()
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText("#sdm_spectate", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("#sdm_spectate", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			Spec_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_joinspec"
				Spec_Button:SetCursor( "blank" )
				surface.PlaySound("menus/select.wav")
			end

			Spec_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				Spec_Button.CurrentTextColor = GetButtonColor()
			end

			Spec_Button.DoClick = function()
				showGameUI = false
				RunConsoleCommand("sdm_joinspec")
				EscMenu:Close()
				surface.PlaySound("menus/press.wav")
			end
			
			Spec_Button:SizeToContents()
			Spec_Button:CenterHorizontal()
			Spec_Button:CenterVertical(0.41)
		end
		
		if LocalPlayer():Team() == TEAM_SPECTATOR then
			local isFlashing = false
		
			local Return_Button = vgui.Create("DButton", EscMenu)
			Return_Button:SetText("#sdm_joingame")
			Return_Button:SetFont("MainMenu_Font")
			Return_Button:SetTextColor(Color(0, 0, 0, 0))
			
			Return_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end

				local col = self.CurrentTextColor or GetButtonColor()
				draw.SimpleText("#sdm_joingame", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("#sdm_joingame", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			Return_Button.OnCursorEntered = function()
				isFlashing = true
				text = "#sdm_help_joingame"
				Return_Button:SetCursor( "blank" )
				surface.PlaySound("menus/select.wav")
				
			end

			Return_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				Return_Button.CurrentTextColor = GetButtonColor()
			end

			Return_Button.DoClick = function()
				showGameUI = false
				RunConsoleCommand("sdm_joingame")
				EscMenu:Close()
				surface.PlaySound("menus/press.wav")
			end
			
			Return_Button:SizeToContents()
			Return_Button:CenterHorizontal()
			Return_Button:CenterVertical(0.41)
		end
	end
	
	if engine.ActiveGamemode() == "serioussam_tdm" then
		print("HELLOOOO 2")
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
	end

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

function OpenExtrasMenu()
	showGameUI = true
	ExtrasOpened = true
	
	ExtrasMenu = vgui.Create("DFrame")
	ExtrasMenu:ShowCloseButton( false )
	ExtrasMenu:SetTitle("")
	ExtrasMenu:SetSize(ScrW(), ScrH())
	ExtrasMenu:Center()
	ExtrasMenu:MakePopup()
	ExtrasMenu:SetCursor("blank")
	ExtrasMenu.Think = nil

	local isFlashing = false
	
	local Credits_Button = vgui.Create("DButton", ExtrasMenu)
	Credits_Button:SetText("#sdm_credits")
	Credits_Button:SetFont("MainMenu_Font")
	Credits_Button:SetTextColor(Color(0, 0, 0, 0))

	Credits_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_credits", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_credits", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	Credits_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_credits"
		Credits_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Credits_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Credits_Button.CurrentTextColor = GetButtonColor()
	end

	Credits_Button.DoClick = function()
		OpenCreditsMenu()
		surface.PlaySound("menus/press.wav")
	end

	Credits_Button:SizeToContents()
	Credits_Button:CenterHorizontal()
	Credits_Button:CenterVertical(0.44)
	
	local isFlashing = false

	local LegacyM_Button = vgui.Create("DButton", ExtrasMenu)
	LegacyM_Button:SetText("#sdm_lmenu")
	LegacyM_Button:SetFont("MainMenu_Font")
	LegacyM_Button:SetTextColor(Color(0, 0, 0, 0))
	
	LegacyM_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_lmenu", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_lmenu", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	LegacyM_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_lmenu"
		LegacyM_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	LegacyM_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		LegacyM_Button.CurrentTextColor = GetButtonColor()
	end

	LegacyM_Button.DoClick = function()
		showGameUI = false
		ExtrasOpened = false
		EscMenu:Close()
		ExtrasMenu:Close()
		gui.ActivateGameUI()
		surface.PlaySound("menus/press.wav")
	end
	
	LegacyM_Button:SizeToContents()
	LegacyM_Button:CenterHorizontal()
	LegacyM_Button:CenterVertical(0.5)
	
	local Docs_Button = vgui.Create("DButton", ExtrasMenu)
	Docs_Button:SetText("#sdm_docs")
	Docs_Button:SetFont("MainMenu_Font")
	Docs_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Docs_Button.Paint = function(self, w, h) 
		local col = self.CurrentTextColor or GetInactiveButtonColor()
		draw.SimpleText("#sdm_docs", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_docs", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Docs_Button.OnCursorEntered = function()
		Docs_Button:SetCursor( "blank" )
	end

	Docs_Button.OnCursorExited = function()
		text = ""
	end

	Docs_Button.DoClick = function()
		--surface.PlaySound("menus/press.wav")
	end
	
	Docs_Button:SizeToContents()
	Docs_Button:CenterHorizontal()
	Docs_Button:CenterVertical(0.56)

	local isFlashing = false
	
	local Back_Button = vgui.Create("DButton", ExtrasMenu)
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
		ExtrasOpened = false
		text = ""
		ExtrasMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)

	ExtrasMenu:MakePopup()
    
	ExtrasMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_extras", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_extras", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	ExtrasMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenCreditsMenu()
	showGameUI = true
	
	CreditsMenu = vgui.Create("DFrame")
	CreditsMenu:ShowCloseButton( false )
	CreditsMenu:SetTitle("")
	CreditsMenu:SetSize(ScrW(), ScrH())
	CreditsMenu:Center()
	CreditsMenu:MakePopup()
	CreditsMenu:SetCursor("blank")
	CreditsMenu.Think = nil
	
	local stored_music_cvar = GetConVarNumber("sdm_music")
	music = CreateSound(LocalPlayer(), "music/End_Credits.mp3")
	RunConsoleCommand("sdm_music", "0")
	
	if music then music:Play() end

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
		SERIOUS SAM DEATHMATCH:
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
		Raineronus MK2
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
	lineHeight = lineHeight + 5
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
	
	local isFlashing = false
	
	local Back_Button = vgui.Create("DButton", CreditsMenu)
	Back_Button:SetText("")
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(color_white)
	
	Back_Button.Paint = nil
	
	Back_Button.OnCursorEntered = function()
		Back_Button:SetCursor("blank")
	end

	Back_Button.OnCursorExited = nil

	Back_Button.DoClick = function()
		if ExtrasOpened then
			CreditsMenu:Close()
			showGameUI = true
			surface.PlaySound("menus/press.wav")
			if music then
				music:Stop()
				music = nil
			end
			RunConsoleCommand("sdm_music", stored_music_cvar)
			text = ""
		else
			RunConsoleCommand("gamemenucommand", "quit")
		end
	end
	
	Back_Button:SetSize(ScrW(), ScrH())
	Back_Button:Center()

	CreditsMenu.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.SetTexture(stars01)
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

function OpenOptionsMenu()
	showGameUI = true
	
	OptionsMenu = vgui.Create("DFrame")
	OptionsMenu:ShowCloseButton( false )
	OptionsMenu:SetTitle("")
	OptionsMenu:SetSize(ScrW(), ScrH())
	OptionsMenu:Center()
	OptionsMenu:MakePopup()
	OptionsMenu:SetCursor("blank")
	OptionsMenu.Think = nil

	local isFlashing = false
	
	local Audio_Button = vgui.Create("DButton", OptionsMenu)
	Audio_Button:SetText("#sdm_audiooptions")
	Audio_Button:SetFont("MainMenu_Font")
	Audio_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Audio_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_audiooptions", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_audiooptions", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Audio_Button.OnCursorEntered = function()
		text = "#sdm_help_audiooptions"
		isFlashing = true
		Audio_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Audio_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Audio_Button.CurrentTextColor = GetButtonColor()
	end

	Audio_Button.DoClick = function()
		OpenAudioOptions()
	end
	
	Audio_Button:SizeToContents()
	Audio_Button:CenterHorizontal()
	Audio_Button:CenterVertical(0.47)
	
	local isFlashing = false
	
	local Profile_Button = vgui.Create("DButton", OptionsMenu)
	Profile_Button:SetText("#sdm_profileoptions")
	Profile_Button:SetFont("MainMenu_Font")
	Profile_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Profile_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_profileoptions", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_profileoptions", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	Profile_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_profileoptions"
		Profile_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Profile_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Profile_Button.CurrentTextColor = GetButtonColor()
	end

	Profile_Button.DoClick = function()
		OpenProfileOptions()
		surface.PlaySound("menus/press.wav")
	end
	
	Profile_Button:SizeToContents()
	Profile_Button:CenterHorizontal()
	Profile_Button:CenterVertical(0.53)

	local isFlashing = false
	
	local Back_Button = vgui.Create("DButton", OptionsMenu)
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
		Back_Button.CurrentTextColor = GetButtonColor()
		text = ""
	end

	Back_Button.DoClick = function()
		showGameUI = true
		text = ""
		OptionsMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)

	OptionsMenu:MakePopup()
    
	OptionsMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_options", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_options", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	OptionsMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenAudioOptions()
	showGameUI = true
	
	AudioOptionsMenu = vgui.Create("DFrame")
	AudioOptionsMenu:ShowCloseButton( false )
	AudioOptionsMenu:SetTitle("")
	AudioOptionsMenu:SetSize(ScrW(), ScrH())
	AudioOptionsMenu:Center()
	AudioOptionsMenu:MakePopup()
	AudioOptionsMenu:SetCursor("blank")
	AudioOptionsMenu.Think = nil

	local isFlashing = false
	
	local Music_Button = vgui.Create("DButton", AudioOptionsMenu)
	Music_Button:SetText("#sdm_mvolume")
	Music_Button:SetFont("MainMenu_MuchSmallerFont")
	Music_Button:SetTextColor(Color(0, 0, 0, 0)) 

	Music_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_mvolume", "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_mvolume", "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	Music_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_mvolume"
		Music_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music_Button.CurrentTextColor = GetButtonColor()
	end
	
	Music_Button:SetContentAlignment(6)
	Music_Button:SetSize(ScrW() / 6, ScrH() / 32)
	Music_Button:SetX(ScrW() / 3.3)
	Music_Button:SetY(ScrH() / 4)
	
	local Music_Volume = vgui.Create("DNumSlider", AudioOptionsMenu)
	Music_Volume:SetSize(ScrW() / 3, Music_Button:GetTall() * 1.1)
	Music_Volume:SetText("")
	Music_Volume:SetMin(0)
	Music_Volume:SetMax(1)
	Music_Volume:SetDecimals(2)
	Music_Volume:SetConVar("sdm_music")
	Music_Volume:SetValue(GetConVar("sdm_music"):GetFloat())
	Music_Volume.Label:SetVisible(false)
	Music_Volume.TextArea:SetVisible(false)
	
	Music_Volume.Paint = function(self, w, h)
		local number = Music_Volume.TextArea:GetText()
		local hudr, hudg, hudb = GetMMFColor()
		Music_Volume:SetCursor( "blank" )

		surface.SetDrawColor(GetFrameMMFColor())
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(hudr, hudg, hudb, 200)
		surface.DrawRect(1, 1, number * w - 2, h - 2)

		draw.SimpleText((number * 100) .. "%", "MainMenu_MuchSmallerFont", w / 2 + 2, 3, color_black, TEXT_ALIGN_CENTER)
		draw.SimpleText((number * 100) .. "%", "MainMenu_MuchSmallerFont", w / 2, 0, Color(hudr, hudg, hudb, 255), TEXT_ALIGN_CENTER)
	end
	
	Music_Volume.Slider.Knob.Paint = function(self)
		self:SetCursor("blank")
	end
	Music_Volume.Slider.Paint = function(self)
		self:SetCursor("blank")
	end

	Music_Volume:SetX(ScrW() / 1.9) 
	Music_Volume:SetY(ScrH() / 4)
	
	local isFlashing = false
	
	local Selector_Button = vgui.Create("DButton", AudioOptionsMenu)
	local Selector_2_Button = vgui.Create("DButton", AudioOptionsMenu)
	Selector_Button:SetText("#sdm_musicmode")
	Selector_Button:SetFont("MainMenu_MuchSmallerFont")
	Selector_Button:SetTextColor(Color(0, 0, 0, 0))

	Selector_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_musicmode", "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_musicmode", "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	Selector_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musicmode"
		Selector_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Selector_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Selector_Button.CurrentTextColor = GetButtonColor()
		Selector_2_Button.CurrentTextColor = GetButtonColor()
	end

	Selector_Button.DoClick = function()
		local cvar = GetConVar("sdm_music_mode")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_music_mode", "1")
			Selector_2_Button:SetText("#sdm_musicselect")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_music_mode", "2")
			Selector_2_Button:SetText("#sdm_musicrandom")
		else
			RunConsoleCommand("sdm_music_mode", "0")
			Selector_2_Button:SetText("#sdm_musicmap")
		end
		Selector_2_Button:SizeToContentsX(40)
		Selector_2_Button:SetHeight(ScrH()/32)
	end

	Selector_Button:SetContentAlignment(6)
	Selector_Button:SetSize(ScrW()/6, ScrH()/32)
	Selector_Button:SetX(ScrW()/3.3)
	Selector_Button:SetY(ScrH()/3.45)
	
	Selector_2_Button:SetText("#sdm_musicmap")
	Selector_2_Button:SetFont("MainMenu_MuchSmallerFont")
	
	local cvar = GetConVar("sdm_music_mode")
	if cvar:GetInt() == 0 then
		Selector_2_Button:SetText("#sdm_musicmap")
	elseif cvar:GetInt() == 1 then
		Selector_2_Button:SetText("#sdm_musicselect")
	elseif cvar:GetInt() == 2 then
		Selector_2_Button:SetText("#sdm_musicrandom")
	end
	Selector_2_Button:SetTextColor(Color(0, 0, 0, 0))

	Selector_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_MuchSmallerFont", w - 18, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_MuchSmallerFont", w - 20, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	Selector_2_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musicmode"
		Selector_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Selector_2_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Selector_2_Button.CurrentTextColor = GetButtonColor()
		Selector_Button.CurrentTextColor = GetButtonColor()
	end

	Selector_2_Button.DoClick = function()
		local cvar = GetConVar("sdm_music_mode")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_music_mode", "1")
			Selector_2_Button:SetText("#sdm_musicselect")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_music_mode", "2")
			Selector_2_Button:SetText("#sdm_musicrandom")
		else
			RunConsoleCommand("sdm_music_mode", "0")
			Selector_2_Button:SetText("#sdm_musicmap")
		end
		Selector_2_Button:SizeToContentsX(40)
		Selector_2_Button:SetHeight(ScrH()/32)
	end

	Selector_2_Button:SizeToContentsX(40)
	Selector_2_Button:SetHeight(ScrH()/32)
	Selector_2_Button:SetX(ScrW()/1.95)
	Selector_2_Button:SetY(ScrH()/3.45)
	
	local isFlashing = false
	
	local MusicSelect_Button = vgui.Create("DButton", AudioOptionsMenu)
	MusicSelect_Button:SetText("#sdm_selectmusic")
	MusicSelect_Button:SetFont("MainMenu_MuchSmallerFont")
	MusicSelect_Button:SetTextColor(Color(0, 0, 0, 0))

	MusicSelect_Button.Paint = function(self, w, h) 
		if isMusicSelectFlashing then
			ButtonFlashing(self)
		end

		local cvar = GetConVar("sdm_music_mode")
		local col = self.CurrentTextColor or GetButtonColor()
		if cvar:GetInt() == 1 then
			draw.SimpleText("#sdm_selectmusic", "MainMenu_MuchSmallerFont", w/2 + 2, h / 2 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("#sdm_selectmusic", "MainMenu_MuchSmallerFont", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("", "MainMenu_MuchSmallerFont", w/2 + 2, h / 2 + 3, color_black, TEXT_ALIGN_CENTER)
		end
	end

	MusicSelect_Button.OnCursorEntered = function()
		local cvar = GetConVar("sdm_music_mode")
		if cvar:GetInt() == 0 then
			MusicSelect_Button:SetCursor( "blank" )
		elseif cvar:GetInt() == 1 then	
			text = "#sdm_help_selectmusic"
			isMusicSelectFlashing = true
			MusicSelect_Button:SetCursor( "blank" )
			surface.PlaySound("menus/select.wav")
		end
	end

	MusicSelect_Button.OnCursorExited = function()
		local cvar = GetConVar("sdm_music_mode")
		if cvar:GetInt() == 0 then
			text = ""
		elseif cvar:GetInt() == 1 then
			text = ""
			isMusicSelectFlashing = false
			MusicSelect_Button.CurrentTextColor = GetButtonColor()
		end
	end

	MusicSelect_Button.DoClick = function()
		local cvar = GetConVar("sdm_music_mode")
		if cvar:GetInt() == 0 then
			text = ""
		elseif cvar:GetInt() == 1 then
			OpenMusicSelector()
		end
	end
	
	MusicSelect_Button:SetSize(ScrW()/5, ScrH()/32)
	MusicSelect_Button:CenterHorizontal()
	MusicSelect_Button:SetY(ScrH()/3)

	local isFlashing = false
	
	local Back_Button = vgui.Create("DButton", AudioOptionsMenu)
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
		Back_Button.CurrentTextColor = GetButtonColor()
		text = ""
	end

	Back_Button.DoClick = function()
		showGameUI = true
		text = ""
		AudioOptionsMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)
    
	AudioOptionsMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_audio", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_audio", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	AudioOptionsMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenMusicSelector()
	showGameUI = true
	
	MusicMenu = vgui.Create("DFrame")
	MusicMenu:ShowCloseButton( false )
	MusicMenu:SetTitle("")
	MusicMenu:SetSize(ScrW(), ScrH())
	MusicMenu:Center()
	MusicMenu:MakePopup()
	MusicMenu:SetCursor("blank")
	MusicMenu.Think = nil

	local isFlashing = false
	
	local Music1_Button = vgui.Create("DButton", MusicMenu)
	Music1_Button:SetText("As Above So Below")
	Music1_Button:SetFont("MainMenu_Font_Models")
	Music1_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music1_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("As Above So Below", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("As Above So Below", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music1_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music1_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music1_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music1_Button.CurrentTextColor = GetButtonColor()
	end

	Music1_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/As_Above_So_Below.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music1_Button:SetContentAlignment(4)
	Music1_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music1_Button:CenterHorizontal(0.275)
	Music1_Button:CenterVertical(0.2)
	
	local isFlashing = false
	
	local Music2_Button = vgui.Create("DButton", MusicMenu)
	Music2_Button:SetText("Catacombs")
	Music2_Button:SetFont("MainMenu_MuchSmallerFont")
	Music2_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Catacombs", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Catacombs", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music2_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music2_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music2_Button.CurrentTextColor = GetButtonColor()
	end

	Music2_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Catacombs.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music2_Button:SetContentAlignment(4)
	Music2_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music2_Button:CenterHorizontal(0.275)
	Music2_Button:CenterVertical(0.235)
	
	local isFlashing = false
	
	local Music3_Button = vgui.Create("DButton", MusicMenu)
	Music3_Button:SetText("Crystal March")
	Music3_Button:SetFont("MainMenu_Font_Models")
	Music3_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music3_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Crystal March", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Crystal March", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music3_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musicwarped"
		Music3_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music3_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music3_Button.CurrentTextColor = GetButtonColor()
	end

	Music3_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Crystal_March.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music3_Button:SetContentAlignment(4)
	Music3_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music3_Button:CenterHorizontal(0.275)
	Music3_Button:CenterVertical(0.27)
	
	local isFlashing = false
	
	local Music4_Button = vgui.Create("DButton", MusicMenu)
	Music4_Button:SetText("Demise of Lava Golem")
	Music4_Button:SetFont("MainMenu_Font_Models")
	Music4_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music4_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Demise of Lava Golem", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Demise of Lava Golem", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music4_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictfe"
		Music4_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music4_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music4_Button.CurrentTextColor = GetButtonColor()
	end

	Music4_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Demise_of_Lava_Golem.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music4_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music4_Button:SetContentAlignment(4)
	Music4_Button:CenterHorizontal(0.275)
	Music4_Button:CenterVertical(0.303)
	
	local isFlashing = false
	
	local Music5_Button = vgui.Create("DButton", MusicMenu)
	Music5_Button:SetText("Desert Temple")
	Music5_Button:SetFont("MainMenu_Font_Models")
	Music5_Button:SetTextColor(Color(0, 0, 0, 0))
	Music5_Button.CurrentTextColor = GetButtonColor()
	
	Music5_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Desert Temple", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Desert Temple", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music5_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictfe"
		Music5_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music5_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music5_Button.CurrentTextColor = GetButtonColor()
	end

	Music5_Button.DoClick = function()
		RunConsoleCommand("sdm_music_path", "sound/music/Desert_Temple.mp3")
		text = ""
		MusicMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	Music5_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music5_Button:SetContentAlignment(4)
	Music5_Button:CenterHorizontal(0.275)
	Music5_Button:CenterVertical(0.3365)
	
	local isFlashing = false
	
	local Music6_Button = vgui.Create("DButton", MusicMenu)
	Music6_Button:SetText("Enlightening the World")
	Music6_Button:SetFont("MainMenu_Font_Models")
	Music6_Button:SetTextColor(Color(0, 0, 0, 0))
	Music6_Button.CurrentTextColor = GetButtonColor()
	
	Music6_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Enlightening the World", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Enlightening the World", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music6_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music6_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music6_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music6_Button.CurrentTextColor = GetButtonColor()
	end

	Music6_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Enlightening_the_World.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end

	Music6_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music6_Button:SetContentAlignment(4)
	Music6_Button:CenterHorizontal(0.275)
	Music6_Button:CenterVertical(0.37)
	
	local isFlashing = false
	local Music7_Button = vgui.Create("DButton", MusicMenu)
	Music7_Button:SetText("Freedom")
	Music7_Button:SetFont("MainMenu_Font_Models")
	Music7_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music7_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Freedom", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Freedom", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music7_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music7_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music7_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music7_Button.CurrentTextColor = GetButtonColor()
	end

	Music7_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Freedom.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end

	Music7_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music7_Button:SetContentAlignment(4)
	Music7_Button:CenterHorizontal(0.275)
	Music7_Button:CenterVertical(0.403)

	local isFlashing = false
	
	local Music8_Button = vgui.Create("DButton", MusicMenu)
	Music8_Button:SetText("Gates of Persepolis")
	Music8_Button:SetFont("MainMenu_Font_Models")
	Music8_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music8_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Gates of Persepolis", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gates of Persepolis", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music8_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music8_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music8_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music8_Button.CurrentTextColor = GetButtonColor()
	end

	Music8_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Gates_of_Persepolis.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music8_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music8_Button:SetContentAlignment(4)
	Music8_Button:CenterHorizontal(0.275)
	Music8_Button:CenterVertical(0.435)
	
	local isFlashing = false
	
	local Music9_Button = vgui.Create("DButton", MusicMenu)
	Music9_Button:SetText("Highlander Reptiloid")
	Music9_Button:SetFont("MainMenu_Font_Models")
	Music9_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music9_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Highlander Reptiloid", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Highlander Reptiloid", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music9_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictfe"
		Music9_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music9_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music9_Button.CurrentTextColor = GetButtonColor()
	end

	Music9_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Highlander_Reptiloid.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end

	Music9_Button:SetContentAlignment(4)
	Music9_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music9_Button:CenterHorizontal(0.275)
	Music9_Button:CenterVertical(0.4685)
	
	local isFlashing = false
	
	local Music10_Button = vgui.Create("DButton", MusicMenu)
	Music10_Button:SetText("Jingle Bells")
	Music10_Button:SetFont("MainMenu_Font_Models")
	Music10_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music10_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Jingle Bells", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Jingle Bells", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music10_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music10_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music10_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music10_Button.CurrentTextColor = GetButtonColor()
	end

	Music10_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Jingle_Bells.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music10_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music10_Button:SetContentAlignment(4)
	Music10_Button:CenterHorizontal(0.275)
	Music10_Button:CenterVertical(0.5)
	
	local isFlashing = false
	
	local Music11_Button = vgui.Create("DButton", MusicMenu)
	Music11_Button:SetText("Marshfreakinhoppers")
	Music11_Button:SetFont("MainMenu_Font_Models")
	Music11_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music11_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Marshfreakinhoppers", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Marshfreakinhoppers", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music11_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictfe"
		Music11_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music11_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music11_Button.CurrentTextColor = GetButtonColor()
	end

	Music11_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Marshfreakinhoppers.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music11_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music11_Button:SetContentAlignment(4)
	Music11_Button:CenterHorizontal(0.275)
	Music11_Button:CenterVertical(0.5325)
	
	local isFlashing = false
	
	local Music12_Button = vgui.Create("DButton", MusicMenu)
	Music12_Button:SetText("Red Station")
	Music12_Button:SetFont("MainMenu_Font_Models")
	Music12_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music12_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("Red Station", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Red Station", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music12_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music12_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music12_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music12_Button.CurrentTextColor = GetButtonColor()
	end

	Music12_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/Red_Station.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music12_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music12_Button:SetContentAlignment(4)
	Music12_Button:CenterHorizontal(0.275)
	Music12_Button:CenterVertical(0.566)
	
	local isFlashing = false
	
	local Music13_Button = vgui.Create("DButton", MusicMenu)
	Music13_Button:SetText("The Citadel")
	Music13_Button:SetFont("MainMenu_Font_Models")
	Music13_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music13_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("The Citadel", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("The Citadel", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music13_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music13_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music13_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music13_Button.CurrentTextColor = GetButtonColor()
	end

	Music13_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/The_Citadel.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music13_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music13_Button:SetContentAlignment(4)
	Music13_Button:CenterHorizontal(0.275)
	Music13_Button:CenterVertical(0.6)
	
	local isFlashing = false
	
	local Music14_Button = vgui.Create("DButton", MusicMenu)
	Music14_Button:SetText("The Grand Cathedral")
	Music14_Button:SetFont("MainMenu_Font_Models")
	Music14_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music14_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("The Grand Cathedral", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("The Grand Cathedral", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music14_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictse"
		Music14_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music14_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music14_Button.CurrentTextColor = GetButtonColor()
	end

	Music14_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/The_Grand_Cathedral.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music14_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music14_Button:SetContentAlignment(4)
	Music14_Button:CenterHorizontal(0.275)
	Music14_Button:CenterVertical(0.6345)
	
	local isFlashing = false
	
	local Music15_Button = vgui.Create("DButton", MusicMenu)
	Music15_Button:SetText("The Great Pyramid")
	Music15_Button:SetFont("MainMenu_Font_Models")
	Music15_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music15_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("The Great Pyramid", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("The Great Pyramid", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music15_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_musictfe"
		Music15_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Music15_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music15_Button.CurrentTextColor = GetButtonColor()
	end

	Music15_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/The_Great_Pyramid.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music15_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music15_Button:SetContentAlignment(4)
	Music15_Button:CenterHorizontal(0.275)
	Music15_Button:CenterVertical(0.6685)
	
	local isFlashing = false
	
	local Music16_Button = vgui.Create("DButton", MusicMenu)
	Music16_Button:SetText("The Lost Tomb Deathmatch")
	Music16_Button:SetFont("MainMenu_Font_Models")
	Music16_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music16_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("The Lost Tomb Deathmatch", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("The Lost Tomb Deathmatch", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music16_Button.OnCursorEntered = function()
		Music16_Button:SetCursor( "blank" )
		text = "#sdm_help_musictse"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Music16_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music16_Button.CurrentTextColor = GetButtonColor()
	end

	Music16_Button.DoClick = function()
		showGameUI = true
		text = ""
		RunConsoleCommand("sdm_music_path", "sound/music/The_Lost_Tomb_Deathmatch.mp3")
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Music16_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music16_Button:SetContentAlignment(4)
	Music16_Button:CenterHorizontal(0.275)
	Music16_Button:CenterVertical(0.701)
	
	local isFlashing = false
	
	local Music17_Button = vgui.Create("DButton", MusicMenu)
	Music17_Button:SetText("The Ride of the Marsh Hoppers")
	Music17_Button:SetFont("MainMenu_Font_Models")
	Music17_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Music17_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("The Ride of the Marsh Hoppers", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("The Ride of the Marsh Hoppers", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Music17_Button.OnCursorEntered = function()
		Music17_Button:SetCursor( "blank" )
		text = "#sdm_help_musictfe"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Music17_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Music17_Button.CurrentTextColor = GetButtonColor()
	end

	Music17_Button.DoClick = function()
		RunConsoleCommand("sdm_music_path", "sound/music/The_Ride_of_the_Marsh_Hoppers.mp3")
		text = ""
		MusicMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end
	
	Music17_Button:SetSize(ScrW()/4.5, ScrH()/20)
	Music17_Button:SetContentAlignment(4)
	Music17_Button:CenterHorizontal(0.275)
	Music17_Button:CenterVertical(0.736)

	local Back_Button = vgui.Create("DButton", MusicMenu)
	local isFlashing = false
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
		MusicMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)

	MusicMenu:MakePopup()
    
	MusicMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("MUSIC", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("MUSIC", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	MusicMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenProfileOptions()	
	showGameUI = true
	
	ProfileMenu = vgui.Create("DFrame")
	ProfileMenu:ShowCloseButton( false )
	ProfileMenu:SetTitle("")
	ProfileMenu:SetSize(ScrW(), ScrH())
	ProfileMenu:Center()
	ProfileMenu:MakePopup()
	ProfileMenu:SetCursor("blank")
	ProfileMenu.Think = nil
	
	local ModelBack = vgui.Create("DImage", ProfileMenu)
	ModelBack:SetX(ScrW()/1.475)
	ModelBack:SetY(ScrH()/4.2)
	ModelBack:SetSize(ScrW()/3.5+2, ScrH()/1.8+2)
	ModelBack.Paint = function(self, w, h)
		local offsetx = math.sin(CurTime() * 1.5) * 30
		local offsety = math.cos(CurTime()* 1.5) * 30
		
		local offsetx2 = math.sin(CurTime()* -0.5) * 15
		local offsety2 = math.cos(CurTime()* -0.5) * 15
		
		local hudr, hudg, hudb = GetFrameMMFColor()
		
		if GAMEMODE:GetHUDSkin() == 2 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/ModelBack")
		elseif GAMEMODE:GetHUDSkin() == 1 then
			modelbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/ModelBack")
		end
		
		surface.SetDrawColor(GetFrameMMFColor())
		surface.DrawRect(0, 0, ScrW()/3.5+2, ScrH()/1.8+2)
		surface.SetTexture( modelbg )
		surface.DrawTexturedRect( 1, 1, ScrW()/3.5, ScrH()/1.8 )
		
		if GAMEMODE:GetHUDSkin() == 2 then
			return
		elseif GAMEMODE:GetHUDSkin() == 1 then
			surface.SetTexture(ssbg)
		end
		
		surface.SetDrawColor(hudr, hudg, hudb, 60)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV(offsetx - 48, offsety - 48, 2048, 2048, 0, 0, 2048 / texW, 2048 / texH)
		
		surface.SetDrawColor(hudr, hudg, hudb, 75)
		surface.DrawTexturedRectUV(offsetx2 - 48, offsety2 - 48, 1024, 1024, 0, 0, 2048 / texW, 2048 / texH)
	end
	
	local ModelFrame = vgui.Create( "DModelPanel", ProfileMenu )
	ModelFrame:SetSize(ScrW() / 3,ScrH() / 1.5)
	ModelFrame:SetModel(GetConVarString("sdm_playermodel"))
	ModelFrame:SetX(ScrW() / 1.52)
	ModelFrame:SetY(ScrH() / 6)
	
	function ModelFrame:LayoutEntity(Entity)		
		ModelFrame:RunAnimation()
		Entity:SetSequence(PoseAnimations[randompose])
		if engine.ActiveGamemode() == "serioussam_tdm" then 
			Entity:SetModel("models/pechenko_121/redrick.mdl")
			if LocalPlayer():Team() == 1 then
				Entity:SetSkin(0)
			elseif LocalPlayer():Team() == 2 then
				Entity:SetSkin(5)
			end
		else
			Entity:SetSkin(GetConVarNumber("sdm_playermodel_skin"))
			Entity:SetBodygroup(GetConVarString("sdm_playermodel_bodygroup"), 1)
			Entity:SetModel(GetConVarString("sdm_playermodel"))
		end
		
		local r = GetConVarNumber("ss_hud_color_r") or 255
		local g = GetConVarNumber("ss_hud_color_g") or 255
		local b = GetConVarNumber("ss_hud_color_b") or 255
		
		if SeriousHUD:GetSkin() == 1 then
			self:SetAmbientLight(Color(r * 0.15, g * 0.15, b * 0.15))
		else
			self:SetAmbientLight(Color(90 * 0.15, 130 * 0.15, 190 * 0.15))
		end
	end
	
	local shadowMatrix = Matrix()
	shadowMatrix:Scale(Vector(1, 1, 0.001))
	shadowMatrix:SetField(2, 3, -1)

	function ModelFrame:DrawModel()
		local ent = self.Entity
		if not IsValid(ent) then return end

		render.ClearDepth()

		ent:EnableMatrix("RenderMultiply", shadowMatrix)
		ent:SetupBones() 

		render.SetColorModulation(0, 0, 0) 
		
		ent:DrawModel()
		
		ent:DisableMatrix("RenderMultiply")
		ent:SetupBones() 

		render.MaterialOverride()
		render.SetColorModulation(1, 1, 1)
		ent:DrawModel()
	end

	ModelFrame.OnCursorEntered = function()
		ModelFrame:SetCursor("blank")
	end

	if engine.ActiveGamemode() == "serioussam_dm" then
		local isFlashing = false
		
		local PMSelect_Button = vgui.Create("DButton", ProfileMenu)
		PMSelect_Button:SetFont("MainMenu_MuchSmallerFont")
		PMSelect_Button:SetText("#sdm_selectpm")
		PMSelect_Button:SetTextColor(Color(0, 0, 0, 0))

		PMSelect_Button.Paint = function(self, w, h) 
			if isFlashing then
				ButtonFlashing(self)
			else
				self.CurrentTextColor = GetButtonColor()
			end

			local col = self.CurrentTextColor or GetButtonColor()
			draw.SimpleText("#sdm_selectpm", "MainMenu_MuchSmallerFont", 2, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("#sdm_selectpm", "MainMenu_MuchSmallerFont", 0, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
			PMSelect_Button.CurrentTextColor = GetButtonColor()
		end

		PMSelect_Button:SetSize(ScrW()/6, ScrH()/20)
		PMSelect_Button:SetContentAlignment(4)
		PMSelect_Button:SetX(ScrW()/1.475)
		PMSelect_Button:SetY(ScrH()/1.23)
	
	
		local ModelButton = vgui.Create( "DButton", ProfileMenu )
		ModelButton:SetText( "" )			
		
		ModelButton.Paint = function(self, w, h) end
		
		ModelButton.DoClick = function()
			surface.PlaySound("menus/press.wav")
			OpenModelMenu()
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
			PMSelect_Button.CurrentTextColor = GetButtonColor()
		end
		
		ModelButton:SetSize( ScrW() / 3.5, ScrH() / 1.6 )
		ModelButton:SetPos( ScrW() / 1.475, ScrH() / 4.2 )
	end
	local isFlashing = false
	
	local Name_Button = vgui.Create("DButton", ProfileMenu)
	local Nickname_Button = vgui.Create("DButton", ProfileMenu)
	
	Name_Button:SetText("#sdm_name")
	Name_Button:SetFont("MainMenu_MuchSmallerFont")
	Name_Button:SetTextColor(Color(0, 0, 0, 0))

	Name_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_name", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_name", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Name_Button.OnCursorEntered = function()
		isFlashing = true
		Name_Button:SetCursor("blank")
		surface.PlaySound("menus/select.wav")
	end

	Name_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Name_Button.CurrentTextColor = GetButtonColor()
		Nickname_Button.CurrentTextColor = GetButtonColor()
	end
	
	Name_Button:SetSize(ScrW()/6, ScrH()/16)
	Name_Button:SetContentAlignment(4)
	Name_Button:SetX(ScrW()-ScrW() / 1.05)
	Name_Button:CenterVertical(0.3)
	
	Nickname_Button:SetText(LocalPlayer():Nick())
	Nickname_Button:SetFont("MainMenu_MuchSmallerFont")
	Nickname_Button:SetTextColor(Color(0, 0, 0, 0))

	Nickname_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(LocalPlayer():Nick(), "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(LocalPlayer():Nick(), "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Nickname_Button.OnCursorEntered = function()
		isFlashing = true
		Nickname_Button:SetCursor("blank")
		surface.PlaySound("menus/select.wav")
	end

	Nickname_Button.OnCursorExited = function()
		isFlashing = false
		Nickname_Button.CurrentTextColor = GetButtonColor()
		Name_Button.CurrentTextColor = GetButtonColor()
	end
	
	Nickname_Button:SetSize(ScrW()/6, ScrH()/16)
	Nickname_Button:SetContentAlignment(4)
	Nickname_Button:SetX(ScrW()-ScrW()/1.345)
	Nickname_Button:CenterVertical(0.3)
	
	local isFlashing = false
	
	local Team_Button = vgui.Create("DButton", ProfileMenu)
	local Team_2_Button = vgui.Create("DButton", ProfileMenu)
	
	Team_Button:SetText("#sdm_team")
	Team_Button:SetFont("MainMenu_MuchSmallerFont")
	Team_Button:SetTextColor(Color(0, 0, 0, 0))

	Team_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_team", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_team", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Team_Button.OnCursorEntered = function()
		isFlashing = true
		Team_Button:SetCursor("blank")
		surface.PlaySound("menus/select.wav")
	end

	Team_Button.OnCursorExited = function()
		isFlashing = false
		text = ""
		Team_Button.CurrentTextColor = GetButtonColor()
		Team_2_Button.CurrentTextColor = GetButtonColor()
	end
	
	Team_Button:SetSize(ScrW()/6, ScrH()/16)
	Team_Button:SetContentAlignment(4)
	Team_Button:SetX(ScrW()-ScrW() / 1.05)
	Team_Button:CenterVertical(0.34)
	
	if engine.ActiveGamemode() == "serioussam_tdm" and LocalPlayer():Team() == 1 then
		Team_2_Button:SetText("#sdm_redteam")
	elseif engine.ActiveGamemode() == "serioussam_tdm" and LocalPlayer():Team() == 2 then
		Team_2_Button:SetText("#sdm_blueteam")
	else
		Team_2_Button:SetText("#sdm_none")
	end
	Team_2_Button:SetFont("MainMenu_MuchSmallerFont")
	Team_2_Button:SetTextColor(Color(0, 0, 0, 0))

	Team_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		if engine.ActiveGamemode() == "serioussam_tdm" and LocalPlayer():Team() == 1 then
			draw.SimpleText("#sdm_redteam", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("#sdm_redteam", "MainMenu_MuchSmallerFont", 15, h / 2, Color(255,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		elseif engine.ActiveGamemode() == "serioussam_tdm" and LocalPlayer():Team() == 2 then
			draw.SimpleText("#sdm_blueteam", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("#sdm_blueteam", "MainMenu_MuchSmallerFont", 15, h / 2, Color(0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("#sdm_none", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("#sdm_none", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	Team_2_Button.OnCursorEntered = function()
		isFlashing = true
		Team_2_Button:SetCursor("blank")
		surface.PlaySound("menus/select.wav")
	end

	Team_2_Button.OnCursorExited = function()
		isFlashing = false
		Team_2_Button.CurrentTextColor = GetButtonColor()
		Team_Button.CurrentTextColor = GetButtonColor()
	end
	
	Team_2_Button:SetSize(ScrW()/6, ScrH()/16)
	Team_2_Button:SetContentAlignment(4)
	Team_2_Button:SetX(ScrW()-ScrW()/1.345)
	Team_2_Button:CenterVertical(0.34)

	local isFlashing = false
	
	local Crosshair_Button = vgui.Create("DButton", ProfileMenu)
	local Crosshair_Image = vgui.Create("DImageButton", ProfileMenu)
	
	Crosshair_Button:SetText("#sdm_crosshair")
	Crosshair_Button:SetFont("MainMenu_MuchSmallerFont")
	Crosshair_Button:SetTextColor(Color(0, 0, 0, 0))
	
	Crosshair_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_crosshair", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_crosshair", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Crosshair_Button.OnCursorEntered = function()
		isFlashing = true
		Crosshair_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Crosshair_Button.OnCursorExited = function()
		isFlashing = false
		Crosshair_Button.CurrentTextColor = GetButtonColor()
	end
	
	Crosshair_Button.DoClick = function()
		surface.PlaySound("menus/press.wav")
		local crosshair_cvar = GetConVar("ss_crosshair")
		local crosshair_value = crosshair_cvar:GetInt() + 1
		if crosshair_value > 7 then
			crosshair_cvar:SetInt(0)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_cvar:GetInt())
		else
			RunConsoleCommand("ss_crosshair", crosshair_value)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_value)
		end
	end
	
	Crosshair_Button:SetSize(ScrW()/1.75, ScrH()/16)
	Crosshair_Button:SetContentAlignment(4)
	Crosshair_Button:SetX(ScrW()-ScrW() / 1.05)
	Crosshair_Button:CenterVertical(0.45)
	
	Crosshair_Image:SetSize(ScrW()/48, ScrW() / 48)
	if GetConVar("ss_crosshair"):GetInt() > 7 or GetConVar("ss_crosshair"):GetInt() < 0 then
		Crosshair_Image:SetImage("vgui/serioussam/CrosshairError")
	else
		Crosshair_Image:SetImage("vgui/serioussam/Crosshair".. GetConVar("ss_crosshair"):GetInt())
	end
	
	Crosshair_Image.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
	end
	
	Crosshair_Image.DoClick = function()
		surface.PlaySound("menus/press.wav")
		local crosshair_cvar = GetConVar("ss_crosshair")
		local crosshair_value = crosshair_cvar:GetInt() + 1
		if crosshair_value > 7 then
			crosshair_cvar:SetInt(0)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_cvar:GetInt())
		else
			RunConsoleCommand("ss_crosshair", crosshair_value)
			Crosshair_Image:SetImage("vgui/serioussam/Crosshair" .. crosshair_value)
		end
	end
	
	Crosshair_Image.OnCursorEntered = function()
		isFlashing = true
		Crosshair_Image:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Crosshair_Image.OnCursorExited = function()
		isFlashing = false
		Crosshair_Button.CurrentTextColor = GetButtonColor()
	end
	
	Crosshair_Image.DepressImage = function() return end
	
	Crosshair_Image:SetX(ScrW()/1.6)
	Crosshair_Image:CenterVertical(0.45)
	
	local isFlashing = false
	
	local Bob_Button = vgui.Create("DButton", ProfileMenu)
	local Bob_2_Button = vgui.Create("DButton", ProfileMenu)
	
	Bob_Button:SetText("#sdm_viewbob")
	Bob_Button:SetFont("MainMenu_MuchSmallerFont")
	Bob_Button:SetTextColor(Color(0, 0, 0, 0))

	Bob_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_viewbob", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_viewbob", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Bob_Button.DoClick = function()
		local cvar = GetConVar("ss_bob")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("ss_bob", "1")
			Bob_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("ss_bob", "0")
			Bob_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Bob_Button.OnCursorEntered = function()
		isFlashing = true
		Bob_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Bob_Button.OnCursorExited = function()
		isFlashing = false
		Bob_Button.CurrentTextColor = GetButtonColor()
		Bob_2_Button.CurrentTextColor = GetButtonColor()
	end
	
	Bob_Button:SetSize(ScrW()/3, ScrH()/16)
	Bob_Button:SetContentAlignment(4)
	Bob_Button:SetX(ScrW()-ScrW() / 1.05)
	Bob_Button:CenterVertical(0.4875)
	
	if GetConVarNumber("ss_bob") == 0 then
		Bob_2_Button:SetText("#sdm_no")
	elseif GetConVarNumber("ss_bob") == 1 then
		Bob_2_Button:SetText("#sdm_yes")
	end
	Bob_2_Button:SetFont("MainMenu_MuchSmallerFont")
	Bob_2_Button:SetTextColor(Color(0, 0, 0, 0))

	Bob_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	Bob_2_Button.DoClick = function()
		local cvar = GetConVar("ss_bob")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("ss_bob", "1")
			Bob_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("ss_bob", "0")
			Bob_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Bob_2_Button.OnCursorEntered = function()
		isFlashing = true
		Bob_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Bob_2_Button.OnCursorExited = function()
		isFlashing = false
		Bob_2_Button.CurrentTextColor = GetButtonColor()
		Bob_Button.CurrentTextColor = GetButtonColor()
	end
	
	Bob_2_Button:SetSize(ScrW()/3, ScrH()/16)
	Bob_2_Button:SetContentAlignment(6)
	Bob_2_Button:SetX(ScrW()-ScrW()/1.473)
	Bob_2_Button:CenterVertical(0.4875)
	
	local isFlashing = false
	
	local HUD_Button = vgui.Create("DButton", ProfileMenu)
	local HUD_2_Button = vgui.Create("DButton", ProfileMenu)
	
	HUD_Button:SetText("#sdm_hudtheme")
	HUD_Button:SetFont("MainMenu_MuchSmallerFont")
	HUD_Button:SetTextColor(Color(0, 0, 0, 0))

	HUD_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_hudtheme", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_hudtheme", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	HUD_Button.DoClick = function()
		local cvar = GetConVar("ss_hud_skin")
		if cvar then
			local skin = cvar:GetInt()
			local children = ProfileMenu:GetChildren()
			table.Add(children, EscMenu:GetChildren())
			table.Add(children, OptionsMenu:GetChildren())
			if skin == 2 then
				RunConsoleCommand("ss_hud_skin", "1")
				HUD_2_Button:SetText("#sdm_tfe")
				UpdateButtonsSkin(children, 1)
			elseif skin == 1 then
				RunConsoleCommand("ss_hud_skin", "2")	
				HUD_2_Button:SetText("#sdm_tse")
				UpdateButtonsSkin(children, 2)
			end
		end
		surface.PlaySound("menus/press.wav")
	end
	
	HUD_Button.OnCursorEntered = function()
		HUD_Button:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	HUD_Button.OnCursorExited = function()
		isFlashing = false
		HUD_Button.CurrentTextColor = GetButtonColor()
		HUD_2_Button.CurrentTextColor = GetButtonColor()
	end

	HUD_Button:SetWidth(ScrW()/3)
	HUD_Button:SizeToContentsY()
	HUD_Button:SetContentAlignment(4)
	HUD_Button:SetX(ScrW()-ScrW() / 1.05)
	HUD_Button:CenterVertical(0.524)
	
	if GAMEMODE:GetHUDSkin() == 2 then
		HUD_2_Button:SetText("#sdm_tse")
	elseif GAMEMODE:GetHUDSkin() == 1 then
		HUD_2_Button:SetText("#sdm_tfe")
	end
	HUD_2_Button:SetFont("MainMenu_MuchSmallerFont")
	HUD_2_Button:SetTextColor(Color(0, 0, 0, 0))

	HUD_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	HUD_2_Button.DoClick = function()
		local cvar = GetConVar("ss_hud_skin")
		local children = ProfileMenu:GetChildren()
		table.Add(children, EscMenu:GetChildren())
		table.Add(children, OptionsMenu:GetChildren())
		if cvar:GetInt() == 2 then
			RunConsoleCommand("ss_hud_skin", "1")
			HUD_2_Button:SetText("#sdm_tfe")
			UpdateButtonsSkin(children, 1)
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("ss_hud_skin", "2")	
			HUD_2_Button:SetText("#sdm_tse")
			UpdateButtonsSkin(children, 2)
		end
		surface.PlaySound("menus/press.wav")
	end
	
	HUD_2_Button.OnCursorEntered = function()
		isFlashing = true
		HUD_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	HUD_2_Button.OnCursorExited = function()
		isFlashing = false
		HUD_2_Button.CurrentTextColor = GetButtonColor()
		HUD_Button.CurrentTextColor = GetButtonColor()
	end

	HUD_2_Button:SetSize(ScrW()/3, ScrH()/16)
	HUD_2_Button:SetContentAlignment(6)
	HUD_2_Button:SetX(ScrW()-ScrW()/1.473)
	HUD_2_Button:CenterVertical(0.524)

	local isFlashing = false
	
	local TFE_Color_Button = vgui.Create("DButton", ProfileMenu)
	TFE_Color_Button:SetText("#sdm_tfehudcolor")
	TFE_Color_Button:SetFont("MainMenu_MuchSmallerFont")
	TFE_Color_Button:SetTextColor(Color(0, 0, 0, 0))
	
	TFE_Color_Button.DoClick = function()
		local cvar_r = GetConVar("ss_hud_color_r")
		local cvar_g = GetConVar("ss_hud_color_g")
		local cvar_b = GetConVar("ss_hud_color_b")
		local children = ProfileMenu:GetChildren()
		table.Add(children, EscMenu:GetChildren())
		table.Add(children, OptionsMenu:GetChildren())
		if cvar_r:GetInt() == 255 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "0")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 0 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 0 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "255")
		elseif cvar_r:GetInt() == 0 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "0")
			RunConsoleCommand("ss_hud_color_b", "255")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 0 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "255")
		else
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	TFE_Color_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_tfehudcolor", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_tfehudcolor", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	TFE_Color_Button.OnCursorEntered = function()
		isFlashing = true
		TFE_Color_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	TFE_Color_Button.OnCursorExited = function()
		isFlashing = false
		TFE_Color_Button.CurrentTextColor = GetButtonColor()
	end

	TFE_Color_Button:SetSize(ScrW()/3, ScrH()/16)
	TFE_Color_Button:SetContentAlignment(4)
	TFE_Color_Button:SetX(ScrW()-ScrW() / 1.05)
	TFE_Color_Button:CenterVertical(0.56)
	
	local TFE_Color_2_Button = vgui.Create("DButton", ProfileMenu)
	TFE_Color_2_Button:SetText("#sdm_tfehudcolor")
	TFE_Color_2_Button:SetFont("MainMenu_MuchSmallerFont")
	TFE_Color_2_Button:SetTextColor(Color(0, 0, 0, 0))

	TFE_Color_2_Button.Paint = function(self, w, h)
		local hud_r = GetConVar("ss_hud_color_r"):GetInt()
		local hud_g = GetConVar("ss_hud_color_g"):GetInt()
		local hud_b = GetConVar("ss_hud_color_b"):GetInt()
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(TFE_Color_2_Button:GetWide()-TFE_Color_2_Button:GetTall() / 1.45 - 1, TFE_Color_2_Button:GetTall() / 3 - 1, ScrH() / 48 + 2, ScrH() / 48 + 2)
		surface.SetDrawColor(hud_r,hud_g,hud_b,255)
		surface.DrawRect(TFE_Color_2_Button:GetWide()-TFE_Color_2_Button:GetTall() / 1.45, TFE_Color_2_Button:GetTall() / 3, ScrH() / 48, ScrH() / 48)
	end
	
	TFE_Color_2_Button.DoClick = function()
		local cvar_r = GetConVar("ss_hud_color_r")
		local cvar_g = GetConVar("ss_hud_color_g")
		local cvar_b = GetConVar("ss_hud_color_b")
		local children = ProfileMenu:GetChildren()
		table.Add(children, EscMenu:GetChildren())
		table.Add(children, OptionsMenu:GetChildren())
		if cvar_r:GetInt() == 255 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "0")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 0 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		elseif cvar_r:GetInt() == 0 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 0 then
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "255")
		elseif cvar_r:GetInt() == 0 and cvar_g:GetInt() == 255 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "0")
			RunConsoleCommand("ss_hud_color_b", "255")
		elseif cvar_r:GetInt() == 255 and cvar_g:GetInt() == 0 and cvar_b:GetInt() == 255 then
			RunConsoleCommand("ss_hud_color_r", "255")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "255")
		else
			RunConsoleCommand("ss_hud_color_r", "0")
			RunConsoleCommand("ss_hud_color_g", "255")
			RunConsoleCommand("ss_hud_color_b", "0")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	TFE_Color_2_Button.OnCursorEntered = function()
		isFlashing = true
		TFE_Color_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	TFE_Color_2_Button.OnCursorExited = function()
		isFlashing = false
		TFE_Color_2_Button.CurrentTextColor = GetButtonColor()
	end

	TFE_Color_2_Button:SetSize(ScrW()/3, ScrH()/16)
	TFE_Color_2_Button:SetContentAlignment(6)
	TFE_Color_2_Button:SetX(ScrW()-ScrW()/1.473)
	TFE_Color_2_Button:CenterVertical(0.56)
	
	local isFlashing = false
	
	local Announcer_Button = vgui.Create("DButton", ProfileMenu)
	local Announcer_2_Button = vgui.Create("DButton", ProfileMenu)
	
	Announcer_Button:SetText("#sdm_announcer")
	Announcer_Button:SetFont("MainMenu_MuchSmallerFont")
	Announcer_Button:SetTextColor(Color(0, 0, 0, 0))

	Announcer_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_announcer", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_announcer", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Announcer_Button.DoClick = function()
		local cvar = GetConVar("sdm_announcer_enabled")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_announcer_enabled", "1")
			Announcer_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_announcer_enabled", "0")
			Announcer_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Announcer_Button.OnCursorEntered = function()
		isFlashing = true
		Announcer_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Announcer_Button.OnCursorExited = function()
		isFlashing = false
		Announcer_Button.CurrentTextColor = GetButtonColor()
		Announcer_2_Button.CurrentTextColor = GetButtonColor()
	end
	
	Announcer_Button:SetSize(ScrW()/3, ScrH()/16)
	Announcer_Button:SetContentAlignment(4)
	Announcer_Button:SetX(ScrW()-ScrW() / 1.05)
	Announcer_Button:CenterVertical(0.595)
	
	if GetConVarNumber("sdm_announcer_enabled") == 0 then
		Announcer_2_Button:SetText("#sdm_no")
	elseif GetConVarNumber("sdm_announcer_enabled") == 1 then
		Announcer_2_Button:SetText("#sdm_yes")
	end
	Announcer_2_Button:SetFont("MainMenu_MuchSmallerFont")
	Announcer_2_Button:SetTextColor(Color(0, 0, 0, 0))

	Announcer_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	Announcer_2_Button.DoClick = function()
		local cvar = GetConVar("sdm_announcer_enabled")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_announcer_enabled", "1")
			Announcer_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_announcer_enabled", "0")
			Announcer_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Announcer_2_Button.OnCursorEntered = function()
		isFlashing = true
		Announcer_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Announcer_2_Button.OnCursorExited = function()
		isFlashing = false
		Announcer_2_Button.CurrentTextColor = GetButtonColor()
		Announcer_Button.CurrentTextColor = GetButtonColor()
	end
	
	Announcer_2_Button:SetSize(ScrW()/3, ScrH()/16)
	Announcer_2_Button:SetContentAlignment(6)
	Announcer_2_Button:SetX(ScrW()-ScrW()/1.473)
	Announcer_2_Button:CenterVertical(0.595)
	
	local isFlashing = false
	
	local Thirdperson_Button = vgui.Create("DButton", ProfileMenu)
	local Thirdperson_2_Button = vgui.Create("DButton", ProfileMenu)
	
	Thirdperson_Button:SetText("#sdm_thirdperson")
	Thirdperson_Button:SetFont("MainMenu_MuchSmallerFont")
	Thirdperson_Button:SetTextColor(Color(0, 0, 0, 0))

	Thirdperson_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_thirdperson", "MainMenu_MuchSmallerFont", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_thirdperson", "MainMenu_MuchSmallerFont", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	Thirdperson_Button.DoClick = function()
		local cvar = GetConVar("sdm_prefer_thirdperson")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_prefer_thirdperson", "1")
			Thirdperson_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_prefer_thirdperson", "0")
			Thirdperson_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Thirdperson_Button.OnCursorEntered = function()
		isFlashing = true
		Thirdperson_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Thirdperson_Button.OnCursorExited = function()
		isFlashing = false
		Thirdperson_Button.CurrentTextColor = GetButtonColor()
		Thirdperson_2_Button.CurrentTextColor = GetButtonColor()
	end
	
	Thirdperson_Button:SetSize(ScrW()/3, ScrH()/16)
	Thirdperson_Button:SetContentAlignment(4)
	Thirdperson_Button:SetX(ScrW()-ScrW() / 1.05)
	Thirdperson_Button:CenterVertical(0.6325)
	
	if GetConVarNumber("sdm_prefer_thirdperson") == 0 then
		Thirdperson_2_Button:SetText("#sdm_no")
	elseif GetConVarNumber("sdm_prefer_thirdperson") == 1 then
		Thirdperson_2_Button:SetText("#sdm_yes")
	end
	Thirdperson_2_Button:SetFont("MainMenu_MuchSmallerFont")
	Thirdperson_2_Button:SetTextColor(Color(0, 0, 0, 0))

	Thirdperson_2_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 13, h / 2 + 3, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), "MainMenu_MuchSmallerFont", w - 15, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	Thirdperson_2_Button.DoClick = function()
		local cvar = GetConVar("sdm_prefer_thirdperson")
		if cvar:GetInt() == 0 then
			RunConsoleCommand("sdm_prefer_thirdperson", "1")
			Thirdperson_2_Button:SetText("#sdm_yes")
		elseif cvar:GetInt() == 1 then
			RunConsoleCommand("sdm_prefer_thirdperson", "0")
			Thirdperson_2_Button:SetText("#sdm_no")
		end
		surface.PlaySound("menus/press.wav")
	end
	
	Thirdperson_2_Button.OnCursorEntered = function()
		isFlashing = true
		Thirdperson_2_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	Thirdperson_2_Button.OnCursorExited = function()
		isFlashing = false
		Thirdperson_2_Button.CurrentTextColor = GetButtonColor()
		Thirdperson_Button.CurrentTextColor = GetButtonColor()
	end
	
	Thirdperson_2_Button:SetSize(ScrW()/3, ScrH()/16)
	Thirdperson_2_Button:SetContentAlignment(6)
	Thirdperson_2_Button:SetX(ScrW()-ScrW()/1.473)
	Thirdperson_2_Button:CenterVertical(0.6325)
	
	local isFlashing = false
	
	local Back_Button = vgui.Create("DButton", ProfileMenu)
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
		ProfileMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)

	ProfileMenu:MakePopup()
    
	ProfileMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_profile", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_profile", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	ProfileMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenModelMenu()
	text = ""
	text_help = ""

	ModelMenu = vgui.Create("DFrame")
	ModelMenu:ShowCloseButton( false )
	ModelMenu:SetTitle("")
	ModelMenu:SetSize(ScrW(), ScrH())
	ModelMenu:Center()
	ModelMenu:MakePopup()
	ModelMenu:SetCursor("blank")
	ModelMenu.Think = nil

	local Back_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
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
		Back_Button:SetCursor("blank")
		isFlashing = true
		surface.PlaySound("menus/select.wav")
		text_help = "#sdm_help_back"
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button.CurrentTextColor = GetButtonColor()
		text_help = ""
	end

	Back_Button.DoClick = function()
		showGameUI = true
		text_help = ""
		ModelMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	Back_Button:SizeToContents()
	Back_Button:SetPos(ScrW() - ScrW() / 1.0215, ScrH() - ScrH() / 10)

	local isFlashing = false

	--Beheaded Ben
	local Beheaded_Ben_Button = vgui.Create("DButton", ModelMenu)
	Beheaded_Ben_Button:SetFont("MainMenu_Font_Models")
	Beheaded_Ben_Button:SetText("#sdm_beheadedben")
	Beheaded_Ben_Button:SetTextColor(Color(0, 0, 0, 0))

	Beheaded_Ben_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Beheaded_Ben_Button.OnCursorEntered = function()
		isFlashing = true
		text = "#sdm_help_beheadedben"
		text_help = "#sdm_help_load"
		Beheaded_Ben_Button:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end
	
	Beheaded_Ben_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Beheaded_Ben_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Beheaded_Ben_Button:SetSize(ScrW()/6, ScrH()/20)
	Beheaded_Ben_Button:SetContentAlignment(4)
	Beheaded_Ben_Button:CenterHorizontal(0.275)
	Beheaded_Ben_Button:SetY(ScrH() / 7.9)
	
	local isFlashing = false
	
	--Blue Bill
	local Blue_Bill_Button = vgui.Create("DButton", ModelMenu)
	Blue_Bill_Button:SetFont("MainMenu_Font_Models")
	Blue_Bill_Button:SetText("#sdm_bluebill")
	Blue_Bill_Button:SetTextColor(Color(0, 0, 0, 0))

	Blue_Bill_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()	
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Blue_Bill_Button.OnCursorEntered = function()
		Blue_Bill_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots1"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Blue_Bill_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Blue_Bill_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Blue_Bill_Button:SetSize(ScrW()/6, ScrH()/20)
	Blue_Bill_Button:SetContentAlignment(4)
	Blue_Bill_Button:CenterHorizontal(0.275)
	Blue_Bill_Button:SetY(ScrH() / 6.3)
	
	--Boxer Barry
	local Boxer_Barry_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Boxer_Barry_Button:SetFont("MainMenu_Font_Models")
	Boxer_Barry_Button:SetText("#sdm_boxerbarry")
	Boxer_Barry_Button:SetTextColor(Color(0, 0, 0, 0))
	Boxer_Barry_Button:SetContentAlignment(4)
	Boxer_Barry_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Boxer_Barry_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Boxer_Barry_Button.OnCursorEntered = function()
		Boxer_Barry_Button:SetCursor( "blank" )
		text = "#sdm_help_boxerbarry"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Boxer_Barry_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Boxer_Barry_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Boxer_Barry_Button:CenterHorizontal(0.275)
	Boxer_Barry_Button:SetY(ScrH() / 5.23)
	
	--Commander Cliff
	local Comm_Cliff_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Comm_Cliff_Button:SetFont("MainMenu_Font_Models")
	Comm_Cliff_Button:SetText("#sdm_commcliff")
	Comm_Cliff_Button:SetTextColor(Color(0, 0, 0, 0))
	Comm_Cliff_Button:SetContentAlignment(4)
	Comm_Cliff_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Comm_Cliff_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Comm_Cliff_Button.OnCursorEntered = function()
		Comm_Cliff_Button:SetCursor( "blank" )
		text = "#sdm_help_commcliff"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Comm_Cliff_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Comm_Cliff_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Comm_Cliff_Button:CenterHorizontal(0.275)
	Comm_Cliff_Button:SetY(ScrH() / 4.49)
	
	--Dancing Denzell
	local Dancing_Den_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Dancing_Den_Button:SetFont("MainMenu_Font_Models")
	Dancing_Den_Button:SetText("#sdm_dancingden")
	Dancing_Den_Button:SetTextColor(Color(0, 0, 0, 0))
	Dancing_Den_Button:SetContentAlignment(4)
	Dancing_Den_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Dancing_Den_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Dancing_Den_Button.OnCursorEntered = function()
		Dancing_Den_Button:SetCursor( "blank" )
		text = "#sdm_help_dancingden"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Dancing_Den_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Dancing_Den_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Dancing_Den_Button:CenterHorizontal(0.275)
	Dancing_Den_Button:SetY(ScrH() / 3.9)
	
	--FastFinger Freddy
	local FastFinger_Freddy_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	FastFinger_Freddy_Button:SetFont("MainMenu_Font_Models")
	FastFinger_Freddy_Button:SetText("#sdm_fastfingerfreddy")
	FastFinger_Freddy_Button:SetTextColor(Color(0, 0, 0, 0))
	FastFinger_Freddy_Button:SetContentAlignment(4)
	FastFinger_Freddy_Button:SetSize(ScrW()/6, ScrH()/20)
	
	FastFinger_Freddy_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	FastFinger_Freddy_Button.OnCursorEntered = function()
		FastFinger_Freddy_Button:SetCursor( "blank" )
		text = "#sdm_help_fastfingerfreddy"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	FastFinger_Freddy_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	FastFinger_Freddy_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	FastFinger_Freddy_Button:CenterHorizontal(0.275)
	FastFinger_Freddy_Button:SetY(ScrH() / 3.465)
	
	--Green Gary
	local Green_Gary_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Green_Gary_Button:SetFont("MainMenu_Font_Models")
	Green_Gary_Button:SetText("#sdm_greengary")
	Green_Gary_Button:SetTextColor(Color(0, 0, 0, 0))
	Green_Gary_Button:SetContentAlignment(4)
	Green_Gary_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Green_Gary_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Green_Gary_Button.OnCursorEntered = function()
		Green_Gary_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots1"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Green_Gary_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Green_Gary_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Green_Gary_Button:CenterHorizontal(0.275)
	Green_Gary_Button:SetY(ScrH() / 3.12)
	
	--Groovy Greg
	local Groovy_Greg_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Groovy_Greg_Button:SetFont("MainMenu_Font_Models")
	Groovy_Greg_Button:SetText("#sdm_groovygreg")
	Groovy_Greg_Button:SetTextColor(Color(0, 0, 0, 0))
	Groovy_Greg_Button:SetContentAlignment(4)
	Groovy_Greg_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Groovy_Greg_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Groovy_Greg_Button.OnCursorEntered = function()
		Groovy_Greg_Button:SetCursor( "blank" )
		text = "#sdm_help_groovygreg"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Groovy_Greg_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Groovy_Greg_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Groovy_Greg_Button:CenterHorizontal(0.275)
	Groovy_Greg_Button:SetY(ScrH() / 2.84)
	
	--Hilarious Harry
	local Hilly_Harry_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Hilly_Harry_Button:SetFont("MainMenu_Font_Models")
	Hilly_Harry_Button:SetText("#sdm_hillyharry")
	Hilly_Harry_Button:SetTextColor(Color(0, 0, 0, 0))
	Hilly_Harry_Button:SetContentAlignment(4)
	Hilly_Harry_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Hilly_Harry_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Hilly_Harry_Button.OnCursorEntered = function()
		Hilly_Harry_Button:SetCursor( "blank" )
		text = "#sdm_help_hillyharry"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Hilly_Harry_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Hilly_Harry_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Hilly_Harry_Button:CenterHorizontal(0.275)
	Hilly_Harry_Button:SetY(ScrH() / 2.59)
	
	--Karate Ken
	local Karate_Ken_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Karate_Ken_Button:SetFont("MainMenu_Font_Models")
	Karate_Ken_Button:SetText("#sdm_karateken")
	Karate_Ken_Button:SetTextColor(Color(0, 0, 0, 0))
	Karate_Ken_Button:SetContentAlignment(4)
	Karate_Ken_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Karate_Ken_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Karate_Ken_Button.OnCursorEntered = function()
		Karate_Ken_Button:SetCursor( "blank" )
		text = "#sdm_help_karateken"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Karate_Ken_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Karate_Ken_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Karate_Ken_Button:CenterHorizontal(0.275)
	Karate_Ken_Button:SetY(ScrH() / 2.4)
	
	--Kleer Kurt
	local Kleer_Kurt_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Kleer_Kurt_Button:SetFont("MainMenu_Font_Models")
	Kleer_Kurt_Button:SetText("#sdm_kleerkurt")
	Kleer_Kurt_Button:SetTextColor(Color(0, 0, 0, 0))
	Kleer_Kurt_Button:SetContentAlignment(4)
	Kleer_Kurt_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Kleer_Kurt_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Kleer_Kurt_Button.OnCursorEntered = function()
		Kleer_Kurt_Button:SetCursor( "blank" )
		text = "#sdm_help_kleerkurt"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Kleer_Kurt_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Kleer_Kurt_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Kleer_Kurt_Button:CenterHorizontal(0.275)
	Kleer_Kurt_Button:SetY(ScrH() / 2.2275)
	
	-- Mental Mate
	local Mental_Mate_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Mental_Mate_Button:SetFont("MainMenu_Font_Models")
	Mental_Mate_Button:SetText("#sdm_mentalmate")
	Mental_Mate_Button:SetTextColor(Color(0, 0, 0, 0))
	Mental_Mate_Button:SetContentAlignment(4)
	Mental_Mate_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Mental_Mate_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Mental_Mate_Button.OnCursorEntered = function()
		Mental_Mate_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Mental_Mate_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Mental_Mate_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Mental_Mate_Button:CenterHorizontal(0.275)
	Mental_Mate_Button:SetY(ScrH() / 2.0825)
	
	--Mighty Marvin
	local Mighty_Marvin_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Mighty_Marvin_Button:SetFont("MainMenu_Font_Models")
	Mighty_Marvin_Button:SetText("#sdm_mightymarvin")
	Mighty_Marvin_Button:SetTextColor(Color(0, 0, 0, 0))
	Mighty_Marvin_Button:SetSize(ScrW()/6, ScrH()/20)
	Mighty_Marvin_Button:SetContentAlignment(4)
	
	Mighty_Marvin_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Mighty_Marvin_Button.OnCursorEntered = function()
		Mighty_Marvin_Button:SetCursor( "blank" )
		text = "#sdm_help_mightymarvin"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Mighty_Marvin_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Mighty_Marvin_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Mighty_Marvin_Button:CenterHorizontal(0.275)
	Mighty_Marvin_Button:SetY(ScrH() / 1.95)
	
	--Pirate Pete
	local Pirate_Pete_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Pirate_Pete_Button:SetFont("MainMenu_Font_Models")
	Pirate_Pete_Button:SetText("#sdm_piratepete")
	Pirate_Pete_Button:SetTextColor(Color(0, 0, 0, 0))
	Pirate_Pete_Button:SetContentAlignment(4)
	Pirate_Pete_Button:SetSize(ScrW()/6, ScrH()/20)
	
	Pirate_Pete_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end
		
		local col = self.CurrentTextColor or GetButtonColor()
		
		draw.SimpleText(self:GetText(), self:GetFont(), 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self:GetText(), self:GetFont(), 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
	
	Pirate_Pete_Button.OnCursorEntered = function()
		Pirate_Pete_Button:SetCursor( "blank" )
		text = "#sdm_help_piratepete"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Pirate_Pete_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
	end
	
	Pirate_Pete_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Pirate_Pete_Button:CenterHorizontal(0.275)
	Pirate_Pete_Button:SetY(ScrH() / 1.835)
	
	--Red Rick
	local Red_Rick_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Red_Rick_Button:SetText("#sdm_redrick")
	Red_Rick_Button:SetSize(ScrW()/6, ScrH()/20)
	Red_Rick_Button:SetFont("MainMenu_Font_Models")
	Red_Rick_Button:SetTextColor(Color(0, 0, 0, 0))
	Red_Rick_Button.CurrentTextColor = GetButtonColor()
	Red_Rick_Button:SetContentAlignment(4)

	Red_Rick_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_redrick", "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_redrick", "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Red_Rick_Button.OnCursorEntered = function()
		Red_Rick_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots2"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Red_Rick_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Red_Rick_Button.CurrentTextColor = GetButtonColor()
	end
	
	Red_Rick_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Red_Rick_Button:CenterHorizontal(0.275)
	Red_Rick_Button:SetY(ScrH() / 1.732)
	
	--Rocking Ryan
	local Rocking_Ryan_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Rocking_Ryan_Button:SetText("#sdm_rockingryan")
	Rocking_Ryan_Button:SetSize(ScrW()/6, ScrH()/20)
	Rocking_Ryan_Button:SetFont("MainMenu_Font_Models")
	Rocking_Ryan_Button:SetTextColor(Color(0, 0, 0, 0))
	Rocking_Ryan_Button.CurrentTextColor = GetButtonColor()
	Rocking_Ryan_Button:SetContentAlignment(4)

	Rocking_Ryan_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Rocking_Ryan_Button.OnCursorEntered = function()
		Rocking_Ryan_Button:SetCursor( "blank" )
		text = "#sdm_help_rockingryan"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Rocking_Ryan_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Rocking_Ryan_Button.CurrentTextColor = GetButtonColor()
	end
	
	Rocking_Ryan_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Rocking_Ryan_Button:CenterHorizontal(0.275)
	Rocking_Ryan_Button:SetY(ScrH() / 1.64)
	
	--Santa Sam
	local Santa_Sam_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Santa_Sam_Button:SetText("#sdm_santasam")
	Santa_Sam_Button:SetSize(ScrW()/6, ScrH()/20)
	Santa_Sam_Button:Center()
	Santa_Sam_Button:SetFont("MainMenu_Font_Models")
	Santa_Sam_Button:SetTextColor(Color(0, 0, 0, 0))
	Santa_Sam_Button.CurrentTextColor = GetButtonColor()
	Santa_Sam_Button:SetContentAlignment(4)

	Santa_Sam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Santa_Sam_Button.OnCursorEntered = function()
		Santa_Sam_Button:SetCursor( "blank" )
		text = "#sdm_help_santasam"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Santa_Sam_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Santa_Sam_Button.CurrentTextColor = GetButtonColor()
	end
	
	Santa_Sam_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Santa_Sam_Button:CenterHorizontal(0.275)
	Santa_Sam_Button:SetY(ScrH() / 1.555)
	
	--Skinless Stan
	local Skinless_Stan_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Skinless_Stan_Button:SetText("#sdm_skinlessstan")
	Skinless_Stan_Button:SetSize(ScrW()/6, ScrH()/20)
	Skinless_Stan_Button:Center()
	Skinless_Stan_Button:SetFont("MainMenu_Font_Models")
	Skinless_Stan_Button:SetTextColor(Color(0, 0, 0, 0))
	Skinless_Stan_Button.CurrentTextColor = GetButtonColor()
	Skinless_Stan_Button:SetContentAlignment(4)

	Skinless_Stan_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Skinless_Stan_Button.OnCursorEntered = function()
		Skinless_Stan_Button:SetCursor( "blank" )
		text = "#sdm_help_skinlessstan"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Skinless_Stan_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Skinless_Stan_Button.CurrentTextColor = GetButtonColor()
	end
	
	Skinless_Stan_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Skinless_Stan_Button:CenterHorizontal(0.275)
	Skinless_Stan_Button:SetY(ScrH() / 1.48)
	
	--Stainless Steve
	local Steel_Steve_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Steel_Steve_Button:SetText("#sdm_steelsteve")
	Steel_Steve_Button:SetSize(ScrW()/6, ScrH()/20)
	Steel_Steve_Button:Center()
	Steel_Steve_Button:SetFont("MainMenu_Font_Models")
	Steel_Steve_Button:SetTextColor(Color(0, 0, 0, 0))
	Steel_Steve_Button.CurrentTextColor = GetButtonColor()
	Steel_Steve_Button:SetContentAlignment(4)

	Steel_Steve_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Steel_Steve_Button.OnCursorEntered = function()
		Steel_Steve_Button:SetCursor( "blank" )
		text = "#sdm_help_steelsteve"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Steel_Steve_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Steel_Steve_Button.CurrentTextColor = GetButtonColor()
	end
	
	Steel_Steve_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Steel_Steve_Button:CenterHorizontal(0.275)
	Steel_Steve_Button:SetY(ScrH() / 1.415)
	
	--TFE Sam
	local Sam_TFE_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_TFE_Button:SetText("#sdm_tfeserioussam")
	Sam_TFE_Button:SetSize(ScrW()/6, ScrH()/20)
	Sam_TFE_Button:Center()
	Sam_TFE_Button:SetFont("MainMenu_Font_Models")
	Sam_TFE_Button:SetTextColor(Color(0, 0, 0, 0))
	Sam_TFE_Button.CurrentTextColor = GetButtonColor()
	Sam_TFE_Button:SetContentAlignment(4)

	Sam_TFE_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Sam_TFE_Button.OnCursorEntered = function()
		Sam_TFE_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Sam_TFE_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Sam_TFE_Button.CurrentTextColor = GetButtonColor()
	end
	
	Sam_TFE_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Sam_TFE_Button:CenterHorizontal(0.275)
	Sam_TFE_Button:SetY(ScrH() / 1.35)
	
	--TSE Sam
	local Sam_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Sam_Button:SetText("#sdm_tseserioussam")
	Sam_Button:SetSize(ScrW()/6, ScrH()/20)
	Sam_Button:Center()
	Sam_Button:SetFont("MainMenu_Font_Models")
	Sam_Button:SetTextColor(Color(0, 0, 0, 0))
	Sam_Button.CurrentTextColor = GetButtonColor()
	Sam_Button:SetContentAlignment(4)

	Sam_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Sam_Button.OnCursorEntered = function()
		Sam_Button:SetCursor( "blank" )
		text = "#sdm_help_serioussam"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Sam_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Sam_Button.CurrentTextColor = GetButtonColor()
	end
	
	Sam_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Sam_Button:CenterHorizontal(0.275)
	Sam_Button:SetY(ScrH() / 1.2925)
	
	--Vegetable Vaughn
	local Veggie_Vaughn_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Veggie_Vaughn_Button:SetText("#sdm_veggievaughn")
	Veggie_Vaughn_Button:SetSize(ScrW()/6, ScrH()/20)
	Veggie_Vaughn_Button:Center()
	Veggie_Vaughn_Button:SetFont("MainMenu_Font_Models")
	Veggie_Vaughn_Button:SetTextColor(Color(0, 0, 0, 0))
	Veggie_Vaughn_Button.CurrentTextColor = GetButtonColor()
	Veggie_Vaughn_Button:SetContentAlignment(4)

	Veggie_Vaughn_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Veggie_Vaughn_Button.OnCursorEntered = function()
		Veggie_Vaughn_Button:SetCursor( "blank" )
		text = "#sdm_help_veggievaughn"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Veggie_Vaughn_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Veggie_Vaughn_Button.CurrentTextColor = GetButtonColor()
	end
	
	Veggie_Vaughn_Button.DoClick = function()
		randompose = math.random(1, #PoseAnimations)
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
	
	Veggie_Vaughn_Button:CenterHorizontal(0.275)
	Veggie_Vaughn_Button:SetY(ScrH() / 1.24)
	
	--Yellow Yarek
	local Yellow_Yarek_Button = vgui.Create("DButton", ModelMenu)
	local isFlashing = false
	Yellow_Yarek_Button:SetText("#sdm_yellowyarek")
	Yellow_Yarek_Button:SetSize(ScrW()/6, ScrH()/20)
	Yellow_Yarek_Button:Center()
	Yellow_Yarek_Button:SetFont("MainMenu_Font_Models")
	Yellow_Yarek_Button:SetTextColor(Color(0, 0, 0, 0))
	Yellow_Yarek_Button.CurrentTextColor = GetButtonColor()
	Yellow_Yarek_Button:SetContentAlignment(4)

	Yellow_Yarek_Button.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local txt = self:GetText()
		if txt:sub(1, 1) == "#" then
			txt = language.GetPhrase(txt:sub(2))
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText(txt, "MainMenu_Font_Models", 17, h / 2 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(txt, "MainMenu_Font_Models", 15, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	Yellow_Yarek_Button.OnCursorEntered = function()
		Yellow_Yarek_Button:SetCursor( "blank" )
		text = "#sdm_help_colorbots2"
		text_help = "#sdm_help_load"
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Yellow_Yarek_Button.OnCursorExited = function()
		text = ""
		text_help = ""
		isFlashing = false
		Yellow_Yarek_Button.CurrentTextColor = GetButtonColor()
	end
	
	Yellow_Yarek_Button.DoClick = function()
		text = ""
		randompose = math.random(1, #PoseAnimations)
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
	
	Yellow_Yarek_Button:CenterHorizontal(0.275)
	Yellow_Yarek_Button:SetY(ScrH() / 1.19)
	
	ModelMenu:MakePopup()
    
	ModelMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("#sdm_pmselect", "MainMenu_BiggerFont", ScrW() / 2 + 3, ScrH() - ScrH() + 50 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_pmselect", "MainMenu_BiggerFont", ScrW() / 2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_Font_Models", Yellow_Yarek_Button:GetX() + 17, ScrH() - ScrH() / 10.5 + 3, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "MainMenu_Font_Models", Yellow_Yarek_Button:GetX() + 15, ScrH() - ScrH() / 10.5, GetButtonColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(text_help, "MainMenu_MuchSmallerFont", ScrW() / 2 + 2, ScrH() - ScrH() / 12 + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text_help, "MainMenu_MuchSmallerFont", ScrW() / 2, ScrH() - ScrH() / 12, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	ModelMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
end

function OpenConfirmationMenu()
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
	
	local isFlashing = false
	
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	YesButton:SetText("#sdm_yes")
	YesButton:SetFont("MainMenu_Font")
	YesButton:SetTextColor(Color(0, 0, 0, 0))
	
	YesButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_yes", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_yes", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	YesButton.OnCursorEntered = function()
		isFlashing = true
		YesButton:SetCursor( "blank" )
		surface.PlaySound("menus/select.wav")
	end

	YesButton.OnCursorExited = function()
		isFlashing = false
		YesButton.CurrentTextColor = GetButtonColor()
	end

	YesButton.DoClick = function()
		if DisconnectConfirm == true then
			RunConsoleCommand("disconnect")
		else
			OpenCreditsMenu()
		end
		surface.PlaySound("menus/press.wav")
	end
	
	YesButton:SizeToContents()
	YesButton:CenterHorizontal(0.44)
	YesButton:CenterVertical(0.65)
	
	local isFlashing = false
	
	local NoButton = vgui.Create("DButton", ConfirmationMenu)
	NoButton:SetText("#sdm_no")
	NoButton:SetFont("MainMenu_Font")
	NoButton:SetTextColor(Color(0, 0, 0, 0))
	
	NoButton.Paint = function(self, w, h) 
		if isFlashing then
			ButtonFlashing(self)
		else
			self.CurrentTextColor = GetButtonColor()
		end

		local col = self.CurrentTextColor or GetButtonColor()
		draw.SimpleText("#sdm_no", "MainMenu_Font", w / 2 + 3, h / 2 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("#sdm_no", "MainMenu_Font", w / 2, h / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	NoButton.OnCursorEntered = function()
		NoButton:SetCursor( "blank" )
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	NoButton.OnCursorExited = function()
		isFlashing = false
		NoButton.CurrentTextColor = GetButtonColor()
	end

	NoButton.DoClick = function()
		showGameUI = true
		ConfirmationMenu:Close()
		DarkOverlayMenu:Close()
		surface.PlaySound("menus/press.wav")
	end
	
	local w, h = ConfirmationMenu:GetSize()
	NoButton:SizeToContents()
	NoButton:CenterHorizontal(0.55)
	NoButton:CenterVertical(0.65)
	
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

		local titleTxt = "#sdm_areyouserious"
		if titleTxt:sub(1, 1) == "#" then
			titleTxt = language.GetPhrase(titleTxt:sub(2))
		end
		draw.SimpleText(titleTxt, "MainMenu_Font", w/2 + 3, h/3 + 4, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(titleTxt, "MainMenu_Font", w/2, h/3, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	DarkOverlayMenu.PaintOver = function(self, w, h)
		draw.CustomCursor(self)
	end
	
	ConfirmationMenu.PaintOver = function(self, w, h)
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