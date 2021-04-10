class WTFEquipM4204FmBProjFieldMedic extends M203GrenadeProjectile;

var()   int     HealBoostAmount;// How much we heal a player by default with the medic nade
var localized   string  SuccessfulHealMessage;
var 	int		MaxNumberOfPlayers;
var     bool    bNeedToPlayEffects; // Whether or not effects have been played yet

simulated function Explode(vector HitLocation, vector HitNormal)
{		
	bHasExploded = True;
	BlowUp(HitLocation);

	PlaySound(ExplosionSound,,TransientSoundVolume);

	if( Role == ROLE_Authority )
	{
        bNeedToPlayEffects = true;
        AmbientSound=Sound'Inf_WeaponsTwo.smoke_loop';
	}

	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFMod.KFNadeHealing',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
	
	Destroy();
}

simulated function BlowUp(vector HitLocation)
{
	HealOrHurt(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}

function HealOrHurt(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local actor Victims;
	local float damageScale;
	local vector HoHdir;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local Pawn P;
	local KFPawn KFP;
	local array<Pawn> CheckedPawns;
	local int i;
	local bool bAlreadyChecked;
	// Healing
	local KFPlayerReplicationInfo PRI;
	local int MedicReward;
	local float HealSum; // for modifying based on perks
	local int PlayersHealed;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
		 && ExtendedZCollision(Victims)==None )
		{
			if( (Instigator==None || Instigator.Health<=0) && KFPawn(Victims)!=None )
				Continue;

			damageScale = 1.0;

			if ( Instigator == None || Instigator.Controller == None )
			{
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			}

			P = Pawn(Victims);

			if( P != none )
			{
		        for (i = 0; i < CheckedPawns.Length; i++)
				{
		        	if (CheckedPawns[i] == P)
					{
						bAlreadyChecked = true;
						break;
					}
				}

				if( bAlreadyChecked )
				{
					bAlreadyChecked = false;
					P = none;
					continue;
				}

                KFMonsterVictim = KFMonster(Victims);

    			if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
    			{
                    KFMonsterVictim = none;
    			}

                KFP = KFPawn(Victims);

                if( KFMonsterVictim != none )
                {
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }
                else if( KFP != none )
                {
				    damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }

				CheckedPawns[CheckedPawns.Length] = P;

				if ( damageScale <= 0)
				{
					P = none;
					continue;
				}
				else
				{
					//Victims = P;
					P = none;
				}
			}
			else
			{
                continue;
			}

            if( KFP == none )
            {
    			//log(Level.TimeSeconds@"Hurting "$Victims$" for "$(damageScale * DamageAmount)$" damage");

    			if( Pawn(Victims) != none && Pawn(Victims).Health > 0 )
    			{
                    Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius)
        			 * HoHdir,(damageScale * Momentum * HoHdir),DamageType);

        			if( Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
                    {
                        NumKilled++;
                    }
                }
			}
			else
			{
                if( Instigator != none && KFP.Health > 0 && KFP.Health < KFP.HealthMax )
                {
	                if ( KFP.bCanBeHealed )
					{
						PlayersHealed += 1;
	            		MedicReward = HealBoostAmount;

	            		PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

	            		if ( PRI != none && PRI.ClientVeteranSkill != none )
	            		{
	            			MedicReward *= PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);
	            		}

	                    HealSum = MedicReward;

	            		if ( (KFP.Health + KFP.healthToGive + MedicReward) > KFP.HealthMax )
	            		{
	                        MedicReward = KFP.HealthMax - (KFP.Health + KFP.healthToGive);
	            			if ( MedicReward < 0 )
	            			{
	            				MedicReward = 0;
	            			}
	            		}

	                    //log(Level.TimeSeconds@"Healing "$KFP$" for "$HealSum$" base healamount "$HealBoostAmount$" health");
	                    KFP.GiveHealth(HealSum, KFP.HealthMax);

	             		if ( PRI != None )
	            		{
	            			if ( MedicReward > 0 && KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements) != none )
	            			{
	            				KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).AddDamageHealed(MedicReward, false, true);
	            			}

	                        // Give the medic reward money as a percentage of how much of the person's health they healed
	            			MedicReward = int((FMin(float(MedicReward),KFP.HealthMax)/KFP.HealthMax) * 60);

	            			PRI.ReceiveRewardForHealing( MedicReward, KFP );

	            			if ( KFHumanPawn(Instigator) != none )
	            			{
	            				KFHumanPawn(Instigator).AlphaAmount = 255;
	            			}

	                        if( PlayerController(Instigator.Controller) != none )
	                        {
	                            PlayerController(Instigator.Controller).ClientMessage(SuccessfulHealMessage$KFP.GetPlayerName(), 'CriticalEvent');
	                        }
	            		}
            		}
                }
			}

			KFP = none;
        }

		if (PlayersHealed >= MaxNumberOfPlayers)
		{
			if (PRI != none)
			{
				KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).HealedTeamWithMedicGrenade();
			}
		}
	}

	bHurtEntry = false;
}

defaultproperties
{
	HealBoostAmount=35
	DamageRadius=175.000000
	Damage=70.000000
	MyDamageType=Class'DamTypeMedicNade'
	DrawScale=1.0
	ExplosionDecal=Class'KFMod.MedicNadeDecal'
	ExplosionSound=Sound'KF_GrenadeSnd.MedicNade_Explode'
	AmbientSound=none
	SoundVolume=150
	SoundRadius=100
	TransientSoundVolume=2.0
	TransientSoundRadius=200
	bFullVolume=false
	DisintegrateSound="Inf_Weapons.faust_explode_distant02"
	SuccessfulHealMessage="You healed "
	MaxNumberOfPlayers=6
}