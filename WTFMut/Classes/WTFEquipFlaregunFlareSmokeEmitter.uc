class WTFEquipFlaregunFlareSmokeEmitter extends Emitter;

#exec OBJ LOAD FILE=WTFSounds.uax

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SmokeColumnUpwards
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         BlendBetweenSubdivisions=True
         Acceleration=(Z=100.000000)
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=55,G=55,R=255))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=55,G=55,R=255))
         FadeOutStartTime=0.250000
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=1.000000,Max=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.750000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000),Y=(Min=25.000000,Max=25.000000),Z=(Min=25.000000,Max=25.000000))
         ParticlesPerSecond=5.000000
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'WTF.WTFEquipFlaregunFlareSmokeEmitter.SmokeColumnUpwards'

     bNoDelete=False
     LifeSpan=150.000000
}
