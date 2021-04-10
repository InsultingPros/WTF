class WTFEquipDwarfsAxe extends DwarfAxe;

var float NextIronTime;
var bool IsBerserker; //turns on/off special weapon behaviors

replication
{
	reliable if(Role < ROLE_Authority)
		DoLunge;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFMeleeFire FmA, FmB;
	
	Super.BringUp(PrevWeapon);

	//if (Role == ROLE_Authority)
	//{
		IsBerserker = False;
		FmA = KFMeleeFire(FireMode[0]);
		FmB = KFMeleeFire(FireMode[1]);
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetBerserker') {
				IsBerserker = True;
				ChopSlowRate = 1.0;
				FmA.WideDamageMinHitAngle = 0.6 * FmA.Default.WideDamageMinHitAngle; //smaller means wider hit arc
				FmB.MaxHoldTime=60.0; //let player hold it until they wanna use it
			}
		}
		if (!IsBerserker) {
			ChopSlowRate = Default.ChopSlowRate;
			FmA.WideDamageMinHitAngle = FmA.Default.WideDamageMinHitAngle;
			FmB.MaxHoldTime=FmB.Default.MaxHoldTime;
		}
	//}
}

simulated exec function ToggleIronSights()
{	
	if (!IsBerserker)
		return;
		
	if (
		NextIronTime <= Level.TimeSeconds &&
		!FireMode[0].bIsFiring && FireMode[0].NextFireTime < Level.TimeSeconds &&
		!FireMode[1].bIsFiring && FireMode[1].NextFireTime < Level.TimeSeconds
		)
	{
		if (Instigator != none && Instigator.Physics != PHYS_Falling)
		{
			DoLunge();
			if (ROLE < ROLE_AUTHORITY) //client-side fx, essentially
				FireMode[1].ModeDoFire();
				
			NextIronTime=Level.TimeSeconds+3.0;
		}
	}
}

simulated function DoLunge()
{
	local rotator VR; //ViewRotation
	local vector DirMomentum;
	
	VR = Instigator.Controller.GetViewRotation();

	DirMomentum.X=325.0;
	DirMomentum.Y=0.0;
	DirMomentum.Z= 275.0; //325.0; //default kfhumanpawn jump height
	VR.Pitch=0;
	
	FireMode[1].ModeDoFire();
	Instigator.AddVelocity(DirMomentum >> VR);
}

defaultproperties
{
	Description="A battle axe from Dwarfs!? Primary might have magical properties..."
	PickupClass=Class'WTF.WTFEquipDwarfsAxePickup'
	ItemName="WTF? Dwarfs Axe!?"
	FireModeClass(0)=Class'WTF.WTFEquipDwarfsAxeFmA'
	FireModeClass(1)=Class'WTF.WTFEquipDwarfsAxeFmB'
	
  appID=210939
	UnlockedByAchievement=208
}