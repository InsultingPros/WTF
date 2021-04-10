class WTFVetCommando extends SRVetCommando
	abstract;

//ole Devil Dog's a wee bit tougher than Average Joe,
//but not a Freak of Nature like Berserker
static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
	switch ( KFPRI.ClientVeteranSkillLevel )
	{
		case 1:
			return float(InDamage) * 0.95;
		case 2:
			return float(InDamage) * 0.95;
		case 3:
			return float(InDamage) * 0.9;
		case 4:
			return float(InDamage) * 0.9;
		case 5:
			return float(InDamage) * 0.85;
		case 6:
			return float(InDamage) * 0.85;
	}

	return InDamage;
}

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI)
{
	switch ( KFPRI.ClientVeteranSkillLevel )
	{
		case 1:
			return 1.05;
		case 2:
			return 1.05;
		case 3:
			return 1.10;
		case 4:
			return 1.10;
		case 5:
			return 1.15;
		case 6:
			return 1.15;
	}

	return 1.0;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
		If (
			WTFEquipBulldog(Other) != none ||
			WTFEquipAK48S(Other) != none ||
			WTFEquipSCAR19AR(Other) != none ||
			WTFEquipM5AR(Other) != none ||
			WTFEquipFNWin(Other) != none ||
			WTFEquipMKb43AR(Other) != none ||
			WTFEquipM4204AR(Other) != none ||
			WTFEquipTommyGun(Other) != none ||
			WTFEquipBanelli(Other) != none ||
			WTFEquipShotgun(Other) != none ||
			WTFEquipKSG(Other) != none
			)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 1 )
		{
			return 1.10;
		}
		else if ( KFPRI.ClientVeteranSkillLevel == 2 )
		{
			return 1.20;
		}

		return 1.25; // 25% increase in assault rifle ammo carry
	}

	return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
	{
		If (
			BullpupAmmo(Other) != none ||
			AK47Ammo(Other) != none ||
			SCARMK17Ammo(Other) != none ||
			M4Ammo(Other) != none ||
			FNFALAmmo(Other) != none || 
			MKb42Ammo(Other) != none ||
			ThompsonAmmo(Other) != none ||
			GoldenAK47Ammo(Other) != none ||
			ShotgunAmmo(Other) != none ||
			BenelliAmmo(Other) != none ||
			KSGAmmo(Other) != none
			)
		{
			if ( KFPRI.ClientVeteranSkillLevel == 1 )
			{
				return 1.10;
			}
			else if ( KFPRI.ClientVeteranSkillLevel == 2 )
			{
				return 1.20;
			}

			return 1.25; // 25% increase in assault rifle ammo carry
		}
	}

	return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
	{
		If (
			AmmoType == class'BullpupAmmo' || 
			AmmoType == class'AK47Ammo' ||
			AmmoType == class'SCARMK17Ammo' ||
			AmmoType == class'M4Ammo' ||
			AmmoType == class'FNFALAmmo' || 
			AmmoType == class'MKb42Ammo' || 
			AmmoType == class'ThompsonAmmo' || 
			AmmoType == class'GoldenAK47Ammo' ||
			AmmoType == class'M4203Ammo' ||
			AmmoType == class'ShotgunAmmo' ||
			AmmoType == class'BenelliAmmo' ||
			AmmoType == class'KSGAmmo'
			)
		{
			if ( KFPRI.ClientVeteranSkillLevel == 1 )
			{
				return 1.10;
			}
			else if ( KFPRI.ClientVeteranSkillLevel == 2 )
			{
				return 1.20;
			}

			return 1.25; // 25% increase in assault rifle ammo carry
		}
	}

	return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if (
		DmgType == class'DamTypeBullpup' ||
		DmgType == class'DamTypeAK47AssaultRifle' ||
        DmgType == class'DamTypeSCARMK17AssaultRifle' ||
		DmgType == class'DamTypeM4AssaultRifle' ||
		DmgType == class'DamTypeFNFALAssaultRifle' ||
		DmgType == class'DamTypeMKb42AssaultRifle' ||
		DmgType == class'DamTypeThompson' ||
		DmgType == class'DamTypeM4203AssaultRifle' ||
		DmgType == class'DamTypeShotgun' ||
		DmgType == class'DamTypeBenelli' ||
		DmgType == class'DamTypeKSGShotgun'
		)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
		{
			return float(InDamage) * 1.05;
		}

		return float(InDamage) * (1.00 + (0.10 * KFPRI.ClientVeteranSkillLevel)); // Up to 60% increase in Damage
	}

	return InDamage;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	return 1.0 + (0.1 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% faster reloads
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if (
		Item == class'WTFEquipBulldogPickup' ||
		Item == class'WTFEquipAK48SPickup' ||
        Item == class'WTFEquipSCAR19Pickup' ||
		Item == class'WTFEquipM5Pickup' || 
		Item == class'WTFEquipFNWinPickup' || 
		Item == class'WTFEquipMKb43Pickup' ||
		Item == class'WTFEquipTommyGunPickup' ||
		Item == class'GoldenAK47Pickup' ||
		Item == class'WTFEquipM4204Pickup' ||
		Item == class'WTFEquipBanelliPickup' ||
		Item == class'WTFEquipShotgunPickup' ||
		Item == class'WTFEquipKSGPickup'
		)
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Assault Rifles
	}

	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipBulldog", GetCostScaling(KFPRI, class'WTFEquipBulldogPickup'));
	}
	else if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipShotgun", GetCostScaling(KFPRI, class'WTFEquipShotgunPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipAK48S", GetCostScaling(KFPRI, class'WTF.WTFEquipAK48SPickup'));
	}
}

defaultproperties
{
	PerkIndex=3
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Commando'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Commando_Gold'
	VeterancyName="WTF Commando"
	Requirements(0)="Kill %x stalkers with Assault/Battle Rifles"
	Requirements(1)="Deal %x damage with Assault/Battle Rifles"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}