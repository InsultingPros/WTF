class WTFEquipLAWLFire extends LAWFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
	
    if( FRand() <= 0.01 )
        p = Weapon.Spawn(Class'WTF.WTFEquipLAWLProjWTF',,, Start, Dir);
	else
		p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
	ProjectileClass=Class'WTF.WTFEquipLAWLProj'
}
