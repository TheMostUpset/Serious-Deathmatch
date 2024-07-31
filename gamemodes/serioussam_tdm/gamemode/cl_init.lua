include( "shared.lua" )
include( "cl_hud.lua" )
include("cl_menus.lua")



concommand.Add( "sdm_changeteam", function( ply, cmd, args )
	OpenSSMenu()
	OpenTeamMenu()
end )

--[[
function draw.CustomCursor(panel, material)
	-- Paint the custom cursor
	local cursorX, cursorY = panel:LocalCursorPos()

	surface.SetDrawColor(255, 255, 255, 240)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(cursorX, cursorY, 32, 32)
end

local myPanel = vgui.Create("DFrame")
	myPanel = vgui.Create("DFrame")
	myPanel:SetSize(ScrW(), ScrH())
	myPanel:Center()
	myPanel:SetTitle("")
	myPanel:ShowCloseButton( false )
	myPanel:SetDraggable(false)
	myPanel:SetMouseInputEnabled(false)
	myPanel:MakePopup()
	myPanel:SetCursor("blank")

local customCursorMaterial = Material("vgui/serioussam/hud/pointer")
myPanel.Paint = function(s, w, h)
	draw.CustomCursor(s, customCursorMaterial)
end
--]]