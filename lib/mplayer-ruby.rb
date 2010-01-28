require 'rubygems'
require 'open4'
require 'active_support/core_ext/hash'
require File.dirname(__FILE__) + '/mplayer-ruby/slave_commands'
require File.dirname(__FILE__) + '/mplayer-ruby/slave_video_commands'
Dir[File.dirname(__FILE__) + '/mplayer-ruby/**/*.rb'].each { |lib| require lib }