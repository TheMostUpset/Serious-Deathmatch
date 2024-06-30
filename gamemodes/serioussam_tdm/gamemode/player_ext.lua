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