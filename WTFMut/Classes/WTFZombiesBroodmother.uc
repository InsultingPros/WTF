//TODO: tweak controller AI so that she tries to stay away and spawn broodlings until she can't anymore, then charge
//		maybe can define spawning a broodling as a ranged weapon of sorts. LOOK AT THE UT2004 REF for skaarjpack.monstercontroller

//		maybe tweak the reference's FindNewEnemy functionality to see what distance/visibility is between broodmother and players and react accordingly
//		maybe utilize LineOfSightTo(something) function as shown in SetEnemy()
//		also check out engine.controller for MoveToward() and such functionality- controls how actor faces while moving to

// LOL!!! Use WasKilledBy from engine.controller to make My remaining Broodlings AVENGE ME!!!

// maybe use controller.PlayerCanSeeMe()- returns true if any player can see me- native code so fast!

class WTFZombiesBroodmother extends ZombieCrawler;

const NUM_BROODLINGS = 3;
var WTFZombiesBroodling MyBroodling[NUM_BROODLINGS];

function SpawnBroodlings()
{
	local int i;
	local vector loc;
	
	Acceleration=vect(0,0,0);
	
	loc = Location;
	loc.X -= 50;
	Loc.Y -= 50;
	Loc.Z += CollisionHeight + 30;
	
	for (i=0; i < NUM_BROODLINGS; i++)
	{
		//only spawn if this one is gone; in this way it won't have more than NUM_BROODLINGS at once
		if (MyBroodling[i] == none || MyBroodling[i].Health <= 0)
		{
			MyBroodling[i] = Spawn(Class'WTF.WTFZombiesBroodling',Owner,,loc,Rotation);
			Loc.X += 20;
			Loc.Y += 20;
		}
	}
}

defaultproperties
{
	GroundSpeed=150.000000
	WaterSpeed=150.000000
	MenuName="Broodmother"
	ControllerClass=Class'WTF.WTFZombiesBroodmotherController'
	Skins(0)=Texture'WTFTex.WTFZombies.Broodmother'
	Mesh=SkeletalMesh'KF_Freaks_Trip.Crawler_Freak'
}
