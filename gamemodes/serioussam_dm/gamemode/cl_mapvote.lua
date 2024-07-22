Mapvote = {}
Mapvote.guiName = "Base GUI"
Mapvote.frame = nil

Mapvote.initialize = function()

	--Include client script assets, which are located under lua/mapvote/
	-- for index, file in pairs( file.Find( "mapvote/cl_*.lua","LUA","nameasc" ) ) do
			-- include( "mapvote/"..file )
	-- end

	net.Receive( "mapvote_prompt", Mapvote.guiFunction )
end

hook.Add( "Initialize", "Mapvote_Initialize", Mapvote.initialize )

Mapvote.guiFunction = function()
	local maps = net.ReadTable()
	local mapcount = table.Count(maps)
	-- PrintTable(maps)
	
	local block_height = 80
	local mapicon_size = 64
	if mapcount > 10 then
		block_height = block_height - mapcount*1.5
		mapicon_size = mapicon_size - mapcount*1.5
	end
	
	Mapvote.frame = vgui.Create("DFrame") 	
	Mapvote.frame:SetPos(100, 100)              
	Mapvote.frame:SetSize(300, 128+mapcount*block_height)
	Mapvote.frame:SetTitle("") 
	Mapvote.frame:SetVisible(true)             
	Mapvote.frame:SetDraggable(false)      
	Mapvote.frame:ShowCloseButton(false)        
	Mapvote.frame:MakePopup() 
	Mapvote.frame:SetKeyboardInputEnabled(false)
	Mapvote.frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 160))
		local x, y = w/2, 15
		draw.SimpleText("#sdm_mapvote", "Vote_Font", x + 1, y + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("#sdm_mapvote", "Vote_Font", x, y, Color(GetMMFColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		surface.SetDrawColor(Color(SeriousHUD:GetFrameColor()))
		surface.DrawOutlinedRect(0, 0, w, h)
	end	
	
	for i = 1, mapcount do
		local x, y = 40, 32 + block_height*i
		
		local map_img = vgui.Create("DImage", Mapvote.frame)
		map_img:SetPos(8, y - mapicon_size/8)
		map_img:SetSize(mapicon_size, mapicon_size)		
		map_img:SetImage("maps/thumb/"..maps[i]..".png")
	
		local button = vgui.Create("DButton", Mapvote.frame)
		button:SetText("")
		button:Center()
		button:SetY(y)
		button:SetX(x)
		
		button.DoClick = function()
			net.Start("mapvote_castvote")
			net.WriteInt(i,16) 
			net.SendToServer()
			surface.PlaySound("menus/press.wav")
			Mapvote.frame:Close()
		end
		button:SetSize(250, 45)
		button.Paint = function(self, w, h)
			draw.SimpleText( maps[i], "Vote_Font2", x + 1, 1, color_black, TEXT_ALIGN_LEFT)
			draw.SimpleText( maps[i], "Vote_Font2", x, 0, color_white, TEXT_ALIGN_LEFT)
		end
		button.OnCursorEntered = function()
			surface.PlaySound("menus/select.wav")
		end
	end
	Mapvote.frame:Center()
end

net.Receive("mapvote_finish", function()
	local name, votes = net.ReadString(), net.ReadUInt(7)
	LocalPlayer():PrintMessage( HUD_PRINTTALK, name .. " " .. "#sdm_mapvote_chosen")
	LocalPlayer():PrintMessage( HUD_PRINTTALK, votes .. " " .. "#sdm_mapvote_votes")
end)