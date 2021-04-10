class WTFZombiesBroodmotherController extends CrawlerController;

function ZombieMoan()
{
	Super(KFMonsterController).ZombieMoan();
	WTFZombiesBroodmother(KFM).SpawnBroodlings();
}

defaultproperties
{
	CombatStyle=-1.000000
}
