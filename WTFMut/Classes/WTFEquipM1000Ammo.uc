class WTFEquipM1000Ammo extends M99Ammo;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
	AmmoPickupAmount=2
	MaxAmmo=25
	InitialAmount=5
	PickupClass=Class'WTF.WTFEquipM1000AmmoPickup'
	IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
	IconCoords=(X1=4,Y1=350,X2=110,Y2=395)
	ItemName="50 Cal Bullets"
}
