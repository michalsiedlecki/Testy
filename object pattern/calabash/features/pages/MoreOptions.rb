class MoreOptions < DroidEndomondo
  
  element(:audioSettings) { "TextView text: 'Audio Settings'" }
  element(:settings) { "TextView text:'Settings'" }
  element(:tutorial) { "TextView text:'Tutorial'" }
  element(:exit) { "TextView text:'Exit'" }
  
  action(:touchAudioSetting) { touch(audioSettings) }
  action(:touchSettings) { touch(settings) }
  action(:touchTutorial) { touch(tutorial) }
  action(:touchExit) { touch(exit) }
  
  trait(:trait) { tutorial }
end