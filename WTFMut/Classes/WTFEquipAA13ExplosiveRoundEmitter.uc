class WTFEquipAA13ExplosiveRoundEmitter extends Emitter;

defaultproperties
{
	Begin Object Class=SpriteEmitter Name=Blast
		UseColorScale=True
		FadeOut=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UniformSize=True
		BlendBetweenSubdivisions=True
		ColorScale(1)=(RelativeTime=0.300000,Color=(B=100,G=100,R=100))
		ColorScale(2)=(RelativeTime=0.500000,Color=(B=100,G=100,R=100))
		FadeOutStartTime=0.100000
		MaxParticles=50
		StartLocationShape=PTLS_Sphere
		SphereRadiusRange=(Min=1.000000,Max=1.000000)
		SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
		SizeScale(1)=(RelativeTime=0.010000,RelativeSize=1.000000)
		SizeScale(2)=(RelativeTime=0.100000,RelativeSize=5.000000)
		StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
		ParticlesPerSecond=500.000000
		Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
		TextureUSubdivisions=8
		TextureVSubdivisions=8
		LifetimeRange=(Min=0.150000,Max=0.150000)
		StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=300.000000))
	End Object
	Emitters(2)=SpriteEmitter'WTF.WTFEquipAA13ExplosiveRoundEmitter.Blast'

	bNoDelete=False
	LifeSpan=0.250000
}
