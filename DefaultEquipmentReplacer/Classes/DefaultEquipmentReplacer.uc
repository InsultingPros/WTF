class DefaultEquipmentReplacer extends Mutator
	Config(DefaultEquipmentReplacer);

var localized string MyConfig;
var() globalconfig string Slot0, Slot1, Slot2, Slot3, Slot4, Slot5, Slot6, Slot7, Slot8, Slot9;

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local KFHumanPawn KFHP;
	bSuperRelevant = 0;
	if ( Other == None )
		Return FALSE;
	if ( Other.IsA('KFHumanPawn') ) {
		KFHP = KFHumanPawn(Other);	
		KFHP.RequiredEquipment[0] = Slot0;
		KFHP.RequiredEquipment[1] = Slot1;
		KFHP.RequiredEquipment[2] = Slot2;
		KFHP.RequiredEquipment[3] = Slot3;
		KFHP.RequiredEquipment[4] = Slot4;
		KFHP.RequiredEquipment[5] = Slot5;
		KFHP.RequiredEquipment[6] = Slot6;
		KFHP.RequiredEquipment[7] = Slot7;
		KFHP.RequiredEquipment[8] = Slot8;
		KFHP.RequiredEquipment[9] = Slot9;
	}
	return true;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.MyConfig,"Slot0","Slot0",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot1","Slot1",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot2","Slot2",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot3","Slot3",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot4","Slot4",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot5","Slot5",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot6","Slot6",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot7","Slot7",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot8","Slot8",1,0, "Text", "64");
	PlayInfo.AddSetting(default.MyConfig,"Slot9","Slot9",1,0, "Text", "64");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "Slot0": return "Default: KFMod.Knife";
		case "Slot1": return "Default: KFMod.Single";
		case "Slot2": return "Default: KFMod.Frag";
		case "Slot3": return "Default: KFMod.Syringe";
		case "Slot4": return "Default: KFMod.Welder";
		case "Slot5": return "Default: leave empty";
		case "Slot6": return "Default: leave empty";
		case "Slot7": return "Default: leave empty";
		case "Slot8": return "Default: leave empty";
		case "Slot9": return "Default: leave empty";
	}
	return Super.GetDescriptionText(PropName);
}

defaultproperties
{
	Slot0="WTF.WTFEquipCombatKnife"
	Slot1="WTF.WTFEquipMachinePistol"
	Slot2="KFMod.Frag"
	Slot3="KFMod.Syringe"
	Slot4="WTF.WTFEquipWelda"
	Slot5=""
	Slot6=""
	Slot7=""
	Slot8=""
	Slot9=""
	
	bAddToServerPackages=True
	GroupName="KF-DefaultEquipmentReplacer"
	FriendlyName="Default Equipment Replacer"
	Description="Allows the host to specify default starting equipment for KFHumanPawns (AKA Players)."
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}