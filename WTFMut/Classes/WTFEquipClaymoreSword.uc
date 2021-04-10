class WTFEquipClaymoreSword extends ClaymoreSword;

var bool IsBerserker;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFMeleeFire FM0,FM1;
	
	Super.BringUp(PrevWeapon);

	if (Role == ROLE_Authority)
	{
		IsBerserker = False;
		FM0 = KFMeleeFire(FireMode[0]);
		FM1 = KFMeleeFire(FireMode[1]);
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetBerserker') {
				ChopSlowRate = 1.0;
				FM0.WideDamageMinHitAngle = 0.6 * FM0.Default.WideDamageMinHitAngle;
				FM1.WideDamageMinHitAngle = 0.6 * FM1.Default.WideDamageMinHitAngle;
			}
		}
		if (!IsBerserker) {
			ChopSlowRate = Default.ChopSlowRate;
			FM0.WideDamageMinHitAngle = FM0.Default.WideDamageMinHitAngle;
			FM1.WideDamageMinHitAngle = FM1.Default.WideDamageMinHitAngle;
		}
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipClaymoreSwordFire'
	FireModeClass(1)=Class'WTF.WTFEquipClaymoreSwordFireB'
	Description="WTF Berserker: attacks do not slow you, wider damage arc"
	PickupClass=Class'WTF.WTFEquipClaymoreSwordPickup'
	ItemName="Claymore Sword"
}