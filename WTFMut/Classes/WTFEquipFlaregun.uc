class WTFEquipFlaregun extends M79GrenadeLauncher;

#exec OBJ LOAD FILE=WTFTex.utx

defaultproperties
{
	Weight=1.000000
	FireModeClass(0)=Class'WTF.WTFEquipFlaregunFire'
	Description="Fires a long-lasting flare for illumination."
	Priority=5
	InventoryGroup=5
	GroupOffset=3
	PickupClass=Class'WTF.WTFEquipFlaregunPickup'
	AttachmentClass=Class'WTF.WTFEquipFlaregunAttachment'
	ItemName="Flaregun"
	Skins(0)=Texture'WTFTex.FlareGun.FlareGun'
}
