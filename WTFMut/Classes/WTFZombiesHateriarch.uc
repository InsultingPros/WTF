class WTFZombiesHateriarch extends ZombieBoss;

var float LastKnockDownTime, LastEyeLaserTime;
var int LastEyeLaserTimeMaxRandomCooldown, LastSneakedTimeMaxRandomCooldown, LastMissileTimeMaxRandomCooldown, LastChainGunTimeMaxRandomCooldown, LastChargeTimeMaxRandomCooldown, LastKnockDownTimeMaxRandomCooldown;
var int LastEyeLaserTimeMinCooldown, LastSneakedTimeMinCooldown, LastMissileTimeMinCooldown, LastChainGunTimeMinCooldown, LastChargeTimeMinCooldown, LastKnockDownTimeMinCooldown;

var float SneakDuration; //amount of time Hateriarch stays in Sneaking state

var float MissileDamageRadius;

var float ScariestDamageTaken;
var Pawn ScariestPlayer;

//overridden to alter HealingAmount
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( Role < ROLE_Authority )
	{
			return;
	}

	HealingAmount = Health/3;
}

//overridden to totally replace the cryptic code that was here before
//	previously you pretty much had to be bumping uglies with him before he would melee you
//	from within RangedAttack()
function bool IsCloseEnuf( Actor A )
{
	local float D;
	
	if( A==None )
	{
		//Log("WTFZombiesHateriarch: IsCloseEnuf(): A was None!");
		Return False;	
	}

	//Log("WTFZombiesHateriarch: IsCloseEnuf(): A="$String(A));
		
	D = VSize(A.Location-Location);
	
	//Log("WTFZombiesHateriarch: IsCloseEnuf(): D="$D);
	//Log("WTFZombiesHateriarch: IsCloseEnuf(): MyRange="$MeleeRange);
	
	//Log("WTFZombiesHateriarch: IsCloseEnuf(): returning "$(D <= MeleeRange));
	
	return D <= MeleeRange;
}

//overridden for logging
function NotifySyringeB()
{
    //log("Heal Part 2");
	if( Level.NetMode != NM_Client )
	{
		Health += HealingAmount;
		bHealed = true;
		//Log ("WTFZombiesHateriarch: NotifySyringeB(): Yay I healed! Health="$Health);
	}
}

//todo: override to account for new charge cooldown
function bool ShouldChargeFromDamage()
{
	if( !bChargingPlayer && LastChargeTime<Level.TimeSeconds )
    {
        return true;
    }

    return false;
}

function bool TryMissileAttack(Actor A, float D, float MinD)
{
	//Log ("WTFZombiesHateriarch: TryMissileAttack(): A="$String(A));
	//Log ("WTFZombiesHateriarch: TryMissileAttack(): D="$D);
	//Log ("WTFZombiesHateriarch: TryMissileAttack(): MinD="$MinD);
	
	if( LastMissileTime<Level.TimeSeconds && D < 4000 && D > MinD )
	{
		//Log ("WTFZombiesHateriarch: TryMissileAttack(): Shooting a rocket into someones face.");
		//Log ("WTFZombiesHateriarch: TryMissileAttack(): LastMissileTime="$LastMissileTime$",TimeSeconds="$Level.TimeSeconds);

		LastMissileTime = Level.TimeSeconds + LastMissileTimeMinCooldown + FRand() * LastMissileTimeMaxRandomCooldown;  //was * 15 at the end

		Controller.Target = A;
		Controller.Focus = A;
		
		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('PreFireMissile');

		HandleWaitForAnim('PreFireMissile');
		
		GoToState('FireMissile');
		
		return true;
	}
	
	return false;
}

