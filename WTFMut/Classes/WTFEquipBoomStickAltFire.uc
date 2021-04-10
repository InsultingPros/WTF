class WTFEquipBoomStickAltFire extends BoomStickAltFire;

var float MySpread;

simulated function AccuracyUpdate(float Velocity)
{
    local float MovementScale, ShakeScaler;
	
	if (KFWeapon(Weapon).bSteadyAim)
		return;

	if (Pawn(Weapon.Owner).bIsCrouched)
		Velocity *= CrouchedAccuracyBonus;

	//old code that assumed I'd never want to change the live value of Spread and have that actually DO SOMETHING
	//Spread = (default.Spread + (Velocity * 10 ));
	MySpread = (Spread + (Velocity * 10 ));
	
    // Add up to 20% more shake depending on how fast the player is moving
    MovementScale= Velocity/Instigator.default.GroundSpeed;
    ShakeScaler = 1.0 + (0.2 * MovementScale);

	ShakeRotMag.x = (default.ShakeRotMag.x * ShakeScaler);
	ShakeRotMag.y = (default.ShakeRotMag.y * ShakeScaler);
	ShakeRotMag.z = (default.ShakeRotMag.z * ShakeScaler);
}

event ModeDoFire()
{
	local float Rec;
	
	if (!AllowFire())
		return;

	//old code that didn't allow changing Spread directly
	//Spread = Default.Spread;
	MySpread = Spread;
	
	Rec = GetFireSpeed();
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	Rec = 1;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		MySpread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
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

	///////////////////////////////////////////////////////////////////////////////////
    // Code from WeaponFire	we have to override

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    BoomStick(Weapon).SingleShotCount--;

    if( BoomStick(Weapon).SingleShotCount < 1 )
    {
        BoomStick(Weapon).SetPendingReload();
    }

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
		// Need to consume ammo client side to make sure the right anims play
        if( Weapon.Role < ROLE_Authority )
		{
	        Weapon.ConsumeAmmo(ThisModeNum, Load);
        }

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
        if( BoomStick(Weapon).SingleShotCount == 0 )
        {
            if (bIsFiring)
                NextFireTime += MaxHoldTime + FireLastRate;
            else
                NextFireTime = Level.TimeSeconds + FireLastRate;
        }
        else
        {
            if (bIsFiring)
                NextFireTime += MaxHoldTime + FireRate;
            else
                NextFireTime = Level.TimeSeconds + FireRate;
        }
    }
    else
    {
        if( BoomStick(Weapon).SingleShotCount == 0 )
        {
            NextFireTime += FireLastRate;
            NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
        }
        else
        {
            NextFireTime += FireRate;
            NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
        }
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
    // end code from WeaponFire
	///////////////////////////////////////////////////////////////////////////////////

    // client
    if (Instigator.IsLocallyControlled())
    {
        HandleRecoil(Rec);
    }
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int p;
    local int SpawnCount;
    local float theta;
	
    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() && !KFWeap.bAimingRifle )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));
	
    switch (SpreadStyle)
    {
    case SS_Random:
        X = Vector(Aim);
        for (p = 0; p < SpawnCount; p++)
        {
            R.Yaw = MySpread * (FRand()-0.5);
            R.Pitch = MySpread * (FRand()-0.5);
            R.Roll = MySpread * (FRand()-0.5);
            SpawnProjectile(StartProj, Rotator(X >> R));
        }
        break;
    case SS_Line:
        for (p = 0; p < SpawnCount; p++)
        {
            theta = MySpread*PI/32768*(p - float(SpawnCount-1)/2.0);
            X.X = Cos(theta);
            X.Y = Sin(theta);
            X.Z = 0.0;
            SpawnProjectile(StartProj, Rotator(X >> Aim));
        }
        break;
    default:
        SpawnProjectile(StartProj, Aim);
    }

	if (Instigator != none )
	{
        if( Instigator.Physics != PHYS_Falling  )
        {
            Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
		}
		// Really boost the momentum for low grav
        else if( Instigator.Physics == PHYS_Falling
            && Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z)
        {
            Instigator.AddVelocity((KickMomentum * LowGravKickMomentumScale) >> Instigator.GetViewRotation());
        }
	}
}

defaultproperties
{
	KickMomentum=(X=-150.000000,Z=66.000000)
	maxVerticalRecoilAngle=6400
	maxHorizontalRecoilAngle=1800
	TransientSoundVolume=3.800000
	TransientSoundRadius=1000.000000
	ShakeRotMag=(X=100.000000,Y=100.000000,Z=800.000000)
	ShakeOffsetMag=(X=12.000000,Y=4.000000,Z=20.000000)
	ProjPerFire=10
	ProjectileClass=Class'WTF.WTFEquipBoomStickPellet'
}