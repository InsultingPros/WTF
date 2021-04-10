class WTFEquipM4204AR extends M4203AssaultRifle
	config(user);

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFShotgunFire FmB;
	
	Super.BringUp(PrevWeapon);
	
	if (Role == ROLE_Authority)
	{	
		FmB = KFShotgunFire(FireMode[1]);
		FmB.ProjectileClass=FmB.Default.ProjectileClass;
		FmB.ProjPerFire = FmB.Default.ProjPerFire;
		FmB.Spread=FmB.Default.Spread;
			
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetFirebug') {
				FmB.ProjectileClass=Class'WTF.WTFEquipM4204FmBProjFirebug';
				FmB.ProjPerFire = FmB.Default.ProjPerFire;
				FmB.Spread=FmB.Default.Spread;
			}
			else if (KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic') {
				FmB.ProjectileClass=Class'WTF.WTFEquipM4204FmBProjFieldMedic';
				FmB.ProjPerFire = FmB.Default.ProjPerFire;
				FmB.Spread=FmB.Default.Spread;
			}
			else if (KFPRI.ClientVeteranSkill == Class'WTFVetSupportSpec') {
				FmB.ProjectileClass=Class'WTF.WTFEquipM4204FmBProjSupportSpec';
				FmB.ProjPerFire=5;
				FmB.Spread=1125.0;
			}
		}
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipM4204FmA'
	FireModeClass(1)=Class'WTF.WTFEquipM4204FmB'
	Description="Nade types vary; WTF Firebug: incendiary. WTF Medic: healing. WTF Support: super buckshot."
	PickupClass=Class'WTF.WTFEquipM4204Pickup'
	ItemName="M4 204"
}