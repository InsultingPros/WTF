class WTFEquipGlowstick extends M79GrenadeLauncher;

#exec OBJ LOAD FILE=WTFTex2.utx

defaultproperties
{
	ReloadAnim="Select"
	FlashBoneName="Hands_R_wrist"
	WeaponReloadAnim="Select"
	Weight=0.000000
	bHasAimingMode=False
	IdleAimAnim="Idle"
	FireModeClass(0)=Class'WTF.WTFEquipGlowstickFire'
	FireModeClass(1)=Class'WTF.WTFEquipGlowstickAltFire'
	Description="Primary to toss for long-lasting illumination. Secondary to activate and wear."
	Priority=4
	InventoryGroup=5
	GroupOffset=4
	PickupClass=Class'WTF.WTFEquipGlowstickPickup'
	PlayerViewOffset=(X=0.000000,Y=0.000000,Z=0.000000)
	AttachmentClass=Class'WTF.WTFEquipGlowstickAttachment'
	ItemName="Glowstick"
	Mesh=SkeletalMesh'KF_Weapons_Trip.Pipe_Trip'
	Skins(0)=Texture'WTFTex2.Glowstick.Glowstick'
}
