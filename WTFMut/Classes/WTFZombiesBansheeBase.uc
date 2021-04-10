// Zombie Monster for KF Invasion gametype
class WTFZombiesBansheeBase extends ZombieStalkerBase;

var () int ScreamRadius; // AOE for scream attack.

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

var(Shake)  rotator RotMag;            // how far to rot view
var(Shake)  float   RotRate;           // how fast to rot view
var(Shake)  vector  OffsetMag;         // max view offset vertically
var(Shake)  float   OffsetRate;        // how fast to offset view vertically
var(Shake)  float   ShakeTime;         // how long to shake for per scream
var(Shake)  float   ShakeFadeTime;     // how long after starting to shake to start fading out
var(Shake)  float	ShakeEffectScalar; // Overall scale for shake/blur effect
var(Shake)  float	MinShakeEffectScale;// The minimum that the shake effect drops off over distance
var(Shake)  float	ScreamBlurScale;   // How much motion blur to give from screams

var bool bAboutToDie;
var float DeathTimer;

var int NextScreamTime;
const ScreamCooldown = 3; //time after scream that a scream will not be allowed

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	ScreamRadius=900
	ScreamDamageType=Class'KFMod.SirenScreamDamage'
	ScreamForce=200000
	ShakeTime=2.000000
	ShakeFadeTime=0.250000
	ShakeEffectScalar=1.000000
	MinShakeEffectScale=0.010000
	ScreamBlurScale=0.950000
	MoanVoice=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Talk'
	MeleeDamage=15
	ScreamDamage=15
	CrispUpThreshhold=7
	PlayerCountHealthScale=0.100000
	HeadHealth=200.000000
	PlayerNumHeadHealthScale=0.050000
	ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
	ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
	ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
	ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
	ScoringValue=25
	HealthMax=300.000000
	Health=300
	MenuName="Banshee"
	AmbientSound=Sound'KF_BaseSiren.Siren_IdleLoop'
}
