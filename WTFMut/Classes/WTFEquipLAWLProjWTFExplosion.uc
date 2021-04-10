class WTFEquipLAWLProjWTFExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=InitialFireBlast
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
         MaxParticles=500
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         StartSizeRange=(X=(Min=600.000000,Max=600.000000),Y=(Min=600.000000,Max=600.000000),Z=(Min=600.000000,Max=600.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'KillingFloorTextures.LondonCommon.fire3'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=-7000.000000,Max=7000.000000),Y=(Min=-7000.000000,Max=7000.000000),Z=(Min=7000.000000))
     End Object
     Emitters(0)=SpriteEmitter'WTF.WTFEquipLAWLProjWTFExplosion.InitialFireBlast'

     Begin Object Class=SpriteEmitter Name=GroundSmokeRingExpanding
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=155,G=155,R=255))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=255,G=255,R=255,A=255))
         MaxParticles=300
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
         ParticlesPerSecond=100.000000
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-1000.000000,Max=1000.000000),Y=(Min=-1000.000000,Max=1000.000000))
     End Object
     Emitters(1)=SpriteEmitter'WTF.WTFEquipLAWLProjWTFExplosion.GroundSmokeRingExpanding'

     Begin Object Class=SpriteEmitter Name=SmokeColumnUpwards
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         BlendBetweenSubdivisions=True
         Acceleration=(Z=-50.000000)
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=155,G=155,R=255))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=2.000000
         MaxParticles=300
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.250000)
         SizeScale(2)=(RelativeTime=0.750000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=750.000000,Max=750.000000),Y=(Min=750.000000,Max=750.000000),Z=(Min=750.000000,Max=750.000000))
         ParticlesPerSecond=10.000000
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         StartVelocityRange=(Z=(Min=500.000000,Max=500.000000))
     End Object
     Emitters(2)=SpriteEmitter'WTF.WTFEquipLAWLProjWTFExplosion.SmokeColumnUpwards'

     AutoDestroy=True
     LightType=LT_Flicker
     LightHue=30
     LightSaturation=100
     LightBrightness=600.000000
     LightRadius=600.000000
     bNoDelete=False
     bDynamicLight=True
     AmbientSound=Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Vehicle'
     LifeSpan=7.000000
     bFullVolume=True
     SoundVolume=255
     SoundRadius=2400.000000
}
