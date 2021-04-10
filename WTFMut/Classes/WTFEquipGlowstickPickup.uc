class WTFEquipGlowstickPickup extends M79Pickup;

#exec OBJ LOAD FILE=Asylum_SM.usx
#exec OBJ LOAD FILE=Asylum_T.utx

defaultproperties
{
	Weight=0.000000
	cost=5
	PowerValue=0
	Description="Primary to toss for long-lasting illumination. Secondary to activate and wear."
	ItemName="Glowstick"
	ItemShortName="Glowstick"
	InventoryType=Class'WTF.WTFEquipGlowstick'
	PickupMessage="You got the Glowstick."
	StaticMesh=StaticMesh'Asylum_SM.Lighting.glow_sticks_green_pile'
	DrawScale=2.000000
	CorrespondingPerkIndex=7
}
