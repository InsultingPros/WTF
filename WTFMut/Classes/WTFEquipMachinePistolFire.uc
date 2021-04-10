class WTFEquipMachinePistolFire extends BullpupFire;

defaultproperties
{
	ShellEjectClass=Class'ROEffects.KFShellEject9mm'
	ShellEjectBoneName="Shell_eject"
	StereoFireSound=SoundGroup'KF_9MMSnd.9mm_FireST'
	DamageType=Class'KFMod.DamTypeDualies'
	DamageMin=25
	DamageMax=35
	Momentum=10000.000000
	FireSound=SoundGroup'KF_9MMSnd.9mm_Fire'
	FireRate=0.120000
	AmmoClass=Class'KFMod.SingleAmmo'
	aimerror=30.000000
	Spread=0.015000
}
