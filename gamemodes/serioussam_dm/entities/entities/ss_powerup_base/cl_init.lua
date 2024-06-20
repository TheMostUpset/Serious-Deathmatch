include('shared.lua')

net.Receive("SSPowerupsClient", function()
	local ply, t = net.ReadEntity(), net.ReadTable()
	if IsValid(ply) then
		ply.SSPowerups = t
	end
end)

local sdmg = surface.GetTextureID("vgui/serioussam/hud/pseriousdamage")
local invis = surface.GetTextureID("vgui/serioussam/hud/pinvisibility")
local protect = surface.GetTextureID("vgui/serioussam/hud/pinvulnerability")
local speed = surface.GetTextureID("vgui/serioussam/hud/pseriousspeed")
	
local function AddPowerupOverlay(pTime, col)
	drawing = false
	local t = LocalPlayer().SSPowerups

	local client = LocalPlayer()
	local awep = client:GetActiveWeapon()
	
	local size = ScrH() / 14.75
	local gap_screen = ScrH() / 14
	local gap_rect = 7
	local y = ScrH() - size - gap_screen
	local armor_y = y * .908
	local widerect_w = size * 2.42
	local widerectleft_x = size + gap_screen + gap_rect
	local text_align_y = size / 5
	
	local cntr = widerectleft_x + widerect_w + ScrW() / 8 - 52
	local ammorectx = cntr + size + gap_rect
	local ammoiconrectx = ammorectx + widerect_w + gap_rect
	
	local hudr, hudg, hudb = 90, 120, 180
	local rect, recta = 0, 160
	local armor = client:Alive() and client:Armor() or 0
	local ammosize = size/1.25
	local ammoy = y+ammosize/4
	local icon_gap = 5.5
	local iconpos = ScrW() - gap_screen + icon_gap 
    local CT = CurTime()
	
	local powerupx = ScrH() / 14.75 /1.25
	local powerupy = ScrH() / 14.75 /1.25
	
	

	

	if LocalPlayer():GetNW2Bool( "HasSDMG", false ) then
	draw.RoundedBox(0, iconpos, ammoy, powerupx, powerupy, Color(0, 0, 0, 100))
    surface.SetDrawColor(Color(SeriousHUD:GetFrameColor()))
    surface.DrawOutlinedRect(iconpos, ammoy, powerupx, powerupy)
	surface.SetTexture(sdmg)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(iconpos+2, ammoy+2, ammosize/1.075, ammosize/1.075)
	elseif LocalPlayer():GetNW2Bool( "HasInvis", false ) then
	draw.RoundedBox(0, iconpos, ammoy, powerupx, powerupy, Color(0, 0, 0, 100))
    surface.SetDrawColor(Color(SeriousHUD:GetFrameColor()))
    surface.DrawOutlinedRect(iconpos, ammoy, powerupx, powerupy)
	surface.SetTexture(invis)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(iconpos+2, ammoy+2, ammosize/1.075, ammosize/1.075)
	elseif LocalPlayer():GetNW2Bool( "HasProtect", false ) then
	draw.RoundedBox(0, iconpos, ammoy, powerupx, powerupy, Color(0, 0, 0, 100))
    surface.SetDrawColor(Color(SeriousHUD:GetFrameColor()))
    surface.DrawOutlinedRect(iconpos, ammoy, powerupx, powerupy)
	surface.SetTexture(protect)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(iconpos+2, ammoy+2, ammosize/1.075, ammosize/1.075)
	elseif LocalPlayer():GetNW2Bool( "HasSSpeed", false ) then
	draw.RoundedBox(0, iconpos, ammoy, powerupx, powerupy, Color(0, 0, 0, 100))
    surface.SetDrawColor(Color(SeriousHUD:GetFrameColor()))
    surface.DrawOutlinedRect(iconpos, ammoy, powerupx, powerupy)
	surface.SetTexture(speed)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(iconpos+2, ammoy+2, ammosize/1.075, ammosize/1.075)	
    end
	end



hook.Add("HUDPaintBackground", "SSPowerupsHUD", function()
	local t = LocalPlayer().SSPowerups
    if !t then return end
    AddPowerupOverlay(t.QuadDamage, Color(255, 0, 0, 25))
	AddPowerupOverlay(t.Invisibility, Color(255, 0, 0, 25))
end)


local function MakeLight(ply, col)
	if !cvars.Bool("q1_cl_firelight") then return end
	local dlight = DynamicLight(ply:EntIndex())
	if dlight then
		dlight.Pos = ply:WorldSpaceCenter()
		dlight.R = col[1]
		dlight.G = col[2]
		dlight.B = col[3]
		dlight.Brightness = 5
		dlight.Decay = 512
		dlight.Size = 192
		dlight.DieTime = CurTime() + 1
	end
end

function ENT:Initialize()
	self.OriginPos = self:GetPos() + Vector(0, 0, 5)
	self.Rotate = 0
	self.RotateTime = RealTime()
end


function ENT:Draw()
	self:SetRenderOrigin(self.OriginPos + Vector(0,0,math.sin(RealTime() * 6) *3.5))
	self:SetupBones()
	self:DrawModel()
	self.Rotate = (RealTime() - self.RotateTime)*180 %360
	self:SetAngles(Angle(0,self.Rotate,0))
end
