class WTFEquipWelda extends Welder
	dependson(KFVoicePack);

#exec OBJ LOAD FILE=WTFTex.utx
#exec OBJ LOAD FILE=KF_Weapons_Trip_T.utx

simulated function Tick(float dt)
{
	if (FireMode[0].bIsFiring)
		FireModeArray = 0;
	else if (FireMode[1].bIsFiring)
		FireModeArray = 1;
		
	if (WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor == none)
	{
		WTFEquipWeldaFire(FireMode[FireModeArray]).LastHitActor = none;
		Super.Tick(dt);
	}
	else if ( WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor.IsA('KFDoorMover') )
	{
		WTFEquipWeldaFire(FireMode[FireModeArray]).LastHitActor = KFDoorMover(WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor);
		Super.Tick(dt);	
	}
	else if ( AmmoAmount(0) < FireMode[0].AmmoClass.Default.MaxAmmo)
	{
		AmmoRegenCount += (dT * AmmoRegenRate );
		ConsumeAmmo(0, -1*(int(AmmoRegenCount)));
		AmmoRegenCount -= int(AmmoRegenCount);
	}
	
	Super(KFMeleeGun).Tick(dt);
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipWeldaFire'
	FireModeClass(1)=Class'WTF.WTFEquipWeldaFireB'
	AmmoClass(0)=Class'WTF.WTFEquipWeldaAmmo'
	Description="Welds doors, zeds, metal clots...anything!"
	PickupClass=Class'WTF.WTFEquipWeldaPickup'
	AttachmentClass=Class'WTF.WTFEquipWeldaAttachment'
	ItemName="Legend of Welda"
	Skins(0)=Texture'WTFTex.Welda.Welda'
}
