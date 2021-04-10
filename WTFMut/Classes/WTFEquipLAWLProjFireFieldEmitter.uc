class WTFEquipLAWLProjFireFieldEmitter extends WTFEquipFirehoseEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         Acceleration=(Z=100.000000)
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.750000,Color=(B=96,G=160,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
         MaxParticles=300
         StartLocationRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000))
         SpinsPerSecondRange=(X=(Max=0.070000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=56.000000,Max=45.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         ScaleSizeByVelocityMax=0.000000
         Texture=Texture'KillingFloorTextures.LondonCommon.fire3'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=15.000000
         LifetimeRange=(Min=0.750000,Max=1.500000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=5.000000,Max=15.000000))
     End Object
     Emitters(0)=SpriteEmitter'WTF.WTFEquipLAWLProjFireFieldEmitter.SpriteEmitter10'

     LightBrightness=300.000000
     LightRadius=28.000000
     LifeSpan=20.000000
     SoundRadius=750.000000
}
