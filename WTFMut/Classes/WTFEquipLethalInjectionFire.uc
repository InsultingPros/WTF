class WTFEquipLethalInjectionFire extends KFMeleeFire;

simulated function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local WTFEquipLethalInjectionProj p;
	local KFPlayerReplicationInfo KFPRI;

	If( !KFWeapon(Weapon).bNoHit )
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if( Instigator.Controller!=None && PlayerController(Instigator.Controller)==None && Instigator.Controller.Enemy!=None )
		{
        	PointRot = rotator(Instigator.Controller.Enemy.Location-StartTrace); // Give aimbot for bots.
        }
		else
        {
            PointRot = Instigator.GetViewRotation();
        }

		EndTrace = StartTrace + vector(PointRot)*weaponRange;
		HitActor = Instigator.Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);

		if (HitActor!=None)
		{
			ImpactShakeView();

			if( HitActor.IsA('ExtendedZCollision') && HitActor.Base != none &&
                HitActor.Base.IsA('KFMonster') )
            {
                HitActor = HitActor.Base;
            }

			if( Level.NetMode==NM_Client )
            {
                Return;
            }

			if( (KFMonster(HitActor)!=none) )
			{
				p = Spawn(Class'WTF.WTFEquipLethalInjectionProj', instigator,, HitLocation, PointRot);
				p.Stick(HitActor,HitLocation);
				
				//Slow Poison is for Medics only
				KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
				if (KFPRI != none && KFPRI.ClientVeteranSkill == Class'WTFVetFieldMedic')
					p.bSlowPoison=True;
				
            	if(MeleeHitSounds.Length > 0)
            	{
            		Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
            	}
			}
		}
	}
}

defaultproperties
{
     DamagedelayMin=0.360000
     DamagedelayMax=0.360000
     FireRate=2.800000
}
