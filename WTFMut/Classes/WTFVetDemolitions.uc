class WTFVetDemolitions extends SRVetDemolitions
	abstract;

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'WTFEquipPipeBombPickup' )
	{
		// Todo, this won't need to be so extreme when we set up the system to only allow him to buy it perhaps
		return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 74% discount on PipeBomb(changed to 68% in Balance Round 1, upped to 74% in Round 4)
	}
	else if (
			Item == class'WTFEquipM79CFPickup' || 
			Item == class'WTFEquipUM32Pickup' || 
			Item == class'WTFEquipLAWLPickup' || 
			Item == class'WTFEquipM4204Pickup' ||
			Item == class'WTFEquipBanHammerPickup' ||
			Item == class'WTFEquipAA13Pickup' ||
			Item == class'SPGrenadePickup' ||
			Item == class'GoldenM79Pickup' ||
			Item == class'CamoM32Pickup' ||
			Item == class'SealSquealPickup' ||
			Item == class'SeekerSixPickup'
			)
	{
		return 0.90 - (0.10 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 70% discount
	}

	return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'WTFEquipPipeBombPickup' )
	{
		return 0.5 - (0.04 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 74% discount on PipeBomb(changed to 68% in Balance Round 3, upped to 74% in Round 4)
	}
	else if (
			Item == class'WTFEquipM79CFPickup' ||
			Item == class'WTFEquipUM32Pickup' ||
			Item == class'WTFEquipLAWLPickup' ||
			Item == class'WTFEquipM4204Pickup' ||
			Item == class'GoldenM79Pickup' ||
			Item == class'SPGrenadePickup' ||
			Item == class'CamoM32Pickup' ||
			Item == class'SealSquealPickup' ||
			Item == class'WTFEquipAA13Pickup'
			)
	{
		return 1.0 - (0.05 * float(KFPRI.ClientVeteranSkillLevel)); // Up to 30% discount on Grenade Launcher and LAW Ammo(Balance Round 5)
	}

	return 1.0;
}

static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{	
	// If Level 5, give them a pipe bomb
	if ( KFPRI.ClientVeteranSkillLevel == 5 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipPipeBomb", GetCostScaling(KFPRI, class'WTFEquipPipeBombPickup'));
	}
	else if ( KFPRI.ClientVeteranSkillLevel == 6 )
	{
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipPipeBomb", GetCostScaling(KFPRI, class'WTFEquipPipeBombPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipM79CF", GetCostScaling(KFPRI, class'WTFEquipM79CFPickup'));
		KFHumanPawn(P).CreateInventoryVeterancy("WTF.WTFEquipBanHammer", GetCostScaling(KFPRI, class'WTFEquipBanHammerPickup'));
	}
}

defaultproperties
{
	PerkIndex=6
	OnHUDIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition_Gold'
	VeterancyName="WTF Demolitions"
	Requirements(0)="Deal %x damage with the Explosives"
	LevelEffects(0)="test description"
	LevelEffects(1)="test description"
	LevelEffects(2)="test description"
	LevelEffects(3)="test description"
	LevelEffects(4)="test description"
	LevelEffects(5)="test description"
	LevelEffects(6)="test description"
}