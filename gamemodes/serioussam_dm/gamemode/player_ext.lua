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
	}
	function meta:OnSeriousItemPickedUp(ent, msg, amount)
		msg = msg or entNameLocalization[ent.PrintName]
		amount = amount or 0
		net.Start("SSPickupText")
		net.WriteString(msg)
		net.WriteUInt(amount, 8)
		net.Send(self)
	end
	
end