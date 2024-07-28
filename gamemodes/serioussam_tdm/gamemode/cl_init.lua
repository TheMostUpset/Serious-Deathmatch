include( "shared.lua" )

function GM:SDMShowTeam()

	if ( IsValid( self.TeamSelectFrame ) ) then return end
	
	-- Simple team selection box
	showGameUI = true
	local text = ""
	EscMenu = vgui.Create("DFrame")
	EscMenu:SetSize(ScrW(), ScrH())
	EscMenu:Center()
	EscMenu:SetTitle("")
	EscMenu:ShowCloseButton( false )
	EscMenu:SetDraggable(false)
	EscMenu:SetMouseInputEnabled(false)
	EscMenu:MakePopup()


	EscMenu.Paint = function(self, w, h)
		PaintBackground(self, w, h)
		draw.SimpleText("CHANGE TEAM", "MainMenu_Font", ScrW()/2, ScrH() - ScrH() + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MainMenu_font_very_small", ScrW()/2, ScrH()-ScrH()/14, Color(GetAccentColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
	local AllTeams = team.GetAllTeams()
	local y = 30
	
		if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED ) then
	
			local RED_Button = vgui.Create("DButton", EscMenu)
			local isFlashing = false
			RED_Button:SetText("JOIN RED")
			RED_Button:SetSize(ScrW()/12, ScrH()/20)
			RED_Button:SetFont("MainMenu_Font")
			RED_Button:SetTextColor(GetButtonColor())

			RED_Button.OnCursorEntered = function()
				isFlashing = true
				text = "join red team"
				surface.PlaySound("menus/select.wav")
			end

			RED_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				RED_Button:SetTextColor(GetButtonColor())
			end

			RED_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end
			end

			RED_Button.DoClick = function()
				RunConsoleCommand("changeteam", 1)
				EscMenu:Close()
				showGameUI = false
				surface.PlaySound("menus/press.wav")
			end
			
			RED_Button:SizeToContents()
			RED_Button:Center()
			RED_Button:SetY(ScrH()/2.58)
			
			local BLUE_Button = vgui.Create("DButton", EscMenu)
			local isFlashing = false
			BLUE_Button:SetText("JOIN BLUE")
			BLUE_Button:SetSize(ScrW()/12, ScrH()/20)
			BLUE_Button:SetFont("MainMenu_Font")
			BLUE_Button:SetTextColor(GetButtonColor())

			BLUE_Button.OnCursorEntered = function()
				isFlashing = true
				text = "join blue team"
				surface.PlaySound("menus/select.wav")
			end

			BLUE_Button.OnCursorExited = function()
				isFlashing = false
				text = ""
				BLUE_Button:SetTextColor(GetButtonColor())
			end

			BLUE_Button.Paint = function(self, w, h) 
				if isFlashing then
					ButtonFlashing(self)
				end
			end

			BLUE_Button.DoClick = function()
				RunConsoleCommand("changeteam", 2)
				EscMenu:Close()
				showGameUI = false
				surface.PlaySound("menus/press.wav")
			end
			
			BLUE_Button:SizeToContents()
			BLUE_Button:Center()
			BLUE_Button:SetY(ScrH()/2.25)
			
			if ( IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
				Team:SetEnabled( false )
			end
		
		end
		

end

concommand.Add( "sdm_changeteam", function( ply, cmd, args )
	GAMEMODE:SDMShowTeam()
end )