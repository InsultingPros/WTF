class WTFEquipMac12MP extends MAC10MP;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFFire MyFm;
	
	Super.BringUp(PrevWeapon);
	
	if (ROLE < ROLE_AUTHORITY) {
		return;
	}
	
	MyFm = KFFire(FireMode[0]);
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	MyFm.bFiringDoesntAffectMovement = MyFm.Default.bFiringDoesntAffectMovement;
	MyFm.RecoilVelocityScale = MyFm.Default.RecoilVelocityScale;
	
	if (KFPRI == None) {
		return;
	}
	
	if (KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic') {
		MyFm.bFiringDoesntAffectMovement = True;
		MyFm.RecoilVelocityScale = 1.2;
	}
}

defaultproperties
{
	Description="WTF Medic: reduced movement penalties for firing."
	PickupClass=Class'WTF.WTFEquipMac12Pickup'
	ItemName="Mac12"
}