CreateConVar( "sdm_playermodel", "", FCVAR_USERINFO )
CreateConVar( "sdm_playermodel_skin", "", FCVAR_USERINFO )
CreateConVar( "sdm_playermodel_bodygroup", "", FCVAR_USERINFO )
hook.Add("PlayerBindPress", "BlockPlayerList", function(ply, bind, pressed)
    if bind == "+showscores" then
        return true 
    end
end)

if SERVER then
    util.AddNetworkString("PlayerModelMenu")
    
    net.Receive("PlayerModelMenu", function(len, ply)
        local model = net.ReadString()
		local skin = net.ReadString()
		local bodygroup = net.ReadString()
        
        if not table.HasValue(player_manager.AllValidModels(), model) then
            return
        end
        
        ply:SetModel(model)
		ply:SetSkin(skin)
		ply:SetBodygroup(bodygroup, bodygroup)
    end)
else

	surface.CreateFont( "TheDefaultSettings5", {
		font = "Roboto",
		size = 16,
		weight = 800,
		shadow = false,
		antialias = true,
	} )
    local function OpenPlayerModelMenu()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 170)
        frame:SetTitle("")
        frame:SetVisible(true)
        frame:SetDraggable(false)
        frame:ShowCloseButton(false)
        frame:Center()
		frame.Paint = function(self, w, h)
    
			draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 160))
			surface.SetDrawColor(Color(90, 120, 180))
			surface.DrawOutlinedRect(0, 0, w, h)
			draw.SimpleText("Playermodel Menu", "TheDefaultSettings5", 11, 6, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Playermodel Menu", "TheDefaultSettings5", 10, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
		end
		local buttonKleiner = vgui.Create("DImageButton", frame)
		buttonKleiner:SetImage("materials/icons/playermodels/samclassic.png")
		buttonKleiner:SetSize(64, 64)
		buttonKleiner:SetPos(15, 25)
		buttonKleiner.DoClick = function()
			net.Start("PlayerModelMenu")
			net.WriteString("models/pechenko_121/samclassic.mdl")
			net.WriteString("0")
			net.WriteString("0")
			net.WriteString("0")
			net.SendToServer()
			frame:Close()
		end

		local buttonKleiner1 = vgui.Create("DImageButton", frame)
        buttonKleiner1:SetImage("materials/icons/playermodels/samclassic_skin1.png")
        buttonKleiner1:SetSize(64, 64)
		buttonKleiner1:SetPos(85, 25)
        buttonKleiner1.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/samclassic.mdl")
			net.WriteString("1")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end
		
        local buttonBarney = vgui.Create("DImageButton", frame)
        buttonBarney:SetImage("materials/icons/playermodels/redrick.png")
        buttonBarney:SetSize(64, 64)
		buttonBarney:SetPos(155, 25)
        buttonBarney.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/redrick.mdl")
			net.WriteString("0")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end

		
		local buttonBarney2 = vgui.Create("DImageButton", frame)
        buttonBarney2:SetImage("materials/icons/playermodels/redrick_skin1.png")
        buttonBarney2:SetSize(64, 64)
		buttonBarney2:SetPos(225, 25)
        buttonBarney2.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/redrick.mdl")
			net.WriteString("1")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end

		
		local buttonBarney3 = vgui.Create("DImageButton", frame)
        buttonBarney3:SetImage("materials/icons/playermodels/redrick_skin2.png")
        buttonBarney3:SetSize(64, 64)
		buttonBarney3:SetPos(15, 100)
        buttonBarney3.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/redrick.mdl")
			net.WriteString("2")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end

		
		local buttonBarney4 = vgui.Create("DImageButton", frame)
        buttonBarney4:SetImage("materials/icons/playermodels/redrick_skin3.png")
        buttonBarney4:SetSize(64, 64)
		buttonBarney4:SetPos(85, 100)
        buttonBarney4.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/redrick.mdl")
			net.WriteString("3")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end

		

        
        
        local buttonAlyx = vgui.Create("DImageButton", frame)
        buttonAlyx:SetImage("materials/icons/playermodels/beheadedben.png")
        buttonAlyx:SetSize(64, 64)
		buttonAlyx:SetPos(155, 100)
        buttonAlyx.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/beheadedben.mdl")
			net.WriteString("1")
			net.WriteString("1")
            net.SendToServer()
            frame:Close()
        end

        
        frame:MakePopup()
		
		local buttonSteve = vgui.Create("DImageButton", frame)
        buttonSteve:SetImage("materials/icons/playermodels/steelsteve.png")
        buttonSteve:SetSize(64, 64)
		buttonSteve:SetPos(225, 100)
        buttonSteve.DoClick = function()
            net.Start("PlayerModelMenu")
            net.WriteString("models/pechenko_121/steelsteve.mdl")
			net.WriteString("1")
			net.WriteString("1")			
            net.SendToServer()
            frame:Close()
        end
		
		frame:MakePopup()
		
		local buttonSteve2 = vgui.Create("DImageButton", frame)
        buttonSteve2:SetImage("materials/icons/playermodels/cross.png")
        buttonSteve2:SetSize(16, 16)
		buttonSteve2:SetPos(270, 5)
        buttonSteve2.DoClick = function()
            frame:Close()
        end
        
        frame:MakePopup()
    end
    
    hook.Add("PlayerBindPress", "OpenPlayerModelMenu", function(ply, bind, pressed)
        if bind == "gm_showspare2" and pressed then
            OpenPlayerModelMenu()
            return true
        end
    end)
end