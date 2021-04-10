class WTFEquipFURYFire extends KnifeFire;

defaultproperties
{
	MeleeDamage=4000
	FireRate=0.5
	hitDamageClass=Class'WTF.WTFEquipFURYDamType' //override so Berserker isn't getting a bonus
	MeleeHitSounds(0)=SoundGroup'KF_KnifeSnd.Knife_HitFlesh' //need appropriate sound, like someone shouting "DIE!"
	HitEffectClass=Class'KFMod.KnifeHitEffect' //need art from joe
	WideDamageMinHitAngle=0.5
}