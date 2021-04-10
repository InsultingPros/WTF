class WTFEquipLethalInjectionProj extends WTFEquipFirehoseFmAProj;

var() KFMonster StuckTo;
var() float SlowedGroundSpeed, DefaultGroundSpeed, ReduceSpeedTo;
var() bool bSlowPoison;

simulated function PostBeginPlay();

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Destroy();
}

simulated function Landed( vector HitNormal )
{
	Destroy();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation);

simulated function Destroyed();

function Timer()
{
	if (StuckTo != None)
	{
		if (StuckTo.Health <= 0)
			Destroy();
			
		if (ROLE == ROLE_Authority)
		{
			StuckTo.TakeDamage(Damage, Instigator, StuckTo.Location, MomentumTransfer * Normal(Velocity), MyDamageType);
			
			if (bSlowPoison) //only is true if I was fired by a field medic
			{
				/*
				Only slow them down if they are faster than our penalty.
				This is so we don't accidentally speed them back up if they are under
				a worse penalty than ours- such as the one Stun Grenades apply.
				*/
				if (StuckTo.OriginalGroundSpeed > SlowedGroundSpeed)
					if (!StuckTo.IsA('ZombieBoss'))
						StuckTo.OriginalGroundSpeed=SlowedGroundSpeed;
					else
					{
						StuckTo.OriginalGroundSpeed=DefaultGroundSpeed * FMin(ReduceSpeedTo*2.0,1.0);
					}
			
				if (LifeSpan <= 1.0)
					StuckTo.OriginalGroundSpeed=DefaultGroundSpeed;
			}
		}
	}
}

function SetSpeeds()
{
	local float MovementSpeedDifficultyScale;
	
	//straight from kfmonster
	if( Level.Game.GameDifficulty < 2.0 )
	{
		MovementSpeedDifficultyScale = 0.95;
	}
	else if( Level.Game.GameDifficulty < 4.0 )
	{
		MovementSpeedDifficultyScale = 1.0;
	}
	else if( Level.Game.GameDifficulty < 7.0 )
	{
		MovementSpeedDifficultyScale = 1.15;
	}
	else // Hardest difficulty
	{
		MovementSpeedDifficultyScale = 1.3;
	}
	
	DefaultGroundSpeed=StuckTo.Default.GroundSpeed * MovementSpeedDifficultyScale;
	SlowedGroundSpeed=DefaultGroundSpeed * ReduceSpeedTo;
}

simulated function Stick(actor HitActor, vector HitLocation)
{
	local name NearestBone;
	local float dist;

	StuckTo=KFMonster(HitActor);
	SetSpeeds();
	
	SetPhysics(PHYS_None);

	NearestBone = GetClosestBone(HitLocation, HitLocation, dist , 'CHR_Spine2' , 15 );
	HitActor.AttachToBone(self,NearestBone);
	
	SetTimer(0.5,true);
}

defaultproperties
{
     ReduceSpeedTo=0.600000
     Speed=1.000000
     MaxSpeed=1.000000
     Damage=15.000000
     DamageRadius=1.000000
     MyDamageType=Class'WTF.WTFEquipDamTypeLethalInjection'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'KF_pickups2_Trip.Supers.MP7_Dart'
     LifeSpan=20.000000
     DrawScale=0.010000
}
