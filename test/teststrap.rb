require 'rubygems'
require 'riot'
require 'rr'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mplayer-ruby'

def mock_stdin(player,input,output=true)
  mock(player.stdin).puts(input) { output }
end


Riot::Situation.instance_eval { include RR::Adapters::RRMethods }