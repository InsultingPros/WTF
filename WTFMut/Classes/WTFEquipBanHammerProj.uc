class WTFEquipBanHammerProj extends Nade;

//never respond to taking damage
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex);

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Local Actor A;
	
	if(bHasExploded)
		return;
		
	bHasExploded=True;

	PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,2.0);
	
	if (ROLE == ROLE_Authority)
	{
		foreach CollidingActors (class 'Actor', A, DamageRadius, HitLocation)
		{
			if (KFMonster(A) != None && ExtendedZCollision(A) == none)
			{
				A.TakeDamage(Damage,Instigator,A.Location,A.Location,MyDamageType);
			}
		}
		Instigator.TakeDamage(120.0,Instigator,Instigator.Location,Instigator.Location,MyDamageType);
	}
		
	if ( EffectIsRelevant(Location,false) )
	{
		//was KFMod.KFNadeLExplosion
		Spawn(Class'WTF.WTFEquipUM32ProjExplosionEmitter',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	Destroy();
}

defaultproperties
{
     ExplodeSounds(0)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode01'
     ExplodeSounds(1)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode02'
     ExplodeSounds(2)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode03'
     ExplodeTimer=0.200000
     Damage=750.000000
     DamageRadius=250.000000
     MomentumTransfer=25000.000000
     MyDamageType=Class'KFMod.DamTypePipeBomb'
     DrawScale=0.010000
}
