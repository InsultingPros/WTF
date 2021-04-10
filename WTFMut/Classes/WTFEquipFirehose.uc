class WTFEquipFirehose extends FlameThrower;

//override parent here, because parent bails if FireMode != 1; aka firemode(0)
simulated function bool StartFire(int Mode)
{
	if( !super(KFWeapon).StartFire(Mode) )  // returns false when mag is empty
	{
		return false;
	}
	
	if( AmmoAmount(0) <= 0 )
	{
    	return false;
    }

	AnimStopLooping();

	if( !FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0) )
	{
		FireMode[Mode].StartFiring();
		return true;
	}
	else
	{
		return false;
	}

	return true;
}

defaultproperties
{
	Weight=8.000000
	FireModeClass(0)=Class'WTF.WTFEquipFirehoseFmA'
	FireModeClass(1)=Class'WTF.WTFEquipFirehoseFmB'
	Description="Sprays fire in a concentrated stream (primary) or cone (secondary)"
	PickupClass=Class'WTF.WTFEquipFirehosePickup'
	ItemName="Fire hose"
}
