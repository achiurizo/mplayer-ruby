require File.join(File.dirname(__FILE__),'..','lib','mplayer-ruby')

$player = MPlayer::Slave.new '/Volumes/Storage/Music/segundo.ogg', :path => '/usr/bin/mplayer' #defauults to /usr/bin/mplayer

puts $player.volume :up
sleep 5
puts $player.volume :down
sleep 5
puts $player.volume :set, 60
sleep 5
load file and play immediately
puts $player.load_file "/Volumes/Storage/Music/primero.ogg", :no_append

sleep 10

# load file and queue
# load_file(file) defaults to :append
puts $player.load_file "/Volumes/Storage/Music/segundo.ogg", :append

sleep 10
# step forward
puts $player.next 1
sleep 10
# step backward
puts $player.back 1

sleep 10

# returns information on the file
$player.get :meta_artist
$player.get :meta_album
$player.get :meta_track
%w[time_pos time_length file_name video_codec video_bitrate video_resolution
  audio_codec audio_bitrate audio_samples meta_title meta_artist meta_album
meta_year meta_comment meta_track meta_genre].each do |line|
  puts $player.get line
end

# time_position. fields can also be called as methods
puts $player.time_position
puts $player.year

# mute
puts $player.mute :on
sleep 10
puts $player.mute # toggles back to off
# seek to position in song
puts $player.seek 2
puts $player.seek 10, :percent
puts $player.seek 20, :absolute

# sets the speed of playback
puts ($player.speed 2,:increment)
puts $player.speed 2,:multiply
puts $player.speed 1

# quits MPlayer
puts $player.quit


