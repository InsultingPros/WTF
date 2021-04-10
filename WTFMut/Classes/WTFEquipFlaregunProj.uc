class WTFEquipFlaregunProj extends Nade;

#exec OBJ LOAD FILE=kf_generic_sm.usx

var WTFEquipFlaregunFlareSmokeEmitter FlareSmoke;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	FlareSmoke = Spawn(class'WTF.WTFEquipFlaregunFlareSmokeEmitter',self);
	FlareSmoke.LifeSpan = LifeSpan;
	FlareSmoke.SetBase(self);
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	//nope
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	bHasExploded = True;
	if (FlareSmoke != none)
		FlareSmoke.Destroy();

	Destroy();
}

defaultproperties
{
     ExplodeTimer=150.000000
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=1.000000
     DamageRadius=1.000000
     LightType=LT_Steady
     LightHue=255
     LightBrightness=60.000000
     LightRadius=30.000000
     StaticMesh=StaticMesh'EffectsSM.Weapons.Ger_Tracer_Ball'
     bDynamicLight=True
     AmbientSound=Sound'WTFSounds.flarehiss'
     LifeSpan=151.000000
     DrawScale=3.000000
     bUnlit=True
     bFullVolume=True
     SoundVolume=255
     SoundRadius=400.000000
     CollisionRadius=6.000000
     CollisionHeight=6.000000
     bCollideActors=False
}
