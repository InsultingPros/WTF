class WTFVetBerserker extends SRVetBerserker
	abstract;

/*
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	return class'WTFEquipGrenadeThrowingKnife';
}
*/

static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if (
		Item == class'WTFEquipRIPsawPickup' ||
		Item == class'WTFEquipKatanaPickup' ||
		Item == class'WTFEquipClaymoreSwordPickup' ||
		Item == class'CrossbuzzsawPickup' ||
		Item == class'ScythePickup' ||
		Item == class'GoldenKatanaPickup' ||
		Item == class'WTFEquipMachetePickup' || 
		Item == class'WTFEquipAxeOfViolencePickup' || 
		Item == class'WTFEquipDwarfsAxePickup' )
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Melee Weapons
	}

	return 1.0;
}

/*
//throwing knives
static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( AmmoType == class'FragAmmo'  )
	{
		return 1.0 + (0.2 * float(KFPRI.ClientVeteranSkillLevel));
	}

	return 1.0;
}

//throwing knives
static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'FragAmmoPickup' )
	{
		return 0.9 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount on Throwing Knives
	}

	return 1.0;
}
*/

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	// If Level 5, give them Machete
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipMachete", GetCostScaling(KFPRI, class'MachetePickup'));
	}

	// If Level 6, give them an AxeOfViolence
	if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipAxeOfViolence", GetCostScaling(KFPRI, class'WTFEquipAxeOfViolencePickup'));
	}

	// If Level 6, give them Body Armor(Removed from Suicidal and HoE in Balance Round 7)
	if ( KFPRI.Level.Game.GameDifficulty < 5.0 && KFPRI.ClientVeteranSkillLevel == 6 )
	{
		P.ShieldStrength = 100;
	}
}

defaultproperties
{
	PerkIndex=4
	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Berserker'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Berserker_Gold'
	VeterancyName="WTF Berserker"
	Requirements(0)="Deal %x damage with melee weapons"
	LevelEffects(0)=""
	LevelEffects(1)=""
	LevelEffects(2)=""
	LevelEffects(3)=""
	LevelEffects(4)=""
	LevelEffects(5)=""
	LevelEffects(6)=""
}