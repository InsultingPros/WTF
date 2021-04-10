class WTFEquipAA13ExplosiveRound extends ShotgunBullet;

var() array<Sound> ExplodeSounds;

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage*0.75, DamageRadius, MyDamageType, 0.0, HitLocation );
		HurtRadius(Damage*0.25, DamageRadius*2.0, MyDamageType, MomentumTransfer, HitLocation );
		
		//does full damage within DamageRadius (dealt in two chunks), but less damage to things outside of DamageRadius but within
		//DamageRadius*2.0
	}

	//why would it matter if instigator exists or not for spawning an fx???
	//if ( KFHumanPawn(Instigator) != none )
	//{
	
		PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,1.0);
		
		if ( EffectIsRelevant(Location,false) )
		{
			Spawn(class'WTF.WTFEquipAA13ExplosiveRoundEmitter',self,,Location);
		}
		
	//}

	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( Other != Instigator && !Other.IsA('PhysicsVolume') && (Other.IsA('Pawn') || Other.IsA('ExtendedZCollision')) )
	{
		Other.Velocity.X = Self.Velocity.X * 0.05;
		Other.Velocity.Y = Self.Velocity.Y * 0.05;
		Other.Velocity.Z = Self.Velocity.Z * 0.05;
		Other.Acceleration = vect(0,0,0); //0,0,0
		
		Explode(Other.Location,Other.Location);
	}
}

defaultproperties
{
	ExplodeSounds(0)=SoundGroup'KF_GrenadeSnd.Nade_Explode_1'
	ExplodeSounds(1)=SoundGroup'KF_GrenadeSnd.Nade_Explode_2'
	ExplodeSounds(2)=SoundGroup'KF_GrenadeSnd.Nade_Explode_3'
	Damage=250.000000
	DamageRadius=75.000000
	MomentumTransfer=1000.000000
	MyDamageType=Class'KFMod.DamTypeM79Grenade'
	StaticMesh=StaticMesh'kf_generic_sm.Bullet_Shells.40mm_Warhead'
	DrawScale=0.500000
}
