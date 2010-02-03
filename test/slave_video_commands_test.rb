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
  
  context "sub_delay" do

    context "absolute" do
      setup { mock_stdin @player, "sub_delay 5 1" }
      asserts("sub_delay 5") {  @player.sub_delay 5 }
      asserts("sub_delay 5, :relative") { @player.sub_delay 5,:absolute }
    end

    context "relative" do
      setup { mock_stdin @player, "sub_delay 5 0" }
      asserts("sub_delay 5, :absolute") { @player.sub_delay 5, :relative }
    end
  end

  context "sub_step" do

    context "next" do
      setup { mock_stdin @player, "sub_step 5" }
      asserts("sub_step 5") { @player.sub_step 5 }
      asserts("sub_step 5,:next") { @player.sub_step 5, :next }
    end

    context "prev" do
      setup { mock_stdin @player, "sub_step -5" }
      asserts("sub_step -5") { @player.sub_step -5 }
      asserts("sub_step 5,:backward") { @player.sub_step 5,:prev }
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

  context "sub_pos" do
    context "by relative" do
      setup { mock_stdin @player, "sub_pos 5 0"  }
      asserts("sub_pos 5") { @player.sub_pos 5 }
      asserts("sub_pos 5,:relative") {  @player.sub_pos 5,:relative }
    end

    context "by absolute" do
      setup { mock_stdin @player, "sub_pos 5 1" }
      asserts("sub_pos 5,:absolute") {  @player.sub_pos 5,:absolute }
    end
  end

  context "sub_alignment" do

    context "toggle" do
      setup { mock_stdin @player, "sub_alignment" }
      asserts("returns true") { @player.sub_alignment }
    end

    context "top" do
      setup { mock_stdin @player, "sub_alignment 0" }
      asserts("sub_alignment :top") { @player.sub_alignment :top }
    end

    context "center" do
      setup { mock_stdin @player, "sub_alignment 1" }
      asserts("sub_alignment :top") { @player.sub_alignment :center }
    end

    context "bottom" do
      setup { mock_stdin @player, "sub_alignment 2" }
      asserts("sub_alignment :top") { @player.sub_alignment :bottom }
    end
  end

  context "sub_visibility" do

    context "toggle" do
      setup { mock_stdin @player, "sub_visibility" }
      asserts("sub_visiblity") { @player.sub_visibility }
    end

    context "on" do
      setup { mock_stdin @player, "sub_visibility 1" }
      asserts("sub_visibility :on") { @player.sub_visibility :on }
    end

    context "off" do
      setup { mock_stdin @player, "sub_visibility 0" }
      asserts("sub_visibility :off") { @player.sub_visibility :off }
    end
  end

  context "sub_load" do

    asserts("invalid file") { @player.sub_load "booger" }.raises ArgumentError,"Invalid File"
    context "valid file" do
      setup { mock_stdin @player, "sub_load test/test.mp3" }
      asserts("sub_load 'test/test.mp3'") { @player.sub_load "test/test.mp3" }
    end
  end

  context "sub_remove" do

    context "all" do
      setup { mock_stdin @player, "sub_remove -1" }
      asserts("sub_remove") { @player.sub_remove }
      asserts("sub_remove :all") { @player.sub_remove :all }
    end

    context "index" do
      setup { mock_stdin @player, "sub_remove 1" }
      asserts("sub_remove 1") { @player.sub_remove 1 }
    end
  end

  context "sub_select" do

    context "select" do
      setup { mock_stdin @player, "sub_select 1" }
      asserts("sub_select 1") { @player.sub_select 1 }
    end

    context "cycle" do
      setup { mock_stdin @player, "sub_select -2" }
      asserts("sub_select") { @player.sub_select }
      asserts("sub_select :cycle") { @player.sub_select :cycle }
    end
  end

  context "sub_source" do

    context "sub" do
      setup { mock_stdin @player, "sub_source 0" }
      asserts("sub_source :sub") { @player.sub_source :sub }
    end

    context "vobsub" do
      setup { mock_stdin @player, "sub_source 1"}
      asserts("sub_source :vobsub") { @player.sub_source :vobsub }
    end

    context "demux" do
      setup { mock_stdin @player, "sub_source 2" }
      asserts("sub_source :demux") { @player.sub_source :demux }
    end

    context "off" do
      setup { mock_stdin @player, "sub_source -1" }
      asserts("sub_source :off") { @player.sub_source :off }
    end

    context "cycle" do
      setup { mock_stdin @player, "sub_source -2" }
      asserts("sub_source :cycle") { @player.sub_source :cycle }
      asserts("sub_source") { @player.sub_source }
    end
  end

  %w[sub_file sub_vob sub_demux].each do |sub|

    context sub do

      context "index" do
        setup { mock_stdin @player, "#{sub} 1" }
        asserts("#{sub} 1") { @player.method(sub).call 1 }
      end

      context "off" do
        setup { mock_stdin @player, "#{sub} -1" }
        asserts("#{sub} :off") { @player.method(sub).call :off}
      end

      context "cycle" do
        setup { mock_stdin @player, "#{sub} -2" }
        asserts("#{sub} :cycle") { @player.method(sub).call :cycle }
        asserts("#{sub}") { @player.method(sub).call }
      end
    end
  end

  context "sub_scale" do
    context "by relative" do
      setup { mock_stdin @player, "sub_scale 5 0" }
      asserts("sub_scale 5") { @player.sub_scale 5 }
      asserts("sub_scale 5,:relative") {  @player.sub_scale 5,:relative }
    end

    context "by absolute" do
      setup { mock_stdin @player, "sub_scale 5 1" }
      asserts("sub_scale 5,:absolute") {  @player.sub_scale 5,:absolute }
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