function bool TryChaingunAttack(Actor A, float D, float MinD)
{
	//Log ("WTFZombiesHateriarch: TryChaingunAttack(): A="$String(A));
	//Log ("WTFZombiesHateriarch: TryChaingunAttack(): D="$D);
	//Log ("WTFZombiesHateriarch: TryChaingunAttack(): MinD="$MinD);
	
	//must be within certain range for accuracy considerations
	//must be a minimum distance away, so barrel doesn't noclip through whatever it is we're trying to shoot
	////took out '!bWaitForAnim && !bShotAnim && ' as it was causing him to never shoot shoot this :(
	if ( LastChainGunTime<Level.TimeSeconds && D < 3000 && D > MinD )
	{
		//Log ("WTFZombiesHateriarch: TryChaingunAttack(): Turning someone into swiss cheese with my minigun.");
		//Log ("WTFZombiesHateriarch: TryChaingunAttack(): LastChainGunTime="$LastChainGunTime$",TimeSeconds="$Level.TimeSeconds);
		
		LastChainGunTime = Level.TimeSeconds + LastChainGunTimeMinCooldown + FRand() * LastChainGunTimeMaxRandomCooldown; //was * 10 at the end

		Controller.Target = A;
		Controller.Focus = A;
		
		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('PreFireMG');

		HandleWaitForAnim('PreFireMG');
		MGFireCounter =  Rand(60) + 35;

		GoToState('FireChaingun');
		
		return true;
	}
		
	return false;
}

//based on FireMGShot in FireChaingun state
function bool TryEyeLaserAttack(Actor A, float D)
{
	//Log ("WTFZombiesHateriarch: TryEyeLaserAttack(): A="$String(A));
	//Log ("WTFZombiesHateriarch: TryEyeLaserAttack(): D="$D);
	
	if ( LastEyeLaserTime<Level.TimeSeconds && D < 700.0 )
	{
		LastEyeLaserTime = Level.TimeSeconds + LastEyeLaserTimeMinCooldown + FRand() * LastEyeLaserTimeMaxRandomCooldown; //was * 10 at the end
		
		if( Level.NetMode!=NM_DedicatedServer )
			AddLaserTraceHitFX(A.Location);

		A.TakeDamage(10,Self,A.Location,A.Location,class'SirenScreamDamage');
			
		return true;
	}
	return false;
}

simulated function AddLaserTraceHitFX( vector HitPos )
{
	local vector Start,SpawnVel,SpawnDir;
	local float hitDist;

	Start = GetBoneCoords('CHR_HeadBone_eyeball6').Origin;
	if( mTracer==None )
		mTracer = Spawn(Class'KFMod.KFNewTracer',,,Start);
	else mTracer.SetLocation(Start);
	if( mMuzzleFlash==None )
	{
		// KFTODO: Replace this
        mMuzzleFlash = Spawn(Class'MuzzleFlash3rdMG');
		AttachToBone(mMuzzleFlash, 'CHR_HeadBone_eyeball6');
	}
	else mMuzzleFlash.SpawnParticle(1);
	hitDist = VSize(HitPos - Start) - 50.f;

	if( hitDist>10 )
	{
		SpawnDir = Normal(HitPos - Start);
		SpawnVel = SpawnDir * 10000.f;
		mTracer.Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
		mTracer.Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
		mTracer.Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
		mTracer.Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
		mTracer.Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
		mTracer.Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;
		mTracer.Emitters[0].LifetimeRange.Min = hitDist / 10000.f;
		mTracer.Emitters[0].LifetimeRange.Max = mTracer.Emitters[0].LifetimeRange.Min;
		mTracer.SpawnParticle(1);
	}
	Instigator = Self;

	if( HitPos != vect(0,0,0) )
	{
        Spawn(class'ROBulletHitEffect',,, HitPos, Rotator(Normal(HitPos - Start)));
    }
}

function bool TryMeleeAttack(Actor A)
{
	//Log ("WTFZombiesHateriarch: TryMeleeAttack(): A="$String(A));
	
	if ( IsCloseEnuf(A) || A.IsA('KFDoorMover') )
	{
		Controller.Target = A;
		Controller.Focus = A;
		
		bShotAnim = true;
		if( Pawn(A)!=None && FRand() < 0.5 )
		{
			//Log ("WTFZombiesHateriarch: TryMeleeAttack(): Melee Impale!");
			SetAnimAction('MeleeImpale');
		}
		else
		{
			//Log ("WTFZombiesHateriarch: TryMeleeAttack(): Melee Claw!");
			SetAnimAction('MeleeClaw');
			//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
		}
		
		if ( A.IsA('KFDoorMover') && FRand() < 0.3 )
		{
			//Log ("WTFZombiesHateriarch: TryMeleeAttack(): Cracking this door open wide!");
			A.TakeDamage(1000, self ,A.Location,vect(0,0,0), CurrentDamType);
		}
				
		return true;
	}
	
	return false;
}

