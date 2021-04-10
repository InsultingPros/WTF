class WTFEquipCrossbow extends Crossbow;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local WTFEquipCrossbowFire FM0;
	
	Super.BringUp(PrevWeapon);

	if (Role == ROLE_Authority)
	{
		FM0 = WTFEquipCrossbowFire(FireMode[0]);
		FM0.ProjectileClass=FM0.Default.ProjectileClass;
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic') {
				FM0.ProjectileClass=Class'WTF.WTFEquipCrossbowArrowPoison';
			}
		}
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipCrossbowFire'
	Description="WTF Medic: poison arrows"
	PickupClass=Class'WTF.WTFEquipCrossbowPickup'
	ItemName="Xbow"
}
