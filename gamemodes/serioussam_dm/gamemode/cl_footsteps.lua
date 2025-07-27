hook.Add("PlayerFootstep", "CustomFootsteps_SeriousSam", function(ply, pos, foot, soundName, volume, filter)
    local customSoundName = string.gsub(soundName, "player/footsteps", "player/serioussam/footsteps")
    ply:EmitSound(customSoundName, 87.5, 100, 1, CHAN_AUTO)
    return true
end)