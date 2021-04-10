class WTFZombiesAIAvoidSpot extends WTFZombiesAIWarnSpot
	placeable;

function SendWarning(KFMonsterController Other)
{
	if (MyProjectile != None)
	{
		Log("WTFZombiesAIAvoidSpot: SendWarning(): My Location="$String(Location));
		Log("WTFZombiesAIAvoidSpot: SendWarning(): MyProjectiles Location="$String(MyProjectile.Location));
		Other.FearThisSpot(self);
	}
}

defaultproperties
{
     CollisionRadius=200.000000
}
