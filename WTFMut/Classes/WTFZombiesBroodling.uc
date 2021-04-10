class WTFZombiesBroodling extends ZombieCrawler;

event Touch( Actor Other )
{
	local KFHumanPawn O;
	
	O = KFHumanPawn(Other);
	
	if (O == none)
		return;
	
	//take squish damage from moving, living players, but only if we aren't pouncing
	if ( O.Health > 0 && (O.Velocity.X > 0 || O.Velocity.Y > 0 || O.Velocity.Z < 0) && bPouncing == false)
	{
		TakeDamage( HealthMax, O, Location, Velocity, Class'KFMod.DamTypeBleedOut');
	}
}

simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	bGibbed = true;
	PlayDyingSound();
}

defaultproperties
{
	MeleeDamage=5
	damageForce=1
	SeveredArmAttachScale=0.320000
	SeveredLegAttachScale=0.340000
	SeveredHeadAttachScale=0.440000
	OnlineHeadshotOffset=(X=11.200000,Z=2.800000)
	OnlineHeadshotScale=0.480000
	MotionDetectorThreat=0.000000
	ScoringValue=0
	GroundSpeed=180.000000
	WaterSpeed=170.000000
	HealthMax=14.000000
	Health=14
	HeadHeight=1.000000
	HeadScale=0.420000
	MenuName="Broodling"
	DrawScale=0.440000
	CollisionRadius=14.000000
	CollisionHeight=7.000000
	bBlockActors=False
	Mesh=SkeletalMesh'KF_Freaks_Trip.Crawler_Freak'
	Skins(0)=Combiner'KF_Specimens_Trip_T.crawler_cmb'
}
