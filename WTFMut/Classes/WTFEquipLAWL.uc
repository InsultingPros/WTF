class WTFEquipLAWL extends LAW;

var bool IsFirebug;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local WTFEquipLAWLFire FM0;
	
	Super.BringUp(PrevWeapon);

	if (Role == ROLE_Authority)
	{
		IsFirebug = False;
		FM0 = WTFEquipLAWLFire(FireMode[0]);

		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetFirebug') {
				IsFirebug = True;
				FM0.ProjectileClass=Class'WTF.WTFEquipLAWLProjFlame';
			}
		}
		if (!IsFirebug) {
			FM0.ProjectileClass=FM0.Default.ProjectileClass;
		}
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipLAWLFire'
	Description="Warning: explosive potential of rockets may vary. WTF Firebug: napalm rockets."
	PickupClass=Class'WTF.WTFEquipLAWLPickup'
	ItemName="The LAWL"
}
