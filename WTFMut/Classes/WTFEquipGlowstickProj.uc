class WTFEquipGlowstickProj extends WTFEquipFlaregunProj;

#exec OBJ LOAD FILE=Asylum_SM.usx
#exec OBJ LOAD FILE=Asylum_T.utx

simulated function PostBeginPlay()
{
	Super(Nade).PostBeginPlay();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	bHasExploded = True;
	Destroy();
}

defaultproperties
{
     ExplodeTimer=300.000000
     Speed=200.000000
     MaxSpeed=200.000000
     LightHue=105
     LightBrightness=20.000000
     LightRadius=15.000000
     StaticMesh=StaticMesh'Asylum_SM.Lighting.glow_sticks_green_pile'
     LifeSpan=301.000000
     DrawScale=1.000000
     AmbientGlow=50
     bUnlit=False
}
