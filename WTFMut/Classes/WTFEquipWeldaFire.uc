class WTFEquipWeldaFire extends WeldFire;

var Actor LHitActor;

simulated Function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal,AdjustedLocation;
	local rotator PointRot;
	local int MyDamage;
	local KFPlayerReplicationInfo KFPRI;

	If( !KFWeapon(Weapon).bNoHit )
	{
		MyDamage = MeleeDamage + Rand(MaxAdditionalDamage);
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if ( KFPRI != none && KFPRI.ClientVeteranSkill != none )
		{
			MyDamage = float(MyDamage) * KFPRI.ClientVeteranSkill.Static.GetWeldSpeedModifier(KFPRI);
		}

		PointRot = Instigator.GetViewRotation();
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if( AIController(Instigator.Controller)!=None && Instigator.Controller.Target!=None )
		{
			EndTrace = StartTrace + vector(PointRot)*weaponRange;
			Weapon.bBlockHitPointTraces = false;
			HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);
            Weapon.bBlockHitPointTraces = Weapon.default.bBlockHitPointTraces;

			if( HitActor==None )
			{
				EndTrace = Instigator.Controller.Target.Location;
    			Weapon.bBlockHitPointTraces = false;
				HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);
                Weapon.bBlockHitPointTraces = Weapon.default.bBlockHitPointTraces;
			}
			if( HitActor==None )
				HitLocation = Instigator.Controller.Target.Location;
			HitActor = Instigator.Controller.Target;
		}
		else
		{
			EndTrace = StartTrace + vector(PointRot)*weaponRange;
            Weapon.bBlockHitPointTraces = false;
            HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);
            Weapon.bBlockHitPointTraces = Weapon.default.bBlockHitPointTraces;
		}

		//LHitActor = KFDoorMover(HitActor); //original line
		LHitActor = HitActor;
		
		if( LHitActor!=none && Level.NetMode!=NM_Client )
		{
			AdjustedLocation = Hitlocation;
			AdjustedLocation.Z = (Hitlocation.Z - 0.15 * Instigator.collisionheight);

			hitDamageClass = default.hitDamageClass;
			
			if ( LHitActor.IsA('KFMonster') )
			{
				if ( LHitActor.IsA('WTFZombiesMetalClot') )
					MyDamage*=2.5;
				if (KFPRI != none && KFPRI.ClientVeteranSkill == Class'WTFvetFirebug')
					hitDamageClass = Class'WTFEquipDamTypeWelda';
			}

			if (ExtendedZCollision(HitActor) != none)
				HitActor.Base.TakeDamage(MyDamage, Instigator, HitLocation , vector(PointRot),hitDamageClass);
			else
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation , vector(PointRot),hitDamageClass);
			Spawn(class'KFWelderHitEffect',,, AdjustedLocation, rotator(HitLocation - StartTrace));
		}
	}
}

function Actor GetTarget()
{
	local Actor A;
	local vector Dummy,End,Start;

	if( AIController(Instigator.Controller)!=None )
		Return Instigator.Controller.Target;
	Start = Instigator.Location+Instigator.EyePosition();
	End = Start+vector(Instigator.GetViewRotation())*weaponRange;
    Instigator.bBlockHitPointTraces = false;
	A = Instigator.Trace(Dummy,Dummy,End,Start,True);
    Instigator.bBlockHitPointTraces = Instigator.default.bBlockHitPointTraces;
	return A;
}

function bool AllowFire()
{
	local Actor WeldTarget;

	//check out of ammo FIRST!
	if (Weapon.AmmoAmount(ThisModeNum) < AmmoPerFire)
		return false;
	
	WeldTarget = GetTarget();

	if (KFMonster(WeldTarget) != none || ExtendedZCollision(WeldTarget) != none) //we are hitting a KFMonster or its ExtendedCollision thingy
	{
		//TODO: change damtype to burned for firebugs
		return true;
	}
	
	// Can't use welder, if no door.
	// AJM - and we couldn't find a monster
	if ( KFDoorMover(WeldTarget) == none )
	{
		if ( KFPlayerController(Instigator.Controller) != none )
		{
			KFPlayerController(Instigator.Controller).CheckForHint(54);

			if ( FailTime + 0.5 < Level.TimeSeconds )
			{
				PlayerController(Instigator.Controller).ClientMessage(NoWeldTargetMessage, 'CriticalEvent');
				FailTime = Level.TimeSeconds;
			}

		}

		return false;
	}

	if(KFDoorMover(WeldTarget) != none && PlayerController(Instigator.controller)!=None)
	{
		if(KFDoorMover(WeldTarget).bDisallowWeld)
		{
			PlayerController(Instigator.controller).ClientMessage(CantWeldTargetMessage, 'CriticalEvent');
			return false;
		}
		else
			return true;
	}
}

defaultproperties
{
     NoWeldTargetMessage="Find something to weld first."
     AmmoClass=Class'WTF.WTFEquipWeldaAmmo'
}
