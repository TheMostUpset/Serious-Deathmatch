local cvar_music = CreateClientConVar( "sdm_music", "1", true, false, "Enable music on SSDM maps", 0, 1)
local cvar_custom_music_en = CreateClientConVar( "sdm_custom_music_enable", "0", true, false, "Enable custom user music override", 0, 1)
local cvar_custom_music_path = CreateClientConVar( "sdm_custom_music_path", "", true, false, "Filepath to the custom music file" )
local cvar_playermodel = CreateClientConVar( "sdm_playermodel", "models/pechenko_121/samclassic.mdl", true, true, "Playermodel option")
local cvar_playermodel_skin = CreateClientConVar( "sdm_playermodel_skin", 0, true, true, "Playermodel skin option", 0 )
local cvar_playermodel_bodygroup = CreateClientConVar( "sdm_playermodel_bodygroup", 0, true, true, "Playermodel bodygroup option", 0, 1 )

include("shared.lua")
include("sb.lua")
include("cl_hud.lua")
include("cl_fonts.lua")
include("cl_menus.lua")
include("cl_weaponselection.lua")
include("cl_footsteps.lua")

net.Receive("ClientChatMessage", function()
	local tbl = net.ReadTable()
	local msg = ""
	for i = 1, #tbl do
		msg = msg.." "..language.GetPhrase(tbl[i])
	end
	msg = string.TrimLeft(msg)
	local col = Color(255, 220, 20)
	chat.AddText(col, msg)
end)

local slotsFix = {
	["weapon_ss_cannon"] = 5,
	["weapon_ss_doubleshotgun"] = 2,
	["weapon_ss_flamer"] = 4,
	["weapon_ss_ghostbuster"] = 5,
	["weapon_ss_grenadelauncher"] = 4,
	["weapon_ss_laser"] = 4,
	["weapon_ss_minigun"] = 3,
	["weapon_ss_rocketlauncher"] = 4,
	["weapon_ss_singleshotgun"] = 2,
	["weapon_ss_sniper"] = 4,
	["weapon_ss_tommygun"] = 3
}

function GM:InitPostEntity()
	self:PlayMapMusic()
	for class, slot in pairs(slotsFix) do
		local wepEnt = weapons.GetStored(class)
		if wepEnt then wepEnt.Slot = slot end
	end
end

local lastMusicStation
GM.MusicTable = {
    ["sdm_red_station"] = "Desert_Temple_Deathmatch.mp3",
    ["sdm_desert_temple"] = "Desert_Temple_Egypt.mp3",
    ["sdmw_winter_temple"] = "Desert_Temple_Egypt.mp3",
    ["sdm_sun_palace"] = "Gates_of_Persepolis.mp3",
    ["sdm_little_trouble"] = "littetrouble.mp3",
    ["sdmw_little_winter"] = "littetrouble.mp3",
    ["sdm_brkeen_chevap"] = "Catacombs.mp3",
    ["sdmw_xmas_chevap"] = "Catacombs.mp3",
    ["sdm_lost_tomb"] = "The_Lost_Tomb_Deathmatch.mp3",
    ["sdm_hole_classic"] = "Enlightening_the_World.mp3",
    ["stdm_crystal_march"] = "crystalmarch.mp3",
    ["sdm_the_fortress"] = "thefortress.mp3",
    ["sdm_yoddler_classic"] = "yoddler.mp3",
    ["sdm_skulls_bones"] = "holeclassic.mp3",
}

function GM:PlayMapMusic(volume)
    if lastMusicStation and IsValid(lastMusicStation) then
        lastMusicStation:Stop()
        lastMusicStation = nil
        timer.Remove("MusicLoopTimer")
    end
    
    local convarVal = cvar_music:GetFloat()
    if convarVal > 0 then
        local targetPath = nil

        if cvar_custom_music_en:GetBool() and cvar_custom_music_path:GetString() ~= "" then
            targetPath = cvar_custom_music_path:GetString()
        else
            local mapMusic = self.MusicTable[game.GetMap()]
            if mapMusic then
                targetPath = "sound/music/" .. mapMusic
            end
        end

        if targetPath then
            volume = volume or convarVal
            sound.PlayFile(targetPath, "", function(station, errorID, errorName)
                if IsValid(station) then
                    station:Play()
                    station:SetVolume(volume)
                    lastMusicStation = station
                    timer.Create("MusicLoopTimer", station:GetLength(), 1, function()
                        GAMEMODE:PlayMapMusic()
                    end)
                else
                    print("failed to load sound at " .. targetPath .. ": " .. tostring(errorName))
                end
            end)
        end
    end
end

cvars.AddChangeCallback("sdm_music", function(name, value_old, value_new)
    value_new = tonumber(value_new)
    value_old = tonumber(value_old)
    if not isnumber(value_new) then return end
    if value_new > 0 then
        if value_old == 0 then
            GAMEMODE:PlayMapMusic(value_new)
        elseif lastMusicStation and IsValid(lastMusicStation) then
            lastMusicStation:SetVolume(value_new)
        end
    else
        GAMEMODE:StopMapMusic()
    end
end, "SDM_MusicMain")

