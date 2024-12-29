MapVote.EndTime = 0
MapVote.Panel = false

MapVote.MapIconSize = 64
MapVote.ColumnAmount = 3
MapVote.MaxMapsWithScoreboard = 16

function MapVote:IsActive()
	return IsValid(self.Panel)
end
function MapVote:GetMapCount()
	return #self.CurrentMaps
end

net.Receive("RAM_MapVoteStart", function()
    MapVote.CurrentMaps = {}
    MapVote.Allow = true
    MapVote.Votes = {}
    
    local amt = net.ReadUInt(32)
    
    for i = 1, amt do
        local map = net.ReadString()
        
        MapVote.CurrentMaps[#MapVote.CurrentMaps + 1] = map
    end
    
    MapVote.EndTime = CurTime() + net.ReadUInt(32)
    
    if(IsValid(MapVote.Panel)) then
        MapVote.Panel:Remove()
    end
    
    MapVote.Panel = vgui.Create("VoteScreen")
    MapVote.Panel:SetMaps(MapVote.CurrentMaps)

end)

net.Receive("RAM_MapVoteUpdate", function()
    local update_type = net.ReadUInt(3)
    
    if(update_type == MapVote.UPDATE_VOTE) then
        local ply = net.ReadEntity()
        
        if(IsValid(ply)) then
            local map_id = net.ReadUInt(32)
            MapVote.Votes[ply:SteamID()] = map_id
        
            if(IsValid(MapVote.Panel)) then
                MapVote.Panel:AddVoter(ply)
            end
        end
    elseif(update_type == MapVote.UPDATE_WIN) then      
        if(IsValid(MapVote.Panel)) then
            MapVote.Panel:Flash(net.ReadUInt(32))
        end
    end
end)

net.Receive("RAM_MapVoteCancel", function()
    if IsValid(MapVote.Panel) then
        MapVote.Panel:Remove()
    end
end)

local gradient = Material("vgui/gradient-r")
local PANEL = {}

function PANEL:Init()
    self:ParentToHUD()
    
    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:MakePopup()
    self.Canvas:SetKeyboardInputEnabled(false)
    
    self.countDown = vgui.Create("DLabel", self.Canvas)
    self.countDown:SetTextColor(color_white)
    self.countDown:SetFont("RAM_VoteFontCountdown")
    self.countDown:SetText("")
    self.countDown:SetPos(0, 20)
    
    self.mapList = vgui.Create("DPanelList", self.Canvas)
    self.mapList:SetDrawBackground(false)
    self.mapList:SetSpacing(4)
    self.mapList:SetPadding(4)
    self.mapList:EnableHorizontal(true)
    self.mapList:EnableVerticalScrollbar()

    self.Voters = {}
end

function PANEL:PerformLayout()
    local cx, cy = chat.GetChatBoxPos()
    
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    
    local extra = math.Clamp(600, 0, ScrW() - 640)
    self.Canvas:StretchToParent(0, 0, 0, 0)
    self.Canvas:SetWide(640 + extra)
    self.Canvas:SetTall(cy -60)
    self.Canvas:SetPos(0, 0)
    self.Canvas:CenterHorizontal()
    self.Canvas:SetZPos(0)
    
    self.mapList:StretchToParent(0, 90, 0, 0)   
	local width = self.Canvas:GetWide() / MapVote.ColumnAmount
    for k, v in pairs(self.mapList:GetItems()) do
        v:SetWide(width - 4)
    end
end

local heart_mat = Material("icon16/heart.png")
local star_mat = Material("icon16/star.png")
local shield_mat = Material("icon16/shield.png")

function PANEL:AddVoter(voter)
    for k, v in pairs(self.Voters) do
        if(v.Player and v.Player == voter) then
            return false
        end
    end
    
    local iconSize = 16
    local icon_container = vgui.Create("Panel", self.mapList:GetCanvas())
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(iconSize, iconSize)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, iconSize)

    if MapVote.HasExtraVotePower(voter) then
        icon_container:SetSize(40, 20)
        icon:SetPos(21, 2)
        icon_container.img = star_mat
    else
        icon_container:SetSize(20, 20)
        icon:SetPos(2, 2)
    end
    
    icon_container.Paint = function(s, w, h)
        
        if(icon_container.img) then
            surface.SetMaterial(icon_container.img)
            surface.SetDrawColor(Color(255, 255, 255))
            surface.DrawTexturedRect(2, 2, iconSize, iconSize)
        end
    end
    
    table.insert(self.Voters, icon_container)
end

