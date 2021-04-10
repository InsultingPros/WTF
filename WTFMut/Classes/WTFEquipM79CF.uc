class WTFEquipM79CF extends M79GrenadeLauncher;

var bool IsFirebug, IsDemolitions, IsSupportSpec;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFShotgunFire FM0;
	
	Super.BringUp(PrevWeapon);

	if (Role == ROLE_Authority)
	{
		IsFirebug = False;
		IsDemolitions = False;
		IsSupportSpec = False;
		FM0 = KFShotgunFire(FireMode[0]);
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetFirebug') {
				IsFirebug = True;
				FM0.ProjectileClass=Class'WTF.WTFEquipM79CFFlameBomb';
			}
			else if (KFPRI.ClientVeteranSkill == Class'WTFVetDemolitions') {
				IsDemolitions = True;
				FM0.ProjectileClass=Class'WTF.WTFEquipM79CFClusterBomb';
			}
			else if (KFPRI.ClientVeteranSkill == Class'WTFVetSupportSpec') {
				IsSupportSpec = True;
				FM0.ProjectileClass=Class'WTF.WTFEquipSuperBuckshot';
				FM0.ProjPerFire = 3;
				FM0.Spread = 1125.0;
				FM0.AimError = 1.0;
				FM0.SpreadStyle=SS_Random;
			}
		}
		if (!(IsFirebug || IsDemolitions || IsSupportSpec)) {
			FM0.ProjectileClass=FM0.Default.ProjectileClass;
			FM0.ProjPerFire=FM0.Default.ProjPerFire;
			FM0.Spread = FM0.Default.Spread;
			FM0.AimError = FM0.Default.AimError;
			FM0.SpreadStyle=FM0.Default.SpreadStyle;
		}
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipM79CFFire'
	Description="WTF Demo: cluster bombs. WTF Firebug: Incindiary. WTF Support: Super Buckshot."
	PickupClass=Class'WTF.WTFEquipM79CFPickup'
	ItemName="M79CF"
}
