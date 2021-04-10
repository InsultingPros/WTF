class WTFZombiesBanshee extends WTFZombiesBansheeBase;

//#exec OBJ LOAD FILE=PlayerSounds.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax
#exec OBJ LOAD FILE=WTFSounds.uax
#exec OBJ LOAD FILE=WTFTex.utx

/* ----------------------------------------------------------------------------------

	SIREN STUFF

---------------------------------------------------------------------------------- */

function RangedAttack(Actor A)
{
	//local int LastFireTime;
	local float Dist;

	if ( bShotAnim )
		return;

    Dist = VSize(A.Location - Location);

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Claw');
		bShotAnim = true;
		//LastFireTime = Level.TimeSeconds;
	}
	else if( Dist <= (ScreamRadius * 0.5) && !bDecapitated && Level.TimeSeconds > NextScreamTime) //prefer scream over melee
	{
		NextScreamTime = Level.TimeSeconds + ScreamCooldown;
		SpawnTwoShots();
		bShotAnim=true;
		SetAnimAction('StalkerSpinAttack');
		// Only stop moving if we are close
		if( Dist < ScreamRadius * 0.3 )
		{
    		Controller.bPreparingMove = true;
    		Acceleration = vect(0,0,0);
        }
        else
        {
            Acceleration = AccelRate * Normal(A.Location - Location);
        }
	}
	else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius)
	{
		bShotAnim = true;
		SetAnimAction('Claw');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
}

function PlayScreamSound()
{
	if( Level.NetMode!=NM_Client )
	{
		PlaySound(sound'WTFSounds.BansheeScream', SLOT_Pain,1.30,true,525);
	}
}

// Scream Time
simulated function SpawnTwoShots()
{
    DoShakeEffect();

	//PlaySound(sound'WTFSounds.BansheeScream', SLOT_Interact);
	//PlaySound(sound'BansheeScream', SLOT_Pain,1.50,true,525);
	PlayScreamSound();
	
	if( Level.NetMode!=NM_Client )
	{
		// Deal Actual Damage.
		if( Controller!=None && KFDoorMover(Controller.Target)!=None )
			Controller.Target.TakeDamage(ScreamDamage*0.6,Self,Location,vect(0,0,0),ScreamDamageType);
		else HurtRadius(ScreamDamage ,ScreamRadius, ScreamDamageType, ScreamForce, Location);
	}
}

