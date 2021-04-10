class WTFEquipGrenadeThrowingKnife extends CrossbowArrow;

#exec OBJ LOAD FILE=KF_InventorySnd.uax

simulated function PostNetBeginPlay()
{
	Super(Projectile).PostNetBeginPlay();
}

simulated function PostBeginPlay()
{
    local rotator Dir;

	/*
	valuable wisdom I've gained from all of this frustration and poking
	-------------------------------------------------------------------
	65536 = 360 degrees
	32768 = 180 degrees
	16384 = 90 degrees 
	182.0444... ~= 1 degree
	
	Yaw is shaking your head left and right, pitch is nodding up and down, and roll is side to side.

	after a lot of experimentation and frustration, the values for degrees gets capped at 65536 (probably at 0 also) and no matter how high
	above that number you go it will change nothing.
	+ rotates clockwise
	- rotates counterclockwise
	*/
	
	Dir = Instigator.GetViewRotation();
	Dir.yaw += 25307; //spot on
	if (Dir.yaw > 65536)
		Dir.yaw -= 65536;
	
	Dir.pitch = 0; //0 looked fine
	
	//however need to rotate so skinny part of blade is vertical, not parallel with ground
	Dir.roll = 0; //0 looked fine
		
	SetRotation(Dir);
		
	Super(Projectile).PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	Local Vector X;
	
    if( Other == Instigator || Other == none || KFBulletWhipAttachment(Other)!=None )
    {
        return;
    }
	
	if (ExtendedZCollision(Other) != none)
		Other = Other.Base;
	
	X =  Vector(Rotation);
	
	Stick(Other,HitLocation);
	if( Level.NetMode!=NM_Client )
	{
		if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
			Pawn(Other).TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * X, DamageTypeHeadShot);
		else Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
	}
}

simulated function Stick(actor HitActor, vector HitLocation)
{
	local name NearestBone;
	local float dist;

	SetPhysics(PHYS_None);

	if (pawn(HitActor) != none)
	{
		NearestBone = GetClosestBone(HitLocation, HitLocation, dist , 'CHR_Spine2' , 1 );
		HitActor.AttachToBone(self,NearestBone);
	}
	else SetBase(HitActor);

	ImpactActor = HitActor;

	GoToState('OnWall');
}

simulated state OnWall
{
Ignores HitWall;

	function ProcessTouch (Actor Other, vector HitLocation)
	{
		local Inventory inv;

		if( Pawn(Other)!=None && Pawn(Other).Inventory!=None )
		{
			for( inv=Pawn(Other).Inventory; inv!=None; inv=inv.Inventory )
			{
				if( Other == Instigator && Weapon(inv).AmmoAmount(0) < Weapon(inv).MaxAmmo(0) )
				{
					KFweapon(Inv).AddAmmo(1,0) ;
					PlaySound(Sound'KF_InventorySnd.Ammo_GenericPickup', SLOT_Pain,2*TransientSoundVolume,,400);
					if(PlayerController(Instigator.Controller)!=none)
						PlayerController(Instigator.Controller).ClientMessage( "You picked up a Throwing Knife." );
					Destroy();
				}
			}
		}
	}
	simulated function BeginState()
	{
		SetCollisionSize(25.0,25.0);
	}
}

defaultproperties
{
	DamageTypeHeadShot=Class'KFMod.DamTypeKnife'
	HeadShotDamageMult=1.100000
	Speed=6000.000000
	MaxSpeed=6000.000000
	Damage=130.000000
	MomentumTransfer=0.000000
	MyDamageType=Class'KFMod.DamTypeKnife'
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'KF_pickups_Trip.melee.Knife_pickup'
	LifeSpan=60.000000
	Acceleration=(Z=-200.000000)
	DrawScale=1.500000
	CollisionRadius=0.500000
	CollisionHeight=0.500000
}
