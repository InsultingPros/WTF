class WTFEquipBanHammerAttachment extends AxeAttachment;

#exec OBJ LOAD FILE=WTFTex2.utx

/*
simulated function PostNetBeginPlay()
{
	Super(BaseKFWeaponAttachment).PostNetBeginPlay();
	SetTimer(1.0,true);
}

simulated function Timer()
{
	Super(BaseKFWeaponAttachment).Timer();
	
	if (Instigator != None && WTFEquipBanHammer(Instigator.Weapon) != None && WTFEquipBanHammer(Instigator.Weapon).bIsBlown)
	{
		Skins[0]=Texture'WTFTex2.BanHammer.Banhammer_bloody_3rd';
	}
	else
	{
		Skins[0]=Texture'WTFTex2.BanHammer.Banhammer_3rd';
	}
}
*/

defaultproperties
{
	Skins(0)=Texture'WTFTex2.BanHammer.Banhammer_3rd'
}