function bool TryCharge()
{
	if(
		!bChargingPlayer && LastChargeTime<Level.TimeSeconds && !IsInState('Charging') && 
		!IsInState('KnockDown') && !IsInState('Escaping') && !IsInState('SneakAround')
	  )
	{
		//Log ("WTFZombiesHateriarch: TryCharge(): Charging!");
		//Log ("WTFZombiesHateriarch: TryCharge(): LastChargeTime="$LastChargeTime$",TimeSeconds="$Level.TimeSeconds);
		LastChargeTime = Level.TimeSeconds + LastChargeTimeMinCooldown + FRand() * LastChargeTimeMaxRandomCooldown; //Level.TimeSeconds;
		SetAnimAction('transition');
		GoToState('Charging');
		
		return true;
	}
	
	return false;
}

function bool TrySneak()
{
	if (
		LastSneakedTime<Level.TimeSeconds && 
		!IsInState('FireChaingun') && !IsInState('FireMissile') && !IsInState('Charging') && 
		!IsInState('KnockDown') && !IsInState('Escaping') && !IsInState('SneakAround')
		)
	{
		//Log ("WTFZombiesHateriarch: TrySneak(): Cloaking.");
		//Log ("WTFZombiesHateriarch: TrySneak(): LastSneakedTime="$LastSneakedTime$",TimeSeconds="$Level.TimeSeconds);
		LastSneakedTime = Level.TimeSeconds + LastSneakedTimeMinCooldown + FRand() * LastSneakedTimeMaxRandomCooldown; //Level.TimeSeconds;
		SetAnimAction('transition');
		GoToState('SneakAround');
		
		return true;
	}
	
	return false;
}

//called from TakeDamage()- Check to see if we need (and have syringes left) to heal after being damaged
function bool TryHealing()
{
	if( SyringeCount < 3 && Health < HealingLevels[SyringeCount] )
	{
	    //log(GetStateName()$" Took damage and want to heal!!! Health="$Health$" HealingLevels "$HealingLevels[SyringeCount]);
		//Log ("WTFZombiesHateriarch: TakeDamage(): I want to heal! Health="$Health);
		
		//The Hateriarch can't be stunlocked on his knees forever;
		//whenever he gets knocked down, there's a random cooldown time before he can be knocked down again
		
		//If we haven't been knocked down recently, take a knee
		//Otherwise, stop the Hateriarch from getting trapped on his knees when he needs to run off and heal
		if (LastKnockDownTime<Level.TimeSeconds)
		{
			//Log ("WTFZombiesHateriarch: TakeDamage(): I got knocked down :(");
			//Log ("WTFZombiesHateriarch: TakeDamage(): LastKnockDownTime="$LastKnockDownTime$",TimeSeconds="$Level.TimeSeconds);
			LastKnockDownTime = Level.TimeSeconds + LastKnockDownTimeMinCooldown + FRand() * LastKnockDownTimeMaxRandomCooldown;
			
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('KnockDown');
			HandleWaitForAnim('KnockDown');
			KFMonsterController(Controller).bUseFreezeHack = True;
			GoToState('KnockDown');
		}
		else
		{
			//Log ("WTFZombiesHateriarch: TakeDamage(): I cant be knocked down again yet. Im outta here suckers!");
			//code from ZombieBoss State KnockDown
			PlaySound(sound'KF_EnemiesFinalSnd.Patriarch.Kev_SaveMe', SLOT_Misc, 2.0,,500.0);
			if( KFGameType(Level.Game).FinalSquadNum == SyringeCount )
			{
			   KFGameType(Level.Game).AddBossBuddySquad();
			}
			GotoState('Escaping');
		}
		
		return true;
	}
	
	return false;
}

function bool TryAttackMineFromSafeDistance(Actor A)
{
	local WTFEquipPipeBombProj Mine;
	local float D,MinSafeD;
	
	Mine = WTFEquipPipeBombProj(A);
	if (Mine == None)
	{
		//Log ("WTFZombiesHateriarchController: TryAttackMineFromSafeDistance(): could not cast to custom pipebomb, returning false!");
		return false;
	}
		
	D = VSize(A.Location-Location);
	
	//establish how far away we have to be to not take damage from this thing when it blows up
	MinSafeD = FMax(MinSafeD, MissileDamageRadius);
	
	//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): damage radius of mine is "$Mine.DamageRadius);
	//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): MinSafeD is "$MinSafeD);
	//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): I am this far away from the mine: "$D);
	//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): trying missile");
	
	//try to shoot it with something from a safe distance first...
	if ( !TryMissileAttack(A,D,MinSafeD) )
	{
		//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): missile failed, trying chaingun");
		
		MinSafeD = Mine.DamageRadius + (CollisionRadius * 2);
		if ( !TryChaingunAttack(A,D,MinSafeD) )
		{
			//Log ("WTFZombiesHateriarch: TryAttackMineFromSafeDistance(): chaingun failed, returning false");
			return false;
		}
	}
	
	return true;
}

