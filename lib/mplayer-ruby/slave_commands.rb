module MPlayer
  module SlaveCommands
    # Increase/decrease volume
    # :up increase volume
    # :down decreases volume
    # :set sets the volume at <value>
    def volume(action,value=30)
      cmd =
      case action
      when :up then "volume 1"
      when :down then "volume 0"
      when :set then "volume #{value} 1"
      else return false
      end
      resp = send cmd, /Volume/
      resp.gsub("\e[A\r\e[KVolume: ","").gsub(" %\n","")
    end

    # Seek to some place in the file
    # :relative is a relative seek of +/- <value> seconds (default).
    # :perecent is a seek to <value> % in the file.
    # :absolute is a seek to an absolute position of <value> seconds.
    def seek(value,type = :relative)
      send case type
      when :percent then "seek #{value} 1"
      when :absolute then "seek #{value} 2"
      else "seek #{value} 0"
      end
    end

    # Adjusts the current playback speed
    # :increment adds <value> to the current speed
    # :multiply multiplies the current speed by <value>
    # :set sets the current speed to <value>.(default)
    def speed(value,type = :set)
      case type
      when :increment then speed_incr(value)
      when :multiply then speed_mult(value)
      else speed_set(value)
      end
    end

    # Adjust/set how many times the movie should be looped.
    # :none means no loop
    # :forever means loop forever.(default)
    # :set sets the amount of times to loop. defaults to one loop.
    def loop(action = :forever,value = 1)
      send case action
      when :none then "loop -1"
      when :set then "loop #{value}"
      else "loop 0"
      end
    end

    # Go to the next/previous entry in the playtree. The sign of <value> tells
    # the direction.  If no entry is available in the given direction it will do
    # nothing unless [force] is non-zero.
    def pt_step(value,force = :no_force)
      send(force == :force ? "pt_step #{value} 1" : "pt_step #{value} 0")
    end

    #convenience methods
    alias :next :pt_step
    def back(value,force = :no_force)
      v = "-" + value.to_s.gsub("-","")
      pt_step v, force
    end

    # Similar to pt_step but jumps to the next/previous entry in the parent list.
    # Useful to break out of the inner loop in the playtree.
    def pt_up_step(value,force = :no_force)
      send(force == :force ? "pt_up_step #{value} 1" : "pt_up_step #{value} 0")
    end

    # Switch volume control between master and PCM.
    def use_master; send("use_master"); end

    # Toggle sound output muting or set it to [value] when [value] >= 0
    #     (1 == on, 0 == off).
    def mute(value = nil)
      toggle :mute, value
    end

    # returns information on file
    # available values are:
    # time_pos time_length file_name video_codec video_bitrate video_resolution
    # audio_codec audio_bitrate audio_samples meta_title meta_artist meta_album
    # meta_year meta_comment meta_track meta_genre
    def get(value)
      match = case value
      when "time_pos" then "ANS_TIME_POSITION"
      when "time_length" then "ANS_LENGTH"
      when "file_name" then "ANS_FILENAME"
      else "ANS_#{value.to_s.upcase}"
      end
      resp = send "get_#{value}",/#{match}/
      resp.gsub("#{match}=","").gsub("'","")
    end

    # This gives methods for each of the fields that data can be extract on.
    # Just to provide more syntactic sugar.
    %w[time_pos time_length file_name video_codec video_bitrate video_resolution
      audio_codec audio_bitrate audio_samples meta_title meta_artist meta_album
    meta_year meta_comment meta_track meta_genre].each do |field|
      define_method(field.to_sym) { get(field) }
    end
    alias :time_position :time_pos
    alias :filename :file_name
    alias :title :meta_title
    alias :album :meta_album
    alias :year :meta_year
    alias :comment :meta_comment
    alias :genre :meta_genre


    # Loads the file into MPlayer
    # :append loads the file and appends it to the current playlist
    # :no_append will stop playback and play new loaded file
    def load_file(file,append = :no_append)
      raise ArgumentError,"Invalid File" unless File.exists? file
      switch = (append == :append ? 1 : 0)
      send "loadfile #{file} #{switch}"
    end

    # Loads the playlist into MPlayer
    # :append loads the playlist and appends it to the current playlist
    # :no_append will stop playback and play new loaded playlist
    def load_list(file,append = :no_append)
      raise ArgumentError,"Invalid File" unless File.exists? file
      switch = (append == :append ? 1 : 0)
      send "loadlist #{file} #{switch}"
    end

    # When more than one source is available it selects the next/previous one.
    # ASX Playlist ONLY
    def alt_src_step(value); send("alt_src_step #{value}"); end

    # Add <value> to the current playback speed.
    def speed_incr(value); send("speed_incr #{value}"); end

    # Multiply the current speed by <value>.
    def speed_mult(value); send("speed_mult #{value}"); end

    # Set the speed to <value>.
    def speed_set(value); send("speed_set #{value}"); end

    # Play one frame, then pause again.
    def frame_step; send("frame_step"); end

    # Write the current position into the EDL file.
    def edl_mark; send("edl_mark"); end

    # Pauses/Unpauses the file.
    def pause; send("pause") ; end

    # Quits MPlayer
    def quit
      send('quit')
      @stdin.close
    end


  end
end
