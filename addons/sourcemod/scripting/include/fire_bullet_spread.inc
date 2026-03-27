#if defined _fire_bullet_spread_included
 #endinput
#endif
#define _fire_bullet_spread_included

forward bool CS_FireBulletSpread(int client, const char[] weapon);

public SharedPlugin __pl_fire_bullet_spread = 
{
	name = "fire_bullet_spread",
	file = "fire_bullet_spread.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};
