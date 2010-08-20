require File.expand_path("teststrap", File.dirname(__FILE__))

context "MPlayer::Player" do
  setup do
    mock(Open4).popen4("/usr/bin/mplayer -slave -quiet test/test.mp3") { [true,true,true,true] }
    stub(true).gets { "playback" }
    @player = MPlayer::Slave.new('test/test.mp3')
  end
  asserts("invalid file") { MPlayer::Slave.new('boooger') }.raises ArgumentError,"Invalid File"
  asserts("@file") { topic }.assigns(:file)
  asserts("@pid") { topic }.assigns(:pid)
  asserts("@stdin") { topic }.assigns(:stdin)
  asserts("@stdout") { topic }.assigns(:stdout)
  asserts("@stderr") { topic }.assigns(:stderr)

  
end
