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
end
