class WTFEquipLethalInjectionPickup extends KFWeaponPickup;

defaultproperties
{
	Weight=1.000000
	cost=500
	Description="Injects debilitating toxins (damage over time). WTF Medic: also slows zeds."
	ItemName="Lethal Injection"
	ItemShortName="Lethal Injection"
	EquipmentCategoryID=3
	InventoryType=Class'WTF.WTFEquipLethalInjection'
	PickupMessage="You found a Lethal Injection."
	PickupSound=Sound'Inf_Weapons_Foley.Misc.AmmoPickup'
	PickupForce="AssaultRiflePickup"
	StaticMesh=StaticMesh'KF_pickups_Trip.equipment.Syringe_pickup'
	Skins(0)=Texture'WTFTex.Lethalinjection.Lethalinjection_3rd'
	CollisionHeight=5.000000
}
