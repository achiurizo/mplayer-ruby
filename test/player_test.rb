require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::Player" do
  setup do
    @player = MPlayer::Player.new('test.mp3')
  end
  asserts("@file").assigns(:file)
  asserts("@pid").assigns(:pid)
  asserts("@stdin").assigns(:stdin)
  asserts("@stdout").assigns(:stdout)
  asserts("@stderr").assigns(:stderr)

  context "pause" do
    setup do
      mock(@player.stdin).puts("pause") { true }
      @player.pause
    end
    asserts("returns true")
  end

  context "quit" do
    setup do
      mock(@player.stdin).puts("quit") { true }
      @player.quit
    end
    asserts("returns true")
  end

  context "volume" do
    context "increases" do
      setup do
        mock(@player.stdin).puts("volume 1") { true }
        @player.volume :up
      end
      asserts("returns true")
    end
    
    context "decreases" do
      setup do
        mock(@player.stdin).puts("volume 0") { true }
        @player.volume :down
      end
      asserts("returns true")
    end
    
    context "sets volume" do
      setup do
        mock(@player.stdin).puts("volume 40 1") { true }
        @player.volume :set,40
      end
      asserts("returns true")
    end
    
    context "incorrect action" do
      setup { @player.volume :boo }
      asserts("returns false").equals false
    end
    
  end

end
