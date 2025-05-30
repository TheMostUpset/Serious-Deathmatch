include('shared.lua')

net.Receive("SSPowerupsClient", function()
	local ply, t = net.ReadEntity(), net.ReadTable()
	if IsValid(ply) then
		ply.SSPowerups = t
	end
end)

hook.Add("HUDPaint", "SSPowerupsHUD", function()

	local client = LocalPlayer()
	local t = client.SSPowerups
    if !t then return end
	
	local icons = {
			["SeriousDamage"] = surface.GetTextureID("vgui/serioussam/hud/pseriousdamage"),
			["Invisibility"] = surface.GetTextureID("vgui/serioussam/hud/pinvisibility"),
			["Protect"] = surface.GetTextureID("vgui/serioussam/hud/pinvulnerability"),
			["Speed"] = surface.GetTextureID("vgui/serioussam/hud/pseriousspeed")
		}

	if SeriousHUD:GetSkin() == 1 then 
		icons = {
			["SeriousDamage"] = surface.GetTextureID("vgui/serioussam/hud/hud_tfe/pseriousdamage"),
			["Invisibility"] = surface.GetTextureID("vgui/serioussam/hud/hud_tfe/pinvisibility"),
			["Protect"] = surface.GetTextureID("vgui/serioussam/hud/hud_tfe/pinvulnerability"),
			["Speed"] = surface.GetTextureID("vgui/serioussam/hud/hud_tfe/pseriousspeed")
		}
	end
	
	local size = ScrH() / 14.75
	local gap_screen = ScrH() / 14
	local y = ScrH() - size - gap_screen
	local ammosize = size/1.25
	local ammoy = y+ammosize/4
	local icon_gap = 5.5
	local iconpos = ScrW() - gap_screen + icon_gap 
    local CT = CurTime()
	local powerupx = ScrH() / 14.75 /1.25
	local powerupy = ScrH() / 14.75 /1.25
	local dur = GetConVar("sdm_powerupduration"):GetInt()
	
	local frame_r, frame_g, frame_b = SeriousHUD:GetFrameColor()
	local r, g, b = SeriousHUD:GetColor()
	
	for k, v in pairs(t) do
		if v > CurTime() then
			draw.RoundedBox(0, iconpos, ammoy, powerupx, powerupy, Color(0, 0, 0, 160))
			surface.SetDrawColor(Color(frame_r, frame_g, frame_b))
			surface.DrawOutlinedRect(iconpos, ammoy, powerupx, powerupy)
			surface.SetTexture(icons[k])
			
			if SeriousHUD:GetSkin() == 1 then 
				surface.SetDrawColor(r, g, b, 255)
			elseif SeriousHUD:GetSkin() == 2 then
				surface.SetDrawColor(255, 255, 255, 255)
			end
			
			surface.DrawTexturedRect(iconpos+2, ammoy+2, ammosize/1.075, ammosize/1.075)	
			local timebar = (v - CT)
			local scale = math.floor((ammosize * timebar ) / dur - ScrH()/270)
			if SeriousHUD:GetSkin() == 1 then
				surface.SetDrawColor(r, g, b, 220)
				if timebar < 0.2 then
					surface.SetDrawColor(255, 0, 0, 220)
				end
			elseif SeriousHUD:GetSkin() == 2 then
				surface.SetDrawColor(255, 255 * timebar / 10, 0, 220)
			end
			surface.DrawRect(iconpos + ammosize / 1.375, ammoy+ammosize-scale-3, ammosize / 4.75, scale)
			
			
			iconpos = iconpos - powerupx - icon_gap
		end
	end
	
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
