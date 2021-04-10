class WTFEquipSCAR19AR extends SCARMK17AssaultRifle
	config(user);

var bool IsWTFCommando;
var WTFEquipSCAR19FmA MyFm;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MyFm = WTFEquipSCAR19FmA(FireMode[0]);
}
simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	
	Super.BringUp(PrevWeapon);
	
	//No role check; both client and server should have the same value for IsWTFCommando
	IsWTFCommando = False;
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none) {
		if (KFPRI.ClientVeteranSkill == Class'WTFVetCommando') {
			IsWTFCommando = True;
			TellPlayerCurrentAutoMode();
		}
	}
}
simulated function DoToggle()
{
	if (!IsWTFCommando) {
		Super.DoToggle();
		return;
	}
	
	if( IsFiring() )
		return;

	MyFm.NextAutoMode();
	ServerChangeFireMode(True);
	PlayOwnedSound(ToggleSound,SLOT_None,2.0,,,,false);
	TellPlayerCurrentAutoMode();
}
function ServerChangeFireMode(bool bNewWaitForRelease) {
	if (!IsWTFCommando) {
		return;
	}
	MyFm.NextAutoMode();
}
simulated function TellPlayerCurrentAutoMode() {
	local PlayerController Player;
	
	Player = Level.GetLocalPlayerController();
	if (Player == None)
		return;

	if (MyFm.MyFireSpeedDiv == 1.0 && !MyFm.bWaitForRelease) {
		Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',3);
	}
	else if (MyFm.MyFireSpeedDiv == 3.0 && !MyFm.bWaitForRelease) {
		Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',4);
	}
	else if (MyFm.MyFireSpeedDiv == 1.0 && MyFm.bWaitForRelease) {
		Player.ReceiveLocalizedMessage(class'WTF.WTFMessages',5);
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipSCAR19FmA'
	Description="WTF Commando: toggle to Super Auto"
	PickupClass=Class'WTF.WTFEquipSCAR19Pickup'
	ItemName="SCAR19"
}