//overriden to support random, reactive cloaking to being damaged
//also implements some other behavioral changes
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local float UsedPipeBombDamScale;

    // Scale damage from the pipebomb down a bit if lots of pipe bomb damage happens
    // at around the same times. Prevent players from putting all thier pipe bombs
    // in one place and owning the patriarch in one blow.
	if ( class<DamTypePipeBomb>(damageType) != none )
	{
	   UsedPipeBombDamScale = FMax(0,(1.0 - PipeBombDamageScale));

	   PipeBombDamageScale += 0.075;

	   if( PipeBombDamageScale > 1.0 )
	   {
	       PipeBombDamageScale = 1.0;
	   }

	   Damage *= UsedPipeBombDamScale;
	}
	else If (Damage > ScariestDamageTaken) {
		ScariestDamageTaken = Damage;
		ScariestPlayer = InstigatedBy;
	}

    Super(KFMonster).TakeDamage(Damage,instigatedBy,hitlocation,Momentum,damageType);

	//TODO: What is this used for exactly anymore?
    if( Level.TimeSeconds - LastDamageTime > 10 )
    {
        ChargeDamage = 0;
    }
    else
    {
        LastDamageTime = Level.TimeSeconds;
        ChargeDamage += Damage;
    }

	//removed SyringeCount check so he doesn't stop doing behaviors further down when he's out of syringes
	if( Health<=0 || IsInState('Escaping') || IsInState('KnockDown') )
		Return;

	if ( TryHealing() )
		return;
	
	if( InstigatedBy != none )
	{
		if ( TrySneak() )
		{
			return;
		}
	}
	
	//edit: no distance checks on charging;
	//	if we couldn't take any of the earlier forms of retaliation and charging isn't on cooldown,
	//	don't just casually walk around getting shot- CHARGE!
	if ( ShouldChargeFromDamage() )
	{
		if( InstigatedBy != none )
		{
			if ( TryCharge() )
			{
				return;
			}
		}
	}
}

//overriden to shoot MG and Rocket more frequently
//Checks to fire Rocket, then MG before checking to melee or charge
//max distance check added to MG evaluation; target must be < 1500 away;
//	may need to tweak this up or down, want it to be within accurate range of the MG, otherwise he should try to get closer
function RangedAttack(Actor A)
{
	local float D;

	if ( bShotAnim || Controller.IsInState('WaitingForLanding') )
		return;
	
	D = VSize(A.Location-Location);

	//Log ("WTFZombiesHateriarch: RangedAttack(): called in state "$GetStateName());
	//Log ("WTFZombiesHateriarch: RangedAttack(): Controller is in state "$Controller.GetStateName());
	
	if ( A.IsA('KFHumanPawn') )
	{
		//yay, uscript apparently supports short-circuted evaluation of OR statements,
		//so this only does the first one available instead of all available.
		if	(
				TryMissileAttack(A,D,MissileDamageRadius) ||
				TryChainGunAttack(A,D,150.0) ||
				TryMeleeAttack(A)
			)
		{
			if( bCloaked )
			{
				//Log ("WTFZombiesHateriarch: RangedAttack(): uncloaking because I attacked.");
				UnCloakBoss();
				bCloaked=False; //just make sure...
			}
			return;
		}
		else if (
				TryCharge() ||
				TrySneak()
				)
				return;
	}
	else if ( A.IsA('WTFEquipPipeBombProj') )
	{
		if ( TryEyeLaserAttack(A,D) )
			return;
			
		if ( !IsInState('Escaping') )
		{
			if ( TryAttackMineFromSafeDistance(A) )
				return;
			else
			{
				//Log ("WTFZombiesHateriarch: RangedAttack(): failed to destroy Mine from a distance. Trying to avoid. State="$GetStateName());
				/*
				Avoidance is already handled natively because the WTFZombiesAIWarnSpot calls controller's FearThisSpot for us
				however, if it can't be pathed around, native behavior switches to ignoring the warn spot :(
				*/
				
				return;
			}
		}
	}
	else if ( A.IsA('KFDoorMover') )
	{
		if	(
				TryMissileAttack(A,D,MissileDamageRadius) ||
				TryChainGunAttack(A,D,150.0)
			)
			return;
		else
		{
			TryMeleeAttack(A);
			return;
		}
	}
}

