class WTFEquipAA13Shotgun extends AA12AutoShotgun;

var bool IsWTFSupportSpec, IsWTFDemolitions;
var KFShotgunFire MyFm;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MyFm = KFShotgunFire(FireMode[0]);
}
simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	
	Super.BringUp(PrevWeapon);
	
	IsWTFSupportSpec = False;
	IsWTFDemolitions = False;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none) {
		return;
	}
	
	if (KFPRI.ClientVeteranSkill == Class'WTFVetSupportSpec') {
		IsWTFSupportSpec = True;
		if (MyFm.ProjectileClass == MyFm.Default.ProjectileClass) {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',1);
		}
		else {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',0);
		}
	}
	else if (KFPRI.ClientVeteranSkill == Class'WTFVetDemolitions') {
		IsWTFDemolitions = True;
		PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',2);
		If (ROLE == ROLE_AUTHORITY) {
			MyFm.ProjPerFire = 1;
			MyFm.ProjectileClass=Class'WTF.WTFEquipAA13ExplosiveRound';
			MyFm.Spread *= 0.35;
			MyFm.AimError *= 0.35;
		}
	}
	
	/*
	Special consideration has to be taken on resetting the number of projectiles.
	WTFSupportSpecs might legitimately have loaded slugs (1 proj) the last time they had this shotgun out,
	and will be expecting slugs to still be loaded when they bring this shotgun back out.
	*/
	If ( !(IsWTFSupportSpec || IsWTFDemolitions) && (Role == ROLE_AUTHORITY) ) {
		MyFm.ProjPerFire=MyFm.Default.ProjPerFire;
		MyFm.ProjectileClass=MyFm.Default.ProjectileClass;
		MyFm.Spread = MyFm.Default.Spread;
		MyFm.AimError = MyFm.Default.AimError;
	}
}
simulated function bool AllowReload()
{	
	if ( IsWTFSupportSpec && (bIsReloading || MagAmmoRemaining >= MagCapacity) ) {		
		if (MyFm.ProjectileClass == MyFm.Default.ProjectileClass)
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',0);
			MyFm.ProjPerFire=1;
			MyFm.ProjectileClass=Class'WTF.WTFEquipAA13Slug';
			MyFm.Spread *= 0.35;
			MyFm.AimError *= 0.35;
		}
		else
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',1);
			MyFm.ProjPerFire=MyFm.Default.ProjPerFire;
			MyFm.ProjectileClass=MyFm.Default.ProjectileClass;
			MyFm.Spread = MyFm.Default.Spread;
			MyFm.AimError = MyFm.Default.AimError;
		}
	}
	Return Super.AllowReload();
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipAA13Fire'
	Description="WTF Demo: explosive rounds. WTF Support: double-reload or reload while full to load Shot/Slugs."
	PickupClass=Class'WTF.WTFEquipAA13Pickup'
	ItemName="AA13"
}
