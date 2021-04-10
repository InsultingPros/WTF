class WTFVetSupportSpec extends SRVetSupportSpec
	abstract;

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if (
		Item == class'WTFEquipShotgunPickup' || 
		Item == class'WTFEquipBoomstickPickup' || 
		Item == class'WTFEquipAA13Pickup' || 
		Item == class'WTFEquipBanelliPickup' || 
		Item == class'WTFEquipKSGPickup' || 
		Item == class'NailGunPickup' ||
		Item == class'GoldenBenelliPickup' ||
		Item == class'WTFEquipFlaregunPickup' ||
		Item == class'WTFEquipGlowstickPickup' ||
		Item == class'WTFEquipSawedOffShotgunPickup' ||
		Item == class'WTFEquipM79CFPickup' ||
		Item == class'WTFEquipUM32Pickup'
		)
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Shotguns
	}

	return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( AmmoType == class'FragAmmo' )
	{
		// Up to 6 extra Grenades
		return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
	}
	else if (
			AmmoType == class'ShotgunAmmo' || 
			AmmoType == class'DBShotgunAmmo' || 
			AmmoType == class'AA12Ammo' ||
			AmmoType == class'BenelliAmmo' || 
			AmmoType == class'KSGAmmo' || 
			AmmoType == class'NailGunAmmo' ||
			AmmoType == class'GoldenBenelliAmmo' ||
			AmmoType == class'WTFEquipSawedOffShotgunAmmo' ||
			AmmoType == class'WTFEquipFlaregunAmmo' ||
			AmmoType == class'WTFEquipGlowstickAmmo' ||
			AmmoType == class'M79Ammo' ||
			AmmoType == class'M32Ammo'
			)
	{
		if ( KFPRI.ClientVeteranSkillLevel > 0 )
		{
			if ( KFPRI.ClientVeteranSkillLevel == 1 )
			{
				return 1.10;
			}
			else if ( KFPRI.ClientVeteranSkillLevel == 2 )
			{
				return 1.20;
			}
			else if ( KFPRI.ClientVeteranSkillLevel == 6 )
			{
				return 1.30; // Level 6 - 30% increase in shotgun ammo carried
			}

			return 1.25; // 25% increase in shotgun ammo carried
		}
	}

	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipShotgun", GetCostScaling(KFPRI, class'WTFEquipShotgunPickup'));
	}
	else if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipShotgun", GetCostScaling(KFPRI, class'WTFEquipShotgunPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipBoomStick", GetCostScaling(KFPRI, class'WTFEquipBoomStickPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipFlaregun", GetCostScaling(KFPRI, class'WTFEquipFlaregunPickup'));
	}
}

defaultproperties
{
	PerkIndex=1
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Support'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Support_Gold'
	VeterancyName="WTF Support Specialist"
	Requirements(0)="Weld %x door hitpoints"
	Requirements(1)="Deal %x damage with shotguns"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}