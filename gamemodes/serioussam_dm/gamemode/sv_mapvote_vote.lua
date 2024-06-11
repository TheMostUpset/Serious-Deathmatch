
--[[		Voting		]]--
--[[	Starts a vote
		@param duration The duration, in seconds, the vote should run for	
		@param terminalHook The hook that ends the vote. Can be left nil	]]--
Mapvote.startVote = function( duration, terminalHook )
	if duration > 0 then
		timer.Create( "Mapvote_Voting", duration or 30, 1, Mapvote.endVote )
	else
		if terminalHook != nil and terminalHook != "" then
			hook.Add( terminalHook, "Mapvote_Voting", Mapvote.endVote )
		else
			return
		end
	end
	
	Mapvote.buildMapSelection()

	SetGlobalInt( "Mapvote_State", MAPVOTE_VOTING )
	Mapvote.players = {}
	Mapvote.tally = {}
	
	net.Start("mapvote_prompt")
	net.WriteTable(Mapvote.maps)
	net.Broadcast()
end

--[[	Ends the voting period, and sets nextlevel to the winning map		]]--
Mapvote.endVote = function()
	if not GetGlobalInt( "Mapvote_State" ) == MAPVOTE_VOTING then return end
	SetGlobalInt( "Mapvote_State", MAPVOTE_VOTED )
	
	net.Start("mapvote_finish")
	net.Broadcast()
	
	local nextmap = table.GetWinningKey(Mapvote.tally) or 1
	
	Mapvote.winningMap = Mapvote.maps[nextmap]
	
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTTALK, Mapvote.winningMap.." was chosen!")
		v:PrintMessage( HUD_PRINTTALK, (Mapvote.tally[nextmap] or 0).." votes.")
	end		

	timer.Simple(3, function()
		RunConsoleCommand("changelevel", Mapvote.winningMap)
	end)
end

--[[	Handles player voting	]]--
Mapvote.handleVote = function( len, ply )
	
	local mapID = net.ReadInt(16)
	if mapID <= table.Count( Mapvote.maps ) and mapID >= 1 then --Make sure the data received is in a valid range.
		--Increment the tally, and mark the player as having voted.
		Mapvote.tally[mapID] = (Mapvote.tally[mapID] or 0) + 1 
		table.insert(Mapvote.players, ply)
	end
end
--[[	End of Voting	]]--

--[[	Overrides	]]--
--[[	Meant to be overridden. Set up any addtional console variables by 
		the gamemode implementation.										]]--

--[[ 	Meant to be overridden
		@return Boolean whether a vote should be started or not				]]--
Mapvote.shouldVote = function()
	return Mapvote.checkRTV()
end

--[[ 	Meant to be overridden. Checks if a vote should be started, 
		and if so runs the start function with gamemode specific arguments	]]--
Mapvote.checkVote = function()
	if Mapvote.shouldVote() then Mapvote.startVote( 30 )  end
end