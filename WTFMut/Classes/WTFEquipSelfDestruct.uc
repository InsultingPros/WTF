class WTFEquipSelfDestruct extends PipeBombExplosive;

#exec OBJ LOAD FILE=WTFTex.utx

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipSelfDestructFire'
	bCanThrow=True
	AmmoClass(0)=Class'WTF.WTFEquipSelfDestructAmmo'
	Description="The last resort."
	Priority=0
	InventoryGroup=1
	GroupOffset=0
	PickupClass=Class'WTF.WTFEquipSelfDestructPickup'
	AttachmentClass=Class'WTF.WTFEquipSelfDestructAttachment'
	ItemName="Self Destruct!"
	Skins(0)=Texture'WTFTex.Selfdestruct.Selfdestruct'
	Skins(1)=Texture'KF_Weapons2_Trip_T.Special.Pipebomb_RLight_OFF'
	Skins(2)=Shader'KF_Weapons2_Trip_T.Special.Pipebomb_GLight_shdr'
}
