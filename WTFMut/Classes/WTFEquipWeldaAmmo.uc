class WTFEquipWeldaAmmo extends Ammunition; //not extending WelderAmmo, had functionality wierdness with that with other weaps sharing same ammo type

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

//TODO: CrossbowAmmoPickup?

defaultproperties
{
     MaxAmmo=300
     InitialAmount=300
     PickupClass=Class'KFMod.CrossbowAmmoPickup'
     IconCoords=(X1=4,Y1=350,X2=110,Y2=395)
     ItemName="Welda Fuel"
}
