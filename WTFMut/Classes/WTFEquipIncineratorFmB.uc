class WTFEquipIncineratorFmB extends FlameBurstFire;

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading) {
		Log("WTFEquipIncineratorFmB: AllowFire(): passed (bIsReloading)");
		return false;
	}
	
	LastClickTime = Level.TimeSeconds;
	
	Log("WTFEquipIncineratorFmB: AllowFire(): AmmoAmount = "$Weapon.AmmoAmount(ThisModeNum));
	
	if(Weapon.AmmoAmount(ThisModeNum) < AmmoPerFire) {
		Log("WTFEquipIncineratorFmB: AllowFire(): passed (< AmmoPerFire)");
		return false;
	}
	
	Log("WTFEquipIncineratorFmB: AllowFire(): returning TRUE");
	return true;
}

event ModeDoFire()
{
	local float Rec;

	Log("WTFEquipIncineratorFmB: ModeDoFire()");
	
	/* if statement from FlameBurstFire */
	if (!AllowFire()) {
		Log("WTFEquipIncineratorFmB: ModeDoFire(): failed because !AllowFire()");
		return;
	}
	if (IsInState('FireLoop') == False) {
		Log("WTFEquipIncineratorFmB: ModeDoFire(): failed because IsInState('FireLoop') == False");
		return;
	}
	/* end if statement from FlameBurstFire */

	/* code from KFShotgunFire */
	Spread = Default.Spread;

	Rec = GetFireSpeed();
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	Rec = 1;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		Spread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
	}

	if( !bFiringDoesntAffectMovement )
	{
		if (FireRate > 0.25)
		{
			Instigator.Velocity.x *= 0.1;
			Instigator.Velocity.y *= 0.1;
		}
		else
		{
			Instigator.Velocity.x *= 0.5;
			Instigator.Velocity.y *= 0.5;
		}
	}
	/* end code from KFShotgunFire */

	/* code from WeaponFire */
	if (MaxHoldTime > 0.0)
			HoldTime = FMin(HoldTime, MaxHoldTime);

	// server
	if (Weapon.Role == ROLE_Authority)
	{
		Weapon.ConsumeAmmo(ThisModeNum, Load);
		DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
		if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
	}

	// client
	if (Instigator.IsLocallyControlled())
	{
		ShakeView();
		PlayFiring();
		FlashMuzzleFlash();
		StartMuzzleSmoke();
	}
	else // server
	{
		ServerPlayFiring();
	}

	Weapon.IncrementFlashCount(ThisModeNum);

	// set the next firing time. must be careful here so client and server do not get out of sync
	if (bFireOnRelease)
	{
		if (bIsFiring)
			NextFireTime += MaxHoldTime + FireRate;
		else
			NextFireTime = Level.TimeSeconds + FireRate;
	}
	else
	{
		NextFireTime += FireRate;
		NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
	}

	Load = AmmoPerFire;
	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}
	/* end code from WeaponFire */

	/* code from KFShotgunFire */
	// client
	if (Instigator.IsLocallyControlled())
	{
		HandleRecoil(Rec);
	}
	/* end code from KFShotgunFire */
}

defaultproperties
{
	ProjSpawnOffset=(X=50,Y=10,Z=-20)
	AmmoClass=Class'KFMod.HuskGunAmmo'
	ProjectileClass=Class'WTF.WTFEquipIncineratorFmBProj'
	FireLoopAnim=Idle
	FireEndAnim=Idle

	ProjPerFire=3
	FireRate=0.023300
	aimerror=1.000000
	Spread=1500.000000
}
