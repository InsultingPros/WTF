class WTFVetSharpshooter extends SRVetSharpshooter
	abstract;

//overridden because I simply made pointy sticks reasonably affordable so there's no need for a special discount on them
static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	return 1.0;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	if (
        WTFEquipMachinePistol(Other.Weapon) != none ||
		WTFEquipMachineDualies(Other.Weapon) != none || 
		WTFEquipCrossbow(Other.Weapon) != none || 
		Winchester(Other.Weapon) != none ||
		WTFEquipDeagle(Other.Weapon) != none || 
		WTFEquipDualDeagle(Other.Weapon) != none ||
		M14EBRBattleRifle(Other.Weapon) != none ||
		WTFEquip44Magnum(Other.Weapon) != none ||
		WTFEquipDual44Magnum(Other.Weapon) != none ||
		WTFEquipMK23Pistol(Other.Weapon) != none ||
		WTFEquipDualMK23Pistol(Other.Weapon) != none ||
		WTFEquipM1000SR(Other.Weapon) != none
		)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 1)
		{
			Recoil = 0.75;
		}
		else if ( KFPRI.ClientVeteranSkillLevel == 2 )
		{
			Recoil = 0.50;
		}
		else
		{
			Recoil = 0.25; // 75% recoil reduction
		}

		return Recoil;
	}

	Recoil = 1.0;
	Return Recoil;
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if (
        WTFEquipMachinePistol(Other) != none ||
		WTFEquipMachineDualies(Other) != none || 
		WTFEquipCrossbow(Other) != none || 
		Winchester(Other) != none ||
		WTFEquipDeagle(Other) != none || 
		WTFEquipDualDeagle(Other) != none ||
		M14EBRBattleRifle(Other) != none ||
		WTFEquip44Magnum(Other) != none ||
		WTFEquipDual44Magnum(Other) != none ||
		WTFEquipMK23Pistol(Other) != none ||
		WTFEquipDualMK23Pistol(Other) != none ||
		WTFEquipM1000SR(Other) != none
		)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
		{
			return 1.0;
		}

		return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% faster fire rate
	}

	return 1.0;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if (
        WTFEquipMachinePistol(Other) != none ||
		WTFEquipMachineDualies(Other) != none || 
		WTFEquipCrossbow(Other) != none || 
		Winchester(Other) != none ||
		WTFEquipDeagle(Other) != none || 
		WTFEquipDualDeagle(Other) != none ||
		M14EBRBattleRifle(Other) != none ||
		WTFEquip44Magnum(Other) != none ||
		WTFEquipDual44Magnum(Other) != none ||
		WTFEquipMK23Pistol(Other) != none ||
		WTFEquipDualMK23Pistol(Other) != none ||
		WTFEquipM1000SR(Other) != none
		)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
		{
			return 1.0;
		}

		return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60% faster reload
	}

	return 1.0;
}

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if (
		Item == class'WTFEquipMachineDualiesPickup' || 
		Item == class'WTFEquipCrossbowPickup' || 
		Item == class'WinchesterPickup' ||
		Item == class'WTFEquipDeaglePickup' || 
		Item == class'WTFEquipDualDeaglePickup' ||
		Item == class'M14EBRPickup' ||
		Item == class'WTFEquip44MagnumPickup' ||
		Item == class'WTFEquipDual44MagnumPickup' ||
		Item == class'WTFEquipMK23Pickup' ||
		Item == class'WTFEquipDualMK23Pickup' ||
		Item == class'WTFEquipM1000Pickup'
		)
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70%
	}

	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	// If Level 5, give them a  Lever Action Rifle
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Winchester", GetCostScaling(KFPRI, class'DualDeaglePickup'));
	}

	// If Level 6, give them a Crossbow
	if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipCrossbow", GetCostScaling(KFPRI, class'CrossbowPickup'));
	}
}

defaultproperties
{
	PerkIndex=2
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_SharpShooter'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_SharpShooter_Gold'
	VeterancyName="WTF Sharpshooter"
	Requirements(0)="Get %x headshot kills with Sharpshooter weapons"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}