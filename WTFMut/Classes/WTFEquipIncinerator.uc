class WTFEquipIncinerator extends HuskGun;

var() Int Fm1FreeShotCounter;
var() Int Fm1FreeShotMax;

simulated function bool StartFire(int Mode)
{
	//do stuff required by WTFEquipIncineratorFmB
	if( Mode == 1 && !FireMode[1].IsInState('FireLoop') && (AmmoAmount(1) > 0) )
	{
		FireMode[1].StartFiring();
	}
	
	return super.StartFire(Mode);
}


simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	if(Mode == 1 && Fm1FreeShotCounter < Fm1FreeShotMax) {
		Fm1FreeShotCounter++;
		return true;
	}
	Else {
		Fm1FreeShotCounter = 0;
	}
	return Super.ConsumeAmmo(Mode,Load,bAmountNeededIsMax);
}

defaultproperties
{
	Fm1FreeShotMax = 25
	Fm1FreeShotCounter = 0
	FireModeClass(0)=Class'WTF.WTFEquipIncineratorFmA'
	FireModeClass(1)=Class'WTF.WTFEquipIncineratorFmB'
	Description="Primary to charge up a firebolt, Secondary to spray intense flames."
	PickupClass=Class'WTF.WTFEquipIncineratorPickup'
	ItemName="Incinerator"
}