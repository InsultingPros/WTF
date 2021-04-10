class WTFEquipAK48SFmA extends AK47Fire;

var float MyFireSpeedDiv;

function float GetFireSpeed() {
	return MyFireSpeedDiv;
}

function NextAutoMode() {
	if (MyFireSpeedDiv == 1.0 && !bWaitForRelease) {
		//full->super
		MyFireSpeedDiv = 3.0;
		bWaitForRelease = False;
	}
	else if (MyFireSpeedDiv == 3.0 && !bWaitForRelease) {
		//super->semi
		MyFireSpeedDiv = 1.0;
		bWaitForRelease = True;
	}
	else if (MyFireSpeedDiv == 1.0 && bWaitForRelease) {
		//semi->full
		MyFireSpeedDiv = 1.0;
		bWaitForRelease = False;
	}
}

defaultproperties
{
	MyFireSpeedDiv=1.0
}