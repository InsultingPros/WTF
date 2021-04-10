class WTFEquipMKb43AR extends MKb42AssaultRifle
	config(user);

var bool IsWTFCommando;
var WTFEquipMKb43FmA MyFm;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MyFm = WTFEquipMKb43FmA(FireMode[0]);
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
		}
	}
}

simulated function DoToggle()
{
	if (!IsWTFCommando)
	{
		Super.DoToggle();
	}
	Else
	{
		MyFm.NextMode();
		if (ROLE < ROLE_AUTHORITY)
			ServerChangeFireMode(MyFm.bWaitForRelease);
	}
}
function ServerChangeFireMode(bool bNewWaitForRelease)
{
	if (!IsWTFCommando)
	{
		Super.ServerChangeFireMode(bNewWaitForRelease);
	}
	Else
	{
		MyFm.NextMode();
	}
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipMKb43FmA'
	Description="WTF Commando: toggle to Super Auto"
	PickupClass=Class'WTF.WTFEquipMKb43Pickup'
	ItemName="MKb43"
}