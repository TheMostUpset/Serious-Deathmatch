local cvar_music = CreateClientConVar( "sdm_music", 1, true, false) 

include("shared.lua")
include("sb.lua")
include("cl_hud.lua")
include("cl_fonts.lua")
include("cl_mapvote.lua")
include("cl_menus.lua")
include("cl_weaponselection.lua")

musictable = {}
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

hook.Add("CalcView", "SeriousSpeedPowerup", function(ply, origin, angles, fov)
	if ply:HasSeriousSpeed() then
		fov = fov + 10
	
		local view = {}

		view.origin = origin
		view.angles = angles
		view.fov = fov

		return view
	end
end)

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
		vm_origin = vm_origin - vm_angles:Forward()*2
	end

	return vm_origin, vm_angles

end

local drawing = false
local sdmg_mat = Material("models/effects/serioussam/sdmg_overlay")
local inv_mat = Material("models/powerups/invisibility")
local protect_mat = Material("models/serioussam/powerups/gold")

hook.Add("PostDrawViewModel", "glowy_vm", function(viewmodel, ply)
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
    if not ply:HasInvisibility() then
        return
    end
    if IsValid(ply) then
        render.SetBlend(0.4)
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


function StopMusic()
	timer.Remove("looptimer")
	RunConsoleCommand("stopsound")
end

function PlayMusic()
	musictable = {
		["sdm_red_station"] = "sound/music/redstation.ogg",
		["sdm_desert_temple"] = "sound/music/redstation.ogg",
		["sdm_sun_palace"] = "sound/music/sunpalace.ogg",
		["sdm_little_trouble"] = "sound/music/littetrouble.ogg",
		["sdm_brkeen_chevap"] = "sound/music/brkeen.ogg",
		["sdm_lost_tomb"] = "sound/music/losttomb.ogg",
		["sdm_hole_classic"] = "sound/music/holeclassic.ogg",
	}
	music = musictable[game.GetMap()]
	if cvar_music:GetBool() then
		sound.PlayFile(music, "", function(station, errorID, errorName)
			if IsValid(station) then
				timer.Remove("looptimer")
				station:SetVolume(1)
				station:Play()
				timer.Create("looptimer", station:GetLength(), 1, function()
					PlayMusic()
				end)
			end
		end)
	end
end



hook.Add("Initialize", "PlayMusicOnSpawn", PlayMusic)


