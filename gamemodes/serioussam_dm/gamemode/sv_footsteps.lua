local playerWaterLevels = {}

hook.Add("PlayerTick", "CustomWaterSounds", function(ply, mv)
    if not ply:Alive() then return end

    local currentWaterLevel = ply:WaterLevel()

    local prevWaterLevel = playerWaterLevels[ply] or 0

    if prevWaterLevel == 0 and currentWaterLevel > 0 then
        ply:EmitSound("player/serioussam/footsteps/waterenter.wav", 75, 125, 0.25)
    elseif prevWaterLevel > 0 and currentWaterLevel == 0 then
        ply:EmitSound("player/serioussam/footsteps/waterleave.wav", 75, 125, 0.25)
    end

    playerWaterLevels[ply] = currentWaterLevel
end)

hook.Add("PlayerDisconnected", "CleanupWaterLevels", function(ply)
    playerWaterLevels[ply] = nil
end)