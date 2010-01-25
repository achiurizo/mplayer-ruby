require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::Player" do
  setup { @player = MPlayer::Slave.new('test.mp3') }

  asserts("@file").assigns(:file)
  asserts("@pid").assigns(:pid)
  asserts("@stdin").assigns(:stdin)
  asserts("@stdout").assigns(:stdout)
  asserts("@stderr").assigns(:stderr)

  context "pause" do
    setup { mock_stdin @player, "pause" }
    asserts("returns true") { @player.pause }
  end

  context "quit" do
    setup { mock_stdin @player, "quit" }
    asserts("returns true") { mock_stdin @player, "quit" }
  end

  context "volume" do

    context "increases" do
      setup { mock_stdin @player, "volume 1" }
      asserts("returns true") { @player.volume :up }
    end

    context "decreases" do
      setup { mock_stdin @player, "volume 0" }
      asserts("returns true") { @player.volume :down }
    end

    context "sets volume" do
      setup { mock_stdin @player, "volume 40 1" }
      asserts("returns true") { @player.volume :set,40 }
    end

    context "incorrect action" do
      setup { @player.volume :boo }
      asserts("returns false").equals false
    end
  end

  context "get meta_info" do
    setup do
      metas = %w[get_meta_album get_meta_artist get_meta_comment get_meta_genre get_meta_title get_meta_track get_meta_year]
      metas.each { |meta| mock_stdin @player,meta }
      @player.meta_info
    end
    asserts("returns hash").equals({:album=>true,:artist=>true,:comment=>true,:genre=>true,:title=>true,:track=>true,:year=>true})
  end

  context "seek" do

    context "by relative" do
      setup { 2.times { mock_stdin @player, "seek 5 0" } }
      asserts("seek 5") { @player.seek 5 }
      asserts("seek 5,:relative") { @player.seek 5,:relative }
    end

    context "by percentage" do
      setup { mock_stdin @player, "seek 5 1" }
      asserts("seek 5,:percent") { @player.seek 5,:percent }
    end

    context "by absolute" do
      setup { mock_stdin @player, "seek 5 2" }
      asserts("seek 5,:absolute") { @player.seek 5,:absolute }
    end
  end

  context "edl_mark" do
    setup { mock_stdin @player, "edl_mark"}
    asserts("returns true") { @player.edl_mark }
  end

  context "audio_delay" do

    context "by relative" do
      setup { 2.times { mock_stdin @player, "audio_delay 5 0" } }
      asserts("audio_delay 5") { @player.audio_delay 5 }
      asserts("audio_delay 5,:relative") {  @player.audio_delay 5,:relative }
    end

    context "by absolute" do
      setup { mock_stdin @player, "audio_delay 5 1" }
      asserts("audio_delay 5,:relative") {  @player.audio_delay 5,:absolute }
    end
  end

  context "speed_incr" do
    setup { mock_stdin @player, "speed_incr 5" }
    asserts("speed_incr 5") { @player.speed_incr 5 }
  end

  context "speed_mult" do
    setup { mock_stdin @player, "speed_mult 5" }
    asserts("speed_mult 5") { @player.speed_mult 5 }
  end

  context "speed_set" do
    setup { mock_stdin @player, "speed_set 5" }
    asserts("speed_set 5") { @player.speed_set 5 }
  end

  context "speed" do

    context "increment" do
      setup { mock(@player).speed_incr(5) { true } }
      asserts("speed 5,:increment") { @player.speed 5,:increment }
    end

    context "multiply" do
      setup { mock(@player).speed_mult(5) { true } }
      asserts("speed 5,:multiply") { @player.speed 5,:multiply }
    end

    context "set" do
      setup { 2.times { mock(@player).speed_set(5) { true } } }
      asserts("speed 5") {  @player.speed 5 }
      asserts("speed 5, :set") {  @player.speed 5,:set }
    end
  end

  context "frame_step" do
    setup { mock_stdin @player, "frame_step" }
    asserts("returns true") { @player.frame_step }
  end

  context "pt_step" do

    context "forced" do
      setup { mock_stdin @player, "pt_step 5 1"}
      asserts("pt_step 5, :force") { @player.pt_step 5, :force }
    end

    context "not forced" do
      setup { 2.times { mock_stdin @player, "pt_step 5 0" } }
      asserts("pt_step 5") {  @player.pt_step 5 }
      asserts("pt_step 5, :no_force") { @player.pt_step 5, :no_force }
    end
  end

  context "pt_up_step" do

    context "forced" do
      setup { mock_stdin @player, "pt_up_step 5 1"}
      asserts("pt_up_step 5, :force") { @player.pt_up_step 5, :force }
    end

    context "not forced" do
      setup { 2.times { mock_stdin @player, "pt_up_step 5 0" } }
      asserts("pt_up_step 5") {  @player.pt_up_step 5 }
      asserts("pt_up_step 5, :no_force") { @player.pt_up_step 5, :no_force }
    end
  end

  context "alt_src_step" do
    setup { mock_stdin @player, "alt_src_step 5" }
    asserts("returns true") { @player.alt_src_step 5 }
  end

  context "loop" do

    context "none" do
      setup { mock_stdin @player,"loop -1" }
      asserts("loop :none") { @player.loop :none }
    end

    context "forever" do
      setup { 2.times { mock_stdin @player, "loop 0" } }
      asserts("loop") { @player.loop }
      asserts("loop :forever") { @player.loop :forever }
    end

    context "set value" do
      setup { mock_stdin @player,"loop 5" }
      asserts("loop :set, 5") { @player.loop :set, 5 }
    end
  end

  context "sub_delay" do

    context "absolute" do
      setup { 2.times { mock_stdin @player, "sub_delay 5 1" } }
      asserts("sub_delay 5") {  @player.sub_delay 5 }
      asserts("sub_delay 5, :relative") { @player.sub_delay 5,:absolute }
    end

    context "relative" do
      setup { mock_stdin @player, "sub_delay 5 0" }
      asserts("sub_delay 5, :absolute") { @player.sub_delay 5, :relative }
    end
  end

  context "sub_step" do

    context "forward" do
      setup { 2.times { mock_stdin @player, "sub_step 5" } }
      asserts("sub_step 5") { @player.sub_step 5 }
      asserts("sub_step 5,:forward") { @player.sub_step 5, :forward }
    end

    context "backward" do
      setup { 2.times { mock_stdin @player, "sub_step -5" } }
      asserts("sub_step -5") { @player.sub_step -5 }
      asserts("sub_step 5,:backward") { @player.sub_step 5,:backward }
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

  context "use_master" do
    setup { mock_stdin @player, "use_master" }
    asserts("returns true") { @player.use_master }
  end

  context "mute" do

    context "toggle" do
      setup { mock_stdin @player, "mute"}
      asserts("returns true") { @player.mute }
    end

    context "set on" do
      setup { mock_stdin @player, "mute 1"}
      asserts("mute :on") { @player.mute :on }
    end

    context "set off" do
      setup { mock_stdin @player, "mute 0"}
      asserts("mute :off") { @player.mute :off }
    end
  end

%w[contrast gamma brightness hue saturation].each do |setting|
  context setting do

    context "relative" do
      setup { 2.times { mock_stdin @player, "#{setting} 5 0"} }
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

end
