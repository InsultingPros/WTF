class WTFEquipMachineDualies extends Dualies;

var Class<KFWeapon> SingleClass; //single version of this class AKA one pistol instead of one in each hand

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
	bSteadyAim = Default.bSteadyAim;
	MyFm.MaxSpread = MyFm.Default.MaxSpread;
	PlayerIronSightFOV=Default.PlayerIronSightFOV;
	
	if (KFPRI != none) {
		if (KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic') {
			MyFm.bFiringDoesntAffectMovement = True; //medic movement is not slowed when firing
			MyFm.RecoilVelocityScale = 1.2;
		}
		else if (KFPRI.ClientVeteranSkill == Class'WTFVetSharpShooter') {
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
	if ( Item.InventoryType==Class'WTFEquipMachinePistol' )
	{
		if( LastHasGunMsgTime<Level.TimeSeconds && PlayerController(Instigator.Controller)!=none )
		{
			LastHasGunMsgTime = Level.TimeSeconds+0.5;
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages',1);
		}
		return True;
	}
	Return Super(KFWeapon).HandlePickupQuery(Item);
}

function GiveTo( pawn Other, optional Pickup Pickup )
{
	local Inventory I;
	local int OldAmmo;
	local bool bNoPickup;
	
	MagAmmoRemaining = 0;
	For( I=Other.Inventory; I!=None; I=I.Inventory )
	{
		if( WTFEquipMachinePistol(I)!=None )
		{
			if( WeaponPickup(Pickup)!= none )
			{
				WeaponPickup(Pickup).AmmoAmount[0]+=Weapon(I).AmmoAmount(0);
			}
			else
			{
				OldAmmo = Weapon(I).AmmoAmount(0);
				bNoPickup = true;
			}

			MagAmmoRemaining = WTFEquipMachinePistol(I).MagAmmoRemaining;

			I.Destroyed();
			I.Destroy();

			Break;
		}
	}
	if( KFWeaponPickup(Pickup)!=None && Pickup.bDropped )
		MagAmmoRemaining = Clamp(MagAmmoRemaining+KFWeaponPickup(Pickup).MagAmmoRemaining,0,MagCapacity);
	else MagAmmoRemaining = Clamp(MagAmmoRemaining+SingleClass.Default.MagCapacity,0,MagCapacity);
	Super(Weapon).GiveTo(Other,Pickup);

	if ( bNoPickup )
	{
		AddAmmo(OldAmmo, 0);
		Clamp(Ammo[0].AmmoAmount, 0, MaxAmmo(0));
	}
}

function DropFrom(vector StartLocation)
{
	local int m;
	local Pickup Pickup;
	local Inventory I;
	local int AmmoThrown,OtherAmmo;

	if( !bCanThrow )
		return;

	AmmoThrown = AmmoAmount(0);
	ClientWeaponThrown();

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m].bIsFiring)
			StopFire(m);
	}

	if ( Instigator != None )
		DetachFromPawn(Instigator);

	if( Instigator.Health>0 )
	{
		OtherAmmo = AmmoThrown/2;
		AmmoThrown-=OtherAmmo;
		I = Spawn(SingleClass);
		I.GiveTo(Instigator);
		Weapon(I).Ammo[0].AmmoAmount = OtherAmmo;
		WTFEquipMachinePistol(I).MagAmmoRemaining = MagAmmoRemaining/2;
		MagAmmoRemaining = Max(MagAmmoRemaining-WTFEquipMachinePistol(I).MagAmmoRemaining,0);
	}
	Pickup = Spawn(PickupClass,,, StartLocation);
	if ( Pickup != None )
	{
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity;
		WeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
		if( KFWeaponPickup(Pickup)!=None )
			KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
		if (Instigator.Health > 0)
			WeaponPickup(Pickup).bThrown = true;
	}

    Destroyed();
	Destroy();
}

simulated function bool PutDown()
{
	//found out via logging that we need to check PendingWeapon != None 'cause apparently sometimes it is
	if ( Instigator.PendingWeapon != None)
	{
		if (Instigator.PendingWeapon.class == SingleClass)
			bIsReloading = false;
	}

	return super(KFWeapon).PutDown();
}

defaultproperties
{
	SingleClass=Class'WTF.WTFEquipMachinePistol'
	MagCapacity=32
	FireModeClass(0)=Class'WTF.WTFEquipMachineDualiesFire'
	Description="WTF Sharpshooter/Medic: reduced movement penalties for firing."
	PickupClass=Class'WTF.WTFEquipMachineDualiesPickup'
	ItemName="2x Machine Pistols"
}
