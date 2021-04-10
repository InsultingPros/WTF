class WTFEquipLAWLProjWTF extends LAWProj;

var() int WaitCounter;
var() float ShakeRadius; //players within this distance will have their views shaken

#exec OBJ LOAD FILE=WTFSounds.uax

var bool bDoneExploding;

simulated function Timer()
{
	WaitCounter++;
	if (WaitCounter == 20)
	{
		//BEEP BEEP BEEP WHAT THE FU-
		PlaySound(Sound'WTFSounds.WTFBOOM', , 10.0, , 5000.0);
	}
	else if (WaitCounter == 28)
	{
		if ( SmokeTrail != None )
		{
			SmokeTrail.HandleOwnerDestroyed();
		}
		SetDrawScale(0.05);
	
		//BWWWAAAUUUUUUU-BWAHAHAHAHAHAHA
		Spawn(class'WTF.WTFEquipLAWLProjWTFExplosion',self,,Self.Location,rotator(Self.Location));
		if (ROLE == ROLE_AUTHORITY)
			KFGameType(Level.Game).DramaticEvent(1.0);
		Explode(Self.Location,Self.Location);
	}
	else if (WaitCounter > 28 && WaitCounter < 56)
	{
		Explode(Self.Location,Self.Location);
	}
	else if (WaitCounter >= 56)
	{
		bDoneExploding = True;
		Destroy();
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController  LocalPlayer;

	if (bDoneExploding)
		Return;
		
    bHasExploded = True;

    BlowUp(HitLocation);
	
    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < ShakeRadius) )
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( (PlayerController(C) != None) && (C != LocalPlayer)
            && (VSize(Location - PlayerController(C).ViewTarget.Location) < ShakeRadius) )
            C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	//I am so awesome I don't get blown up by taking damage
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function Landed( vector HitNormal )
{
	Velocity = vect(0,0,0);
	SetPhysics(PHYS_Falling);
	SetTimer(0.25,true);
	AmbientSound=none;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other == none || Other == Instigator || Other.Base == Instigator  )
		return;
		
	if (bHasExploded)
		return;

    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

	Landed(HitLocation);
}

defaultproperties
{
	ShakeRadius=2400.000000
	ImpactDamage=1
	Speed=1000.000000
	MaxSpeed=1000.000000
	Damage=1500.000000
	DamageRadius=1800.000000
	LifeSpan=30.000000
}