/*********************************************************************************

	STATES & STATE-RELATED FUNCTIONS

*********************************************************************************/

/*
	CLOAKED AND SNEAKIN' AROUND
	overridden to not set LastSneakedTime during EndState
*/
State SneakAround //extends Escaping // Attempt to sneak around.
{
	function RangedAttack(Actor A)
	{
		Global.RangedAttack(A);
	}
	
	//from Escaping
	function EndState()
	{
        GroundSpeed = GetOriginalGroundSpeed();
		bChargingPlayer = False;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();
		if( bCloaked )
			UnCloakBoss();
	}

Begin:
	CloakBoss();
	While( true )
	{
		Sleep(0.5);

		if( Level.TimeSeconds - SneakStartTime > SneakDuration )
		{
            GoToState('');
		}

		if( !bCloaked && !bShotAnim )
			CloakBoss();
		if( !Controller.IsInState('ZombieHunt') && !Controller.IsInState('WaitForAnim') )
		{
        	Controller.GoToState('ZombieHunt');
        }
	}
}

/*
	RUNNING FOR MY LIFE
*/
State Escaping //extends Charging // Got hurt and running away...
{
	function RangedAttack(Actor A)
	{
		Global.RangedAttack(A);
	}

	function Tick( float Delta )
	{
		//haul ass!
		bChargingPlayer = True;
		GroundSpeed = OriginalGroundSpeed * 2.5;
		Global.Tick(Delta);
	}
}

/*
	INTERACTING WITH DOORS 
*/
//overriden to call RangedAttack() instead of going into missile firing
//	because: minimum distance gets checked in RangedAttack() firing missiles...let's not have the Hateriarch blowing himself up
//This function is called repeatedly from controller class from code inherited from KFMonsterController's
//	DoorBashing state, AttackDoor() function
function DoorAttack(Actor A)
{
	if ( A!=None )
	{
		//Log("WTFZombiesHateriarch: DoorAttack(): calling RangedAttack()");
		RangedAttack(A);
	}
}

