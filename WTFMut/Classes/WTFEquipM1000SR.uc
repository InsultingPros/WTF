class WTFEquipM1000SR extends M99SniperRifle;

defaultproperties
{
	Weight=12.0 //was 13.0 - let someone carry a pistol at least
	FireModeClass(0)=Class'WTF.WTFEquipM1000Fire'
	FireModeClass(1)=Class'KFMod.NoFire'
	Description="I'm looking for a big gun that shoots a really big bullet."
	PickupClass=Class'WTF.WTFEquipM1000Pickup'
	ItemName="M1000"
}
