class WTFEquipChemicalSprayerFmAProjTrail extends Emitter;

defaultproperties
{
	Begin Object Class=SpriteEmitter Name=SpriteEmitter0
		UseColorScale=True
		FadeOut=True
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		UseRandomSubdivision=True
		ColorScale(1)=(RelativeTime=0.300000,Color=(B=61,G=105,R=61,A=255))
		ColorScale(2)=(RelativeTime=0.750000,Color=(B=61,G=105,R=61,A=255))
		ColorScale(3)=(RelativeTime=1.000000)
		ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
		FadeOutStartTime=0.501500
		MaxParticles=15
		Name="SpriteEmitter2"
		StartLocationShape=PTLS_Sphere
		SphereRadiusRange=(Max=1.000000)
		SpinsPerSecondRange=(X=(Max=0.070000))
		StartSpinRange=(X=(Max=1.000000))
		SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.250000)
		StartSizeRange=(X=(Min=1.000000,Max=15.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
		ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
		ScaleSizeByVelocityMax=0.000000
		Texture=Texture'KillingFloorWeapons.FlameThrower.FlameThrowerFire'
		TextureUSubdivisions=1
		TextureVSubdivisions=1
		SecondsBeforeInactive=30.000000
		LifetimeRange=(Min=0.450000,Max=0.850000)
		StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=2.000000,Max=25.000000))
		MaxAbsVelocity=(X=100.000000,Y=100.000000,Z=100.000000)
	End Object
	Emitters(0) = SpriteEmitter'SpriteEmitter0'

	//SoundVolume = 255
	//bFullVolume = true
	//AmbientSound = Sound'GeneralAmbience.firefx12'

	LightRadius = 4
	LightType = LT_Pulse
	LightBrightness = 300
	LightHue = 30
	LightSaturation = 100
	bDynamicLight = true

	bNetTemporary=True
	RemoteRole=ROLE_None

	bNoDelete=false
	Physics=PHYS_Trailer

	DrawScale = 1.0
}