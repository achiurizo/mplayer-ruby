module MPlayer
  class Player
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file

    def initialize(file)
      @file = file
      mplayer = "/usr/bin/mplayer -slave #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
    end

    def volume(action,value=30)
      cmd =
      case action
      when :up then "volume 1"
      when :down then "volume 0"
      when :set then "volume #{value} 1"
      else
        return false
      end
      send cmd
    end

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

    def seek(value,type = :relative)
      cmd = case type
      when :percent then "seek #{value} 1"
      when :absolute then "seek #{value} 2"
      else "seek #{value} 0"
      end
      send cmd
    end

    def audio_delay(value,type = :relative)
      type == :relative ? send("audio_delay #{value} 0") : send("audio_delay #{value} 1")
    end

    # Write the current position into the EDL file.
    def edl_mark; send("edl_mark"); end

    def pause; send("pause") ; end

    def quit; send('quit') ; end


    private

    def send(cmd); @stdin.puts(cmd); return true; end

    def meta(field); "get_meta_#{field}"; end
  end
end