function PANEL:Think()
    for k, v in pairs(self.mapList:GetItems()) do
        v.NumVotes = 0
    end
    
    for k, v in pairs(self.Voters) do
        if(not IsValid(v.Player)) then
            v:Remove()
        else
            if(not MapVote.Votes[v.Player:SteamID()]) then
                v:Remove()
            else
                local bar = self:GetMapButton(MapVote.Votes[v.Player:SteamID()])
                
                if(MapVote.HasExtraVotePower(v.Player)) then
                    bar.NumVotes = bar.NumVotes + 2
                else
                    bar.NumVotes = bar.NumVotes + 1
                end
                
                if(IsValid(bar)) then
                    local CurrentPos = Vector(v.x, v.y, 0)
                    local NewPos = Vector((bar.x + bar:GetWide()) - 21 * bar.NumVotes - 2, bar.y + (bar:GetTall() * 0.5 - 10), 0)
                    
                    if(not v.CurPos or v.CurPos ~= NewPos) then
                        v:MoveTo(NewPos.x, NewPos.y, 0.3)
                        v.CurPos = NewPos
                    end
                end
            end
        end
        
    end
    
    local timeLeft = math.Round(math.Clamp(MapVote.EndTime - CurTime(), 0, math.huge))
    
	local text = language.GetPhrase( "sdm_mapvote_countdown" )
	
	if timeLeft == 1 then 
		text = language.GetPhrase( "sdm_mapvote_countdown1" )
	elseif timeLeft == 2 or timeLeft == 3 or timeLeft == 4 then
		text = language.GetPhrase( "sdm_mapvote_countdown2" )
	else
		text = language.GetPhrase( "sdm_mapvote_countdown" )
	end
	
    self.countDown:SetText(tostring(timeLeft or 0).. " " .. text)
    self.countDown:SizeToContents()
    self.countDown:CenterHorizontal()
end

function PANEL:SetMaps(maps)
    self.mapList:Clear()
	
	local iconSize = MapVote.MapIconSize
    
    for k, v in RandomPairs(maps) do		
		local mapName = v
		local isCurrentMap = mapName == game.GetMap()
        local button = vgui.Create("DButton", self.mapList)
		if isCurrentMap then
			button.bgColor = Color(245, 200, 0, 100)
		end
        button.ID = k
        button:SetText(mapName)
        
        button.DoClick = function()
            net.Start("RAM_MapVoteUpdate")
                net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                net.WriteUInt(button.ID, 32)
            net.SendToServer()
        end
        
        do
            local Paint = button.Paint
            button.Paint = function(s, w, h)
				local hudr, hudg, hudb = SeriousHUD:GetFrameColor()
                local col = Color(hudr, hudg, hudb, 50)
                
                if(button.bgColor) then
                    col = button.bgColor
                end
                
				
                surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor( col, 255 )
				surface.DrawOutlinedRect( 0, 0, w, h, 1 )
                Paint(s, w, h)
            end
        end
        
        button:SetTextColor(color_white)
        button:SetContentAlignment(4)
        button:SetTextInset(iconSize + 4, 0)
        button:SetFont("RAM_VoteFont")
        
        local extra = math.Clamp(150, 0, ScrW() - 640)
        
        button:SetDrawBackground(false)
        button:SetTall(52)
        button:SetWide(extra / 2)
        button.NumVotes = 0
		
		local mapThumb = "maps/thumb/"..v..".png"
		if !file.Exists(mapThumb, "GAME") then
			mapThumb = "icons/vgui/nomap.png"
		end
		local thumbMaterial = Material(mapThumb)
		local mapIcon = vgui.Create("DImage", button)
		mapIcon:SetSize(iconSize, iconSize)
		mapIcon:CenterVertical()
		mapIcon.Paint = function(self, w, h)
			
			
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(thumbMaterial)
			surface.DrawTexturedRect(0, 0, w, h)

			render.OverrideBlend(false)
		end
        
        self.mapList:AddItem(button)
    end
end

function PANEL:GetMapButton(id)
    for k, v in pairs(self.mapList:GetItems()) do
        if(v.ID == id) then return v end
    end
    
    return false
end

function PANEL:Paint()    
    local CenterY = ScrH() / 2
    local CenterX = ScrW() / 2
    
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, ScrW(), ScrH())
end

function PANEL:Flash(id)
    self:SetVisible(true)

    local bar = self:GetMapButton(id)
	local dsnd = "menus/select.wav"
    
    if IsValid(bar) then
        timer.Simple( 0.0, function() if IsValid(bar) then bar.bgColor = Color( 255, 255, 0 ) surface.PlaySound( dsnd ) end end )
        timer.Simple( 0.2, function() if IsValid(bar) then bar.bgColor = nil end end )
        timer.Simple( 0.4, function() if IsValid(bar) then bar.bgColor = Color( 255, 255, 0 ) surface.PlaySound( dsnd ) end end )
        timer.Simple( 0.6, function() if IsValid(bar) then bar.bgColor = nil end end )
        timer.Simple( 0.8, function() if IsValid(bar) then bar.bgColor = Color( 255, 255, 255 ) surface.PlaySound( dsnd ) end end )
        timer.Simple( 1.0, function() if IsValid(bar) then bar.bgColor = Color( 255, 255, 0 ) end end )
    end
end

derma.DefineControl("VoteScreen", "", PANEL, "DPanel")