class WTFZombiesMauler extends ZombieScrake;

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	SetBoneScale(2,1.3,'Chainsaw_lod1'); //chainsaw
}

function RangedAttack(Actor A)
{
	if ( bShotAnim || Physics == PHYS_Swimming)
		return;
	else if ( CanAttack(A) )
	{
		bShotAnim = true;
		SetAnimAction(MeleeAnims[Rand(2)]);
		CurrentDamType = ZombieDamType[0];
		//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
		GoToState('SawingLoop');
	}

	if( !bShotAnim && !bDecapitated ) //he's coming to get you
		GoToState('RunningState');
}

state RunningState
{
	// Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

	function BeginState()
	{
		GroundSpeed = OriginalGroundSpeed * AttackChargeRate;
		bCharging = true;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function EndState()
	{
		GroundSpeed = GetOriginalGroundSpeed();
		bCharging = False;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();
	}

	function RemoveHead()
	{
		GoToState('');
		Global.RemoveHead();
	}

    function RangedAttack(Actor A)
    {
    	if ( bShotAnim || Physics == PHYS_Swimming)
    		return;
    	else if ( CanAttack(A) )
    	{
    		bShotAnim = true;
    		SetAnimAction(MeleeAnims[Rand(2)]);
    		CurrentDamType = ZombieDamType[0];
    		GoToState('SawingLoop');
    	}
    }
}

State SawingLoop
{
	// Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

	function BeginState()
	{
		GroundSpeed = OriginalGroundSpeed * AttackChargeRate;
		bCharging = true;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function RangedAttack(Actor A)
	{
		if ( bShotAnim )
			return;
		else if ( CanAttack(A) )
		{
			Acceleration = vect(0,0,0);
			bShotAnim = true;
			MeleeDamage = default.MeleeDamage*0.6;
			SetAnimAction('SawImpaleLoop');
			CurrentDamType = ZombieDamType[0];
			if( AmbientSound != SawAttackLoopSound )
			{
                AmbientSound=SawAttackLoopSound;
			}
		}
		else GoToState('');
	}
	function AnimEnd( int Channel )
	{
		Super.AnimEnd(Channel);
		if( Controller!=None && Controller.Enemy!=None )
			RangedAttack(Controller.Enemy); // Keep on attacking if possible.
	}

	function Tick( float Delta )
	{
        // Keep the scrake moving toward its target when attacking
    	if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
    	{
    		if( LookTarget!=None )
    		{
    		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    		}
        }

		global.Tick(Delta);
	}

	function EndState()
	{
		AmbientSound=default.AmbientSound;
		MeleeDamage= default.MeleeDamage;

		GroundSpeed = GetOriginalGroundSpeed();
		bCharging = False;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();
	}
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	//local int StunChance;

	//StunChance = rand(5);

	if( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
		return;

	//our good fellow the mauler cannot be stunned in this fashion
	//if( Damage>=150 || (DamageType.name=='DamTypeStunNade' && StunChance>3) || (DamageType.name=='DamTypeCrossbowHeadshot' && Damage>=200) )
	//	PlayDirectionalHit(HitLocation);

	LastPainAnim = Level.TimeSeconds;

	if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
		return;

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

defaultproperties
{
	AttackChargeRate=2.000000
	HeadHealth=1000.000000
	GroundSpeed=180.000000
	HealthMax=1500.000000
	Health=1500
	MenuName="Mauler"
	Mesh=SkeletalMesh'KF_Freaks_Trip.Scrake_Freak'
	Skins(0)=Texture'WTFTex.WTFZombies.Mauler'
	Skins(1)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
}
