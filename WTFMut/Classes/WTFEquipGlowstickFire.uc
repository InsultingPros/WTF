class WTFEquipGlowstickFire extends M79Fire;

#exec OBJ LOAD FILE=KF_AxeSnd.uax

defaultproperties
{
	StereoFireSoundRef="KF_AxeSnd.AxeFireBase.Axe_Fire1"
	FireSoundRef="KF_AxeSnd.AxeFireBase.Axe_Fire1"
	NoAmmoSoundRef="KF_AxeSnd.AxeFireBase.Axe_Fire1"
	FireRate=1.000000
	AmmoClass=Class'WTF.WTFEquipGlowstickAmmo'
	ProjectileClass=Class'WTF.WTFEquipGlowstickProj'
}
