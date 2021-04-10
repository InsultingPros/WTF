class WTFZombiesAIWarnSpot extends FearSpot
	placeable;

var Projectile MyProjectile;

function Touch( actor Other )
{
	local KFMonster Target;
	local KFMonsterController TargetController;
	
	Target=KFMonster(Other);
	if(Target!=None)
	{
		if (ShouldWarn(Target))
		{
			TargetController=KFMonsterController(Target.Controller);
			if(TargetController!=None)
				SendWarning(TargetController);
		}
	}
}

function bool ShouldWarn(KFMonster Other)
{
	if ( Other.IsA('ZombieSirenBase') || Other.IsA('WTFZombiesBansheeBase') || Other.IsA('ZombieBossBase') )
		return true;
	return false;
}

function SendWarning(KFMonsterController Other)
{
	if (MyProjectile != None)
	{
		Log("WTFZombiesAIWarnSpot: SendWarning(): My Location="$String(Location));
		Log("WTFZombiesAIWarnSpot: SendWarning(): MyProjectiles Location="$String(MyProjectile.Location));
		Other.Target = MyProjectile;
		Other.Focus = MyProjectile;
		Other.FireWeaponAt(MyProjectile);
	}
}

defaultproperties
{
     CollisionRadius=500.000000
     CollisionHeight=50.000000
}
