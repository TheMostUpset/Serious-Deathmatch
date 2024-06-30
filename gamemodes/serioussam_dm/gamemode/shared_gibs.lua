if SERVER then
	util.AddNetworkString("SDMGibs_GibPlayer")

	local cvar_plygib = 1
	local cvar_plygibthreshold = 0
	local cvar_plygibbullet = 1

	local function GibEntity(ent, amount, force)
		amount = amount or 16
		force = force or Vector()
		net.Start("SDMGibs_GibPlayer")
		net.WriteVector(ent:GetPos())
		net.WriteVector(force)
		net.WriteUInt(amount, 8)
		net.WriteEntity(ent)
		net.WriteFloat(math.floor(ent:GetInfoNum("cl_sdm_playergib_snd",1)))
		net.WriteFloat(math.floor(ent:GetInfoNum("cl_sdm_playergib_type",1)))
		net.Broadcast()
	end

	hook.Add("DoPlayerDeath","SDMGibs_DoPlayerDeath",function(ply, attacker, dmginfo)
		if attacker:IsPlayer() then
			if cvar_plygib and (ply:Health() <= -(math.abs(cvar_plygibthreshold)) or dmginfo:IsDamageType(DMG_ALWAYSGIB)) and (!dmginfo:IsBulletDamage() or cvar_plygibbullet) and dmginfo:GetDamage() >= 70 then
			local weapon = attacker:GetActiveWeapon():GetClass()
			if weapon == "weapon_ss_knife" then return end
				GibEntity(ply, 4, dmginfo:GetDamageForce() / 128)
				timer.Simple(0, function()
					if ply:GetRagdollEntity():IsValid() then
						ply:GetRagdollEntity():Remove()
					end
				end)
			else
				return
			end
		else
			GibEntity(ply, 4, dmginfo:GetDamageForce() / 128)
			timer.Simple(0, function()
				if ply:GetRagdollEntity():IsValid() then
					ply:GetRagdollEntity():Remove()
				end
			end)
		end
	end)
end

if CLIENT then
	local cvar_clplygib = CreateClientConVar("sdm_playergib", 1, true, false)

	
	local function CL_GibEntity(pos, amount, force, gibtype, ent, snd)
		gibtype = gibtype or 0
		local effectdata = EffectData()
		effectdata:SetFlags(1)
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(force)
		effectdata:SetScale(amount)
		effectdata:SetMaterialIndex(gibtype)
		if ent and IsValid(ent) then
			effectdata:SetEntity(ent)
			ent.GibTable = {}
		else
			effectdata:SetEntity(NULL)
		end
		util.Effect("ss_gibs_emitter", effectdata, true)
	end

	net.Receive("SDMGibs_GibPlayer", function()
		if cvar_clplygib:GetBool() then
			local pos, force, amount, ent, snd, typ = net.ReadVector(), net.ReadVector(), net.ReadUInt(8), net.ReadEntity(), math.floor(net.ReadFloat()), math.floor(net.ReadFloat())
			if cvar_gibforcetype == 1 or cvar_gibforcetype == 2 then
				CL_GibEntity(pos, amount, force, (cvar_gibforcetype:GetInt()-1), ent, snd)
			elseif cvar_gibforcetype != -1 then
				if typ == 1 or typ == 2 then
					CL_GibEntity(pos, amount, force, (typ-1), ent, snd)
				end
			end
			
		end
	end)
end