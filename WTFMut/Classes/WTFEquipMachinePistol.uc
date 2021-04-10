class WTFEquipMachinePistol extends Single;

var Class<KFWeapon> DualClass; //dual version of this class

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFFire MyFm;
	
	Super.BringUp(PrevWeapon);
	
	if (ROLE < ROLE_AUTHORITY) {
		return;
	}
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	MyFm = KFFire(FireMode[0]);
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

function bool HandlePickupQuery( pickup Item )
{
	if ( Item.InventoryType == Class )
	{
		if ( KFHumanPawn(Owner) != none && !KFHumanPawn(Owner).CanCarry(DualClass.Default.Weight) )
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 2);
			return true;
		}

		return false; // Allow to "pickup" so this weapon can be replaced with dualies.
	}
	Return Super(KFWeapon).HandlePickupQuery(Item);
}

simulated function bool PutDown()
{
	if (  Instigator.PendingWeapon != none && Instigator.PendingWeapon.class == DualClass )
	{
		bIsReloading = false;
	}

	return super(KFWeapon).PutDown();
}
	

defaultproperties
{
	DualClass = Class'WTF.WTFEquipMachineDualies'
	MagCapacity=16
	FireModeClass(0)=Class'WTF.WTFEquipMachinePistolFire'
	bCanThrow=False
	Description="WTF Sharpshooter: reduced movement penalties for firing."
	PickupClass=Class'WTF.WTFEquipMachinePistolPickup'
	ItemName="Machine Pistol"
}
