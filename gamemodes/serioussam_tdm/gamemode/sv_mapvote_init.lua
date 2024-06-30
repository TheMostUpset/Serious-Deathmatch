
Mapvote = {}
Mapvote.name = "Mapvote Base"
Mapvote.mapFile = "seriousdm_maps.txt"
Mapvote.mapPrefix = {"sdm_"}
Mapvote.players = {}
Mapvote.tally = {}
Mapvote.maps = {}
Mapvote.winningMap = ""

local function getGamemodePrefix()
	local info = file.Read(GAMEMODE.Folder.."/"..GAMEMODE.FolderName..".txt", "GAME")

	if info then
		local info = util.KeyValuesToTable(info)
		Mapvote.mapPrefix = info.maps
	else
		error("MapVote Prefix can not be loaded from gamemode")
	end
end

util.AddNetworkString("mapvote_prompt")
util.AddNetworkString("mapvote_finish")
util.AddNetworkString("mapvote_castvote")

Mapvote.initialize = function()
	SetGlobalInt( "Mapvote_State", MAPVOTE_NOTVOTED )
	Mapvote.players = {}
	net.Receive( "mapvote_castvote", Mapvote.handleVote )
end
hook.Add( "Initialize", "Mapvote_Initialize", Mapvote.initialize )

Mapvote.readMapList = function( fName, filter )
	fName = fName or Mapvote.mapFile
	if !file.Exists( fName, "DATA" ) then return end
	
	local lines = string.Explode( "\n", file.Read( fName , "DATA" ) )
	for k,v in pairs( lines ) do
		if string.len( v ) <= 4 or string.find( v, "#", 0, true ) then table.remove( lines, k ) end
	end
	
	return lines
end

local function getMaps( filter )
	filter = filter or Mapvote.mapPrefix
	
	local maps = {}

	for k, v in pairs( file.Find( "maps/sdm_*.bsp", "GAME" ) ) do
		local noextension = string.StripExtension(v)
		local lowername = string.lower( noextension )
		table.insert( maps, lowername )
		-- for key, prefix in pairs( filter ) do
			-- if string.find( lowername, "^"..prefix ) then table.insert( maps, string.Explode( ".", v )[1] ) end
		-- end

	end
	
	-- adding user maps from data file (if any)
	local extramaps = Mapvote.readMapList()
	if extramaps and !table.IsEmpty(extramaps) then
		for _, map in pairs(extramaps) do
			if !table.HasValue(maps, map) then
				table.insert(maps, map)
			end
		end
	end
	
	return maps
end

Mapvote.buildMapSelection = function()
	local maps = getMaps()
	if table.IsEmpty(maps) then
		print("No maps were found for map vote!")
		return
	end
	Mapvote.maps = maps
end