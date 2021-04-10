class WTFVetFirebug extends SRVetFirebug
	abstract;

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
	{
		return class'WTFEquipGrenadeFlame'; // Grenade detonations cause enemies to catch fire
	}

	return super.GetNadeType(KFPRI);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	If (KFPRI.ClientVeteranSkillLevel > 0) {
		If (
			WTFEquipFirehose(Other) != none ||
			WTFEquipMAC12MP(Other) != none
			)
		{
			return 1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 60%
		}
	}

	return 1.0;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	If (KFPRI.ClientVeteranSkillLevel > 0) {
		If (
			FlameAmmo(Other) != none ||
			MAC10Ammo(Other) != none ||
			HuskGunAmmo(Other) != none ||
			TrenchgunAmmo(Other) != none ||
			FlareRevolverAmmo(Other) != none ||
			LAWAmmo(Other) != none ||
			M79Ammo(Other) != none ||
			M32Ammo(Other) != none
			) {
			return 1.0 + (0.12 * float(KFPRI.ClientVeteranSkillLevel));
		}
	}

	return 1.0;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	If (KFPRI.ClientVeteranSkillLevel > 0) {
		If (
			AmmoType == class'FlameAmmo' ||
			AmmoType == class'MAC10Ammo' ||
			AmmoType == class'HuskGunAmmo' ||
			AmmoType == class'TrenchgunAmmo' ||
			AmmoType == class'FlareRevolverAmmo' ||
			AmmoType == class'LAWAmmo' ||
			AmmoType == class'M79Ammo' ||
			AmmoType == class'M32Ammo'
			) {
			return 1.0 + (0.12 * float(KFPRI.ClientVeteranSkillLevel));
		}
	}

	return 1.0;
}

//extra damage with welda, but this only applies when hitting zeds (no bonus for door welding)
static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType)
{
	if (
		class<DamTypeBurned>(DmgType) != none || 
		class<DamTypeFlamethrower>(DmgType) != none || 
		class<WTFEquipDamTypeWelda>(DmgType) != none ||
		class<DamTypeFlameNade>(DmgType) != none ||
		class<DamTypeHuskGunProjectileImpact>(DmgType) != none ||
		class<DamTypeHuskGun>(DmgType) != none ||
		class<DamTypeTrenchgun>(DmgType) != none ||
		class<DamTypeFlareRevolver>(DmgType) != none ||
		class<DamTypeFlareProjectileImpact>(DmgType) != none ||
		class<DamTypeMAC10MPInc>(DmgType) != none
		)
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
		{
			return float(InDamage) * 1.05;
		}

		return float(InDamage) * (1.0 + (0.10 * float(KFPRI.ClientVeteranSkillLevel))); //  Up to 60% extra damage
	}

	return InDamage;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if (
		WTFEquipFirehose(Other) != none ||
		WTFEquipMAC12MP(Other) != none ||
		Trenchgun(Other) != none ||
		FlareRevolver(Other) != none ||
		DualFlareRevolver(Other) != none ||
		WTFEquipM79CF(Other) != none ||
		WTFEquipUM32GL(Other) != none ||
		WTFEquipLAWL(Other) != none
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
		Item == class'WTFEquipFirehosePickup' || 
		Item == class'WTFEquipMAC12Pickup' ||
        Item == class'WTFEquipIncineratorPickup' || 
		Item == class'TrenchgunPickup' || 
		Item == class'FlareRevolverPickup' ||
        Item == class'DualFlareRevolverPickup' ||
		Item == class'WTFEquipM79CFPickup' ||
		Item == class'WTFEquipUM32Pickup' ||
		Item == class'WTFEquipLAWLPickup'
		)
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Flame Weapons
	}

	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{	
	// If Level 5, give them a Flame Thrower
	if ( KFPRI.ClientVeteranSkillLevel >= 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipFirehose", GetCostScaling(KFPRI, class'WTF.WTFEquipFirehosePickup'));
	}

	// If Level 6, add Body Armor
	if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		P.ShieldStrength = 100;
	}
}

defaultproperties
{
	PerkIndex=5
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Firebug'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Firebug_Gold'
	VeterancyName="WTF Firebug"
	Requirements(0)="Deal %x damage with the flame weapons"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}