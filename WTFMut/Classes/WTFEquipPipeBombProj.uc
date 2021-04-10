class WTFEquipPipeBombProj extends PipeBombProjectile;

var WTFZombiesAIWarnSpot WarnSpot;
var WTFZombiesAIAvoidSpot AvoidSpot;
var bool bQuiet;

//Timer isn't called until Landed()
function Timer()
{
	local Pawn CheckPawn;
	local float ThreatLevel;
	
	if (WarnSpot == None)
	{
		WarnSpot = Spawn(Class'WTFZombiesAIWarnSpot');
		WarnSpot.MyProjectile=Self;
	}
	if (AvoidSpot == None)
	{
		AvoidSpot = Spawn(Class'WTFZombiesAIAvoidSpot');
		AvoidSpot.MyProjectile=Self;
	}

    if( !bHidden && !bTriggered )
    {
        if( ArmingCountDown >= 0 )
        {
            ArmingCountDown -= 0.1;
            if( ArmingCountDown <= 0 )
            {
                SetTimer(1.0,True);
            }
    	}
    	else
    	{
            // Check for enemies
            if( !bEnemyDetected )
            {
                bAlwaysRelevant=false;
				if (BeepSound != None)
					PlaySound(BeepSound,,0.5,,50.0);

            	foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DetectionRadius, Location )
            	{
            		if( CheckPawn == Instigator || KFGameType(Level.Game).FriendlyFireScale > 0 &&
                        CheckPawn.PlayerReplicationInfo != none &&
                        CheckPawn.PlayerReplicationInfo.Team.TeamIndex == PlacedTeam )
                    {
                        // Make the thing beep if someone on our team is within the detection radius
                        // This gives them a chance to get out of the way
                        ThreatLevel += 0.001;
                    }
                    else
                    {
                        if( (CheckPawn != Instigator) && (CheckPawn.Role == ROLE_Authority) &&
                            CheckPawn.PlayerReplicationInfo == none || CheckPawn.PlayerReplicationInfo.Team.TeamIndex != PlacedTeam )
                		{
                            if( KFMonster(CheckPawn) != none )
                            {
                                ThreatLevel += KFMonster(CheckPawn).MotionDetectorThreat;
                                if( ThreatLevel >= ThreatThreshhold )
                                {
                                    bEnemyDetected=true;
                                    SetTimer(0.15,True);
                                }
                            }
                            else
                            {
                                bEnemyDetected=true;
                                SetTimer(0.15,True);
                            }
                		}
            		}

            	}

                if( ThreatLevel >= ThreatThreshhold )
                {
                    bEnemyDetected=true;
                    SetTimer(0.15,True);
                }
                else if( ThreatLevel > 0 )
                {
                    SetTimer(0.5,True);
                }
                else
                {
                    SetTimer(1.0,True);
                }
        	}
        	// Play some fast beeps and blow up
        	else
        	{
                bAlwaysRelevant=true;
                Countdown--;

                if( CountDown > 0 )
                {
					if (BeepSound != None)
						PlaySound(BeepSound,SLOT_Misc,2.0,,150.0);
                }
                else
                {
                    Explode(Location, vector(Rotation));
                }
        	}
    	}
	}
	else
	{
        Destroy();
	}
}

//straight from PipeBombProjectile
//play lower-volume sound if we were blown up by another explosive
simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController  LocalPlayer;
	local Projectile P;
	local byte i;

	if (bHasExploded)
		Return;
		
	bHasExploded = True;
	BlowUp(HitLocation);

    bTriggered = true;

	if( Role == ROLE_Authority )
	{
	   SetTimer(0.1, false);
	   NetUpdateTime = Level.TimeSeconds - 1;
	}

	if (bQuiet)
		PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,0.5);
	else
		PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,2.0);

	// Shrapnel
	for( i=Rand(6); i<10; i++ )
	{
		P = Spawn(ShrapnelClass,,,,RotRand(True));
		if( P!=None )
			P.RemoteRole = ROLE_None;
	}
	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFMod.KFNadeLExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

	// Clear Explosive Detonation Flag
//	if ( KFPlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(KFPlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
//	{
//		KFSteamStatsAndAchievements(KFPlayerController(Instigator.Controller).SteamStatsAndAchievements).OnGrenadeExploded();
//	}

    if( Role < ROLE_Authority )
    {
	   Destroy();
	}
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    // only take damage from Instigator or Zeds, never from squad mates
    if( InstigatedBy != Instigator && KFMonster(InstigatedBy) == None )
    {
        return;
    }
	
	//was hitlocation in both of these...
    if( damageType == class'SirenScreamDamage')
    {
		Disintegrate(Location, vect(0,0,1));
    }
    else
    {
		if (Class<KFWeaponDamageType>(damageType).default.bIsExplosive)
			bQuiet=True; //don't be as loud
        Explode(Location, vect(0,0,1));
    }
	
	Destroy(); //being a little paranoid here...
}

simulated function Destroyed()
{
	if (WarnSpot != None)
	{
		WarnSpot.Destroy();
	}
	if (AvoidSpot != None)
	{
		AvoidSpot.Destroy();
	}
	Super.Destroyed();
}

defaultproperties
{
}
