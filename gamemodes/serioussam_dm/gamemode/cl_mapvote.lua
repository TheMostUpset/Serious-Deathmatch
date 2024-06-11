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
	PrintTable(maps)
	
	Mapvote.frame = vgui.Create("DFrame") 	
	Mapvote.frame:SetPos(100, 100)              
	Mapvote.frame:SetSize(300, 400+mapcount*31)    
	Mapvote.frame:SetTitle("") 
	Mapvote.frame:SetVisible(true)             
	Mapvote.frame:SetDraggable(false)      
	Mapvote.frame:ShowCloseButton(false)        
	Mapvote.frame:MakePopup() 
	Mapvote.frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 160))
		draw.SimpleText("Map Vote", "Vote_Font", w/2 + 1, 6, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("Map Vote", "Vote_Font", w/2, 5, Color(240, 155, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		surface.SetDrawColor(Color(90, 120, 180))
		surface.DrawOutlinedRect(0, 0, w, h)
	end	
	
	for i = 1,mapcount do
		local button = vgui.Create("DButton",Mapvote.frame)
		button:SetText("")
		button:Center()
		button:SetY(125 + 50*i)
		button:SetX(25)
		
		button.DoClick = function()
			net.Start("mapvote_castvote")
			net.WriteInt(i,16) 
			net.SendToServer()
			surface.PlaySound("menus/press.wav")
			Mapvote.frame:Close()
		end
		button:SetSize(250, 45)
		button.Paint = function(self, w, h)
			draw.SimpleText( maps[i], "Vote_Font2", w/2 +1, 1, color_black, TEXT_ALIGN_CENTER)
			draw.SimpleText( maps[i], "Vote_Font2", w/2, 0, color_white, TEXT_ALIGN_CENTER)
		end
		button.OnCursorEntered = function()
			surface.PlaySound("menus/select.wav")
		end
	end
	Mapvote.frame:Center()
end