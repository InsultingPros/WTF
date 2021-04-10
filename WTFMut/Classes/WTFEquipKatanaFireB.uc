class WTFEquipKatanaFireB extends KatanaFireB;

function float GetFireSpeed()
{
	local float FS;
	
	FS = Super.GetFireSpeed();
	
	if (WTFEquipKatana(Weapon).ZEDTimeActive)
		return FS * 3;

	return FS;
}

defaultproperties
{
	weaponRange=110.0 //70.0
}