include("shared.lua")
include("sb.lua")
include("cl_hud.lua")
include("cl_fonts.lua")
include("cl_mapvote.lua")
include("cl_weaponselection.lua")

local showGameUI



local offset = 0
local speed = 5
local flashSpeed = 4


function GetMMFColor()
	if SeriousHUD and SeriousHUD:GetSkin() == 1 then
		return SeriousHUD:GetColor()
	end
	return 240, 155, 0
end


local slotsFix = {
	["weapon_ss_cannon"] = 5,
	["weapon_ss_doubleshotgun"] = 2,
	["weapon_ss_flamer"] = 4,
	["weapon_ss_ghostbuster"] = 6,
	["weapon_ss_grenadelauncher"] = 4,
	["weapon_ss_laser"] = 4,
	["weapon_ss_minigun"] = 3,
	["weapon_ss_rocketlauncher"] = 4,
	["weapon_ss_singleshotgun"] = 2,
	["weapon_ss_sniper"] = 4,
	["weapon_ss_tommygun"] = 3
}

function GM:InitPostEntity()
	for class, slot in pairs(slotsFix) do
		local wepEnt = weapons.GetStored(class)
		if wepEnt then wepEnt.Slot = slot end
	end
end

-- function GM:PlayerBindPress(ply, bind, pressed)
    -- if not pressed then return end
    -- bind = bind:lower()
	-- if ply:Alive() then
		-- if bind == "+duck" and !ply:IsOnGround() or bind == "+jump" and ply:Crouching() then
			-- return true
		-- end
	-- end
-- end


-- hook.Add( "Tick", "RestartCheck", function()

	-- for _, ply in ipairs(player.GetAll()) do
		-- if ply:Frags() >= set_frags then

		-- if not mapvotestate then

	-- hook.Add("PostDrawHUD", "GameEnd_Text", function()
	-- if endgamesoundplayed == true then
	-- surface.PlaySound( "misc/serioussam/boioing.wav" )
	-- endgamesoundplayed = false
	-- end	
		-- draw.SimpleText( "The game has ended! Starting Map Vote in 5 seconds..", "GameEnd_Font", ScrW() / 2 + 1.5 , ScrH()/2 / 2 + 1.5, color_black, TEXT_ALIGN_CENTER )
		-- draw.SimpleText( "The game has ended! Starting Map Vote in 5 seconds..", "GameEnd_Font", ScrW() / 2, ScrH()/2 / 2, color_white, TEXT_ALIGN_CENTER )
	-- end )
	-- timer.Simple(5, function()
	-- hook.Remove("PostDrawHUD", "GameEnd_Text")
	
	-- mapvotestate = true
	-- end)
  -- else
	-- return
	-- end
  -- end
  -- end

-- end)



local thirdperson_enabled = false
function togglethirdperson()
	thirdperson_enabled = not thirdperson_enabled
end
concommand.Add("togglethirdperson", togglethirdperson)

hook.Add( "PlayerButtonDown", "TPCheck", function( ply, button )
	
	if not IsFirstTimePredicted() then return end
	if CLIENT and button == KEY_H then
		togglethirdperson()
	end

end)

function GM:CalcThirdpersonView(ply, pos, ang, fov)
	if ply:GetObserverMode() == OBS_MODE_IN_EYE or !ply:Alive() then return end

	local startpos = pos
	local camPos = ang:Forward() * -80 + ang:Up() * (80 + ply:GetPos()[3] - pos[3])
	local tr = util.TraceHull({
		start = startpos,
		endpos = startpos + camPos,
		filter = ply,
		mins = Vector(-5, -5, -5),
		maxs = Vector(5, 5, 5),
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})

	if tr.Fraction > .25 then
		pos = tr.HitPos

		local view = {}

		view.origin = pos
		view.angles = ang
		view.fov = fov
		view.drawviewer = true

		return view
	end
end

