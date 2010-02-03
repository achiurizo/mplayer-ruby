require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::SlaveVideoCommands" do
  setup do
    mock(Open4).popen4("/usr/bin/mplayer -slave -quiet test/test.mp3") { [true,true,true,true] }
    stub(true).gets { "playback" }
    @player = MPlayer::Slave.new('test/test.mp3')
  end
  
  context "audio_delay" do

    context "by relative" do
      setup { mock_stdin @player, "audio_delay 5 0" }
      asserts("audio_delay 5") { @player.audio_delay 5 }
      asserts("audio_delay 5,:relative") {  @player.audio_delay 5,:relative }
    end

    context "by absolute" do
      setup { mock_stdin @player, "audio_delay 5 1" }
      asserts("audio_delay 5,:absolute") {  @player.audio_delay 5,:absolute }
    end
  end
  
  context "osd" do

    context "toggle" do
      setup { mock_stdin @player, "osd" }
      asserts("osd toggle") { @player.osd }
    end

    context "set level" do
      setup { mock_stdin @player, "osd 5" }
      asserts("osd 5") { @player.osd 5 }
    end
  end

  context "osd_show_text" do

    context "with just string" do
      setup { mock_stdin @player, "osd_show_text hello 0 0"}
      asserts("mock_stdin 'hello'") { @player.osd_show_text 'hello' }
    end

    context "with duration" do
      setup { mock_stdin @player, "osd_show_text hello 5 0"}
      asserts("mock_stdin 'hello',:duration => 5") { @player.osd_show_text 'hello', :duration => 5 }
    end

    context "with level" do
      setup { mock_stdin @player, "osd_show_text hello 0 5"}
      asserts("mock_stdin 'hello', :level => 5") { @player.osd_show_text 'hello', :level => 5 }
    end
  end

  context "osd_show_property_text" do

    context "with just string" do
      setup { mock_stdin @player, "osd_show_property_text hello 0 0"}
      asserts("mock_stdin 'hello'") { @player.osd_show_property_text 'hello' }
    end

    context "with duration" do
      setup { mock_stdin @player, "osd_show_property_text hello 5 0"}
      asserts("mock_stdin 'hello',:duration => 5") { @player.osd_show_property_text 'hello', :duration => 5 }
    end

    context "with level" do
      setup { mock_stdin @player, "osd_show_property_text hello 0 5"}
      asserts("mock_stdin 'hello', :level => 5") { @player.osd_show_property_text 'hello', :level => 5 }
    end
  end
  
  %w[contrast gamma brightness hue saturation].each do |setting|
    context setting do

      context "relative" do
        setup { mock_stdin @player, "#{setting} 5 0" }
        asserts("#{setting} 5, :relative") { @player.method(setting).call(5, :relative) }
        asserts("#{setting} 5") { @player.method(setting).call(5) }
      end

      context "absolute" do
        setup { mock_stdin @player, "#{setting} 5 1" }
        asserts("#{setting} 5, :absolute") { @player.method(setting).call( 5, :absolute) }
      end

      asserts("value out of range [-100,100]") { @player.method(setting).call(1000) }.raises(ArgumentError,"Value out of Range -100..100")
    end
  end

  context "frame_drop" do

    context "toggle" do
      setup { mock_stdin @player, "frame_drop"}
      asserts("toggles") { @player.frame_drop }
    end

    context "on" do
      setup { mock_stdin @player, "frame_drop 1"}
      asserts("frame_drop :on") { @player.frame_drop :on }
    end

    context "off" do
      setup { mock_stdin @player, "frame_drop 0"}
      asserts("frame_drop :off") { @player.frame_drop :off }
    end
  end

  %w[switch_angle switch_audio switch_title].each do |switch|

    context switch do

      context "select" do
        setup { mock_stdin @player, "#{switch} 1" }
        asserts("#{switch} 1") { @player.method(switch).call 1 }
      end

      context "cycle" do
        setup { mock_stdin @player, "#{switch} -2" }
        asserts("#{switch}") { @player.method(switch).call }
        asserts("#{switch} :cycle") { @player.method(switch).call :cycle }
      end

    end
  end

  context "switch_ratio" do
    setup { mock_stdin @player,"switch_ratio 1" }
    asserts("switch_ratio 1") { @player.switch_ratio 1 }
  end

  context "switch_vsync" do
    context "toggle" do
      setup { mock_stdin @player, "switch_vsync" }
      asserts("switch_vsynce") { @player.switch_vsync }
    end

    context "on" do
      setup { mock_stdin @player, "switch_vsync 1" }
      asserts("switch_vsync :on") { @player.switch_vsync :on }
    end

    context "off" do
      setup { mock_stdin @player, "switch_vsync 0" }
      asserts("switch_vsync :off") { @player.switch_vsync :off }
    end
  end
  
end