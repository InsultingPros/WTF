class WTFEquipFURY extends Knife;

var float DeathTime; //...and then the player turned into gibs.
var Emitter FuryFlame;

simulated function WeaponTick(float dt) {
	Local Inventory I;
	local array<Inventory> DropList;
	local int index;
	
	Super.WeaponTick(dt);
	
	if (Role == ROLE_AUTHORITY) {
		//////////////////////////////////////
		//clear inventory
		for ( I = KFHumanPawn(Instigator).Inventory; I != none; I = I.Inventory )
		{
			if (WTFEquipFury(I) == None && KFWeapon(I) != None) {
				DropList[DropList.Length]=I;
			}
		}
		for ( index = 0; index < DropList.Length; index++ ) {
			DropList[index].Destroy();
		}
		//////////////////////////////////////
		//set stuff
		KFHumanPawn(Instigator).InventorySpeedModifier=250;
		Instigator.AccelRate=50000.0;
		Instigator.Health = 100.0;
		//////////////////////////////////////
		//do FX

		//////////////////////////////////////
		//time to die
		if (Level.TimeSeconds > DeathTime) {
			KFHumanPawn(Instigator).TakeDamage(9001, Instigator, Instigator.Location, Instigator.Location, class'WTF.WTFEquipFURYDamType');
		}
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	DeathTime = Level.TimeSeconds + 60.0;
	WeaponTick(Level.TimeSeconds - 1);
	FuryFlame = Spawn(Class'WTF.WTFEquipFuryFlame');
	FuryFlame.SetBase(Instigator);
	FuryFlame.Emitters[0].SkeletalMeshActor = self;
	FuryFlame.Emitters[0].UseSkeletalLocationAs = PTSU_SpawnOffset;
}

simulated event Destroyed()
{
	if (FuryFlame != none) {
		FuryFlame.Emitters[0].SkeletalMeshActor = none;
		FuryFlame.Destroy();
	}
}

defaultproperties
{
	//what class does the AmbientSound need to go on???
	// AmbientSound= //"FFFFFUUUUUUUUUUUUUUUUUUUUUUUU *HEAVY METAL PLAYING IN BACKGROUND* UUUUUUUUUUUUUUUUU"
	bSpeedMeUp=False
	HudImage=Texture'KillingFloorHUD.WeaponSelect.knife_unselected' //need an ANGRY FACE from Joe
	SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.knife' //need an ANGRY FACE from Joe
	Weight=100.000000
	bKFNeverThrow=True
	TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Knife' //need an ANGRY FACE from Joe
	FireModeClass(0)=Class'WTF.WTFEquipFURYFire'
	FireModeClass(1)=Class'KFMod.NoFire'
	SelectSound=SoundGroup'KF_KnifeSnd.Knife_Select' //need a replacement sound
	Description="FURY"
	PickupClass=Class'WTF.WTFEquipFURYPickup'
	AttachmentClass=Class'WTF.WTFEquipFURYAttachment' //need art from joe
	ItemName="FURY"
	Skins(0)=Combiner'KF_Weapons_Trip_T.melee.knife_cmb' //need art from joe
}
