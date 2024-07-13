if CLIENT then

	SWEP.PrintName			= "Railgun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 3
	SWEP.ViewModelFOV		= 54
	SWEP.WepIcon			= "icons/serioussam/ghostbuster"
	killicon.Add("weapon_ss_railgun", SWEP.WepIcon, Color(255, 255, 255, 255))
	SWEP.FakeFireAnim		= {[3] = true}
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	local delay = self.Primary.Delay
	if self.Owner:HasSeriousSpeed() then
		delay = delay / 1.5
	end
	self:SetNextPrimaryFire(CurTime() + delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	-- self:TakeAmmo()
	self:WeaponSound()
	
	if SERVER then self.Owner:LagCompensation(true) end
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
		filter = self.Owner
	})
	
	if IsFirstTimePredicted() then
		local ef_ray = EffectData()
		ef_ray:SetOrigin(self.Owner:GetShootPos())
		ef_ray:SetStart(tr.HitPos)
		ef_ray:SetEntity(self)
		ef_ray:SetAttachment(1)
		util.Effect("ss_lightning_rail", ef_ray)
	
		local ef_hit = EffectData()
		ef_hit:SetOrigin(tr.HitPos)
		util.Effect("ss_lightning_hit", ef_hit)
	end
	
	if tr.HitWorld then
		local hit1, hit2 = tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal
		util.Decal("FadingScorch", hit1, hit2)
	end

	if !IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
			filter = self.Owner,
			-- mins = Vector(-4, -4, -4),
			-- maxs = Vector(4, 4, 4)
		})
	end
	
	if tr.Hit then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if !IsValid(attacker) then attacker = self end
		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_ENERGYBEAM)
		dmginfo:SetDamage(self.Primary.Damage)
		dmginfo:SetDamageForce(self.Owner:GetUp() *2000 +self.Owner:GetForward() *20000)
		dmginfo:SetDamagePosition(tr.HitPos)
		tr.Entity:DispatchTraceAttack(dmginfo, tr)
	end
	if SERVER then
		self.Owner:LagCompensation(false)
	end

	self:HolsterDelay()
end

local mat = Material("sprites/serioussam/lightning")
local flare = Material("sprites/serioussam/effectflare")

function SWEP:ViewModelDrawn(vm)
	local bone = vm:LookupBone("rotator")	
	if !bone then return end
	
	local pos, ang = vm:GetBonePosition(bone)
	pos = pos + vm:GetForward() * 5
	local right, up = ang:Forward(), ang:Up()
	local width = 8
	local size = 2
	local move = CurTime() * 10
	
	local firetime = CurTime() - self:GetNextPrimaryFire()
	local colchange = math.Clamp(firetime*3 + 1.2, 0, 1)
	-- print(colchange)
	local col = Color(255, 255, 255, 255 * colchange)
	
	render.SetMaterial(mat)
	render.DrawBeam(pos + up * size, pos - right * size, width, move, move-1, col)
	render.DrawBeam(pos + up * size, pos + right * size, width, move, move+1, col)
	render.DrawBeam(pos + right * size, pos - up * size, width, move, move+1, col)
	render.DrawBeam(pos - up * size, pos - right * size, width, move, move+1, col)
	
	render.SetMaterial(flare)
	render.DrawBeam(pos + up * size, pos - right * size, width, 0, 1, col)
	render.DrawBeam(pos + up * size, pos + right * size, width, 0, 1, col)
	render.DrawBeam(pos + right * size, pos - up * size, width, 0, 1, col)
	render.DrawBeam(pos - up * size, pos - right * size, width, 0, 1, col)	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_ss_base"
SWEP.Category			= "Serious Sam"
SWEP.Spawnable			= true

-- SWEP.EntityPickup		= "ss_pickup_ghostbuster"
-- SWEP.EntityAmmo			= "ss_ammo_electricity"

SWEP.ViewModel			= "models/weapons/serioussam/v_ghostbuster.mdl"
SWEP.WorldModel			= "models/weapons/serioussam/w_ghostbuster.mdl"

SWEP.Primary.Sound			= Sound("weapons/serioussam/railgun/fire.wav")
SWEP.Primary.Damage			= 100
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Ammo			= "ar2"

SWEP.HitDist				= 4096