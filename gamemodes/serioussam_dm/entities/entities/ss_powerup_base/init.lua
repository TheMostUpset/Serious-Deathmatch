AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("SSPowerupsClient")
CreateConVar( "sdm_powerup", "nothing", FCVAR_CHEAT, "Toggle death zones" )
-- CreateConVar( "sdm_powerupamount", "0", FCVAR_CHEAT, "Toggle death zones" )
 
ENT.PDuration = 30
local ss_cvar_powerupduration = CreateConVar("ss_powerupduration", 20)

function ENT:Initialize()

	self:SetModel(self.model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, 24)
	self.PDuration = ss_cvar_powerupduration:GetInt()
	self:SetModelScale( self:GetModelScale() * 1.2, 1 )
	



    self.StartPos = self:GetPos()

end
function ENT:SendPickupMsg(ply, msg)
	msg = msg or self.PrintName
	amount = amount or 0
	net.Start("SSPickupText")
	net.WriteString(msg)
	net.Send(ply)
end





function ENT:Pickup(ply)

end

local function netBroadcast(ply, t)
	net.Start("SSPowerupsClient")
	net.WriteEntity(ply)
	net.WriteTable(t)
	net.Broadcast()
	
end

function ENT:SendToClient(ply, t)
	netBroadcast(ply, t)
end



hook.Add("PlayerDeath", "QuakePlayerDeath", function(ply)
	if ply.SSPowerups then
		table.Empty(ply.SSPowerups)
	
		netBroadcast(ply, ply.SSPowerups)
		
		ply.SSPowerups = nil
	end
end)