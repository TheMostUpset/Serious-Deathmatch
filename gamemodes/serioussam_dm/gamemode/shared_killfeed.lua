if CLIENT then
  
    surface.CreateFont("killfeed_font",{
        font = "Roboto",
        size = ScrH() / 46,
        weight = 1000,
        antialiasing = true,
        additive = false,
		shadow = true
    });
end
--[[
  KILLFEED
]]
local NET_STRING = "killfeed_log";

if CLIENT then

  HUDKillfeed = {}
  killfeed = {};

  local TIME = 10;

  function HUDKillfeed:Drawkillfeed(i, x, y)
    if (killfeed[i] == nil) then return; end;
    if (killfeed[i].time < CurTime()) then table.remove(killfeed, i); return; end;
    local feed = killfeed[i];
    surface.SetFont("killfeed_font");
    HeadShotD = "D"
    HeadShotC = "C"
    HeadShotDW, HeadShotDH = surface.GetTextSize(HeadShotD)
    HeadShotCW, HeadShotCH = surface.GetTextSize(HeadShotC)
    local size = surface.GetTextSize(feed.victim);
    local killerSize = surface.GetTextSize(feed.attacker)
    local iconWidth, iconHeight = (killicon.GetSize(feed.weapon)/ 20);
    --print(iconWidth)

    backgroundWidth = nil
    if (feed.headshot) then
      backgroundWidth = size + killerSize + iconWidth + HeadShotDW + 120
    else
      backgroundWidth = size + killerSize + iconWidth + HeadShotCW + 60
    end
   

 
    local icon = (killicon.GetSize(feed.weapon));
    -- Draw the victim's name
	draw.SimpleText(feed.attacker, "killfeed_font", ScrW() - ScrW() / 1.05 - icon + 10, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);
    draw.SimpleText(feed.victim, "killfeed_font", ScrW() - ScrW() / 1.113 + killerSize, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);

    -- Draw the headshot icon
    local offset = 0;


    -- Draw the killicon

    local kOffset = (size + icon + offset + killerSize); -- Killicon offset
    if (killicon.Exists(feed.weapon)) then
      killicon.Draw(ScrW() - ScrW() /1.065 + killerSize / 1, y, feed.weapon, 255);
    end

  
  end

  function HUDKillfeed:Getkillfeed()
    return killfeed;
  end

  -- Override default killfeed
  hook.Add("DrawDeathNotice", "killfeed_log", function(x, y)
    return false;
  end);

  net.Receive(NET_STRING, function(len)
    table.insert(killfeed, {victim = language.GetPhrase(net.ReadString()),
                            vCol = net.ReadColor(),
                            headshot = net.ReadBool(),
                            attacker = language.GetPhrase(net.ReadString()),
                            aCol = net.ReadColor(),
                            weapon = net.ReadString() or nil,
                            time = CurTime() + TIME});
  end);

  local H = ScrH() * 0.107;


  function HUDKillfeed:killfeedPanel()
    for k,v in pairs(HUDKillfeed:Getkillfeed()) do
      HUDKillfeed:Drawkillfeed(k, ScrW() - 40, H + 32 + ((k - 1) * 36));
    end
  end
 
  hook.Add("HUDPaint", "killfeedPanel", function()
    HUDKillfeed:killfeedPanel()
  end)
 
end

if SERVER then

  util.AddNetworkString(NET_STRING);

  --[[
    Sends a death notice to everyone
    @param {}
  ]]
  local function SendDeathNotice(victim, inflictor, attacker)
    net.Start(NET_STRING)

    -- Victim data
    if (victim:IsPlayer()) then
      net.WriteString(victim:Name())
      net.WriteColor(team.GetColor(victim:Team()))
    elseif (victim:IsNPC() or victim:IsNextBot() and !victim.IsLambdaPlayer) then
      net.WriteString(victim:GetClass())
      net.WriteColor(Color(255, 0, 0))
    elseif (victim.IsLambdaPlayer) then
      net.WriteString(victim:GetLambdaName())
      net.WriteColor(team.GetColor(victim:Team()))
    end
    
    net.WriteBool(victim.killfeed_headshot or false)

    -- Inflictor class
    local inflClass = ""
    if (IsValid(inflictor)) then inflClass = inflictor:GetClass(); end

    -- Attacker data
    if (IsValid(attacker) and attacker:GetClass() != nil and attacker != victim) then
      if (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) then
        -- Name
        if (attacker:IsPlayer()) then
          net.WriteString(attacker:Name())
          net.WriteColor(team.GetColor(attacker:Team()))
        elseif (attacker:IsNPC() or attacker:IsNextBot() and !attacker.IsLambdaPlayer) then
          net.WriteString(attacker:GetClass())
          net.WriteColor(Color(255, 0, 0))
        elseif (attacker.IsLambdaPlayer) then
          net.WriteString(attacker:GetLambdaName())
          net.WriteColor(team.GetColor(attacker:Team()))
        end

        -- Weapon
        if (attacker.IsLambdaPlayer) then
          if (attacker:GetWeaponENT().l_killiconname == nil) then
            net.WriteString(inflClass);
          else
            net.WriteString(attacker:GetWeaponENT().l_killiconname)
          end 
        elseif (inflictor == attacker and IsValid(attacker:GetActiveWeapon())) then
          net.WriteString(attacker:GetActiveWeapon():GetClass())
        else
          net.WriteString(inflClass);
        end
      else
        net.WriteString(inflClass);
        net.WriteColor(Color(255, 0, 0));
      end
    else
      net.WriteString("");
      net.WriteColor(Color(255, 0, 0));
      net.WriteString("");
    end

    -- Send to everyone
    net.Broadcast();
  end

  -- Detect headshots
  hook.Add("ScalePlayerDamage", "killfeed_headshot", function(player, hitgroup, dmginfo)
    player.killfeed_headshot = hitgroup == HITGROUP_HEAD;
  end);

  hook.Add("ScaleNPCDamage", "killfeed_headshot_npc", function(npc, hitgroup, dmginfo)
    npc.killfeed_headshot = hitgroup == HITGROUP_HEAD;
  end);

  -- Send death notice
  hook.Add("PlayerDeath", "killfeed_death", function(player, infl, attacker)
    SendDeathNotice(player, infl, attacker);
  end);

  hook.Add("OnNPCKilled", "killfeed_death_npc", function(npc, attacker, infl)
    SendDeathNotice(npc, infl, attacker);
  end);

  -- Reset buffer data
  hook.Add("PlayerSpawn", "killfeed_spawn", function(player)
    player.killfeed_headshot = nil;
  end);
end

