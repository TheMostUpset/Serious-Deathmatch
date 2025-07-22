local meta = FindMetaTable("Player")

function meta:HasSeriousDamage()
	local powerupTable = self.SSPowerups
	return powerupTable and powerupTable.SeriousDamage and powerupTable.SeriousDamage > CurTime()
end
function meta:HasInvisibility()
	local powerupTable = self.SSPowerups
	return powerupTable and powerupTable.Invisibility and powerupTable.Invisibility > CurTime()
end
function meta:HasProtect()
	local powerupTable = self.SSPowerups
	return powerupTable and powerupTable.Protect and powerupTable.Protect > CurTime()
end
function meta:HasSeriousSpeed()
	local powerupTable = self.SSPowerups
	return powerupTable and powerupTable.Speed and powerupTable.Speed > CurTime()
end

if SERVER then

	local entNameLocalization = {
		["16mm Rounds"] = "#sdm_16mm",
		["Bullets"] = "#sdm_bullets",
		["Cannonballs"] = "#sdm_cannonballs",
		["Electricity"] = "#sdm_electricity",
		["Grenades"] = "#sdm_grenades",
		["Napalm"] = "#sdm_napalm",
		["Rockets"] = "#sdm_rockets",
		["Shells"] = "#sdm_shells",

		["Armor"] = "#sdm_armor",
		["Health"] = "#sdm_health",

		["Cannon"] = "#sdm_cannon",
		["Chainsaw"] = "#sdm_chainsaw",
		["Colt"] = "#sdm_colt",
		["Double Shotgun"] = "#sdm_doubleshotgun",
		["Flamer"] = "#sdm_flamer",
		["Ghostbuster"] = "#sdm_ghostbuster",
		["Grenade Launcher"] = "#sdm_grenadel",
		["Lasergun"] = "#sdm_laser",
		["Minigun"] = "#sdm_minigun",
		["Rocket Launcher"] = "#sdm_rocketl",
		["Shotgun"] = "#sdm_pump",
		["Sniper Rifle"] = "#sdm_sniper",
		["Thompson"] = "#sdm_tommygun",

		["Serious Damage"] = "#sdm_seriousdmg",
		["Serious Speed"] = "#sdm_seriousspeed",
		["Invulnerability"] = "#sdm_protect",
		["Invisibility"] = "#sdm_inv",
	}
	function meta:OnSeriousItemPickedUp(ent, msg, amount)
		msg = msg or ent.PrintName
		if !msg then return end
		if entNameLocalization[msg] then
			msg = entNameLocalization[msg]
		end
		amount = amount or 0
		net.Start("SSPickupText")
		net.WriteString(msg)
		net.WriteUInt(amount, 8)
		net.Send(self)
	end

	function meta:ChatMessage(tbl)
		if !istable(tbl) then tbl = {tbl} end
		net.Start("ClientChatMessage")
		net.WriteTable(tbl)
		net.Send(self)
	end

	-- Original code from TTT
	-- https://github.com/Facepunch/garrysmod/blob/3f6517458a1b74d469ba3f53f42ff37076a0037e/garrysmod/gamemodes/terrortown/gamemode/player_ext.lua
	-- https://github.com/Facepunch/garrysmod/blob/3f6517458a1b74d469ba3f53f42ff37076a0037e/garrysmod/gamemodes/terrortown/gamemode/player_ext_shd.lua
	-- This is a fix for spectator mode
	-- And Spectator check
	local plymeta = FindMetaTable( "Player" )
	if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

	local oldSpectate = plymeta.Spectate
	function plymeta:Spectate(type)
		oldSpectate(self, type)

	-- NPCs should never see spectators. A workaround for the fact that gmod NPCs
	-- do not ignore them by default.
		self:SetNoTarget(true)

		if type == OBS_MODE_ROAMING then
			self:SetMoveType(MOVETYPE_NOCLIP)
		end
	end

	local oldUnSpectate = plymeta.UnSpectate
	function plymeta:UnSpectate()
		oldUnSpectate(self)
		self:SetNoTarget(false)
	end
end
