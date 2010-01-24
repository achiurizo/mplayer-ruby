require 'rubygems'
require 'riot'
require 'rr'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mplayer-ruby'


Riot::Situation.instance_eval { include RR::Adapters::RRMethods }