cvars.AddChangeCallback("sdm_custom_music_enable", function(name, value_old, value_new)
    GAMEMODE:PlayMapMusic()
end, "SDM_CustomMusicToggle")

cvars.AddChangeCallback("sdm_custom_music_path", function(name, value_old, value_new)
    if cvar_custom_music_en:GetBool() then
        GAMEMODE:PlayMapMusic()
    end
end, "SDM_CustomMusicPath")

function GM:StopMapMusic()
    timer.Remove("MusicLoopTimer")
    if lastMusicStation and IsValid(lastMusicStation) then
        lastMusicStation:Stop()
        lastMusicStation = nil
    else
        RunConsoleCommand("stopsound")
    end
end

function GM:PostCleanupMap()
    self:PlayMapMusic()
end

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

--[[---------------------------------------------------------
	Name: CalcView
	Allows override of the default view
-----------------------------------------------------------]]
function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	local Vehicle	= ply:GetVehicle()
	local Weapon	= ply:GetActiveWeapon()
	
	if ply:HasSeriousSpeed() then
		fov = fov + 10
	end
	
	if thirdperson_enabled then
		return GAMEMODE:CalcThirdpersonView(ply, origin, angles, fov)
	end

	local view = {
		["origin"] = origin,
		["angles"] = angles,
		["fov"] = fov,
		["znear"] = znear,
		["zfar"] = zfar,
		["drawviewer"] = false,
	}

	--
	-- Let the vehicle override the view and allows the vehicle view to be hooked
	--
	if ( IsValid( Vehicle ) ) then return hook.Run( "CalcVehicleView", Vehicle, ply, view ) end

	--
	-- Let drive possibly alter the view
	--
	if ( drive.CalcView( ply, view ) ) then return view end

	--
	-- Give the player manager a turn at altering the view
	--
	player_manager.RunClass( ply, "CalcView", view )

	-- Give the active weapon a go at changing the view
	if ( IsValid( Weapon ) ) then

		local func = Weapon.CalcView
		if ( func ) then
			local origin, angles, fov = func( Weapon, ply, Vector( view.origin ), Angle( view.angles ), view.fov ) -- Note: Constructor to copy the object so the child function can't edit it.
			view.origin, view.angles, view.fov = origin or view.origin, angles or view.angles, fov or view.fov
		end

	end
	
	if ply:GetObserverMode() == OBS_MODE_IN_EYE then
		local view = {}
		view.origin = pos
		view.angles = ang
		view.fov = GetConVar("fov_desired"):GetInt()
		return view
	end

	return view

end

function GM:CalcViewModelView( Weapon, ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng )

	if ( !IsValid( Weapon ) ) then return end

	local vm_origin, vm_angles = EyePos, EyeAng

	-- Controls the position of all viewmodels
	local func = Weapon.GetViewModelPosition
	if ( func ) then
		local pos, ang = func( Weapon, EyePos*1, EyeAng*1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	-- Controls the position of individual viewmodels
	func = Weapon.CalcViewModelView
	if ( func ) then
		local pos, ang = func( Weapon, ViewModel, OldEyePos*1, OldEyeAng*1, EyePos*1, EyeAng*1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end
	
	local owner = Weapon:GetOwner()
	if IsValid(owner) and owner:HasSeriousSpeed() then
		if LocalPlayer():Team() == TEAM_SPECTATOR then return end
		vm_origin = vm_origin - vm_angles:Forward()*2
	end

	return vm_origin, vm_angles

end


local drawing = false
local sdmg_mat = Material("models/effects/serioussam/sdmg_overlay")
local inv_mat = Material("models/powerups/invisibility")
local protect_mat = Material("models/serioussam/powerups/gold")

hook.Add("PostDrawViewModel", "glowy_vm", function(viewmodel, ply)
	if LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget():HasSeriousDamage() and not drawing then
		drawing = true

        render.ModelMaterialOverride(sdmg_mat)
        viewmodel:DrawModel()
		
        render.ModelMaterialOverride()

        drawing = false
	end
    if not ply:HasSeriousDamage() then
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


hook.Add("PreDrawViewModel", "invis_vm", function(vm, ply)
	if LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget():HasInvisibility() then
		render.SetBlend(0.2)
		render.OverrideBlend( false )
	end
    if not ply:HasInvisibility() then
        return
    end
	
    if IsValid(ply) then
        render.SetBlend(0.2)
		render.OverrideBlend( false )
    end
end)

local undomodelblend = false
function GM:PrePlayerDraw(ply)
	if !IsValid(LocalPlayer()) then return end
    if ply:HasInvisibility() then
        render.SetBlend(0.2)
		undomodelblend = true
    end
end

function GM:PostPlayerDraw(ply)
	if undomodelblend then
		render.SetBlend(1)
		undomodelblend = false
	end
end

hook.Add("PostDrawViewModel", "gold_vm", function(viewmodel, ply)
	if LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget():HasProtect() and not drawing then
		drawing = true

        render.ModelMaterialOverride(protect_mat)
        viewmodel:DrawModel()
		
        render.ModelMaterialOverride()

        drawing = false
	end
    if not ply:HasProtect() then
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
    if not ply:HasSeriousDamage() then
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
    if not ply:HasProtect() then
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
	return true
end

function GM:ContextMenuOpen()
	return true
end