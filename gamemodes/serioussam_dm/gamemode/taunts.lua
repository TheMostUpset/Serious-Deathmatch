local neutraltaunts = {
    "quotes/serioussam/taunt01.wav",
    "quotes/serioussam/taunt02.wav",
    "quotes/serioussam/taunt03.wav",
    "quotes/serioussam/taunt04.wav",
    "quotes/serioussam/taunt05.wav",
	"quotes/serioussam/taunt06.wav",
	"quotes/serioussam/taunt07.wav",
	"quotes/serioussam/taunt08.wav",
	"quotes/serioussam/taunt09.wav"
}

local deathtaunts = {
    "quotes/serioussam/deathtaunt01.wav",
    "quotes/serioussam/deathtaunt02.wav",
    "quotes/serioussam/deathtaunt03.wav",
    "quotes/serioussam/deathtaunt04.wav",
    "quotes/serioussam/deathtaunt05.wav",
	"quotes/serioussam/deathtaunt06.wav",
	"quotes/serioussam/deathtaunt07.wav",
	"quotes/serioussam/deathtaunt08.wav",
	"quotes/serioussam/deathtaunt09.wav"
}

local killtaunts = {
    "quotes/serioussam/killtaunt01.wav",
    "quotes/serioussam/killtaunt02.wav",
    "quotes/serioussam/killtaunt03.wav",
    "quotes/serioussam/killtaunt04.wav",
    "quotes/serioussam/killtaunt05.wav",
	"quotes/serioussam/killtaunt06.wav",
	"quotes/serioussam/killtaunt07.wav",
	"quotes/serioussam/killtaunt08.wav",
	"quotes/serioussam/killtaunt09.wav",
}

local lastKillTime = {}
local lastTauntTime = {}

hook.Add("PlayerDeath", "TrackPlayerKillTime", function(victim, inflictor, killer)
    if killer:IsPlayer() then
        lastKillTime[killer:SteamID()] = CurTime()
    end
end)

hook.Add("PlayerButtonDown", "PlayRandomTaunts", function(ply, button)
	if button == KEY_P then
		
		local neutral = neutraltaunts[math.random(1, #neutraltaunts)]
		local kill = killtaunts[math.random(1, #killtaunts)]
		local death = deathtaunts[math.random(1, #deathtaunts)]
		local killTime = lastKillTime[ply:SteamID()]
		
		--time check
		if lastTauntTime[ply:SteamID()] and CurTime() - lastTauntTime[ply:SteamID()] <= 3 then
            return
        end
		
		lastTauntTime[ply:SteamID()] = CurTime()
		
		if ply:Alive() then
			if killTime and CurTime() - killTime <= 2 then
				ply:EmitSound(kill)
			else
				ply:EmitSound(neutral)
			end
		else
			ply:EmitSound(death)
		end
	end
end)
