#include <sourcemod>
#include <sdktools>

#define HITGROUP_HEAD 1

public Plugin:myinfo =
{
  name = "Headshots Only",
  author = "Brian Cosgrove",
  description = "Only headshots count.",
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

  if (hitgroup != HITGROUP_HEAD)
  {
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    SetEntProp(client, Prop_Data, "m_iHealth", GetClientHealth(client) + GetEventInt(event, "dmg_health"));
    return Plugin_Continue;
  }
}
