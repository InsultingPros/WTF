class WTFEquipFSyringe extends Syringe;

defaultproperties
{
	HudImage=Texture'KillingFloorHUD.WeaponSelect.syring_unselected' //art from joe
	SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.Syringe' //art from joe
	FireModeClass(0)=Class'WTF.WTFEquipFSyringeAltFire'
	FireModeClass(1)=Class'KFMod.NoFire'
	PickupClass=Class'WTF.WTFEquipFSyringePickup'
	AttachmentClass=Class'KFMod.SyringeAttachment' //art from joe
	ItemName="F-Syringe"
	Description="Unleash the FURY."
	Skins(0)=Combiner'KF_Weapons_Trip_T.equipment.medInjector_cmb' //art from joe
}
