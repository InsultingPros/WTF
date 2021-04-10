class WTFEquipUM32Proj extends M32GrenadeProjectile;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController  LocalPlayer;
	
	if (bHasExploded)
		Return;
		
    bHasExploded = True;

    // Don't explode if this is a dud
    if( bDud )
    {
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
    }

    PlaySound(ExplosionSound,,2.0);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'WTF.WTFEquipUM32ProjExplosionEmitter',,,HitLocation + HitNormal*20,rotator(HitNormal));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }

    BlowUp(HitLocation);
    Destroy();

    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < DamageRadius) )
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( (PlayerController(C) != None) && (C != LocalPlayer)
            && (VSize(Location - PlayerController(C).ViewTarget.Location) < DamageRadius) )
            C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

defaultproperties
{
	Speed=1750.000000
	MaxSpeed=1750.000000
	Damage=400.000000
	DrawScale=4.000000
}
