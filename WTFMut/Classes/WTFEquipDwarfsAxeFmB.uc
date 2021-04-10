class WTFEquipDwarfsAxeFmB extends DwarfAxeFireB;

var float MyHoldTime, MyMaxHoldTime;

simulated event ModeDoFire()
{
	MyHoldTime = HoldTime;
	Super.ModeDoFire();
}

simulated function Timer()
{
	local PlayerController Player;
	local float DamageMult;
	local bool FullyCharged, DeathFromAbove;
	
	if (WTFEquipDwarfsAxe(Weapon).IsBerserker) {
		DamageMult = 1.0;
		FullyCharged = False;
		DeathFromAbove = False;
		Player = PlayerController(Instigator.Controller);
		if (Instigator.Velocity.Z < 0)
			DeathFromAbove = True;
		if (MyHoldTime >= MyMaxHoldTime)
			FullyCharged = True;
		if (Player != None) {
			if (DeathFromAbove && FullyCharged) {
				DamageMult = 1.3;
				Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',8);
			}
			else if (DeathFromAbove) {
				DamageMult = 1.15;
				Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',6);
			}
			else if (FullyCharged) {
				DamageMult = 1.15;
				Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',7);
			}
		}
		if (Level.NetMode != NM_Client) {
			MeleeDamage *= DamageMult;
			Super.Timer();
			MeleeDamage = Default.MeleeDamage;
		}
	}
	else {
		Super.Timer();
	}
}

defaultproperties
{
	//charging stuff
	bFireOnRelease=true
	MaxHoldTime=0.01
	MyMaxHoldTime=1.5
}