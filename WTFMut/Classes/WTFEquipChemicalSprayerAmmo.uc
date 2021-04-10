class WTFEquipChemicalSprayerAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
	MaxAmmo=400
	InitialAmount=400
	AmmoPickupAmount=80
	PickupClass=Class'WTF.WTFEquipChemicalSprayerAmmoPickup'
	IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
	IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
	ItemName="Chem Canisters"
}