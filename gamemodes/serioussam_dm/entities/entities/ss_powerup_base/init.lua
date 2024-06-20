AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("SSPowerupsClient")

 
ENT.PDuration = 30
ENT.RespawnTime = 10
local ss_cvar_powerupduration = CreateConVar("ss_powerupduration", 20)

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent = ents.Create(self.ClassName)
	local SpawnPos = tr.HitPos + tr.HitNormal * ent.SpawnHeight
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel(self.model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self.Available = true
	self:DrawShadow(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, 24)
	self.PDuration = ss_cvar_powerupduration:GetInt()
	self:SetModelScale( self:GetModelScale() * 1.2, 1 )
    self.StartPos = self:GetPos()
end

function ENT:Think()
	if self.ReEnabled and CurTime() >= self.ReEnabled then
		self.ReEnabled = nil
		self.Available = true
		self:SetNoDraw(false)
	end
end

function ENT:Touch(ent)	
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then
		if game.SinglePlayer() then
			if !ent.SSPowerups then
				ent.SSPowerups = {}
			end
			self:Remove()
		else
			if !ent.SSPowerups then
				ent.SSPowerups = {}
			end
			self.Available = false
			self:SetNoDraw(true)
			self.ReEnabled = CurTime() + self.RespawnTime
		end
		self:Pickup(ent)
		
	self:SendPickupMsg(ent, "Serious Damage")
	end
end

function ENT:SendPickupMsg(ply, msg)
	msg = msg or self.PrintName
	amount = amount or 0
	net.Start("SSPickupText")
	net.WriteString(msg)
	net.Send(ply)
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