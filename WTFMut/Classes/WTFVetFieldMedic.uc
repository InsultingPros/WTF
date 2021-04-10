class WTFVetFieldMedic extends SRVetFieldMedic
	abstract;

/*
probably will use this in the future
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	return class'MedicNade'; // Grenade detonations heal nearby teammates, and cause enemies to be poisoned
}
*/

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType)
{
	if( class<KFWeaponDamageType>(DmgType) != none)
	{
		if (
			DmgType == class'WTFEquipDamTypeLethalInjection' ||
			DmgType == class'DamTypeKnife' ||
			DmgType == class'DamTypeMP7M' ||
			DmgType == class'DamTypeMP5M' ||
			DmgType == class'DamTypeM7A3M' ||
			DmgType == class'DamTypeKrissM' ||
			DmgType == class'DamTypeMP7M' ||
			DmgType == class'DamTypeMAC10MP' ||
			DmgType == class'DamTypeThompson' ||
			DmgType == class'DamTypeDualies' ||
			DmgType == class'DamTypeDeagle' || 
			DmgType == class'DamTypeDualDeagle' || 
			DmgType == class'DamTypeMK23Pistol' ||
			DmgType == class'DamTypeDualMK23Pistol'
			)
		{
			return float(InDamage) * (1.0 + (0.06 * float(KFPRI.ClientVeteranSkillLevel) ) );
		}
	}

	return InDamage;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'Vest' )
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel));  // Up to 70% discount on Body Armor
	}
	else if (
			Item == class'WTFEquipMP7M2Pickup' ||
			Item == class'WTFEquipMP6MPickup' ||
			Item == class'WTFEquipM7A4MPickup' ||
			Item == class'WTFEquipKrissM2Pickup' ||
			Item == class'WTFEquipLethalInjection' ||
			Item == class'WTFEquipMAC12Pickup' ||
			Item == class'WTFEquipTommyGunPickup' ||
			Item == class'WTFEquipMachineDualiesPickup' ||
			Item == class'WTFEquipDeaglePickup' ||
			Item == class'WTFEquipDualDeaglePickup' ||
			Item == class'WTFEquipMK23Pickup' ||
			Item == class'WTFEquipDualMK23Pickup' ||
			Item == class'WTFEquipCrossbowPickup' ||
			Item == class'WTFEquipChemicalSprayerPickup'
			)
	{
		return 0.25 - (0.02 * float(KFPRI.ClientVeteranSkillLevel));  // Up to 87% discount
	}

	return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if (
		Item == class'WTFEquipMP7M2Pickup' ||
		Item == class'WTFEquipMP6MPickup' ||
		Item == class'WTFEquipM7A4MPickup' ||
		Item == class'WTFEquipKrissM2Pickup' ||
		Item == class'WTFEquipLethalInjection' ||
		Item == class'WTFEquipMAC12Pickup' ||
		Item == class'WTFEquipTommyGunPickup' ||
		Item == class'WTFEquipMachineDualiesPickup' ||
		Item == class'WTFEquipDeaglePickup' ||
		Item == class'WTFEquipDualDeaglePickup' ||
		Item == class'WTFEquipMK23Pickup' ||
		Item == class'WTFEquipDualMK23Pickup' ||
		Item == class'WTFEquipCrossbowPickup' ||
		Item == class'WTFEquipChemicalSprayerPickup'
		)
	{
		return 0.25 - (0.02 * float(KFPRI.ClientVeteranSkillLevel));  // Up to 87% discount
	}

	return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
	{
		if (
			AmmoType == class'MP7MAmmo' ||
			AmmoType == class'MP5MAmmo' ||
			AmmoType == class'M7A3MAmmo' ||
			AmmoType == class'KrissMAmmo' ||
			AmmoType == class'MAC10Ammo' ||
			AmmoType == class'ThompsonAmmo' ||
			AmmoType == class'SingleAmmo' ||
			AmmoType == class'DeagleAmmo' ||
			AmmoType == class'MK23Ammo' ||
			AmmoType == class'CrossbowAmmo' ||
			AmmoType == class'WTFEquipChemicalSprayerAmmo'
			)
		{
			return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
		}
	}

	return 1.0;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
	{
		if (
			WTFEquipMP7M2MG(Other) != none ||
			WTFEquipMP6M(Other) != none ||
			WTFEquipM7A4M(Other) != none ||
			WTFEquipKrissM2MG(Other) != none ||
			WTFEquipMAC12MP(Other) != none ||
			WTFEquipTommyGun(Other) != none ||
			WTFEquipMachinePistol(Other) != none ||
			WTFEquipMachineDualies(Other) != none ||
			WTFEquipDeagle(Other) != none ||
			WTFEquipDualDeagle(Other) != none ||
			WTFEquipMK23Pistol(Other) != none ||
			WTFEquipDualMK23Pistol(Other) != none ||
			WTFEquipChemicalSprayer(Other) != none
			)
		{
			return 1.0 + (0.20 * float(KFPRI.ClientVeteranSkillLevel));
		}
	}
	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{	
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		//they spawn with dualies (since you already spawn with 1 MachinePistol)
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipMachineDualies", GetCostScaling(KFPRI, class'WTFEquipMachineDualiesPickup'));
	}
	else if ( KFPRI.ClientVeteranSkillLevel >= 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipMachineDualies", GetCostScaling(KFPRI, class'WTFEquipMachineDualiesPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipMP7M2MG", GetCostScaling(KFPRI, class'WTFEquipMP7M2Pickup'));
	}
	
	if ( KFPRI.ClientVeteranSkillLevel >= 5 )
	{
		P.ShieldStrength = 100;
	}
}

defaultproperties
{
	PerkIndex=0
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Medic'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Medic_Gold'
	VeterancyName="WTF Field Medic"
	Requirements(0)="Heal %x HP on your teammates"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}