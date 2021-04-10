class WTFEquipUM32ProximityMine extends WTFEquipPipeBombProj;

//make an exec to create an attach point on the back of the mesh

// cut-n-paste to remove grenade smoke trail
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (BombLight != None)
		BombLight.Destroy();
}

defaultproperties
{
	BeepSound=None
	CountDown=1
	DetectionRadius=75.000000
	ArmingCountDown=3.000000
	ThreatThreshhold=0.250000
	Speed=750.000000
	MaxSpeed=750.000000
	Damage=400.000000
	DamageRadius=400.000000
	StaticMeshRef="kf_generic_sm.40mm_Warhead"
	LifeSpan=600.000000
	DrawScale=4.000000
	CollisionRadius=15.000000
	CollisionHeight=15.000000
}
