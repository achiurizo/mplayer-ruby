module MPlayer
  class Slave
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file

    def initialize(file)
      @file = file
      mplayer = "/usr/bin/mplayer -slave #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
    end

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
      send cmd
    end

    # Returns a hash of the meta information of the file.
    def meta_info
      meta = "get_meta_%s"
      album = send meta('album')
      artist = send meta('artist')
      comment = send meta('comment')
      genre = send meta('genre')
      title = send meta('title')
      track = send meta('track')
      year = send meta('year')
      {:album => album,:artist => artist, :comment => comment, :genre => genre, :title => title, :track => track, :year => year}
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
    
    # Set/adjust the audio delay.
    # If type is :relative adjust the delay by <value> seconds.
    # If type is :absolute, set the delay to <value> seconds.     
    def audio_delay(value,type = :relative)
      type == :relative ? send("audio_delay #{value} 0") : send("audio_delay #{value} 1")
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

    # Add <value> to the current playback speed.
    def speed_incr(value); send("speed_incr #{value}"); end
    
    # Multiply the current speed by <value>.
    def speed_mult(value); send("speed_mult #{value}"); end
    
    # Set the speed to <value>.
    def speed_set(value); send("speed_set #{value}"); end

    # Write the current position into the EDL file.
    def edl_mark; send("edl_mark"); end

    # Pauses/Unpauses the file.
    def pause; send("pause") ; end

    # Quits MPlayer
    def quit; send('quit') ; end


    private

    def send(cmd); @stdin.puts(cmd); return true; end

    def meta(field); "get_meta_#{field}"; end
  end
end
