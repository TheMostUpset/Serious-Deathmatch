local size = math.Clamp(5, 5, 5) * 0.1
local scale = 0.5 - size + 0.35 or 0.8
local CurTb = 0
local CurSlt = 1
local alpha = 0
local lastAction = -math.huge
local tblLoad = {}
local slide = {}
local newinv
local CurSwep = {}
local width = 200 * scale
local height = ScrH() / ScrH() / 2 * scale
local Marge = 50
local x = 0

WeaponSelector = WeaponSelector or {}
WeaponSelector.Colors = {
    BG = Color(44, 62, 80),
    Select = Color(252, 186, 4, 100),
    TextColor = Color(255, 255, 255), 
}
local hideElements = {
    ["CHudWeaponSelection"] = true
}
local tblFont = {}

for _, y in pairs(file.Find("scripts/weapon_*.txt", "MOD")) do
    local t = util.KeyValuesToTable(file.Read("scripts/" .. y, "MOD"))

    CurSwep[y:match("(.+)%.txt")] = {
        Slot = t.bucket,
        SlotPos = t.bucket_position,
        TextureData = t.texturedata
    }
end

local function GetCurSwep()
    if alpha <= 0 then
        table.Empty(slide)
        local class = IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()

        for k1, v1 in pairs(tblLoad) do
            for k2, v2 in pairs(v1) do
                if v2.classname == class then
                    CurTb = k1
                    CurSlt = k2

                    return
                end
            end
        end
    end
end

local function update()
    table.Empty(tblLoad)

    for k, v in pairs(LocalPlayer():GetWeapons()) do
        local classname = v:GetClass()
        local Slot = CurSwep[classname] and CurSwep[classname].Slot - 1 or v.Slot or 1
        tblLoad[Slot] = tblLoad[Slot] or {}

        table.insert(tblLoad[Slot], {
            classname = classname,
            name = v:GetPrintName(),
            slotpos = CurSwep[classname] and CurSwep[classname].SlotPos - 1 or v.SlotPos or 1
        })
    end

    for k, v in pairs(tblLoad) do
        table.sort(v, function(a, b) return a.slotpos < b.slotpos end)
    end
end

hook.Add("OnScreenSizeChanged", "WeaponSelector.Hooks.OnScreenSizeChanged", function(oldWidth, oldHeight)
    scale = (ScrW() >= 2560 and size + 0.5) or (ScrW() / 175 >= 6 and size + 0.1) or 0.8
end)

hook.Add("CreateMove", "WeaponSelector.Hooks.CreateMove", function(cmd)
    if newinv then
        local wep = LocalPlayer():GetWeapon(newinv)

        if wep:IsValid() and LocalPlayer():GetActiveWeapon() ~= wep then
            cmd:SelectWeapon(wep)
        else
            newinv = nil
        end
    end
end)

