require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::SlaveTvCommands" do
  setup do
    mock(Open4).popen4("/usr/bin/mplayer -slave -quiet test/test.mp3") { [true,true,true,true] }
    stub(true).gets { "playback" }
    @player = MPlayer::Slave.new('test/test.mp3')
  end
  
  context "tv_start_scan" do
    setup { mock_stdin @player, "tv_start_scan" }
    asserts("tv_start_scan") { @player.tv_start_scan }
  end
  
  context "tv_step_channel" do
    context "next" do
      setup { mock_stdin @player, "tv_step_channel 1" }
      asserts("tv_step_channel :next") { @player.tv_step_channel :next }
    end
    context "previous" do
      setup { mock_stdin @player, "tv_step_channel -1" }
      asserts("tv_step_channel :prev") { @player.tv_step_channel :prev }
    end
  end
  
  context "next_channel" do
    setup { mock(@player).tv_step_channel(:next) { true } }
    asserts("next_channel") { @player.next_channel }
  end
  
  context "prev_channel" do
    setup { mock(@player).tv_step_channel(:prev) { true } }
    asserts("prev_channel") { @player.prev_channel }
  end
  
  context "tv_step_norm" do
    setup { mock_stdin @player, "tv_step_norm" }
    asserts("tv_step_norm") { @player.tv_step_norm }
  end
  
  context "tv_step_chanlist" do
    setup { mock_stdin @player, "tv_step_chanlist" }
    asserts("tv_step_chanlist") { @player.tv_step_chanlist }
  end
  
  context "tv_set_channel" do
    setup { mock_stdin @player, "tv_set_channel 1" }
    asserts("tv_set_channel 1") { @player.tv_set_channel 1 }
    asserts("set_channel 1") { @player.set_channel 1 }
  end
  
  context "tv_last_channel" do
    setup { mock_stdin @player, "tv_last_channel" }
    asserts("tv_last_channel") { @player.tv_last_channel }
    asserts("last_channel") { @player.last_channel }
  end
  
  context "tv_set_freq" do
    setup { mock_stdin @player, "tv_set_freq 1.92" }
    asserts("tv_set_freq 1.92") { @player.tv_set_freq 1.92 }
  end
  
  context "tv_step_freq" do
    setup { mock_stdin @player, "tv_step_freq 2.3" }
    asserts("tv_step_freq 2.3") { @player.tv_step_freq 2.3 }
  end
  
  context "tv_set_norm" do
    setup { mock_stdin @player, "tv_set_norm NTSC" }
    asserts(":ntsc") {  @player.tv_set_norm :ntsc }
    asserts("ntsc") { @player.tv_set_norm 'ntsc' }
    asserts("NTSC") { @player.tv_set_norm 'NTSC' }
  end
  
  %w[tv_set_contrast tv_set_brightness tv_set_hue tv_set_saturation].each do |setting|
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
    
end