class WTFEquipIncineratorPickup extends HuskGunPickup;

defaultproperties
{	
	Description="Primary to charge up a firebolt, Secondary to spray intense flames."
	ItemName="Incinerator"
	ItemShortName="Incinerator"
	InventoryType=Class'WTF.WTFEquipIncinerator'
	PickupMessage="You picked up the Incinerator."
	
	Weight=8.000000
	cost=4000
	AmmoCost=2
	BuyClipSize=1
	PowerValue=85
	SpeedValue=25
	RangeValue=75

	AmmoItemName="Husk Gun Fuel"
	AmmoMesh=StaticMesh'KillingFloorStatics.FT_AmmoMesh'
	CorrespondingPerkIndex=5
	EquipmentCategoryID=3
	MaxDesireability=0.790000

	PickupSound=Sound'KF_HuskGunSnd.foley.Husk_Pickup'
	PickupForce="AssaultRiflePickup"
	StaticMesh=StaticMesh'KF_pickups3_Trip.Rifles.HuskGun_Pickup'
	CollisionRadius=25.000000
	CollisionHeight=10.000000
}