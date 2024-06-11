include("shared.lua")
include( "sb.lua" )
include( "cl_mapvote.lua" )
AddCSLuaFile("cl_wepselect.lua")

local endgamesoundplayed = false
local showGameUI
local ssbg = Material( "materials/vgui/serioussam/mainmenu/MenuBack.jpg" )
local detailTexture = Material("materials/vgui/serioussam/mainmenu/MenuBack_detail.png")
local detailTexture_vtf = surface.GetTextureID("vgui/serioussam/mainmenu/MenuBack_detail")

local offset = 0
local speed = 5
-- local set_frags = GetConVarNumber( "sdm_max_frags" )
-- local frags_left = GetConVarNumber( "sdm_max_frags" )
-- local time_left = GetConVarNumber( "sdm_max_time" )
local flashSpeed = 4
local originalflashColor = Color(240, 155, 0)
local flashColor1 = Color(170, 85, 0)
local flashColor2 = Color(255, 200, 0)
local on = false

include("cl_weaponselection.lua")

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

function GM:PlayerBindPress(ply, bind, pressed)
    if not pressed then return end
    bind = bind:lower()
	if ply:Alive() then
		if bind == "+duck" and !ply:IsOnGround() or bind == "+jump" and ply:Crouching() then
			return true
		end
	end
end

surface.CreateFont("seriousHUDfont_timer", {
	font = "default",
	size = ScrH()/16,
	weight = 600,
	blursize = 1
})

surface.CreateFont("DeathMessageFont", {
	font = font,
	size = fontSize,
	weight = 500,
	antialias = true,
	additive = false
})

surface.CreateFont( "TheDefaultSettings", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "TheDefaultSettings1", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 48,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "TheDefaultSettings2", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrH() / 42,
	weight = 800,
	blursize = 1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "GameEnd_Font", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrH() / 42,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "MainMenu_Font", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 24	,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Vote_Font", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 32	,
	weight = 0,
} )

surface.CreateFont( "Vote_Font2", {
	font = "Mytupi", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() / 42	,
	weight = 0,
} )

surface.CreateFont("MainMenu_font_small", {
	font = "Franklin Gothic",
	size = ScrH()/52,
	weight = 600,
	blursize = 0,
	shadow = true
})


local playerTable = vgui.Create("DPanel")
playerTable:SetPos(ScrW() / 2, 0)
playerTable:SetSize(ScrW(), ScrH())

function playerTable:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)

    local players = player.GetAll()


	table.sort(players, function(a, b)
        if a:Frags() > b:Frags() then
            return true
        elseif a:Frags() < b:Frags() then
            return false
        else
            return a:Deaths() < b:Deaths()
        end
    end)

    local posY = 10

    for _, ply in ipairs(players) do
        draw.SimpleText(ply:Nick(), "TheDefaultSettings1", ScrW() / 2 / 1.2 + 1, posY + 1, Color(0, 0, 0), TEXT_ALIGN_RIGHT)
        draw.SimpleText(ply:Frags() .. "  /  " .. ply:Deaths(), "TheDefaultSettings1", ScrW() /2  / 1.04  + 1, posY + 1, Color(0, 0, 0), TEXT_ALIGN_RIGHT)
    
        draw.SimpleText(ply:Nick(), "TheDefaultSettings1", ScrW() /2  / 1.2, posY, Color(90, 121, 181), TEXT_ALIGN_RIGHT)
        draw.SimpleText(ply:Frags() .. "  /  " .. ply:Deaths(), "TheDefaultSettings1", ScrW() /2 / 1.04 , posY, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        posY = posY + ScrH() / 28
    end
end


function GM:HUDItemPickedUp()
    return true
end

local ITime = surface.GetTextureID("vgui/serioussam/hud/itimer")
--[[
hook.Add("HUDPaint", "CountdownTimer", function()
    --if timerActive then
        
		draw.RoundedBox(0, ScrH() / 80 , ScrH() /  14.75 / 5 , ScrH() / 14.75 /1.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 160))
		surface.SetDrawColor(Color(90, 120, 180))
		surface.DrawOutlinedRect(ScrH() / 80 , ScrH() /  14.75 / 5, ScrH() / 14.75 / 1.25, ScrH() / 14.75 / 1.25)
		surface.SetTexture(ITime)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(ScrH() / 80 * 1.35 , ScrH() /  14.75 / 5 * 1.2, ScrH() / 14.75 /1.4, ScrH() / 14.75 /1.4)
		
		draw.RoundedBox(0, ScrH() / ScrH() * ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 160))
		surface.SetDrawColor(Color(90, 120, 180))
		surface.DrawOutlinedRect(ScrH() / ScrH() * ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 / 1.25)
		draw.SimpleText("00:00", "seriousHUDfont_timer", ScrH() / ScrH() * ScrH() / 14.75 + 5.5 * ScrW() / 120, ScrH() /  14.75 / 10, color_white, TEXT_ALIGN_CENTER)
	end
end)
--]]

