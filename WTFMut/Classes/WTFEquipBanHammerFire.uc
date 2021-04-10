class WTFEquipBanHammerFire extends AxeFireB;

var array<sound>    ExplodeSounds;
	
simulated function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local int MyDamage;
	local WTFEquipBanHammerProj P;

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

			Weapon.Skins[KFMeleeGun(Weapon).BloodSkinSwitchArray] = KFMeleeGun(Weapon).BloodyMaterial;
			Weapon.texture = Weapon.default.Texture;
			
			if( Level.NetMode==NM_Client && !WTFEquipBanHammer(Weapon).bIsBlown)
            {
                Return;
            }

			Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);

			if (!WTFEquipBanHammer(Weapon).bIsBlown)
			{
				WTFEquipBanHammer(Weapon).bIsBlown=True;
				P = Spawn(Class'WTF.WTFEquipBanHammerProj',Instigator, '', HitLocation, PointRot);
			}
			else
			{
				if( HitActor.IsA('ExtendedZCollision') && HitActor.Base != none &&
                HitActor.Base.IsA('KFMonster') )
				{
					HitActor = HitActor.Base;
				}
				
				MyDamage = MeleeDamage;
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, vector(PointRot), hitDamageClass) ;

				if(HitActor.IsA('KFMonster') || HitActor.IsA('KFHumanPawn'))
            	{
            		Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
            	}
			}
		}
	}
}

defaultproperties
{
	ExplodeSounds(0)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode01'
	ExplodeSounds(1)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode02'
	ExplodeSounds(2)=SoundGroup'Inf_Weapons.antitankmine.antitankmine_explode03'
	hitDamageClass=Class'KFMod.DamTypeBat'
	MeleeHitSounds(0)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh'
	MeleeHitSounds(1)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh2'
	MeleeHitSounds(2)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh3'
}
