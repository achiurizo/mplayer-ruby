require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::SlaveSubCommands" do
  setup do
    mock(Open4).popen4("/usr/bin/mplayer -slave -quiet test/test.mp3") { [true,true,true,true] }
    stub(true).gets { "playback" }
    @player = MPlayer::Slave.new('test/test.mp3')
  end
  
  context "sub_delay" do

    context "absolute" do
      setup { mock_stdin @player, "sub_delay 5 1" }
      asserts("sub_delay 5") {  @player.sub_delay 5 }
    end

    context "explicit absolute" do
      setup { mock_stdin @player, "sub_delay 5 1" }
      asserts("sub_delay 5, :absolute") { @player.sub_delay 5,:absolute }
    end

    context "relative" do
      setup { mock_stdin @player, "sub_delay 5 0" }
      asserts("sub_delay 5, :relative") { @player.sub_delay 5, :relative }
    end
  end

  context "sub_step" do

    context "next" do
      setup { mock_stdin @player, "sub_step 5" }
      asserts("sub_step 5") { @player.sub_step 5 }
    end

    context "explicit next" do
      setup { mock_stdin @player, "sub_step 5" }
      asserts("sub_step 5,:next") { @player.sub_step 5, :next }
    end

    context "prev" do
      setup { mock_stdin @player, "sub_step -5" }
      asserts("sub_step -5") { @player.sub_step -5 }
    end

    context "explicit prev" do
      setup { mock_stdin @player, "sub_step -5" }
      asserts("sub_step 5,:backward") { @player.sub_step 5,:prev }
    end
  end
  
  context "sub_pos" do
    context "by relative" do
      setup { mock_stdin @player, "sub_pos 5 0"  }
      asserts("sub_pos 5") { @player.sub_pos 5 }
    end

    context "by explicit relative" do
      setup { mock_stdin @player, "sub_pos 5 0"  }
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
    end

    context "explicit all" do
      setup { mock_stdin @player, "sub_remove -1" }
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
    end

    context "explicit cycle" do
      setup { mock_stdin @player, "sub_select -2" }
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
    end

    context "explicit cycle" do
      setup { mock_stdin @player, "sub_source -2" }
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
      end

      context "explicit cycle" do
        setup { mock_stdin @player, "#{sub} -2" }
        asserts("#{sub}") { @player.method(sub).call }
      end
    end
  end

  context "sub_scale" do
    context "by relative" do
      setup { mock_stdin @player, "sub_scale 5 0" }
      asserts("sub_scale 5") { @player.sub_scale 5 }
    end

    context "explicitly by relative" do
      setup { mock_stdin @player, "sub_scale 5 0" }
      asserts("sub_scale 5,:relative") {  @player.sub_scale 5,:relative }
    end

    context "by absolute" do
      setup { mock_stdin @player, "sub_scale 5 1" }
      asserts("sub_scale 5,:absolute") {  @player.sub_scale 5,:absolute }
    end
  end
  
  context "forced_subs_only" do
    context "toggle" do
      setup { mock_stdin @player, "forced_subs_only" }
      asserts("forced_subs_only") { @player.forced_subs_only }
    end

    context "on" do
      setup { mock_stdin @player, "forced_subs_only 1" }
      asserts("forced_subs_only :on") { @player.forced_subs_only :on }
    end

    context "off" do
      setup { mock_stdin @player, "forced_subs_only 0" }
      asserts("forced_subs_only :off") { @player.forced_subs_only :off }
    end
  end
  
end
