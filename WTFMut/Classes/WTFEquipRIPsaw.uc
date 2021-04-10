class WTFEquipRIPsaw extends Chainsaw;

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
	local KFMeleeFire FmB;
	
	Super.BringUp(PrevWeapon);

	//if (Role == ROLE_Authority)
	//{
		IsBerserker = False;
		FmB = KFMeleeFire(FireMode[1]);
		
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetBerserker') {
				IsBerserker = True;
				ChopSlowRate = 1.0; //no bSpeedMeUp is enough of a speed penalty, no additional slowdown for firing
				FmB.MaxHoldTime=60.0; //let player hold it until they wanna use it
			}
		}
		if (!IsBerserker) {
			ChopSlowRate = Default.ChopSlowRate;
			FmB.MaxHoldTime=FmB.Default.MaxHoldTime;
		}
	//}
} 

simulated exec function ToggleIronSights()
{
	local KFPlayerReplicationInfo KFPRI;
	
	//this functionality is available to berserkers only
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none || KFPRI.ClientVeteranSkill != Class'WTFVetBerserker')
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

	DirMomentum.X=300.0;
	DirMomentum.Y=0.0;
	DirMomentum.Z= 275.0; //325.0; //default kfhumanpawn jump height
	VR.Pitch=0;
	
	FireMode[1].ModeDoFire();
		
	Instigator.AddVelocity(DirMomentum >> VR);
}

defaultproperties
{
	//it's just so powerful, there has to be this drawback
	//bSpeedMeUp=True
	
	ItemName="RIPSaw"
	BloodyMaterialRef="WTFTex.Chainsaw.Chainsaw_bloody"
	FireModeClass(0)=Class'WTF.WTFEquipRIPsawFmA'
	FireModeClass(1)=Class'WTF.WTFEquipRIPsawFmB'
	Description="WTF Berserker: attacks do not slow you, iron-sights to lunge, hold secondary to charge or release while falling."
	PickupClass=Class'WTF.WTFEquipRIPsawPickup'
	AttachmentClass=Class'WTF.WTFEquipRIPsawAttachment'
	SkinRefs(0)="WTFTex.Chainsaw.Chainsaw"
	SkinRefs(1)="KF_Specimens_Trip_T.scrake_saw_panner"
}
