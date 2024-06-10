if SERVER then
Mapvote = {}
Mapvote.name = "Mapvote Base"
Mapvote.mapPrefix = {""}
Mapvote.mapFile = "seriousdm_maps.txt"

Mapvote.players = {}
Mapvote.tally = {}
Mapvote.maps = {}
Mapvote.winningMap = ""




local mapvote_shuffle = 1

util.AddNetworkString("mapvote_prompt")
util.AddNetworkString("mapvote_finish")
util.AddNetworkString("mapvote_castvote")

Mapvote.initialize = function()
	SetGlobalInt( "Mapvote_State", MAPVOTE_NOTVOTED )
	Mapvote.players = {}
	net.Receive( "mapvote_castvote", Mapvote.handleVote )
end
hook.Add( "Initialize", "Mapvote_Initialize", Mapvote.initialize )

Mapvote.readMapList = function( fName )
	if fName == nil then fName = Mapvote.mapFile end
	if filter == nil then filter = Mapvote.mapPrefix end
	if not file.Exists( fName, "DATA" ) then Mapvote.buildMapList( fName, filter  ) end
	
	local lines = string.Explode( "\n", file.Read( fName , "DATA" ) )
	for k,v in pairs( lines ) do
		if string.len( v ) <= 4 or string.find( v, "#", 0, true ) then table.remove( lines, k ) end
	end
	
	return lines
end

Mapvote.writeMapList = function( maps, fName )
	if fName == nil then fName = Mapvote.mapFile end
	if fName =="" then return end
	file.Write( fName, "" )
	local count = table.Count( maps )
	
	for i=1, count-1 do 
		file.Append( fName, maps[i].."\n" )
	end
	file.Append( fName, maps[count] )
end

function getMaps( filter )
	if filter == nil then filter = Mapvote.mapPrefix end
	
	local maps = {}

	for k, v in pairs( file.Find( "maps/sdm_*.bsp", "GAME" ) ) do
		local lowername = string.lower( v )
		for key, prefix in pairs( filter ) do
			if string.find( lowername, "^"..prefix ) then table.insert( maps, string.Explode( ".", v )[1] ) end
		end

	end
	return maps
end

Mapvote.buildMapList = function( fName, filter )
	if fName == nil then fName = Mapvote.mapFile end
	if filter == nil then filter = Mapvote.mapPrefix end
	
	local maps = getMaps( filter )
	Mapvote.writeMapList( maps, fName )
end

Mapvote.buildMapSelection = function( filter, fName )
	local maps = {}
	if filter != nil then 
		maps = getMaps( filter )
	else
		if fName != nil then 
			maps = Mapvote.readMapList( fName )
		else
			maps = Mapvote.readMapList()
			if maps == {} then 
				Mapvote.buildMapList()
				Mapvote.readMapList()
			end
		end
	end
	Mapvote.maps = {}
	
	
	local mCount = table.Count(maps)
		
	local oCount = 2
	local rCount = 3
	if oCount > mCount or oCount < 0 then
		oCount = mCount
	end
	for i=1,oCount do
		if maps[i] == nil then break end
		table.insert(Mapvote.maps,maps[i])
	end
		
	if rCount > mCount - oCount or rCount < 0 then
		rCount = mCount - oCount
		rCount = 0
		Mapvote.maps = maps
	end
	for i=1,rCount do
		local id = table.Random( maps )
		while ( table.HasValue( Mapvote.maps, id ) ) do
			id = table.Random( maps )
		end
		table.insert( Mapvote.maps, id )
	end
	local mCount = table.Count( Mapvote.maps )

	if mapvote_shuffle == 1 then
		for i=1,mCount do
			local current = table.remove(Mapvote.maps,math.random(mCount))
			table.insert(Mapvote.maps,current)
		end
	end
end
end