-- overwrite binding
hook.Add("PlayerBindPress", "WeaponSelector.Hooks.PlayerBindPress", function(ply, bind, pressed)
    if not pressed then return end
    bind = bind:lower()
    if LocalPlayer():InVehicle() then return end

    if string.sub(bind, 1, 4) == "slot" and not ply:KeyDown(IN_ATTACK) then
        local n = tonumber(string.sub(bind, 5, 5) or 1) or 1
        if n < 1 or n > 6 then return true end
        n = n - 1
        update()
        if not tblLoad[n] then return true end
        GetCurSwep()

        if CurTb == n and tblLoad[CurTb] and (alpha > 0 or GetConVarNumber("hud_fastswitch") > 0) then
            CurSlt = CurSlt + 1

            if CurSlt > #tblLoad[CurTb] then
                CurSlt = 1
            end
        else
            CurTb = n
            CurSlt = 1
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            newinv = tblLoad[CurTb][CurSlt].classname
        else
            lastAction = RealTime()
            alpha = 1
        end

        return true
    elseif bind == "invnext" and not ply:KeyDown(IN_ATTACK) then
        update()
        if #tblLoad < 1 then return true end
        GetCurSwep()
        CurSlt = CurSlt + 1

        if CurSlt > (tblLoad[CurTb] and #tblLoad[CurTb] or -1) then
            repeat
                CurTb = CurTb + 1

                if CurTb > 5 then
                    CurTb = 0
                end
            until tblLoad[CurTb]
            CurSlt = 1
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            newinv = tblLoad[CurTb][CurSlt].classname
        else
            lastAction = RealTime()
            alpha = 1
        end

        return true
    elseif bind == "invprev" and not ply:KeyDown(IN_ATTACK) then
        update()
        if #tblLoad < 1 then return true end
        GetCurSwep()
        CurSlt = CurSlt - 1

        if CurSlt < 1 then
            repeat
                CurTb = CurTb - 1

                if CurTb < 0 then
                    CurTb = 5
                end
            until tblLoad[CurTb]
            CurSlt = #tblLoad[CurTb]
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            newinv = tblLoad[CurTb][CurSlt].classname
        else
            lastAction = RealTime()
            alpha = 1
        end

        return true
    elseif bind == "+attack" and alpha > 0 then
        if tblLoad[CurTb] and tblLoad[CurTb][CurSlt] then
            newinv = tblLoad[CurTb][CurSlt].classname
        end
        alpha = 0

        return true
    end
end)
--weapon selection
local sdmg = surface.GetTextureID("vgui/serioussam/hud/pseriousdamage")
local invis = surface.GetTextureID("vgui/serioussam/hud/pinvisibility")
hook.Add("HUDPaint", "WeaponSelector.Hooks.HUDPaint", function()
	local client = LocalPlayer()
	local t = client.SSPowerups
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
	local iconpos = ScrW() / 2
	local powerupx = ScrH() / 14.75 /1.25
	local powerupy = ScrH() / 14.75 /1.25
    if not IsValid(LocalPlayer()) then return end

    if alpha < 1e-02 then
        if alpha ~= 0 then
            alpha = 0
        end

        return
    end

    update()

    if RealTime() - lastAction > 2 then
        alpha = Lerp(FrameTime() * 4, alpha, 0)
    end

    surface.SetAlphaMultiplier(alpha)
    surface.SetDrawColor(Color(255, 255, 255))
    surface.SetTextColor(Color(255, 255, 255))
    local thisWidth = 0

    for i, v in pairs(tblLoad) do
        thisWidth = thisWidth + width + Marge
    end

    x = ScrW()/2 - powerupx/2 - (#LocalPlayer():GetWeapons() * (powerupx + icon_gap * 2)) * 0.4

	
	ss_x = (ScrW() + thisWidth) / 2
	
    local pos = x

    for i, v in SortedPairs(tblLoad) do
        local y = Marge

        pos = x + thisWidth

        for j, wep in pairs(v) do
            local selected = CurTb == i and CurSlt == j
            local height = height + (height + Marge) * 1 
            draw.RoundedBox(0, x, ammoy / 1.2, powerupx, powerupy, selected and WeaponSelector.Colors.Select or Color(20, 20, 20, 160))
            surface.SetDrawColor(selected and WeaponSelector.Colors.Select or Color(90, 120, 180))
			surface.DrawOutlinedRect( x, ammoy / 1.2, powerupx, powerupy)
			--serious sam weapon icons
			local icon = SeriousHUD and SeriousHUD.WeaponIcons[wep.classname] or sdmg
			surface.SetTexture(icon)			
			surface.SetDrawColor(Color(255, 255, 255))
			surface.DrawTexturedRect( x+2, ammoy / 1.2+2, ammosize/1.075, ammosize/1.075)
			
			local w, h = surface.GetTextSize(wep.classname)
			x = x + (powerupx + 4)
        end
		
    end

    surface.SetAlphaMultiplier(1)
end)

hook.Add("HUDShouldDraw", "WeaponSelector.Hooks.HUDShouldDraw", function(elementName)
    if hideElements[elementName] then return false end
end)