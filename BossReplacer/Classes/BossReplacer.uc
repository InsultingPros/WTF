class BossReplacer extends Mutator
	Config(BossReplacer);

var localized string BossReplacerConfig;
var() globalconfig string BossClass;

function PostBeginPlay()
{
	
	SetTimer(5.0,False);
	Super.PostBeginPlay();
}

function Timer()
{
	local KFGameType KF;
	KF = KFGameType(Level.Game);
	KF.EndGameBossClass=BossClass;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.BossReplacerConfig,"BossClass","Boss Class",1,0, "Text", "64");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "BossClass":		return "Specify the [Package.Class] to use as the boss.";
	}
	return Super.GetDescriptionText(PropName);
}

defaultproperties
{
	BossClass="WTF.WTFZombiesHateriarch"
	bAddToServerPackages=True
	GroupName="KF-BossReplacer"
	FriendlyName="Boss Replacer"
	Description="Allows the host to specify a custom end-game boss."
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}
