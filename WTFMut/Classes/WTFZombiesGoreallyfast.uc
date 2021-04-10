class WTFZombiesGoreallyFast extends ZombieGoreFast;

//charge from farther away
function RangedAttack(Actor A)
{
	Super.RangedAttack(A);
	if( !bShotAnim && !bDecapitated && VSize(A.Location-Location)<=1400 )
		GoToState('RunningState');
}

defaultproperties
{
	GroundSpeed=260.000000
	WaterSpeed=200.000000
	MenuName="Goreallyfast"
	Mesh=SkeletalMesh'KF_Freaks_Trip.GoreFast_Freak'
	Skins(0)=Texture'WTFTex.WTFZombies.Goreallyfast'
}
