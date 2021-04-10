class WTFEquipKatana extends Katana;

var float NextIronTime; //cooldown for on-demand ZED Time; Iron-sights can't be used until level time has passed this mark
var bool IsBerserker; //turns on/off special weapon behaviors
var bool ZEDTimeActive; //used by client/server-side Fire code to return same FireSpeed on both client and server since client can't directly know if KFGameType(Level.Game).bZEDTimeActive

Replication {
	Reliable if (ROLE < ROLE_AUTHORITY)
		ServerZEDTime;
	Reliable if (ROLE == ROLE_AUTHORITY)
		ZEDTimeActive;
}

simulated event RenderOverlays(Canvas Canvas)
{
	Super.RenderOverlays(Canvas);
	
	Canvas.Style = 255;

	//Draw some text.
	Canvas.Font = Canvas.SmallFont;
	Canvas.SetDrawColor(200,150,0);

	Canvas.SetPos(Canvas.SizeX * 0.5, Canvas.SizeY * 0.1);
	if (Level.TimeSeconds < NextIronTime)
		Canvas.DrawText( String(Int(NextIronTime - Level.TimeSeconds)) );
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local KFPlayerReplicationInfo KFPRI;
	local KFMeleeFire FM0,FM1;
	
	Super.BringUp(PrevWeapon);

	//if (Role == ROLE_Authority)
	//{
		IsBerserker = False;
		
		FM0 = KFMeleeFire(FireMode[0]);
		FM1 = KFMeleeFire(FireMode[1]);
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI != none) {
			if (KFPRI.ClientVeteranSkill == Class'WTFVetBerserker') {
				IsBerserker = True;
				ChopSlowRate = 1.0;
				FM0.WideDamageMinHitAngle = 0.6 * FM0.Default.WideDamageMinHitAngle; //smaller means wider hit arc
				FM1.WideDamageMinHitAngle = 0.6 * FM1.Default.WideDamageMinHitAngle;
			}
		}
		if (!IsBerserker) {
			ChopSlowRate = Default.ChopSlowRate;
			FM0.WideDamageMinHitAngle = FM0.Default.WideDamageMinHitAngle;
			FM1.WideDamageMinHitAngle = FM1.Default.WideDamageMinHitAngle;
		}
	//}
}

simulated exec function ToggleIronSights()
{
	if (IsBerserker) {
		if (NextIronTime <= Level.TimeSeconds) {
			NextIronTime=Level.TimeSeconds+90.0;
			ServerZEDTime();
		}
	}
}

function ServerZEDTime() {
	if (KFGameType(Level.Game).bWaveInProgress) {
		KFGameType(Level.Game).DramaticEvent(1.0);
	}
}

simulated function WeaponTick(float dt)
{
	Super.WeaponTick(dt);
	
	if (!IsBerserker)
		Return;
	
	//ensure we are running on server
	if (Level.Game == None)
		Return;
	
	//change once each time ZEDTime starts
	if (KFGameType(Level.Game).bZEDTimeActive && Instigator.AccelRate < 100000.0) {
		SuperMovement();
	}
	//change once each time ZEDTime ends
	if (KFGameType(Level.Game).bZEDTimeActive == False && Instigator.AccelRate >= 100000.0) {
		ResetMovement();
	}
}

function SuperMovement() {
	local KFHumanPawn P;
	
	ZEDTimeActive = True;
	
	P = KFHumanPawn(Instigator);
	P.InventorySpeedModifier=500;
	P.AccelRate=100000.0;
	P.ModifyVelocity(Level.TimeSeconds, Instigator.Velocity);
}

function ResetMovement() {
	local KFHumanPawn P;
	
	ZEDTimeActive = False;
	
	P = KFHumanPawn(Instigator);
	P.InventorySpeedModifier = ((P.default.GroundSpeed * P.BaseMeleeIncrease) - Weight * 2);
	P.AccelRate=P.Default.AccelRate;
	P.AirControl=P.Default.AirControl;
	P.AirSpeed=P.Default.AirSpeed;
	P.ModifyVelocity(Level.TimeSeconds, P.Velocity);
}

///////////////////////////////////////////////////////////////
// MAKE SURE MOVEMENT SPEED GETS RESET
///////////////////////////////////////////////////////////////

simulated function Weapon WeaponChange( byte F, bool bSilent )
{
	ResetMovement();
	return Super.WeaponChange(F,bSilent);
}

simulated function bool PutDown()
{
	ResetMovement();
	return Super.PutDown();
}

simulated function bool CanThrow()
{
	ResetMovement();
	return Super.CanThrow();
}

simulated function ClientWeaponThrown()
{
	ResetMovement();
	Super.ClientWeaponThrown();
}

function DropFrom(vector StartLocation)
{
	ResetMovement();
	Super.DropFrom(StartLocation);
}

defaultproperties
{
	FireModeClass(0)=Class'WTF.WTFEquipKatanaFire'
	FireModeClass(1)=Class'WTF.WTFEquipKatanaFireB'
	Description="WTF Berserker: wider damage arc, attacks do not slow you, iron-sights for adrenaline."
	PickupClass=Class'WTF.WTFEquipKatanaPickup'
}
