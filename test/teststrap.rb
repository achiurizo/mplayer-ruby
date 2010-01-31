require 'rubygems'
require 'riot'
require 'rr'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mplayer-ruby'

Riot.rr

def mock_stdin(player,input,output="")
  mock(player.stdin).puts(input) { output }
end

def mock_send(player,input,output="",match=nil)
  return mock(player).send(input) { output } unless match
  mock(player).send(input,match) { output }
end
