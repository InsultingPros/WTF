class WTFEquipM4204FmAAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
	MaxAmmo=300
	InitialAmount=150
	AmmoPickupAmount=30
	PickupClass=Class'KFMod.M4203AmmoPickup'
	IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
	IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
	ItemName="M4 w/M203 bullets"
}