hook.Add("CalcView", "ThirdpersonView", function(ply, origin, angles, fov)
	if thirdperson_enabled then
		return GAMEMODE:CalcThirdpersonView(ply, origin, angles, fov)
	end
end)
	
 
local drawing = false

local sdmg_mat = Material("models/effects/serioussam/sdmg_overlay")
local inv_mat = Material("models/powerups/invisibility")
local protect_mat = Material("models/serioussam/powerups/gold")

hook.Add("PostDrawViewModel", "glowy_vm", function(viewmodel, ply)
    if not ply:GetNW2Bool( "HasSDMG", false ) then
        return
    end
    if not drawing then
        drawing = true

        render.ModelMaterialOverride(sdmg_mat)
        viewmodel:DrawModel()
		
        render.ModelMaterialOverride()

        drawing = false
	end
end)


hook.Add("PreDrawViewModel", "invis_vm", function(vm, wep)
    if not wep:GetNW2Bool( "HasInvis", false ) then
        return
    end
    if IsValid(wep) then
        render.SetBlend(0.4)
		render.OverrideBlend( false )
    end
end)

hook.Add("PrePlayerDraw", "invis_pm", function(ply)
    if not ply:GetNW2Bool( "HasInvis", false ) then
        return
    end
    if IsValid(ply) then
        render.SetBlend(0.2)
		render.OverrideBlend( false )
    end
end)

hook.Add("PostDrawViewModel", "gold_vm", function(viewmodel, ply)
    if not ply:GetNW2Bool( "HasProtect", false ) then
        return
    end
    if not drawing then
        drawing = true

        render.ModelMaterialOverride(protect_mat)
        viewmodel:DrawModel()
		
        render.ModelMaterialOverride()

        drawing = false
	end
end)

hook.Add("PostPlayerDraw", "glowy_pm", function(ply)
    if not ply:GetNW2Bool( "HasSDMG", false ) then
        return
    end
    if not drawing then
        drawing = true

        render.ModelMaterialOverride(sdmg_mat)
        ply:DrawModel()
        render.ModelMaterialOverride()

        drawing = false
	end
end)

hook.Add("PostPlayerDraw", "gold_pm", function(ply)
    if not ply:GetNW2Bool( "HasProtect", false ) then
        return
    end
    if not drawing then
        drawing = true

        render.ModelMaterialOverride(protect_mat)
        ply:DrawModel()
        render.ModelMaterialOverride()

        drawing = false
	end
end)

function GM:OnSpawnMenuOpen()
	RunConsoleCommand("lastinv")
end

function GM:ContextMenuOpen()
	return true
end


