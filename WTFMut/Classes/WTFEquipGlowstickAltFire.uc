class WTFEquipGlowstickAltFire extends WTFEquipGlowstickFire;

#exec OBJ LOAD FILE=KF_AxeSnd.uax

var float NextHangTime;

event ModeDoFire()
{
	if (Level.TimeSeconds > NextHangTime)
	{
		NextHangTime = Level.TimeSeconds + 300.0;
		Super.ModeDoFire();
	}
}

defaultproperties
{
	ProjectileClass=Class'WTF.WTFEquipGlowstickProjHanging'
}
