class WTFEquipKrissM2MG extends KrissMMedicGun;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFFire MyFmA;
	local KFShotgunFire MyFmB;
	
	Super.BringUp(PrevWeapon);
	
	if (ROLE < ROLE_AUTHORITY) {
		return;
	}
	
	MyFmA = KFFire(FireMode[0]);
	MyFmB = KFShotgunFire(FireMode[1]);
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	MyFmA.bFiringDoesntAffectMovement = MyFmA.Default.bFiringDoesntAffectMovement;
	MyFmA.RecoilVelocityScale = MyFmA.Default.RecoilVelocityScale;
	MyFmB.FireRate=MyFmB.Default.FireRate;
	MyFmB.AmmoPerFire=MyFmB.Default.AmmoPerFire;
	
	if (KFPRI == None) {
		return;
	}
	
	if (KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic') {
		MyFmA.bFiringDoesntAffectMovement = True;
		MyFmA.RecoilVelocityScale = 1.2;
		MyFmB.FireRate=MyFmB.Default.FireRate * 0.4;
		MyFmB.AmmoPerFire=MyFmB.Default.AmmoPerFire * 0.4;
	}
}

defaultproperties
{
	Description="WTF Medic: reduced movement penalties for firing, faster healing recharge/firing"
	PickupClass=Class'WTF.WTFEquipKrissM2Pickup'
	ItemName="KrissM2 Medic Gun"
}