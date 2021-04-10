class WTFEquipGlowstickProjHanging extends WTFEquipGlowstickProj;

#exec OBJ LOAD FILE=Asylum_SM.usx
#exec OBJ LOAD FILE=Asylum_T.utx

function PostNetBeginPlay()
{
	Super(Nade).PostNetBeginPlay();
	Stick(Instigator,Instigator.Location);
}

simulated function Stick(actor HitActor, vector HitLocation)
{
	//local name NearestBone;
	//local float dist;
	local Rotator rot;
	local Vector loc;

	if (pawn(HitActor) != none)
	{
		//NearestBone = GetClosestBone(HitLocation, HitLocation, dist , 'CHR_Neck' , 1 );
		HitActor.AttachToBone(self,'CHR_Neck');
		
		//need to SetRelativeLocation and SetRelativeRotation so it doesn't point sideways out of their neck
		rot.Yaw=0;
		rot.Pitch= -16384; //-16384; looks 99% perfect
		rot.Roll=6144; //+ is tilt wire towards player's back
		SetRelativeRotation(rot);
		
		loc.X=-10; //+ is up, - is down
		loc.Y=-13; //+ is back, - is front?
		loc.Z=1; //+ is left, - is right
		SetRelativeLocation(loc);
	}
	//else
		//SetBase(HitActor);
}

defaultproperties
{
     Speed=1.000000
     MaxSpeed=1.000000
     StaticMesh=StaticMesh'Asylum_SM.Lighting.glow_sticks_green_bundle'
     Physics=PHYS_Projectile
     DrawScale=0.500000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
