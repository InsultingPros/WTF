//used in M79CF and UM32 for SupportSpec
class WTFEquipSuperBuckshot extends AA12Bullet;

defaultproperties
{
	/*
		each one needs hefty damage to align with this idea that we're basically firing small cannonballs
		down-range, but it does mean we can't fire very many at a time lest we become too much more powerful
		than the demo-version of the M79/M32 grenade projectiles, which deal 350 base. I'm willing to let
		each shot on these do a bit more damage just to match the asthetic, coupled with the fact that
		explosives deal straight up double damage against Fleshpounds.
	*/
	Damage=135.0
	DrawScale=10.0
}