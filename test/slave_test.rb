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
    asserts("speed_incr") { @player.speed_incr 5 }
  end
  
end
