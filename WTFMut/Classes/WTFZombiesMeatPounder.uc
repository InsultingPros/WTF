class  WTFZombiesMeatPounder extends ZombieFleshPound;

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	SetHeadScale(0.5);
	SetBoneScale(2,1.75,'rarm'); //let's put some big beefy arms on there...
	SetBoneScale(3,1.75,'larm');
}

// NO BONUSES OR RESISTANCES
simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex )
{
	//FFFFFFFFFFFUUUUUUUUUUU ANGRYYYYYYYYY
	if ( !bDecapitated && !bChargingPlayer && !bFrustrated)
	{
		bFrustrated=True;
		StartCharging();
	}
	
	Super(KFMonster).TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,damageType,HitIndex);
}

state RageCharging
{
Ignores StartCharging;

    function PlayDirectionalHit(Vector HitLoc)
    {
        if( !bShotAnim )
        {
            super.PlayDirectionalHit(HitLoc);
        }
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

    // Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

	function BeginState()
	{
        local float DifficultyModifier;

        bChargingPlayer = true;
		if( Level.NetMode!=NM_DedicatedServer )
			ClientChargingAnims();

        // Scale rage length by difficulty
        if( Level.Game.GameDifficulty < 2.0 )
        {
            DifficultyModifier = 0.85;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            DifficultyModifier = 1.0;
        }
        else if( Level.Game.GameDifficulty < 7.0 )
        {
            DifficultyModifier = 1.25;
        }
        else // Hardest difficulty
        {
            DifficultyModifier = 1.5;
        }

		RageEndTime = (Level.TimeSeconds + 5 * DifficultyModifier) + (FRand() * 6 * DifficultyModifier);
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function EndState()
	{
        bChargingPlayer = False;
        bFrustrated = false;

        FleshPoundZombieController(Controller).RageFrustrationTimer = 0;

		if( Health>0 )
		{
			GroundSpeed = GetOriginalGroundSpeed();
		}

		if( Level.NetMode!=NM_DedicatedServer )
			ClientChargingAnims();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function Tick( float Delta )
	{
		if( !bShotAnim )
		{
			GroundSpeed = OriginalGroundSpeed * 2.3;//2.0;
			if( !bFrustrated && !bZedUnderControl && Level.TimeSeconds>RageEndTime )
			{
            	GoToState('');
			}
		}

        // Keep the flesh pound moving toward its target when attacking
    	if( Role == ROLE_Authority && bShotAnim)
    	{
    		if( LookTarget!=None )
    		{
    		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    		}
        }

        global.Tick(Delta);
	}

	function Bump( Actor Other )
	{
        local float RageBumpDamage;
        //local KFMonster KFMonst;

        //KFMonst = KFMonster(Other);

        // push human pawns and zombies out of the way!
        if( !bShotAnim && (KFMonster(Other)!=None || KFHumanPawn(Other)!=None) && ZombieFleshPound(Other)==None && Pawn(Other).Health>0 )
		{
			RageBumpDamage = 0;

			Other.TakeDamage(RageBumpDamage, self, Other.Location, Velocity * Other.Mass, class'DamTypePoundCrushed');
		}
		else Global.Bump(Other);
	}
	// If fleshie hits his target on a charge, then he should settle down for abit.
	function bool MeleeDamageTarget(int hitdamage, vector pushdir)
	{
		local bool RetVal,bWasEnemy;

		bWasEnemy = (Controller.Target==Controller.Enemy);
		
		//hitdamage and pushdir are both multiplied in ZombieFleshPound so don't mult them here!
		//Skipping Super(ZombieFleshPound) so damage doesn't get double-multiplied!
		RetVal = Super(KFMonster).MeleeDamageTarget(hitdamage*1.75, pushdir*1.75);
		if( RetVal && bWasEnemy )
			GoToState('');
		return RetVal;
	}
}

defaultproperties
{
	RageDamageThreshold=1
	damageForce=100000
	ColRadius=18.000000
	ColHeight=17.000000
	SeveredArmAttachScale=2.275000
	OnlineHeadshotScale=0.650000
	HeadHealth=1250.000000
	MeleeRange=96.250000
	HealthMax=1750.000000
	Health=1750
	MenuName="Meat Pounder"
	Mesh=SkeletalMesh'KF_Freaks_Trip.FleshPound_Freak'
	Skins(0)=Texture'WTFTex.WTFZombies.MeatPounder'
	Skins(1)=Shader'KFCharacters.FPAmberBloomShader'
}
