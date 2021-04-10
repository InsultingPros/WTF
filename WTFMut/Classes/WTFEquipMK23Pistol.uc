class WTFEquipMK23Pistol extends MK23Pistol;

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFFire MyFm;
	
	Super.BringUp(PrevWeapon);
	
	if (ROLE < ROLE_AUTHORITY) {
		return;
	}
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	MyFm.bFiringDoesntAffectMovement = MyFm.Default.bFiringDoesntAffectMovement;
	MyFm.RecoilVelocityScale = MyFm.Default.RecoilVelocityScale;
	bSteadyAim = Default.bSteadyAim;
	MyFm.MaxSpread = MyFm.Default.MaxSpread;
	PlayerIronSightFOV=Default.PlayerIronSightFOV;
	
	if (KFPRI != none) {
		if (KFPRI.ClientVeteranSkill == Class'WTFVetSharpShooter') {
			MyFm.bFiringDoesntAffectMovement = True;
			MyFm.RecoilVelocityScale = 0; //moving has no affect on recoil
			bSteadyAim = True; //so KFFire.AccuracyUpdate() doesn't adjust spread based on pawn's velocity
			MyFm.MaxSpread = MyFm.Default.MaxSpread * 0.5;
			PlayerIronSightFOV=45.0;
		}
	}
}

defaultproperties
{
	Description="WTF Sharpshooter: reduced movement penalties for firing."
	PickupClass=Class'WTF.WTFEquipMK23Pickup'
	ItemName="MK23"
}