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
    asserts("returns true").equals true
  end
  
  context "quit" do
    setup do
      mock(@player.stdin).puts("quit") { true }
      @player.quit
    end
    asserts("returns true").equals true
  end
  
end