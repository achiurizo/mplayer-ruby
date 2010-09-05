require 'rubygems'
require 'riot'
require 'riot/rr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mplayer-ruby'


Riot.reporter = Riot::DotMatrixReporter

class Riot::Situation
  # mocks stdin
  def mock_stdin(player,input,output="")
    mock(player.stdin).puts(input) { output }
  end

  # mocks send method
  def mock_command(player,input,output="",match=nil)
    return mock(player).command(input) { output } unless match
    mock(player).command(input,match) { output }
  end
  
  # mocks Open4
  def mock_player
    mock(Open4).popen4("/usr/bin/mplayer -slave -quiet test/test.mp3") { [true,true,true,true] }
    stub(true).gets { "playback" }
    MPlayer::Slave.new('test/test.mp3')
  end

  def mock_stdout(player, input, output="")
    mock(player.stdout).gets { output }
  end
end

class Riot::Context
  # setup the mock player
  def setup_player
    setup { @player = mock_player }
  end
  
end