/*
	CHAINGUN
*/
//overriden to support shooting at mine-type hazards set down by players (PipeBombs and Proximity Mines)
state FireChaingun
{
	function RangedAttack(Actor A)
	{
		Controller.Target = A;
		Controller.Focus = A;
	}

    // Chaingun mode handles this itself
    function bool ShouldChargeFromDamage()
    {
        return false;
    }

    function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
    {
		local float DamagerDistSq;
		
        global.TakeDamage(Damage,instigatedBy,hitlocation,vect(0,0,0),damageType);

        if( InstigatedBy != none )
        {
			DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);
			
			if ( DamagerDistSq < (400 * 400) )
			{
                SetAnimAction('transition');
        		GoToState('Charging');
			}
			else
			{
				//turn 'em into swiss cheese
				RangedAttack(InstigatedBy);
			}
        }
    }

	function EndState()
	{
        TraceHitPos = vect(0,0,0);
		bMinigunning = False;

        AmbientSound = default.AmbientSound;
        SoundVolume=default.SoundVolume;
        SoundRadius=default.SoundRadius;
        MGFireCounter=0;
	}

	function BeginState()
	{
        bFireAtWill = False;
		Acceleration = vect(0,0,0);
		MGLostSightTimeout = 0.0;
		bMinigunning = True;
	}

	function AnimEnd( int Channel )
	{
		if( MGFireCounter <= 0 )
		{
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
		}
		else
		{
			//is this necessary? ...|| !Controller.Target.IsA('WTFEquipPipeBombProj')
			//	Target is being set to the Mine or Door
			if ( Controller.Target == None )
			{
				if ( Controller.Enemy != none )
				{
					if ( Controller.LineOfSightTo(Controller.Enemy) && FastTrace(GetBoneCoords('tip').Origin,Controller.Enemy.Location))
					{
						MGLostSightTimeout = 0.0;
						Controller.Focus = Controller.Enemy;
						Controller.FocalPoint = Controller.Enemy.Location;
					}
					else
					{
						MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
						Controller.Focus = None;
					}

					Controller.Target = Controller.Enemy;
				}
				else
				{
					MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
					Controller.Focus = None;
				}
			}

			if( !bFireAtWill )
			{
                MGFireDuration = Level.TimeSeconds + (0.75 + FRand() * 0.5);
			}
			else if ( FRand() < 0.03 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
			{
				// Randomly send out a message about Patriarch shooting chain gun(3% chance)
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 9, "");
			}

			bFireAtWill = True;
			bShotAnim = true;
			Acceleration = vect(0,0,0);

			SetAnimAction('FireMG');
			bWaitForAnim = true;
		}
	}

	function FireMGShot()
	{
		local vector Start,End,HL,HN,Dir;
		local rotator R;
		local Actor A;

		MGFireCounter--;

        if( AmbientSound != MiniGunFireSound )
        {
            SoundVolume=255;
            SoundRadius=400;
            AmbientSound = MiniGunFireSound;
        }

		Start = GetBoneCoords('tip').Origin;
		if( Controller.Focus!=None )
			R = rotator(Controller.Focus.Location-Start);
		else R = rotator(Controller.FocalPoint-Start);
		if( NeedToTurnFor(R) )
			R = Rotation;
		// KFTODO: Maybe scale this accuracy by his skill or the game difficulty
		Dir = Normal(vector(R)+VRand()*0.03); //was .06, so he should be significantly more accurate with this
		End = Start+Dir*10000;

        // Have to turn of hit point collision so trace doesn't hit the Human Pawn's bullet whiz cylinder
        bBlockHitPointTraces = false;
		A = Trace(HL,HN,End,Start,True);
		bBlockHitPointTraces = true;

		if( A==None )
			Return;
		TraceHitPos = HL;
		if( Level.NetMode!=NM_DedicatedServer )
			AddTraceHitFX(HL);

		if( A!=Level )
		{
        	A.TakeDamage(MGDamage+Rand(3),Self,HL,Dir*500,Class'DamageType');
		}
	}

	function bool NeedToTurnFor( rotator targ )
	{
		local int YawErr;

		targ.Yaw = DesiredRotation.Yaw & 65535;
		YawErr = (targ.Yaw - (Rotation.Yaw & 65535)) & 65535;
		return !((YawErr < 2000) || (YawErr > 64535));
	}

Begin:
	While( True )
	{
		Acceleration = vect(0,0,0);

        if( MGLostSightTimeout > 0 && Level.TimeSeconds > MGLostSightTimeout )
        {
            bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
        }

		if( MGFireCounter <= 0 )
		{
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
		}

		// Give some randomness to the patriarch's firing
		if( Level.TimeSeconds > MGFireDuration )
		{
            if( AmbientSound != MiniGunSpinSound )
            {
                SoundVolume=185;
                SoundRadius=200;
                AmbientSound = MiniGunSpinSound;
            }
            Sleep(0.5 + FRand() * 0.75);
            MGFireDuration = Level.TimeSeconds + (0.75 + FRand() * 0.5);
		}
		else
		{
            if( bFireAtWill )
    			FireMGShot();
    		Sleep(0.05);
		}
	}
}

/*
	MISSILE
*/
//overridden to fire a much faster, higher damage rocket
state FireMissile
{
Ignores RangedAttack;

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

	function BeginState()
	{
        Acceleration = vect(0,0,0);
	}

	function AnimEnd( int Channel )
	{
		local vector Start;
		local Rotator R;

		Start = GetBoneCoords('tip').Origin;

		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = 0.15;
			SavedFireProperties.MaxRange = 10000;
			SavedFireProperties.bTossed = False;
			SavedFireProperties.bTrySplash = True;
			SavedFireProperties.bLeadTarget = True;
			SavedFireProperties.bInstantHit = False;
			SavedFireProperties.bInitialized = true;
		}

		R = AdjustAim(SavedFireProperties,Start,0); //last param = AimError, was 100
		PlaySound(RocketFireSound,SLOT_Interact,2.0,,TransientSoundRadius,,false);
		Spawn(Class'WTFZombiesHateriarchRocketProj',,,Start,R);

		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('FireEndMissile');
		HandleWaitForAnim('FireEndMissile');

		// Randomly send out a message about Patriarch shooting a rocket(5% chance)
		if ( FRand() < 0.05 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
		{
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 10, "");
		}

		GoToState('');
	}
