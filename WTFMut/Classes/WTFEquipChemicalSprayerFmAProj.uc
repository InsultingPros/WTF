class WTFEquipChemicalSprayerFmAProj extends WTFEquipFirehoseFmAProj;

var float HealAmt;
var bool bHasExploded;

simulated function PostBeginPlay()
{
	local KFPlayerReplicationInfo KFPRI;
	
	SetTimer(0.2, true);

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( !PhysicsVolume.bWaterVolume )
		{
			FlameTrail = Spawn(class'WTFEquipChemicalSprayerFmAProjTrail',self);
			//Trail = Spawn(class'FlameThrowerFlame',self);
		}
	}

	Velocity.z += TossZ;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	HealAmt *= KFPRI.ClientVeteranSkill.Static.GetHealPotency(KFPRI);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( Other != Instigator && !Other.IsA('PhysicsVolume') && (Other.IsA('Pawn') || Other.IsA('ExtendedZCollision')) )
	{
		Explode(self.Location,self.Location);
	}
}

simulated function Timer()
{
	TimerRunCount++;
	if (TimerRunCount >= 1) {
		Explode(Location,Location);
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local Actor Sprayed;
	
	if (bHasExploded)
		Return;
		
	bHasExploded = True;
	
	if ( Role == ROLE_Authority )
	{
		//HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
		foreach CollidingActors (class 'Actor', Sprayed, DamageRadius, HitLocation)
		{
			If (KFMonster(Sprayed) != None) {
				//hurt
				Sprayed.TakeDamage(Damage,Instigator,Sprayed.Location,Vect(0,0,0),MyDamageType);
			}
			Else If (KFHumanPawn(Sprayed) != None) {
				//heal
				KFHumanPawn(Sprayed).GiveHealth(HealAmt, KFHumanPawn(Sprayed).HealthMax);
			}
		}
	}

	/*
	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFMod.KFNadeHealing',,, HitLocation, rotator(vect(0,0,1)));
	}
	*/

	Destroy();
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Explode(Location,HitNormal);
}

simulated function Landed( vector HitNormal )
{
}

defaultproperties
{
	HealAmt = 2.0
	Damage=10.000000
	DamageRadius=50.000000
	MyDamageType=Class'DamTypeMedicNade'
	bDynamicLight = false
	LightType = LT_None
}