// Shake nearby players screens
simulated function DoShakeEffect()
{
	local PlayerController PC;
	local float Dist, scale, BlurScale;

	//viewshake
	if (Level.NetMode != NM_DedicatedServer)
	{
		PC = Level.GetLocalPlayerController();
		if (PC != None && PC.ViewTarget != None)
		{
			Dist = VSize(Location - PC.ViewTarget.Location);
			if (Dist < ScreamRadius )
			{
				scale = (ScreamRadius - Dist) / (ScreamRadius);
                scale *= ShakeEffectScalar;
                BlurScale = scale;

                // Reduce blur if there is something between us and the siren
                if( !FastTrace(PC.ViewTarget.Location,Location) )
                {
                    scale *= 0.25;
                    BlurScale = scale;
                }
                else
                {
                    scale = Lerp(scale,MinShakeEffectScale,1.0);
                }

                PC.SetAmbientShake(Level.TimeSeconds + ShakeFadeTime, ShakeTime, OffsetMag * Scale, OffsetRate, RotMag * Scale, RotRate);

                if( KFHumanPawn(PC.ViewTarget) != none )
                {
                    KFHumanPawn(PC.ViewTarget).AddBlur(ShakeTime, BlurScale * ScreamBlurScale);
                }
			}
		}
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local float UsedDamageAmount;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, ScreamRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		// Or Karma actors in this case. Self inflicted Death due to flying chairs is uncool for a zombie of your stature.
		if( (Victims != self) && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('KFMonster') && !Victims.IsA('ExtendedZCollision') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

			if (!Victims.IsA('KFHumanPawn')) // If it aint human, don't pull the vortex crap on it.
				Momentum = 0;

			if (Victims.IsA('KFGlassMover'))   // Hack for shattering in interesting ways.
			{
				UsedDamageAmount = 100000; // Siren always shatters glass
			}
			else
			{
                UsedDamageAmount = DamageAmount;
			}

			if (Victims.Velocity.Z != 0) //don't fling potentially airborne players further into the air...as much
				Momentum *= 0.1;
				
			Victims.TakeDamage(damageScale * UsedDamageAmount,Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,(damageScale * Momentum * dir),DamageType);

            if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(UsedDamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}

/* ----------------------------------------------------------------------------------

	STALKER STUFF

---------------------------------------------------------------------------------- */

simulated function PostBeginPlay()
{
	CloakStalker();
	super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
    local PlayerController PC;

	super.PostNetBeginPlay();

	if( Level.NetMode!=NM_DedicatedServer )
	{
        PC = Level.GetLocalPlayerController();
        if( PC != none && PC.Pawn != none )
        {
            LocalKFHumanPawn = KFHumanPawn(PC.Pawn);
        }
	}
}

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == 'Claw' || NewAction == MeleeAnims[0] || NewAction == MeleeAnims[1] || NewAction == MeleeAnims[2] )
	{
		UncloakStalker();
	}

	super.SetAnimAction(NewAction);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	if( Level.NetMode==NM_DedicatedServer )
		Return; // Servers aren't intrested in this info.

	if( Level.TimeSeconds > NextCheckTime && Health > 0 )
	{
		NextCheckTime = Level.TimeSeconds + 0.5;

        if( LocalKFHumanPawn != none && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
            VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
        {
			bSpotted = True;
		}
		else
		{
			bSpotted = false;
		}

		if ( !bSpotted && !bCloaked && Skins[0] != Texture'WTFTex.WTFZombies.Banshee') //&& Skins[0] != Combiner'KF_Specimens_Trip_T.stalker_cmb' 
		{
			UncloakStalker();
		}
		else if ( Level.TimeSeconds - LastUncloakTime > 1.2 )
		{
			// if we're uberbrite, turn down the light
			if( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )
			{
				bUnlit = false;
				CloakStalker();
			}
			else if ( Skins[0] != Shader'KF_Specimens_Trip_T.stalker_invisible' )
			{
				CloakStalker();
			}
		}
	}
}

// Cloak Functions ( called from animation notifies to save Gibby trouble ;) )

simulated function CloakStalker()
{
	if ( bSpotted )
	{
		if( Level.NetMode == NM_DedicatedServer )
			return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = true;
		return;
	}

	if ( !bDecapitated && !bCrispified ) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	{
		Visibility = 1;
		bCloaked = true;

		if( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Shader'KF_Specimens_Trip_T.stalker_invisible';
		Skins[1] = Shader'KF_Specimens_Trip_T.stalker_invisible';

		// Invisible - no shadow
		if(PlayerShadow != none)
			PlayerShadow.bShadowActive = false;
		if(RealTimeShadow != none)
			RealTimeShadow.Destroy();

		// Remove/disallow projectors on invisible people
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
	}
}

simulated function UnCloakStalker()
{
	if( !bCrispified )
	{
		LastUncloakTime = Level.TimeSeconds;

		Visibility = default.Visibility;
		bCloaked = false;

		// 25% chance of our Enemy saying something about us being invisible
		if( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
		 PlayerController(Controller.Enemy.Controller)!=none )
		{
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
			KFGameType(Level.Game).bDidStalkerInvisibleMessage = true;
		}
		if( Level.NetMode == NM_DedicatedServer )
			Return;

		if ( Skins[0] !=  Texture'WTFTex.WTFZombies.Banshee') //Combiner'KF_Specimens_Trip_T.stalker_cmb'
		{
			Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
			Skins[0] = Texture'WTFTex.WTFZombies.Banshee';

			if (PlayerShadow != none)
				PlayerShadow.bShadowActive = true;

			bAcceptsProjectors = true;

			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
		}
	}
}

function RemoveHead()
{
	Super.RemoveHead();

	if (!bCrispified)
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
		Skins[0] = Texture'WTFTex.WTFZombies.Banshee';
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType,HitLoc);

	if(bUnlit)
		bUnlit=!bUnlit;

    LocalKFHumanPawn = none;

	if (!bCrispified)
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
		Skins[0] = Texture'WTFTex.WTFZombies.Banshee';
	}
}

// Give her the ability to spring.
function bool DoJump( bool bUpdating )
{
	if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( (Level.Game != None) && (Level.Game.GameDifficulty > 2) )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && (Inventory != None) )
				Inventory.OwnerEvent('Jumped');
		}
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
		{
			Velocity.Z = Default.JumpZ;
			Velocity.X = (Default.JumpZ * 0.6);
		}
		else
		{
			Velocity.Z = JumpZ;
			Velocity.X = (JumpZ * 0.6);
		}
		if ( (Base != None) && !Base.bWorldGeometry )
		{
			Velocity.Z += Base.Velocity.Z;
			Velocity.X += Base.Velocity.X;
		}
		SetPhysics(PHYS_Falling);
		return true;
	}
	return false;
}

defaultproperties
{
	DetachedArmClass=Class'KFChar.SeveredArmStalker'
	DetachedLegClass=Class'KFChar.SeveredLegStalker'
	DetachedHeadClass=Class'KFChar.SeveredHeadStalker'
	Mesh=SkeletalMesh'KF_Freaks_Trip.Stalker_Freak'
	Skins(0)=Texture'WTFTex.WTFZombies.Banshee'
	Skins(1)=Shader'KF_Specimens_Trip_T.stalker_invisible'
}
