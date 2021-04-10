class WTFEquipMKb43FmA extends MKb42Fire;

var float MyFireSpeedDiv;

function float GetFireSpeed() {
	return MyFireSpeedDiv;
}

function NextMode() {
	if (!bWaitForRelease && MyFireSpeedDiv == 1.0) {
		//we're in full auto, switch to super auto
		MyFireSpeedDiv=3.0;
	}
	else if (!bWaitForRelease && MyFireSpeedDiv != 1.0) {
		//we're in super auto, switch to semi auto
		bWaitForRelease=True;
		MyFireSpeedDiv=1.0;
	}
	else {
		//we're in semi auto, switch to full auto
		bWaitForRelease=False;
		MyFireSpeedDiv=1.0;
	}
}

defaultproperties
{
	MyFireSpeedDiv=1.0
}