Begin:
	while ( true )
	{
		Acceleration = vect(0,0,0);
		Sleep(0.1);
	}
}

/*
	CHARGING
*/
state Charging
{
    // Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

	function BeginState()
	{
        bChargingPlayer = True;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();

		// How many charge attacks we can do randomly 1-3
		NumChargeAttacks = Rand(2) + 1;
	}

	function EndState()
	{
        GroundSpeed = GetOriginalGroundSpeed();
		bChargingPlayer = False;
		ChargeDamage = 0;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();
	}

	function Tick( float Delta )
	{

        if( NumChargeAttacks <= 0 )
        {
            GoToState('');
        }

        // Keep the flesh pound moving toward its target when attacking
    	if( Role == ROLE_Authority && bShotAnim)
    	{
    		if( bChargingPlayer )
    		{
                bChargingPlayer = false;
        		if( Level.NetMode!=NM_DedicatedServer )
        			PostNetReceive();
    		}
            GroundSpeed = OriginalGroundSpeed * 0.9; //slow down just a tad, give players a slim chance to get out of the way if they're quick on the draw
            if( LookTarget!=None )
    		{
    		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    		}
        }
        else
        {
    		if( !bChargingPlayer )
    		{
                bChargingPlayer = true;
        		if( Level.NetMode!=NM_DedicatedServer )
        			PostNetReceive();
    		}

            GroundSpeed = OriginalGroundSpeed * 2.0; //really freakin' fast!
        }


		Global.Tick(Delta);
	}

	function bool MeleeDamageTarget(int hitdamage, vector pushdir)
	{
		local bool RetVal;

        NumChargeAttacks--;

		RetVal = Global.MeleeDamageTarget(hitdamage, pushdir*1.5);
		if( RetVal )
			GoToState('');
		return RetVal;
	}

Begin:
	Sleep(8); //was 6; charge a little bit longer than that
	GoToState('');
}

/*********************************************************************************

	GAMETYPE-RELATED FUNCTIONS

*********************************************************************************/

// Creapy endgame camera when the evil wins.
function bool SetBossLaught()
{
	local Controller C;
	
	GoToState('');
	bShotAnim = true;
	Acceleration = vect(0,0,0);
	SetAnimAction('VictoryLaugh');
	HandleWaitForAnim('VictoryLaugh');
	bIsBossView = True;
	bSpecialCalcView = True;
		
	For( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if( PlayerController(C)!=None )
		{
			PlayerController(C).SetViewTarget(Self);
			PlayerController(C).ClientSetViewTarget(Self);
			PlayerController(C).ClientSetBehindView(True);
			PlayerController(C).ClientMessage("The HATERIARCH had " $ Health $ " left.");
		}
	}
	Return True;
}

defaultproperties
{
	//EyeLaser is only used on PipeBombs so it's ok for pretty short cooldown
	LastEyeLaserTimeMinCooldown=1
	LastEyeLaserTimeMaxRandomCooldown=3
	
	LastSneakedTimeMinCooldown=2
	LastSneakedTimeMaxRandomCooldown=10
	SneakDuration=10.000000
	
	LastMissileTimeMinCooldown=5
	LastMissileTimeMaxRandomCooldown=30
	MissileDamageRadius=400.0 //used for aiming splash damage
	
	LastChainGunTimeMinCooldown=5
	LastChainGunTimeMaxRandomCooldown=20
	MGDamage=10.0
	
	LastChargeTimeMinCooldown=5
	LastChargeTimeMaxRandomCooldown=30
	MeleeRange=85.000000
	ClawMeleeDamageRange=85
	ImpaleMeleeDamageRange=45
	MeleeDamage=60
	GroundSpeed=180.000000
	WaterSpeed=180.000000
	
	LastKnockDownTimeMinCooldown=10
	LastKnockDownTimeMaxRandomCooldown=60
	
	JumpZ=400.000000
	HealthMax=5500.0
	Health=5500.0
	HeadHealth=5500.0
	PlayerNumHeadHealthScale=0.750000
	
	MenuName="The Hateriarch"
	ControllerClass=Class'WTF.WTFZombiesHateriarchController'
	Mesh=SkeletalMesh'KF_Freaks_Trip.Patriarch_Freak'
}
