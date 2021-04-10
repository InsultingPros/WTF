class WTFEquipCrossbowArrow extends CrossbowArrow;

//overridden to reduce damage and velocity for each penetrated target
simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local vector X,End,HL,HN;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
  local KFPawn HitPawn;
	local bool	bHitWhipAttachment;

	if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces || Other==IgnoreImpactPawn || (IgnoreImpactPawn != none && Other.Base == IgnoreImpactPawn) )
		return;
		
	X =  Vector(Rotation);

 	if( ROBulletWhipAttachment(Other) != none )
	{
   	bHitWhipAttachment=true;

    if(!Other.Base.bDeleteMe)
    {
	    Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, 1);

			if( Other == none || HitPoints.Length == 0 )
				return;

			HitPawn = KFPawn(Other);

			if (Role == ROLE_Authority)
			{
				if ( HitPawn != none )
				{
          if( !HitPawn.bDeleteMe )
            HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);

        	Damage*=0.3;
        	Velocity*=0.3;
					
          IgnoreImpactPawn = HitPawn;

          if( Level.NetMode!=NM_Client )
            PlayhitNoise(Pawn(Other)!=none && Pawn(Other).ShieldStrength>0);
    			
					return;
    	  }
    	}
		}
		else
		{
			return;
		}
	}

	if( Level.NetMode!=NM_Client )
		PlayhitNoise(Pawn(Other)!=none && Pawn(Other).ShieldStrength>0);

	if( Physics==PHYS_Projectile && Pawn(Other)!=None && Vehicle(Other)==None )
	{
		IgnoreImpactPawn = Pawn(Other);
		if( IgnoreImpactPawn.IsHeadShot(HitLocation, X, 1.0) )
			Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
		else
			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
		
		Damage*=0.3;
		Velocity*=0.3;
		
		Return;
	}
	else if( ExtendedZCollision(Other)!=None && Pawn(Other.Owner)!=None )
	{
		if( Other.Owner==IgnoreImpactPawn )
			Return;
		IgnoreImpactPawn = Pawn(Other.Owner);
		if ( IgnoreImpactPawn.IsHeadShot(HitLocation, X, 1.0))
			Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
		else
			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
		
		Damage*=0.3;
		Velocity*=0.3;
		
		Return;
	}
	
	if( Level.NetMode!=NM_DedicatedServer && SkeletalMesh(Other.Mesh)!=None && Other.DrawType==DT_Mesh && Pawn(Other)!=None )
	{ // Attach victim to the wall behind if it dies.
		End = Other.Location+X*600;
		if( Other.Trace(HL,HN,End,Other.Location,False)!=None )
			Spawn(Class'BodyAttacher',Other,,HitLocation).AttachEndPoint = HL-HN;
	}
	
	Stick(Other,HitLocation);
	
	if( Level.NetMode!=NM_Client )
	{
		if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
			Pawn(Other).TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
		else
			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
	}
}

defaultproperties
{
	LifeSpan=30.000000
	Acceleration=(Z=-2000.000000)
}
