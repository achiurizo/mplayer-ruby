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

  context "vo_border" do
    context "toggle" do
      setup { mock_stdin @player, "vo_border" }
      asserts("vo_border") { @player.vo_border }
    end

    context "on" do
      setup { mock_stdin @player, "vo_border 1" }
      asserts("vo_border :on") { @player.vo_border :on }
    end

    context "off" do
      setup { mock_stdin @player, "vo_border 0" }
      asserts("vo_border :off") { @player.vo_border :off }
    end
  end

  context "vo_fullscreen" do
    context "toggle" do
      setup { mock_stdin @player, "vo_fullscreen" }
      asserts("vo_fullscreen") { @player.vo_fullscreen }
    end

    context "on" do
      setup { mock_stdin @player, "vo_fullscreen 1" }
      asserts("vo_fullscreen :on") { @player.vo_fullscreen :on }
    end

    context "off" do
      setup { mock_stdin @player, "vo_fullscreen 0" }
      asserts("vo_fullscreen :off") { @player.vo_fullscreen :off }
    end
  end

  context "vo_ontop" do
    context "toggle" do
      setup { mock_stdin @player, "vo_ontop" }
      asserts("vo_ontop") { @player.vo_ontop }
    end

    context "on" do
      setup { mock_stdin @player, "vo_ontop 1" }
      asserts("vo_ontop :on") { @player.vo_ontop :on }
    end

    context "off" do
      setup { mock_stdin @player, "vo_ontop 0" }
      asserts("vo_ontop :off") { @player.vo_ontop :off }
    end
  end

  context "vo_rootwin" do
    context "toggle" do
      setup { mock_stdin @player, "vo_rootwin" }
      asserts("vo_rootwin") { @player.vo_rootwin }
    end

    context "on" do
      setup { mock_stdin @player, "vo_rootwin 1" }
      asserts("vo_rootwin :on") { @player.vo_rootwin :on }
    end

    context "off" do
      setup { mock_stdin @player, "vo_rootwin 0" }
      asserts("vo_rootwin :off") { @player.vo_rootwin :off }
    end
  end

  context "screenshot" do
    context "take screenshot" do
      setup { mock_stdin @player, "screenshot 0" }
      asserts("screenshot") { @player.screenshot }
    end

    context "start/stop screenshot" do
      setup { mock_stdin @player, "screenshot 1" }
      asserts("screenshot :toggle") { @player.screenshot :toggle }
    end
  end

  context "panscan" do
    asserts("panscan 2") { @player.panscan 2}.raises ArgumentError, "Value out of Range -1.0 .. 1.0"
    context "valid range" do
      setup { mock_stdin @player, "panscan 0.1 0" }
      asserts("panscan 0.1") { @player.panscan 0.1 }
    end
  end

  context "dvdnav" do
    asserts("dvdnav :what") { @player.dvdnav :what }.raises ArgumentError, "Invalid button name"
    context "up" do
      setup { mock_stdin @player, "dvdnav up" }
      asserts("dvdnav :up") { @player.dvdnav :up }
    end
    context "down" do
      setup { mock_stdin @player, "dvdnav down" }
      asserts("dvdnav :downleft") { @player.dvdnav :down }
    end
    context "left" do
      setup { mock_stdin @player, "dvdnav left" }
      asserts("dvdnav :left") { @player.dvdnav :left }
    end
    context "right" do
      setup { mock_stdin @player, "dvdnav right" }
      asserts("dvdnav :right") { @player.dvdnav :right }
    end
    context "select" do
      setup { mock_stdin @player, "dvdnav select" }
      asserts("dvdnav :select") { @player.dvdnav :select }
    end
    context "menu" do
      setup { mock_stdin @player, "dvdnav menu" }
      asserts("dvdnav :menu") { @player.dvdnav :menu }
    end
    context "prev" do
      setup { mock_stdin @player, "dvdnav prev" }
      asserts("dvdnav :prev") { @player.dvdnav :prev }
    end
    context "mouse" do
      setup { mock_stdin @player, "dvdnav mouse" }
      asserts("dvdnav :mouse") { @player.dvdnav :mouse }
    end
  end

  context "get_property" do
    context "valid property" do
      setup { mock_send @player, "get_property pause","ANS_pause=no",/pause/ }
      asserts("get_property :hue") { @player.get_property :pause }.equals "no"
    end
    context "failed property" do
      setup { mock_send @player, "get_property saturation","Failed to get value of property 'saturation'.",/saturation/}
      asserts("get_property :saturation") { @player.get_property :saturation }.raises StandardError, "Failed to get value of property 'saturation'."
    end
  end

  context "set_property" do
    setup { mock_send @player, "set_property volume 40" }
    asserts("set_property :volume, 40") { @player.set_property :volume, 40 }
  end
  
  context "step_property" do
    context ":up" do
      setup { mock_send @player, "step_property volume 10 1"}
      asserts("step_property :volume, 10") { @player.step_property :volume, 10}
    end
    context ":down" do
      setup { mock_send @player, "step_property volume 10 -1"}
      asserts("step_property :volume, -10") { @player.step_property :volume, -10}
    end
    
  end
  
  context "get_vofullscreen" do
    context "fullscreen" do
      setup { mock_send @player, "get_vofullscreen","1",/(0|1)/ }
      asserts("get_vofullscreen") { @player.get_vofullscreen }
    end
    context "windowed" do
      setup { mock_send @player, "get_vofullscreen","0",/(0|1)/ }
      asserts("get_vofullscreen") { @player.get_vofullscreen }.equals false
    end

  end
  
  context "get_sub_visibility" do
    context "on" do
      setup { mock_send @player, "get_sub_visibility","1",/(0|1)/ }
      asserts("get_sub_visiblity") { @player.get_sub_visibility }
    end
    context "off" do
      setup { mock_send @player, "get_sub_visibility","0",/(0|1)/ }
      asserts("get_sub_visiblity") { @player.get_sub_visibility }.equals false
    end
  end
  
end
