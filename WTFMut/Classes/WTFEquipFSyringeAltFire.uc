class WTFEquipFSyringeAltFire extends SyringeAltFire;

function bool AllowFire()
{
	return true;
}

function DoFireEffect()
{
	//local KFWeapon FURY;
	
	Super.DoFireEffect();
	
	//FURY = Spawn(Class'WTF.WTFEquipFURY');
	//FURY.GiveTo(Instigator);
	KFHumanPawn(Instigator).CreateInventory("WTF.WTFEquipFURY");
}

defaultproperties
{
}
