class WTFEquipFURYDamType extends KFWeaponDamageType
	abstract;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
}

defaultproperties
{
	WeaponClass=Class'WTF.WTFEquipFURYDamType'
	KDamageImpulse=3000.000000
	VehicleDamageScaling=0.500000
	
	bIsExplosive=True
	bCheckForHeadShots=False
	DeathString="%o filled %k's body with FURY."
	FemaleSuicide="%o couldn't contain the FURY."
	MaleSuicide="%o couldn't contain the FURY."
	bLocationalHit=False
	bThrowRagdoll=True
	bExtraMomentumZ=True
	DamageThreshold=1
	DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
	DeathOverlayTime=999.000000
	KDeathVel=900.000000
	KDeathUpKick=600.000000
	HumanObliterationThreshhold=1
}
