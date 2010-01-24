module MPlayer
  class Player
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file
    
    def initialize(file)
      @file = file
      mplayer = "/usr/bin/mplayer -slave #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
    end
    
    def pause
      send("pause") ; return true
    end
    
    def quit
      send('quit') ; return true
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
      return true
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
      case type
      when :percent then send "seek #{value} 1"
      when :absolute then send "seek #{value} 2"
      else
        send "seek #{value} 0"
      end
      return true
    end
    
    
    private
    
    def send(cmd); @stdin.puts(cmd); end
    
    def meta(field); "get_meta_#{field}"; end
  end
end