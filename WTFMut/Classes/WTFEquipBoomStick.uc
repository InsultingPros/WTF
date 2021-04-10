class WTFEquipBoomStick extends BoomStick;

var bool IsWTFSupportSpec;
var KFShotgunFire MyFmA, MyFmB;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MyFmA = KFShotgunFire(FireMode[0]);
	MyFmB = KFShotgunFire(FireMode[1]);
}
simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	
	Super.BringUp(PrevWeapon);
	
	IsWTFSupportSpec = False;
	
	//DETERMINE PERK & BENEFITS
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none) {
		return;
	}
	
	if (KFPRI.ClientVeteranSkill == Class'WTFVetSupportSpec') {
		IsWTFSupportSpec = True;
		if (MyFmA.ProjectileClass == MyFmA.Default.ProjectileClass) {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',1);
		}
		else {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',0);
		}
	}
	
	/*
	Special consideration has to be taken on resetting the number of projectiles.
	WTFSupportSpecs might legitimately have loaded slugs (1 proj) the last time they had this shotgun out,
	and will be expecting slugs to still be loaded when they bring this shotgun back out.
	*/
	If ( !IsWTFSupportSpec && Role == ROLE_AUTHORITY ) {
		MyFmA.ProjPerFire=MyFmA.Default.ProjPerFire;
		MyFmA.ProjectileClass=MyFmA.Default.ProjectileClass;
		MyFmA.Spread = MyFmA.Default.Spread;
		MyFmA.AimError = MyFmA.Default.AimError;
		MyFmB.ProjPerFire=MyFmB.Default.ProjPerFire;
		MyFmB.ProjectileClass=MyFmB.Default.ProjectileClass;
		MyFmB.Spread = MyFmB.Default.Spread;
		MyFmB.AimError = MyFmB.Default.AimError;
	}
}
simulated function bool AllowReload()
{
	if ( IsWTFSupportSpec && (bIsReloading || MagAmmoRemaining >= 1) ) {		
		if (MyFmA.ProjectileClass == MyFmA.Default.ProjectileClass) {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',0);
			MyFmA.ProjPerFire=1;
			MyFmB.ProjPerFire=1;
			MyFmA.ProjectileClass=Class'WTF.WTFEquipBoomStickSlug';
			MyFmA.Spread *= 0.35;
			MyFmA.AimError *= 0.35;
			MyFmB.ProjectileClass=Class'WTF.WTFEquipBoomStickSlug';
			MyFmB.Spread *= 0.35;
			MyFmB.AimError *= 0.35;
		}
		else {
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'WTF.WTFMessages',1);
			MyFmA.ProjPerFire=MyFmA.Default.ProjPerFire;
			MyFmB.ProjPerFire=MyFmB.Default.ProjPerFire;
			MyFmA.ProjPerFire=MyFmA.Default.ProjPerFire;
			MyFmA.ProjectileClass=MyFmA.Default.ProjectileClass;
			MyFmA.Spread = MyFmA.Default.Spread;
			MyFmA.AimError = MyFmA.Default.AimError;
			MyFmB.ProjPerFire=MyFmB.Default.ProjPerFire;
			MyFmB.ProjectileClass=MyFmB.Default.ProjectileClass;
			MyFmB.Spread = MyFmB.Default.Spread;
			MyFmB.AimError = MyFmB.Default.AimError;
		}
	}
	Return Super.AllowReload();
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipBoomStickAltFire'
	FireModeClass(1)=Class'WTF.WTFEquipBoomStickFire'
	Description="WTF Support: reload while full to use shot / slugs"
	PickupClass=Class'WTF.WTFEquipBoomStickPickup'
	ItemName="BOOMSTICK"
}
