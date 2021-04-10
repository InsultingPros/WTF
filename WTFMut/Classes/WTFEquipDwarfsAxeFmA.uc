class WTFEquipDwarfsAxeFmA extends DwarfAxeFire;

var float ShrinkChance;

//overridden parent class code to spawn the debuff projectile
simulated function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local int MyDamage;
	local bool bBackStabbed;
	local Pawn Victims;
	local vector dir, lookdir;
	local float DiffAngle, VictimDist;
	local float AppliedMomentum;
	local KFMonster HitKFMonster;

	MyDamage = MeleeDamage;

	If( !KFWeapon(Weapon).bNoHit )
	{
		MyDamage = MeleeDamage;
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if( Instigator.Controller!=None && PlayerController(Instigator.Controller)==None && Instigator.Controller.Enemy!=None ) {
			PointRot = rotator(Instigator.Controller.Enemy.Location-StartTrace); // Give aimbot for bots.
    }
		else {
			PointRot = Instigator.GetViewRotation();
    }

		EndTrace = StartTrace + vector(PointRot)*weaponRange;
		HitActor = Instigator.Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);

		if (HitActor!=None) {
			ImpactShakeView();

			if( HitActor.IsA('ExtendedZCollision') && HitActor.Base != none && HitActor.Base.IsA('KFMonster') ) {
				HitActor = HitActor.Base;
      }

			if ( (HitActor.IsA('KFMonster') || HitActor.IsA('KFHumanPawn')) && KFMeleeGun(Weapon).BloodyMaterial!=none ) {
				Weapon.Skins[KFMeleeGun(Weapon).BloodSkinSwitchArray] = KFMeleeGun(Weapon).BloodyMaterial;
				Weapon.texture = Weapon.default.Texture;
			}
			if( Level.NetMode==NM_Client ) {
				Return;
      }

			if( HitActor.IsA('Pawn') && !HitActor.IsA('Vehicle') && (Normal(HitActor.Location-Instigator.Location) dot vector(HitActor.Rotation))>0 ) {
				bBackStabbed = true;
				MyDamage*=2;
			}

			if( (KFMonster(HitActor)!=none) )
			{	
				KFMonster(HitActor).bBackstabbed = bBackStabbed;
				dir = Normal((HitActor.Location + KFMonster(HitActor).EyePosition()) - Instigator.Location);
				AppliedMomentum = InterpCurveEval(AppliedMomentumCurve,HitActor.Mass);
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, dir * AppliedMomentum, hitDamageClass) ;

				if (FRand() <= ShrinkChance && ZombieBossBase(HitActor) == None) {
					//cut 'em down to size!
					HitKFMonster = KFMonster(HitActor);
					HitKFMonster.OriginalGroundSpeed = HitKFMonster.Default.GroundSpeed * 0.3;
					HitKFMonster.SetDrawScale(HitKFMonster.Default.DrawScale * 0.3);
					HitKFMonster.Default.ColOffset *= 0.3;
					HitKFMonster.Default.ColRadius *= 0.3;
					HitKFMonster.Default.ColHeight *= 0.3;
					HitKFMonster.SetCollisionSize(HitKFMonster.Default.CollisionRadius * 0.3, HitKFMonster.Default.CollisionHeight * 0.3);
					HitKFMonster.MeleeDamage = HitKFMonster.MeleeDamage * 0.3;
				}
				
				if( KFMonster(HitActor) != none ) {
					KFMonster(HitActor).BreakGrapple();
				}

				if(MeleeHitSounds.Length > 0) {
					Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
				}

				if(VSize(Instigator.Velocity) > 300 && KFMonster(HitActor).Mass <= Instigator.Mass) {
				    KFMonster(HitActor).FlipOver();
				}
			}
			else {
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, Normal(vector(PointRot)) * MomentumTransfer, hitDamageClass) ;
				Spawn(HitEffectClass,,, HitLocation, rotator(HitLocation - StartTrace));
			}
		}

		if( WideDamageMinHitAngle > 0 )
		{
			foreach Weapon.VisibleCollidingActors( class 'Pawn', Victims, (weaponRange * 2), StartTrace ) //, RadiusHitLocation
			{
				if( (HitActor != none && Victims == HitActor) || Victims.Health <= 0 )
				{
					continue;
				}

				if( Victims != Instigator )
				{
					VictimDist = VSizeSquared(Instigator.Location - Victims.Location);
					if( VictimDist > (((weaponRange * 1.1) * (weaponRange * 1.1)) + (Victims.CollisionRadius * Victims.CollisionRadius)) )
					{
							continue;
					}

    	  	lookdir = Normal(Vector(Instigator.GetViewRotation()));
    			dir = Normal(Victims.Location - Instigator.Location);
					DiffAngle = lookdir dot dir;
					dir = Normal((Victims.Location + Victims.EyePosition()) - Instigator.Location);

    	    if( DiffAngle > WideDamageMinHitAngle ) {
            AppliedMomentum = InterpCurveEval(AppliedMomentumCurve,Victims.Mass);
    	      Victims.TakeDamage(MyDamage*DiffAngle, Instigator, (Victims.Location + Victims.CollisionHeight * vect(0,0,0.7)), dir * AppliedMomentum, hitDamageClass) ;

						// Break thier grapple if you are knocking them back!
						if( KFMonster(Victims) != none )
						{
							KFMonster(Victims).BreakGrapple();
						}

						if(MeleeHitSounds.Length > 0)
						{
							Victims.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
						}
    	    }
    		}
    	}
		}
	}
}

defaultproperties
{
	ShrinkChance=0.1
}