if SeriousHUD then
	function SeriousHUD:Enabled()
		return true
	end
	function SeriousHUD:AmmoIconsEnabled()
		return true
	end
end
	
function GM:HUDPaint()
    playerTable:PaintManual()
	if GetConVarNumber("sdm_timer_enabled") == 1 then
		local timeLimit = GetConVarNumber( "sdm_max_time" )
		local timer = "%02i:%02i"
		draw.RoundedBox(0, ScrH() / 80 , ScrH() /  14.75 / 5 , ScrH() / 14.75 /1.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 160))
		surface.SetDrawColor(Color(90, 120, 180))
		surface.DrawOutlinedRect(ScrH() / 80 , ScrH() /  14.75 / 5, ScrH() / 14.75 / 1.25, ScrH() / 14.75 / 1.25)
		surface.SetTexture(ITime)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(ScrH() / 80 * 1.35 , ScrH() /  14.75 / 5 * 1.2, ScrH() / 14.75 /1.4, ScrH() / 14.75 /1.4)
		
		
		
		draw.RoundedBox(0, ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 /1.25, Color(20, 20, 20, 160))
		surface.SetDrawColor(Color(90, 120, 180))
		surface.DrawOutlinedRect(ScrH() / 14.75 + 5.5 , ScrH() /  14.75 / 5 , ScrH() / 14.75 * 2.25, ScrH() / 14.75 / 1.25)
		local countdown = timeLimit - (CurTime() - GetGlobalFloat("GameTime"))
		if countdown < 0 then
			countdown = 0
		end
		draw.SimpleText(string.FormattedTime(countdown, "%02i:%02i"), "seriousHUDfont_timer", ScrH() / 14.75 * 2.2 ,ScrH() /  14.75 / 10, color_white, TEXT_ALIGN_CENTER)
	
		if countdown <= 0 and !endgamesoundplayed then
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
			local text = "The game has ended! Starting Map Vote in 5 seconds.."
			draw.SimpleText( text, "GameEnd_Font", x + 1.5, y + 1.5, color_black, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )			
			
			local winner = GetGlobalString("WinnerName")
			if winner and string.len(winner) > 0 then
				local text = winner.." has won!"
				local x, y = ScrW() / 2, ScrH()/3.6
				draw.SimpleText( text, "GameEnd_Font", x + 1.5, y + 1.5, color_black, TEXT_ALIGN_CENTER )
				draw.SimpleText( text, "GameEnd_Font", x, y, color_white, TEXT_ALIGN_CENTER )
			end
		end
	else
		if !LocalPlayer():Alive() then
			local x, y = ScrW() / 2, ScrH() / 4
			local text = "Press FIRE to respawn"
			draw.SimpleText( text, "TheDefaultSettings2", x + 1.5, y + 1.5, color_black, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "TheDefaultSettings2", x, y, color_white, TEXT_ALIGN_CENTER)
		end
	end
end

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



function togglethirdperson()
	on = not on
end

net.Receive("sv_togglethirdperson")

function CalcThirdperson(ply, pos, angles, fov)
	if on then
		local view = {}
		view.origin = pos-(angles:Forward()*90) + (angles:Up()*15)
		view.angles = angles 
		view.fov = fov
	 
		return view
	end
end

hook.Add("CalcView", "CalcThirdperson", CalcThirdperson)
 
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
        render.SetBlend(0.5)
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

hook.Add("ShouldDrawLocalPlayer", "MyHax ShouldDrawLocalPlayer", function(ply)
	if on then
        return true
    end
end)

concommand.Add("togglethirdperson", togglethirdperson)


hook.Add( "PlayerButtonDown", "TPCheck", function( ply, button )
	
	if not IsFirstTimePredicted() then return end
	if CLIENT and button == KEY_H  then
		togglethirdperson()
	end

end)

function GM:OnSpawnMenuOpen()
	RunConsoleCommand("lastinv")
end

function GM:ContextMenuOpen()
	return true
end


