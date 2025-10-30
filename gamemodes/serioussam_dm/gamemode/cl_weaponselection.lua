local size = math.Clamp(5, 5, 5) * 0.1
local scale = 0.5 - size + 0.35 or 0.8
local CurTb = 0
local CurSlt = 1
local alpha = 0
local lastAction = -math.huge
local tblLoad = {}
local newinv
local CurSwep = {}
local width = 200 * scale
local height = ScrH() / ScrH() / 2 * scale
local Marge = 50
local x = 0

WeaponSelector = WeaponSelector or {}

WeaponSelector.Colors = {
    Select = Color(0,0,0,0),
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

local HUDOrder = {
    [0] = { "weapon_ss_knife", "weapon_ss_chainsaw" },               -- key 1
    [1] = { "weapon_ss_colt", "weapon_ss_colt_dual" },               -- key 2
    [2] = { "weapon_ss_singleshotgun", "weapon_ss_doubleshotgun" },  -- key 3
    [3] = { "weapon_ss_tommygun", "weapon_ss_minigun" },             -- key 4
    [4] = { "weapon_ss_rocketlauncher", "weapon_ss_grenadelauncher" }, -- key 5
    [5] = { "weapon_ss_flamer", "weapon_ss_sniper" },                -- key 6
    [6] = { "weapon_ss_ghostbuster", "weapon_ss_laser" },            -- key 7
    [7] = { "weapon_ss_cannon" }, 									 -- key 8
}

local CycleOrder = {
    [0] = { "weapon_ss_knife", "weapon_ss_chainsaw" },               -- key 1
    [1] = { "weapon_ss_colt_dual", "weapon_ss_colt" },               -- key 2
    [2] = { "weapon_ss_doubleshotgun", "weapon_ss_singleshotgun" },  -- key 3
    [3] = { "weapon_ss_minigun", "weapon_ss_tommygun" },             -- key 4
    [4] = { "weapon_ss_rocketlauncher", "weapon_ss_grenadelauncher" }, -- key 5
    [5] = { "weapon_ss_flamer", "weapon_ss_sniper" },                -- key 6
    [6] = { "weapon_ss_laser", "weapon_ss_ghostbuster" },            -- key 7
    [7] = { "weapon_ss_cannon" },									 -- key 8
}

local function update()
    table.Empty(tblLoad)

    local ownedWeapons = {}
    for _, wep in pairs(LocalPlayer():GetWeapons()) do
        ownedWeapons[wep:GetClass()] = wep
    end

    for slot, weaponList in pairs(HUDOrder) do
        tblLoad[slot] = {}

        for pos, class in ipairs(weaponList) do
            if ownedWeapons[class] then
                local wep = ownedWeapons[class]
                local ammotype = wep:GetPrimaryAmmoType()
                local ammo = ammotype > -1 and LocalPlayer():GetAmmoCount(ammotype) or 999

                table.insert(tblLoad[slot], {
                    classname = class,
                    name = wep:GetPrintName(),
                    slotpos = pos - 1,
                    ammo = ammo,
                    noammo = (ammo == 0 and ammotype > -1) -- flag weapons with no ammo (exclude melee)
                })
            end
        end

        if #tblLoad[slot] == 0 then
            tblLoad[slot] = nil
        end
    end
end

hook.Add("OnScreenSizeChanged", "WeaponSelector.Hooks.OnScreenSizeChanged", function(oldWidth, oldHeight)
    scale = (ScrW() >= 2560 and size + 0.5) or (ScrW() / 175 >= 6 and size + 0.1) or 0.8
end)

hook.Add("CreateMove", "WeaponSelector.Hooks.CreateMove", function(cmd)
    if newinv then
        local wep = LocalPlayer():GetWeapon(newinv)

        if IsValid(wep) and LocalPlayer():GetActiveWeapon() ~= wep then
            cmd:SelectWeapon(wep)
        else
            newinv = nil
        end
    end
end)

local lastSwitchTime = 0
local switchCooldown = 0.45

-- overwrite binding
hook.Add("PlayerBindPress", "WeaponSelector.Hooks.PlayerBindPress", function(ply, bind, pressed)
    if (bind ~= "invnext" and bind ~= "invprev") and not pressed then return end
    bind = bind:lower()
    if LocalPlayer():InVehicle() then return end

    if RealTime() - lastSwitchTime < switchCooldown then
        if string.sub(bind, 1, 4) == "slot" or bind == "invnext" or bind == "invprev" then
            return true
        else
            return
        end
    end

    if ply:KeyDown(IN_ATTACK) then return end

    update()

    if string.sub(bind, 1, 4) == "slot" then
        local n = tonumber(string.sub(bind, 5, 5) or "1") or 1
        if n < 1 or n > 8 then return true end
        local slotIndex = n - 1

        local hudWeapons = tblLoad[slotIndex]
        if not hudWeapons or #hudWeapons == 0 then return true end

        local cycleList = CycleOrder[slotIndex] or {}

        local ownedCycleWeapons = {}
        for _, class in ipairs(cycleList) do
            for i, w in ipairs(hudWeapons) do
                if w.classname == class and not w.noammo then
                    table.insert(ownedCycleWeapons, {classname = class, hudIndex = i})
                    break
                end
            end
        end

        if #ownedCycleWeapons == 0 then return true end

        local currentCyclePos = 0
        for i, w in ipairs(ownedCycleWeapons) do
            if CurTb == slotIndex and hudWeapons[CurSlt] and hudWeapons[CurSlt].classname == w.classname then
                currentCyclePos = i
                break
            end
        end

        local nextCyclePos = currentCyclePos + 1
        if nextCyclePos > #ownedCycleWeapons then nextCyclePos = 1 end

        local nextWeapon = ownedCycleWeapons[nextCyclePos]

        CurTb = slotIndex
        CurSlt = nextWeapon.hudIndex

        local wep = LocalPlayer():GetWeapon(nextWeapon.classname)
        if IsValid(wep) and LocalPlayer():GetActiveWeapon() ~= wep then
            newinv = nextWeapon.classname
        end

        alpha = 1
        lastAction = RealTime()
        lastSwitchTime = RealTime()

        return true
    end

    if bind == "invnext" or bind == "invprev" then
        local flatWeapons = {}
        for slot = 0, 7 do
            if tblLoad[slot] then
                for i, w in ipairs(tblLoad[slot]) do
                    if not w.noammo then
                        table.insert(flatWeapons, {classname = w.classname, slot = slot, hudIndex = i})
                    end
                end
            end
        end

        if #flatWeapons == 0 then return true end

        local activeWep = LocalPlayer():GetActiveWeapon()
        local activeClass = IsValid(activeWep) and activeWep:GetClass() or nil
        local currentPos = 0
        for i, w in ipairs(flatWeapons) do
            if w.classname == activeClass then
                currentPos = i
                break
            end
        end

        local nextPos
        if bind == "invnext" then
            nextPos = currentPos + 1
            if nextPos > #flatWeapons then nextPos = 1 end
        else -- invprev
            nextPos = currentPos - 1
            if nextPos < 1 then nextPos = #flatWeapons end
        end

        local nextWeapon = flatWeapons[nextPos]

        CurTb = nextWeapon.slot
        CurSlt = nextWeapon.hudIndex

        local wep = LocalPlayer():GetWeapon(nextWeapon.classname)
        if IsValid(wep) and LocalPlayer():GetActiveWeapon() ~= wep then
            newinv = nextWeapon.classname
        end

        alpha = 1
        lastAction = RealTime()
        lastSwitchTime = RealTime()

        return true
    end
end)


local sdmg = surface.GetTextureID("vgui/serioussam/hud/pseriousdamage")
local invis = surface.GetTextureID("vgui/serioussam/hud/pinvisibility")
hook.Add("HUDPaint", "WeaponSelector.Hooks.HUDPaint", function()
    --weapon selection
    local hudr, hudg, hudb = GAMEMODE:GetHUDColor()
    local size = ScrH() / 14.75
    local gap_screen = ScrH() / 14
    local y = ScrH() - size - gap_screen * 2.2
    local ammosize = size/1.025
    local ammoy = y+ammosize/4
    local icon_gap = 5.5
    local powerupx = ScrH() / 14.75
    local powerupy = ScrH() / 14.75

    if not IsValid(LocalPlayer()) then return end

    if alpha < 1 then
        if alpha ~= 0 then
            alpha = 0
        end

        return
    end

    update()

    if RealTime() - lastAction > 2 then
        alpha = 0
    end

    surface.SetAlphaMultiplier(alpha)
    surface.SetDrawColor(Color(255, 255, 255))
    surface.SetTextColor(Color(255, 255, 255))
    local thisWidth = 0

    for i, v in pairs(tblLoad) do
        thisWidth = thisWidth + width + Marge
    end

    local weapons = LocalPlayer():GetWeapons()
    local numWeapons = #weapons

    local iconWidth = powerupx
    local gap = 4

    local totalWidth = numWeapons * iconWidth + (numWeapons - 1) * gap

    local x = (ScrW() / 2) - (totalWidth / 2)

    local pos = x
    local frame_r, frame_g, frame_b = SeriousHUD:GetFrameColor()
    if SeriousHUD:GetSkin() == 1 then
        WeaponSelector.Colors.Select = Color(255, 255, 255, 255)
    elseif SeriousHUD:GetSkin() == 2 then
        WeaponSelector.Colors.Select = Color(240, 200, 0, 255)
	elseif SeriousHUD:GetSkin() == 3 then
        WeaponSelector.Colors.Select = Color(240, 255, 255, 255)
    end

    for i, v in SortedPairs(tblLoad) do
        local y = Marge

        pos = x + thisWidth

        for j, wep in pairs(v) do
            local selected = CurTb == i and CurSlt == j
            local height = height + (height + Marge) * 1

            draw.RoundedBox(0, x, ammoy / 1.2, powerupx, powerupy, Color(20, 20, 20, 160))
			
			
            surface.SetDrawColor(selected and WeaponSelector.Colors.Select or Color(frame_r, frame_g, frame_b))
			if wep.ammo == 0 then
				surface.SetDrawColor(selected and WeaponSelector.Colors.Select or Color(frame_r / 3, frame_g / 3, frame_b / 3))
			end
            surface.DrawOutlinedRect( x, ammoy / 1.2, powerupx, powerupy)

            --serious sam weapon icons
            local icon = SeriousHUD and SeriousHUD:GetWeaponIcon(wep.classname) or sdmg
            local iconr, icong, iconb = hudr, hudg, hudb
            if wep.ammo == 0 then
                iconr, icong, iconb = iconr / 3, icong / 3, iconb / 3
            end

            if selected then
                surface.SetDrawColor(WeaponSelector.Colors.Select.r, WeaponSelector.Colors.Select.g, WeaponSelector.Colors.Select.b, 255)
            else
                surface.SetDrawColor(Color(iconr, icong, iconb))
            end

            surface.SetTexture(icon)
            surface.DrawTexturedRect( x+1, ammoy / 1.2+2, ammosize, ammosize)

            local w, h = surface.GetTextSize(wep.classname)
            x = x + (powerupx + 4)
        end

    end

    surface.SetAlphaMultiplier(1)
end)

hook.Add("HUDShouldDraw", "WeaponSelector.Hooks.HUDShouldDraw", function(elementName)
    if hideElements[elementName] then return false end
end)