local cvar_music = CreateClientConVar( "sdm_music", 1, true, false) 
function PlayRandomMusic()

	if cvar_music:GetBool() then
	if game.GetMap() == "sdm_desert_temple" or game.GetMap() == "sdm_red_station" then
		sound.PlayFile("sound/music/redstation.ogg", "", function(station_dt, errorID, errorName)
			if IsValid(station_dt) then
				timer.Remove("looptimer")
				station_dt:SetVolume(1)
				station_dt:Play()
				timer.Create("looptimer", station_dt:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	if game.GetMap() == "sdm_sun_palace" then
		sound.PlayFile("sound/music/sunpalace.ogg", "", function(station_sp, errorID, errorName)
			if IsValid(station_sp) then
				timer.Remove("looptimer")
				station_sp:SetVolume(1)
				station_sp:Play()
				timer.Create("looptimer", station_sp:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	if game.GetMap() == "sdm_little_trouble" then
		sound.PlayFile("sound/music/littetrouble.ogg", "", function(station_lt, errorID, errorName)
			if IsValid(station_lt) then
				timer.Remove("looptimer")
				station_lt:SetVolume(1)
				station_lt:Play()
				timer.Create("looptimer", station_lt:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	if game.GetMap() == "sdm_brkeen_chevap" then
		sound.PlayFile("sound/music/brkeen.ogg", "", function(station_bc, errorID, errorName)
			if IsValid(station_bc) then
				timer.Remove("looptimer")
				station_bc:SetVolume(1)
				station_bc:Play()
				timer.Create("looptimer", station_bc:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	if game.GetMap() == "sdm_lost_tomb" then
		sound.PlayFile("sound/music/losttomb.ogg", "", function(station_bc, errorID, errorName)
			if IsValid(station_bc) then
				timer.Remove("looptimer")
				station_bc:SetVolume(1)
				station_bc:Play()
				timer.Create("looptimer", station_bc:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	if game.GetMap() == "sdm_hole_classic" then
		sound.PlayFile("sound/music/holeclassic.ogg", "", function(station_bc, errorID, errorName)
			if IsValid(station_bc) then
				timer.Remove("looptimer")
				station_bc:SetVolume(1)
				station_bc:Play()
				timer.Create("looptimer", station_bc:GetLength(), 1, function()
					PlayRandomMusic()
				end)
			end
		end)
	end
	end
end

hook.Add("Initialize", "PlayRandomMusicOnSpawn", PlayRandomMusic)




function OpenSSMenu()

	showGameUI = true
	
	local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
	local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
	local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
	local originalflashColor = Color(SeriousHUD:GetTextColor())
	local SHUD_text_r, SHUD_text_g, SHUD_text_b = SeriousHUD:GetTextColor()
	local flashColor1 = Color(SHUD_text_r / 2, SHUD_text_g / 2, SHUD_text_b / 2)
	local flashColor2 = color_white
	if GetConVarNumber("ss_hud_skin") == 2 then
		ssbg_tse = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf_tse = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
		originalflashColor = Color(240, 155, 0)
		flashColor1 = Color(170, 85, 0)
		flashColor2 = Color(255, 200, 0)
	end
	local EscMenu = vgui.Create("DFrame")
	EscMenu:SetSize(ScrW(), ScrH())
	EscMenu:Center()
	EscMenu:SetTitle("")
	EscMenu:ShowCloseButton( false )
	EscMenu:SetDraggable(false)
	EscMenu:SetMouseInputEnabled(false)
	EscMenu:MakePopup()


	EscMenu.Paint = function(self, w, h)
		local offsetX = math.sin(CurTime() * 1.5) * -22
		local offsetY = math.cos(CurTime() * 1.5) * -22
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0, 0, w, h)
		if GetConVarNumber("ss_hud_skin") == 2 then
		surface.SetTexture(ssbg_tse)
		else
		surface.SetTexture(ssbg)
		end
		local hudr, hudg, hudb = SeriousHUD:GetColor()
		surface.SetDrawColor(hudr, hudg, hudb, 145)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
		if GetConVarNumber("ss_hud_skin") == 2 then
			surface.DrawTexturedRect(0,0,w,h)
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
		if GetConVarNumber("ss_hud_skin") == 2 then
		surface.SetTexture(detailTexture_vtf_tse)
		else
		surface.SetTexture(detailTexture_vtf)
		end
		surface.SetDrawColor(hudr, hudg, hudb, 140)
		surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w*4, h*4, 0, 0, w / texW, h / texH )
		surface.SetDrawColor(SeriousHUD:GetColor())
		draw.SimpleText("GAME", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end




local Continue_Button = vgui.Create("DButton", EscMenu)
local isFlashing = false
Continue_Button:SetText("CONTINUE")
Continue_Button:SetSize(ScrW()/8, ScrH()/20)
Continue_Button:Center()
Continue_Button:SetY(ScrH()/2.58)
Continue_Button:SetFont("MainMenu_Font")
if GetConVarNumber("ss_hud_skin") == 2 then
	Continue_Button:SetTextColor(Color(240, 155, 0))
elseif GetConVarNumber("ss_hud_skin") == 1 then
	Continue_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
end
Continue_Button.Paint = function(self, w, h) 
    if isFlashing then
        local t = RealTime() * flashSpeed -- 4
        local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
        local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
        local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
       
        Continue_Button:SetTextColor(Color(r, g, b))
    end
	
end
Continue_Button.OnCursorEntered = function()
    isFlashing = true
	surface.PlaySound("menus/select.wav")
end

Continue_Button.OnCursorExited = function()
    isFlashing = false
    Continue_Button:SetTextColor(originalflashColor)
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
if GetConVarNumber("ss_hud_skin") == 2 then
	Disconnect_Button:SetTextColor(Color(240, 155, 0))
elseif GetConVarNumber("ss_hud_skin") == 1 then
	Disconnect_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
end
Disconnect_Button.Paint = function(self, w, h) 
    if isFlashing then
        local t = RealTime() * flashSpeed -- 4
        local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
        local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
        local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
        
        Disconnect_Button:SetTextColor(Color(r, g, b))
    end
end
Disconnect_Button.OnCursorEntered = function()
    isFlashing = true
	surface.PlaySound("menus/select.wav")
end

Disconnect_Button.OnCursorExited = function()
    isFlashing = false
    Disconnect_Button:SetTextColor(originalflashColor)
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
	Options_Button:SetTextColor(Color(240, 155, 0))
elseif GetConVarNumber("ss_hud_skin") == 1 then
	Options_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
end
Options_Button.Paint = function(self, w, h) 
    if isFlashing then
        local t = RealTime() * flashSpeed -- 4
        local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
        local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
        local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
        
        Options_Button:SetTextColor(Color(r, g, b))
    end
end
Options_Button.OnCursorEntered = function()
    isFlashing = true
	surface.PlaySound("menus/select.wav")
end

Options_Button.OnCursorExited = function()
    isFlashing = false
    Options_Button:SetTextColor(originalflashColor)
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
if GetConVarNumber("ss_hud_skin") == 2 then
	LegacyM_Button:SetTextColor(Color(240, 155, 0))
elseif GetConVarNumber("ss_hud_skin") == 1 then
	LegacyM_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
end
LegacyM_Button.Paint = function(self, w, h) 
    if isFlashing then
        local t = RealTime() * flashSpeed -- 4
        local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
        local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
        local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
        
        LegacyM_Button:SetTextColor(Color(r, g, b))
    end
end
LegacyM_Button.OnCursorEntered = function()
    isFlashing = true
	surface.PlaySound("menus/select.wav")
end

LegacyM_Button.OnCursorExited = function()
    isFlashing = false
    LegacyM_Button:SetTextColor(originalflashColor)
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
if GetConVarNumber("ss_hud_skin") == 2 then
	Quit_Button:SetTextColor(Color(240, 155, 0))
elseif GetConVarNumber("ss_hud_skin") == 1 then
	Quit_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
end
Quit_Button.Paint = function(self, w, h)
end

Quit_Button.Paint = function(self, w, h) 
    if isFlashing then
        local t = RealTime() * flashSpeed -- 4
        local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
        local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
        local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
        
        Quit_Button:SetTextColor(Color(r, g, b))
    end
end
Quit_Button.OnCursorEntered = function()
    isFlashing = true
	surface.PlaySound("menus/select.wav")
end

Quit_Button.OnCursorExited = function()
    isFlashing = false
    Quit_Button:SetTextColor(originalflashColor)
end
Quit_Button.DoClick = function()
    OpenConfirmationMenu()
	surface.PlaySound("menus/press.wav")
end
end

function OpenConfirmationMenu()
	showGameUI = true
	local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/MenuBack_detail")
	local ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/menuback")
	local grid_bg = surface.GetTextureID("vgui/serioussam/mainmenu/hud_tfe/grid")
	local originalflashColor = Color(SeriousHUD:GetTextColor())
	local SHUD_text_r, SHUD_text_g, SHUD_text_b = SeriousHUD:GetTextColor()
	local flashColor1 = Color(SHUD_text_r / 2, SHUD_text_g / 2, SHUD_text_b / 2)
	local flashColor2 = color_white
	if GetConVarNumber("ss_hud_skin") == 2 then
		ssbg = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
		originalflashColor = Color(240, 155, 0)
		flashColor1 = Color(170, 85, 0)
		flashColor2 = Color(255, 200, 0)
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


	local ConfirmationMenu = vgui.Create("DFrame")
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
		surface.SetDrawColor(SeriousHUD:GetColor())
	draw.SimpleText("ARE YOU SERIOUS?", "MainMenu_Font", w/2, h/3, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	YesButton:SetText("YES")
	YesButton:SetSize(ScrW() / 5 / YesButton:GetTextSize()*3.5, ScrH() / 20)
	YesButton:SetX(ScrW() - ScrW()/1.25)
	YesButton:SetY(ScrH()- ScrH()/1.15)
	YesButton:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		YesButton:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		YesButton:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
	YesButton.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			YesButton:SetTextColor(Color(r, g, b))
		end
	end
	YesButton.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	YesButton.OnCursorExited = function()
		isFlashing = false
		YesButton:SetTextColor(originalflashColor)
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
	if GetConVarNumber("ss_hud_skin") == 2 then
		NoButton:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		NoButton:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
	NoButton.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			NoButton:SetTextColor(Color(r, g, b))
		end
	end
	NoButton.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	NoButton.OnCursorExited = function()
		isFlashing = false
		YesButton:SetTextColor(originalflashColor)
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
	showGameUI = true
	local originalflashColor = Color(SeriousHUD:GetTextColor())
	local SHUD_text_r, SHUD_text_g, SHUD_text_b = SeriousHUD:GetTextColor()
	local flashColor1 = Color(SHUD_text_r / 2, SHUD_text_g / 2, SHUD_text_b / 2)
	local flashColor2 = color_white
	if GetConVarNumber("ss_hud_skin") == 2 then
		ssbg_tse = surface.GetTextureID("vgui/serioussam/mainmenu/menuback")	
		detailTexture_vtf_tse = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")
		originalflashColor = Color(240, 155, 0)
		flashColor1 = Color(170, 85, 0)
		flashColor2 = Color(255, 200, 0)
	end
	local SettingsMenu = vgui.Create("DFrame")
	SettingsMenu:SetSize(ScrW(), ScrH())
	SettingsMenu:Center()
	SettingsMenu:SetTitle("")
	SettingsMenu:ShowCloseButton( false )
	SettingsMenu:SetDraggable(false)
	SettingsMenu:MakePopup()

	SettingsMenu.Paint = function(self, w, h)
		local offsetX = math.sin(CurTime() * 1.5) * -22
		local offsetY = math.cos(CurTime() * 1.5) * -22
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0, 0, w, h)
		
		if GetConVarNumber("ss_hud_skin") == 2 then
		surface.SetTexture(ssbg_tse)
		else
		surface.SetTexture(ssbg)
		end
		local hudr, hudg, hudb = SeriousHUD:GetColor()
		surface.SetDrawColor(hudr, hudg, hudb, 145)
		local texW = 256
		local texH = 256
		surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w+500, h+500, 0, 0, w / texW, h / texH )
		if GetConVarNumber("ss_hud_skin") == 2 then
			surface.DrawTexturedRect(0,0,w,h)
		end
		if GetConVarNumber("ss_hud_skin") == 1 then 
		surface.SetTexture(grid_bg)
		surface.SetDrawColor(hudr, hudg, hudb, 100)
		end
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
		if GetConVarNumber("ss_hud_skin") == 2 then
		surface.SetTexture(detailTexture_vtf_tse)
		else
		surface.SetTexture(detailTexture_vtf)
		end
		surface.SetDrawColor(hudr, hudg, hudb, 140)
		surface.DrawTexturedRectUV( offsetX-25, offsetY-25, w*4, h*4, 0, 0, w / texW, h / texH )
		surface.SetDrawColor(SeriousHUD:GetColor())
		draw.SimpleText("OPTIONS", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local Playermodel_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Playermodel_Button:SetText("PLAYERMODEL SELECTOR")
	Playermodel_Button:SetSize(ScrW()/4, ScrH() / 20)
	Playermodel_Button:Center()
	Playermodel_Button:SetY(ScrH()/6)
	Playermodel_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Playermodel_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Playermodel_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end

	Playermodel_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Playermodel_Button:SetTextColor(Color(r, g, b))
		end
	end
	Playermodel_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Playermodel_Button.OnCursorExited = function()
		isFlashing = false
		Playermodel_Button:SetTextColor(originalflashColor)
	end

	local Music_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if !cvar_music:GetBool() then
	Music_Button:SetText("ENABLE MUSIC")
	else
	Music_Button:SetText("DISABLE MUSIC")
	end
	Music_Button:SetSize(ScrW()/4, ScrH() / 20)
	Music_Button:Center()
	Music_Button:SetY(ScrH()/2.45)
	Music_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Music_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Music_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
	Music_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Music_Button:SetTextColor(Color(r, g, b))
		end
	end
	Music_Button.DoClick = function()
		if !cvar_music:GetBool() then
			Music_Button:SetText("DISABLE MUSIC")
			timer.Remove("looptimer")
			RunConsoleCommand("sdm_music", "1")

			if game.GetMap() == "sdm_desert_temple" or game.GetMap() == "sdm_red_station" then
				sound.PlayFile("sound/music/redstation.ogg", "", function(station_dt, errorID, errorName)
					if IsValid(station_dt) then
						timer.Remove("looptimer")
						station_dt:SetVolume(1)
						station_dt:Play()
						timer.Create("looptimer", station_dt:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
			if game.GetMap() == "sdm_sun_palace" then
				sound.PlayFile("sound/music/sunpalace.ogg", "", function(station_sp, errorID, errorName)
					if IsValid(station_sp) then
						timer.Remove("looptimer")
						station_sp:SetVolume(1)
						station_sp:Play()
						timer.Create("looptimer", station_sp:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
			if game.GetMap() == "sdm_little_trouble" then
				sound.PlayFile("sound/music/littetrouble.ogg", "", function(station_lt, errorID, errorName)
					if IsValid(station_lt) then
						timer.Remove("looptimer")
						station_lt:SetVolume(1)
						station_lt:Play()
						timer.Create("looptimer", station_lt:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
			if game.GetMap() == "sdm_brkeen_chevap" then
				sound.PlayFile("sound/music/brkeen.ogg", "", function(station_bc, errorID, errorName)
					if IsValid(station_bc) then
						timer.Remove("looptimer")
						station_bc:SetVolume(1)
						station_bc:Play()
						timer.Create("looptimer", station_bc:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
			if game.GetMap() == "sdm_lost_tomb" then
				sound.PlayFile("sound/music/losttomb.ogg", "", function(station_bc, errorID, errorName)
					if IsValid(station_bc) then
						timer.Remove("looptimer")
						station_bc:SetVolume(1)
						station_bc:Play()
						timer.Create("looptimer", station_bc:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
			if game.GetMap() == "sdm_hole_classic" then
				sound.PlayFile("sound/music/holeclassic.ogg", "", function(station_bc, errorID, errorName)
					if IsValid(station_bc) then
						timer.Remove("looptimer")
						station_bc:SetVolume(1)
						station_bc:Play()
						timer.Create("looptimer", station_bc:GetLength(), 1, function()
							PlayRandomMusic()
						end)
					end
				end)
			end
		else
			Music_Button:SetText("ENABLE MUSIC")
			RunConsoleCommand("sdm_music", "0")
			RunConsoleCommand("stopsound")
			timer.Remove("looptimer")
			
		end
	surface.PlaySound("menus/press.wav")
	end
	Music_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Music_Button.OnCursorExited = function()
		isFlashing = false
		Music_Button:SetTextColor(originalflashColor)
	end

	local Crosshair_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Crosshair_Button:SetText("CROSSHAIR")
	Crosshair_Button:SetSize(ScrW()/4, ScrH() / 20)
	Crosshair_Button:Center()
	Crosshair_Button:SetY(ScrH()/2.05)
	Crosshair_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Crosshair_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Crosshair_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end

	Crosshair_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Crosshair_Button:SetTextColor(Color(r, g, b))
		end
	end

	Crosshair_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Crosshair_Button.OnCursorExited = function()
		isFlashing = false
		Crosshair_Button:SetTextColor(originalflashColor)
	end
	
	local Crosshair_Image = vgui.Create("DImage", SettingsMenu)	-- Add image to Frame
	Crosshair_Image:Center()	-- Move it into frame
	Crosshair_Image:SetY(ScrH()/1.8)	-- Size it to 150x150
	Crosshair_Image:SetSize(ScrH()/20, ScrH() / 20)
	-- Set material relative to "garrysmod/materials/"
	Crosshair_Image:SetImage("vgui/serioussam/Crosshair".. GetConVarNumber("ss_crosshair"))
	
	local Forward_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Forward_Button:SetText(">")
	Forward_Button:SetSize(ScrW()/80, ScrH() / 20)
	Forward_Button:SetX(ScrW()/1.9)
	Forward_Button:SetY(ScrH()/1.825)
	Forward_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Forward_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Forward_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end

	Forward_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Forward_Button:SetTextColor(Color(r, g, b))
		end
	end
	
	Forward_Button.DoClick = function()
	local crosshair_value =  GetConVarNumber("ss_crosshair") + 1
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
		Forward_Button:SetTextColor(originalflashColor)
	end
	

	
	local Backwards_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Backwards_Button:SetText("<")
	Backwards_Button:SetSize(ScrW()/80, ScrH() / 20)
	Backwards_Button:SetX(ScrW()/2.195)
	Backwards_Button:SetY(ScrH()/1.825)
	Backwards_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Backwards_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Backwards_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end

	Backwards_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Backwards_Button:SetTextColor(Color(r, g, b))
		end
	end
	
	Backwards_Button.DoClick = function()
	local crosshair_value =  GetConVarNumber("ss_crosshair") - 1
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
		Backwards_Button:SetTextColor(originalflashColor)
	end

	local HUD_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	if GetConVarNumber("ss_hud_skin") == 2 then
	HUD_Button:SetText("TFE HUD")
	elseif GetConVarNumber("ss_hud_skin") == 1 then
	HUD_Button:SetText("TSE HUD")
	end
	HUD_Button:SetSize(ScrW()/4, ScrH() / 20)
	HUD_Button:Center()
	HUD_Button:SetY(ScrH()/1.56)
	HUD_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		HUD_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		HUD_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
	HUD_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			HUD_Button:SetTextColor(Color(r, g, b))
		end
	end
	HUD_Button.DoClick = function()
		if GetConVarNumber("ss_hud_skin") == 2 then
			HUD_Button:SetText("TSE HUD")
			RunConsoleCommand("ss_hud_skin", "1")
		elseif GetConVarNumber("ss_hud_skin") == 1 then
			HUD_Button:SetText("TFE HUD")
			RunConsoleCommand("ss_hud_skin", "2")
			
		end
	surface.PlaySound("menus/press.wav")
	end
	HUD_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	HUD_Button.OnCursorExited = function()
		isFlashing = false
		HUD_Button:SetTextColor(originalflashColor)
	end


	local TFE_Color_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	TFE_Color_Button:SetText("TFE HUD COLOR")
	TFE_Color_Button:SetSize(ScrW()/4, ScrH() / 20)
	TFE_Color_Button:Center()
	TFE_Color_Button:SetY(ScrH()/1.38)
	TFE_Color_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		TFE_Color_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		TFE_Color_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end

	TFE_Color_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			TFE_Color_Button:SetTextColor(Color(r, g, b))
		end
	end
	TFE_Color_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	TFE_Color_Button.OnCursorExited = function()
		isFlashing = false
		TFE_Color_Button:SetTextColor(originalflashColor)
	end

	local TFE_Color_Mixer = vgui.Create("DColorMixer", SettingsMenu)
	TFE_Color_Mixer:SetSize(ScrW()/8, ScrW()/12.5)
	TFE_Color_Mixer:Center()
	TFE_Color_Mixer:SetY(ScrH()/1.25)
	TFE_Color_Mixer:SetPalette(false)  			-- Show/hide the palette 				DEF:true
	TFE_Color_Mixer:SetAlphaBar(false) 			-- Show/hide the alpha bar 				DEF:true
	TFE_Color_Mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
	TFE_Color_Mixer:SetColor(Color(30,100,160)) 	-- Set the default color
	TFE_Color_Mixer:SetConVarR("ss_hud_color_r")
	TFE_Color_Mixer:SetConVarG("ss_hud_color_g")
	TFE_Color_Mixer:SetConVarB("ss_hud_color_b")

	local Back_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Back_Button:SetText("BACK")
	Back_Button:SetSize(ScrW()/15, ScrH()/20)
	Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/11)
	Back_Button:SetFont("MainMenu_Font")
	if GetConVarNumber("ss_hud_skin") == 2 then
		Back_Button:SetTextColor(Color(240, 155, 0))
	elseif GetConVarNumber("ss_hud_skin") == 1 then
		Back_Button:SetTextColor(Color(SeriousHUD:GetTextColor()))
	end
	Back_Button.Paint = function(self, w, h) 
		if isFlashing then
			local t = RealTime() * flashSpeed -- 4
			local r = Lerp(math.abs(math.sin(t)), flashColor1.r, flashColor2.r)
			local g = Lerp(math.abs(math.sin(t)), flashColor1.g, flashColor2.g)
			local b = Lerp(math.abs(math.sin(t)), flashColor1.b, flashColor2.b)
			
			Back_Button:SetTextColor(Color(r, g, b))
		end
	end
	Back_Button.OnCursorEntered = function()
		isFlashing = true
		surface.PlaySound("menus/select.wav")
	end

	Back_Button.OnCursorExited = function()
		isFlashing = false
		Back_Button:SetTextColor(originalflashColor)
	end

	Back_Button.DoClick = function()
		SettingsMenu:Close()
		showGameUI = true
		surface.PlaySound("menus/press.wav")
	end


 
	local buttonKleiner = vgui.Create("DImageButton", SettingsMenu)
	buttonKleiner:SetImage("materials/icons/playermodels/samclassic.png")
	buttonKleiner:SetSize(64, 64)

	buttonKleiner:SetPos(ScrW()/2 - 145, ScrH()/2 /1.6 - 70)

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
	buttonKleiner1:SetSize(64, 64)
	buttonKleiner1:SetPos(ScrW()/2 - 75, ScrH()/2 /1.6 - 70)
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
	buttonBarney:SetSize(64, 64)
	buttonBarney:SetPos(ScrW()/2 + 10, ScrH()/2 /1.6 - 70)
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
	buttonBarney2:SetSize(64, 64)
	buttonBarney2:SetPos(ScrW()/2 + 80, ScrH()/2 /1.6 - 70)
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
	buttonBarney3:SetSize(64, 64)
	buttonBarney3:SetPos(ScrW()/2 - 145, ScrH()/2 /1.6 + 6)
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
	buttonBarney4:SetSize(64, 64)
	buttonBarney4:SetPos(ScrW()/2 - 75, ScrH()/2 /1.6 + 6)
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
	buttonAlyx:SetSize(64, 64)
	buttonAlyx:SetPos(ScrW()/2 + 10, ScrH()/2 /1.6 + 6)
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
	buttonSteve:SetSize(64, 64)
	buttonSteve:SetPos(ScrW()/2 + 80, ScrH()/2 /1.6 + 6)
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
		end
	end
end )


