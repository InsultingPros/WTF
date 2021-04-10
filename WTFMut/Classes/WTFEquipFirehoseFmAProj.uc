class WTFEquipFirehoseFmAProj extends FlameTendril;

var() WTFEquipFirehoseEmitter FF;
var() bool bHasLanded;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (bHasLanded)
		return;
	if (Other.IsA('Pawn'))
		if(Pawn(Other).Health <= 0)
			return; //this is to let players light fires on terrain when they are actually hitting a corpse on the ground

	if ( Other != Instigator && !Other.IsA('PhysicsVolume') && (Other.IsA('Pawn') || Other.IsA('ExtendedZCollision')) )
	{
		Explode(self.Location,self.Location);
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	}

	if ( KFHumanPawn(Instigator) != none )
	{
		if ( EffectIsRelevant(Location,false) )
		{
			Spawn(class'WTF.WTFEquipFirehoseEmitter',self,,Location);
		}
	}

	Destroy();
}

//running every .2 seconds (5 times per second)
simulated function Timer()
{
	local Actor A;

	if (!bHasLanded)
	{
		TimerRunCount++;
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		{
			if ( TimerRunCount >= 1 + KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ExtraRange(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo)) )
			{
				Explode(Location,Location);
			}
		}
		else if ( TimerRunCount >= 1 )
		{
			Explode(Location,Location);
		}
	}
	else if (Role == ROLE_Authority)
	{
		ForEach TouchingActors(class 'Actor', A)
		{
			if (A.IsA('Pawn'))
				if(Pawn(A).Health > 0)
					A.TakeDamage(Damage, Instigator, A.Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function Landed( vector HitNormal )
{
	if(bHasLanded)
		return; //sometimes Landed(...) gets called twice...

	bHasLanded=true;

	bProjTarget=true;
	SetCollisionSize(25.0,25.0);

	SetTimer(0.3, true);

	DestroyTrail();
	SetPhysics(PHYS_None);

	if ( KFHumanPawn(Instigator) != none )
	{
		if ( EffectIsRelevant(Location,false) )
		{
			FF = Spawn(class'WTF.WTFEquipFirehoseEmitter',self);
			FF.LifeSpan = LifeSpan;
		}
	}
}

simulated function Destroyed()
{
	DestroyTrail();
	if (FF != none)
		FF.Destroy();
}

/* Utility Functions */

simulated function DestroyTrail()
{
	if ( Trail != none )
	{
		Trail.mRegen=False;
		Trail.SetPhysics(PHYS_None);
	}

	if ( FlameTrail != none )
	{
		FlameTrail.Kill();
		FlameTrail.SetPhysics(PHYS_None);
	}
}

defaultproperties
{
	Damage=14.000000
	DamageRadius=125.000000
}
