class WTFEquipDamTypeLethalInjection extends KFWeaponDamageType;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed );
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount);

defaultproperties
{
     DeathString="%o was poisoned."
     bLocationalHit=False
}
