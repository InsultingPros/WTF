class WTFEquipM4204FmB extends M203Fire;

event ModeDoFire()
{
	local float MySpread;
	local float Rec;
	
	if (!AllowFire())
		return;

	//To "Ramm": WHY YOU DO DIS!? STOP IT!
	//Spread = Default.Spread;
	MySpread = Spread;
	
	Rec = GetFireSpeed();
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	Rec = 1;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		MySpread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
	}

	if( !bFiringDoesntAffectMovement )
	{
		if (FireRate > 0.25)
		{
			Instigator.Velocity.x *= 0.1;
			Instigator.Velocity.y *= 0.1;
		}
		else
		{
			Instigator.Velocity.x *= 0.5;
			Instigator.Velocity.y *= 0.5;
		}
	}

	Super(WeaponFire).ModeDoFire(); //don't reset mah spread! Just need WeaponFire to do other important stuff

	// client
	if (Instigator.IsLocallyControlled())
	{
		HandleRecoil(Rec);
	}
}

defaultproperties
{
	ProjectileClass=Class'WTF.WTFEquipM4204FmBProj'
	AmmoClass=Class'WTF.WTFEquipM4204FmBAmmo'
}