CreateClientConVar( "sdm_music", "1", true, false) 
function PlayRandomMusic()

	if GetConVar("sdm_music"):GetInt() == 1 then
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


	local EscMenu = vgui.Create("DFrame")
	EscMenu:SetSize(ScrW(), ScrH())
	EscMenu:Center()
	EscMenu:SetTitle("")
	EscMenu:ShowCloseButton( false )
	EscMenu:SetDraggable(false)
	EscMenu:SetMouseInputEnabled(false)
	EscMenu:MakePopup()


	EscMenu.Paint = function(self, w, h)
		surface.SetMaterial(ssbg)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(0,0,w,h)

		offset = offset + speed
		if offset > w then
			offset = 0
		end

	local offsetX = math.sin(CurTime() * 1.5) * 10
	local offsetY = math.cos(CurTime() * 1.5) * 10

	surface.SetTexture(detailTexture_vtf)
	surface.DrawTexturedRect(offsetX - 50, offsetY - 50, ScrW() + 100, ScrH() + 100)
	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.SimpleText("GAME", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end




local Continue_Button = vgui.Create("DButton", EscMenu)
local isFlashing = false
Continue_Button:SetText("CONTINUE")
Continue_Button:SetSize(ScrW()/8, ScrH()/20)
Continue_Button:Center()
Continue_Button:SetY(ScrH()/2.58)
Continue_Button:SetFont("MainMenu_Font")
Continue_Button:SetTextColor(Color(240, 155, 0))
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
Disconnect_Button:SetTextColor(Color(240, 155, 0))
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
Options_Button:SetTextColor(Color(240, 155, 0))
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
LegacyM_Button:SetTextColor(Color(240, 155, 0))
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
Quit_Button:SetTextColor(Color(240, 155, 0))
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
	ConfirmationMenu:SetSize(ScrW()/1.9, ScrH()/4.65)
	ConfirmationMenu:SetTitle("")
	ConfirmationMenu:SetVisible(true)
	ConfirmationMenu:SetDraggable(false)
	ConfirmationMenu:ShowCloseButton(false)
	ConfirmationMenu:Center()
	ConfirmationMenu:MakePopup()
	ConfirmationMenu.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w+5, h+5, Color(240, 155, 0, 75))
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(ssbg)
		surface.DrawTexturedRect(1,1,w-2,h-2)
			if offset > w then
			offset = 0
		end

	local offsetX = math.sin(CurTime() * 1.5) * 10
	local offsetY = math.cos(CurTime() * 1.5) * 10

	surface.SetTexture(detailTexture_vtf)
	surface.SetDrawColor(Color(255,255,255,255))
	surface.DrawTexturedRect(offsetX-25, offsetY-25, w+50, h+50)
	offset = offset + speed
	draw.SimpleText("ARE YOU SERIOUS?", "MainMenu_Font", w/2, h/3, Color(240, 155, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	local YesButton = vgui.Create("DButton", ConfirmationMenu)
	local isFlashing = false
	YesButton:SetText("YES")
	YesButton:SetSize(ScrW() / 5 / YesButton:GetTextSize()*3.5, ScrH() / 20)
	YesButton:SetX(ScrW() - ScrW()/1.25)
	YesButton:SetY(ScrH()- ScrH()/1.15)
	YesButton:SetFont("MainMenu_Font")
	YesButton:SetTextColor(Color(240, 155, 0))
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
	NoButton:SetTextColor(Color(240, 155, 0))
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
	surface.PlaySound("menus/press.wav")
	end
end
function OpenSettingsMenu()
	showGameUI = true
	local SettingsMenu = vgui.Create("DFrame")
	SettingsMenu:SetSize(ScrW(), ScrH())
	SettingsMenu:Center()
	SettingsMenu:SetTitle("")
	SettingsMenu:ShowCloseButton( false )
	SettingsMenu:SetDraggable(false)
	SettingsMenu:MakePopup()

	SettingsMenu.Paint = function(self, w, h)
		surface.SetMaterial(ssbg)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(0,0,w,h)

		offset = offset + speed
		if offset > w then
			offset = 0
		end

		local offsetX = math.sin(CurTime() * 1.5) * 10
		local offsetY = math.cos(CurTime() * 1.5) * 10

		surface.SetTexture(detailTexture_vtf)
		surface.SetDrawColor(Color(255,255,255,20))
		surface.DrawTexturedRect(offsetX - 50, offsetY - 50, ScrW() + 100, ScrH() + 100)
		draw.SimpleText("OPTIONS", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local Playermodel_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Playermodel_Button:SetText("PLAYERMODEL SELECTOR")
	Playermodel_Button:SetSize(ScrW()/4, ScrH() / 20)
	Playermodel_Button:Center()
	Playermodel_Button:SetY(ScrH()/6)
	Playermodel_Button:SetFont("MainMenu_Font")
	Playermodel_Button:SetTextColor(Color(240, 155, 0))

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
	if GetConVar("sdm_music"):GetInt() == 0 then
	Music_Button:SetText("ENABLE MUSIC")
	else
	Music_Button:SetText("DISABLE MUSIC")
	end
	Music_Button:SetSize(ScrW()/4, ScrH() / 20)
	Music_Button:Center()
	Music_Button:SetFont("MainMenu_Font")
	Music_Button:SetTextColor(Color(240, 155, 0))
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
		if GetConVar("sdm_music"):GetInt() == 0 then
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



	local Back_Button = vgui.Create("DButton", SettingsMenu)
	local isFlashing = false
	Back_Button:SetText("BACK")
	Back_Button:SetSize(ScrW()/15, ScrH()/20)
	Back_Button:SetPos(ScrW() - ScrW() / 1.01, ScrH() - ScrH()/11)
	Back_Button:SetFont("MainMenu_Font")
	Back_Button:SetTextColor(Color(240, 155, 0))
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

	buttonKleiner:SetPos(ScrW()/2 - 145, ScrH()/2 /1.5 - 70)

	buttonKleiner.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("0")
		net.WriteString("0")
		net.SendToServer()
	end
	buttonKleiner.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local buttonKleiner1 = vgui.Create("DImageButton", SettingsMenu)
	buttonKleiner1:SetImage("materials/icons/playermodels/samclassic_skin1.png")
	buttonKleiner1:SetSize(64, 64)
	buttonKleiner1:SetPos(ScrW()/2 - 75, ScrH()/2 /1.5 - 70)
	buttonKleiner1.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/samclassic.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonKleiner1.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	

	local buttonBarney = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney:SetImage("materials/icons/playermodels/redrick.png")
	buttonBarney:SetSize(64, 64)
	buttonBarney:SetPos(ScrW()/2 + 10, ScrH()/2 /1.5 - 70)
	buttonBarney.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("0")
		net.WriteString("1")
		net.SendToServer()
	end
		buttonBarney.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney2 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney2:SetImage("materials/icons/playermodels/redrick_skin1.png")
	buttonBarney2:SetSize(64, 64)
	buttonBarney2:SetPos(ScrW()/2 + 80, ScrH()/2 /1.5 - 70)
	buttonBarney2.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
		buttonBarney2.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney3 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney3:SetImage("materials/icons/playermodels/redrick_skin2.png")
	buttonBarney3:SetSize(64, 64)
	buttonBarney3:SetPos(ScrW()/2 - 145, ScrH()/2 /1.5 + 6)
	buttonBarney3.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("2")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonBarney3.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		
	local buttonBarney4 = vgui.Create("DImageButton", SettingsMenu)
	buttonBarney4:SetImage("materials/icons/playermodels/redrick_skin3.png")
	buttonBarney4:SetSize(64, 64)
	buttonBarney4:SetPos(ScrW()/2 - 75, ScrH()/2 /1.5 + 6)
	buttonBarney4.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/redrick.mdl")
		net.WriteString("3")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonBarney4.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

		

        

	local buttonAlyx = vgui.Create("DImageButton", SettingsMenu)
	buttonAlyx:SetImage("materials/icons/playermodels/beheadedben.png")
	buttonAlyx:SetSize(64, 64)
	buttonAlyx:SetPos(ScrW()/2 + 10, ScrH()/2 /1.5 + 6)
	buttonAlyx.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/beheadedben.mdl")
		net.WriteString("1")
		net.WriteString("1")
		net.SendToServer()
	end
	buttonAlyx.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	
	SettingsMenu:MakePopup()
	
	local buttonSteve = vgui.Create("DImageButton", SettingsMenu)
	buttonSteve:SetImage("materials/icons/playermodels/steelsteve.png")
	buttonSteve:SetSize(64, 64)
	buttonSteve:SetPos(ScrW()/2 + 80, ScrH()/2 /1.5 + 6)
	buttonSteve.DoClick = function()
		net.Start("PlayerModelMenu")
		net.WriteString("models/pechenko_121/steelsteve.mdl")
		net.WriteString("1")
		net.WriteString("1")			
		net.SendToServer()
	end
	buttonSteve.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 0))
		surface.SetDrawColor(Color(240, 155, 0))
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


