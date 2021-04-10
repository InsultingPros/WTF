class WTFEquipUM32AltFire extends M32Fire;

event ModeDoFire()
{
	if (WTFEquipUM32GL(Weapon).IsDemolitions)
		Super.ModeDoFire();
}

defaultproperties
{
	ProjectileClass=Class'WTF.WTFEquipUM32ProximityMine'
}