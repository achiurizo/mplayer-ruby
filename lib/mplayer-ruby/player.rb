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
      @stdin.puts("pause") ; return true
    end
    
    def quit
      @stdin.puts("quit") ; return true
    end
    
  end
end