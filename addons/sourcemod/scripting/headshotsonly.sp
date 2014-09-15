#include <sourcemod>
#include <sdktools>

#define HITGROUP_HEAD 1

public Plugin:myinfo =
{
  name = "Headshots Only",
  author = "Brian Cosgrove",
  description = "Only headshots count. Except that grenades and knives count too.",
  version = "0.1",
  url = "https://github.com/cosgroveb/sm_headshotsonly/"
};

public OnPluginStart()
{
  HookEvent("player_hurt", Event_RewritePlayerHurtEvent, EventHookMode_Pre)
}

public Action:Event_RewritePlayerHurtEvent(Handle:event, const String:name[], bool:dontBroadcast)
{
  new Integer:hitgroup = GetEventInt(event, "hitgroup")

  if ((hitgroup != HITGROUP_HEAD) && !DamageFromApprovedNonHeadshotWeapon(event) && DamageFromAPlayer(event))
  {
    new client = GetClientOfUserId(GetEventInt(event, "userid"))
    SetEntProp(client, Prop_Data, "m_iHealth", GetClientHealth(client) + GetEventInt(event, "dmg_health"))
    return Plugin_Continue
  }
}

DamageFromAPlayer(event)
{
  new Integer:attackerId = GetEventInt(event, "attacker")

  if (attackerId > 0)
  {
    return true
  }
  else
  {
    return false
  }
}

DamageFromApprovedNonHeadshotWeapon(Handle:event)
{
  new String:weaponName[MAX_NAME_LENGTH]
  GetEventString(event, "weapon", weaponName, sizeof(weaponName))
  new approvedWeapons[5][MAX_NAME_LENGTH] = { "knife", "taser", "molotov", "incgrenade", "hegrenade" }

  for (new i = 0; i < sizeof(approvedWeapons); i++)
  {
    if (StrEqual(weaponName, approvedWeapons[i]))
    {
      return true
    }
  }
  return false
}
