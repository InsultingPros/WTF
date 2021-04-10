class WTFEquipDamTypeWelda extends DamTypeWelder
	abstract;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed );
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount);

defaultproperties
{
     WeaponClass=Class'WTF.WTFEquipWelda'
}
