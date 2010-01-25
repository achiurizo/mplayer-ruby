require 'rubygems'
require 'open4'
require 'active_support/core_ext/hash'
Dir[File.dirname(__FILE__) + '/mplayer-ruby/**/*.rb'].each { |lib| require lib }