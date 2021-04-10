class WTFEquipM79CFClusterBomblet extends Nade;

//only blow up from fuse running out or siren scream
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	if ( Monster(instigatedBy) != none || instigatedBy == Instigator )
	{
        if( damageType == class'SirenScreamDamage')
        {
            Disintegrate(HitLocation, vect(0,0,1));
        }
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController  LocalPlayer;

	if (bHasExploded)
		Return;
	
	bHasExploded = True;
	BlowUp(HitLocation);

	PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,1.5);

	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(class'WTF.WTFEquipM79CFExplosionEmitter',self,,HitLocation + HitNormal*20,rotator(HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

	Destroy();
}

//same code as hitwall- bounce around!
simulated function ProcessTouch( actor Other, vector HitLocation )
{
    local Vector VNorm;
	local PlayerController PC;
	
    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitLocation) * HitLocation;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    DesiredRotation.Roll = 0;
    RotationRate.Roll = 0;
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        PrePivot.Z = -1.5;
			SetPhysics(PHYS_None);
		DesiredRotation = Rotation;
		DesiredRotation.Roll = 0;
		DesiredRotation.Pitch = 0;
		SetRotation(DesiredRotation);

		if( Fear == none )
		{
		    Fear = Spawn(class'AvoidMarker');
    		Fear.SetCollisionSize(DamageRadius,DamageRadius);
    		Fear.StartleBots();
		}

        if ( Trail != None )
            Trail.mRegen = false; // stop the emitter from regenerating
    }
    else
    {
		//if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 50) )
			//PlaySound(ImpactSound, SLOT_Misc );
		//else
		//{
			bFixedRotationDir = false;
			bRotateToDesired = true;
			DesiredRotation.Pitch = 0;
			RotationRate.Pitch = 50000;
		//}
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			PC = Level.GetLocalPlayerController();
			if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
				Spawn(HitEffectClass,,, Location, Rotator(HitLocation));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

defaultproperties
{
	ExplodeTimer=1.500000
	DampenFactorParallel=0.250000
	Speed=300.000000
	MaxSpeed=300.000000
	Damage=200.000000
	DamageRadius=400.000000
	MomentumTransfer=100.000000
	StaticMesh=StaticMesh'kf_generic_sm.Bullet_Shells.40mm_Warhead'
	DrawScale=3.000000
}
