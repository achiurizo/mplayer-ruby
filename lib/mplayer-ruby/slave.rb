module MPlayer
  class Slave
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file
    include MPlayer::SlaveCommands
    include MPlayer::SlaveVideoCommands

    def initialize(file = "")
      raise ArgumentError,"Invalid File" unless File.exists?(file)
      @file = file
      mplayer = "/usr/bin/mplayer -slave -quiet #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
      until @stdout.gets.inspect =~ /playback/ do
      end #fast forward to the desired output
    end


    def balance(value,type = :relative)
      #TODO
      return false
    end

    def vobsub_lang(value = nil)
      # TODO
      return false
    end

    def sub_log
      #TODO
      return false      
    end
    
    
    private

    def select_cycle(command,value)
      switch = case value
      when :off then -1
      when :cycle then -2
      else value
      end
      send "#{command} #{switch}"
    end

    def toggle(command,value)
      send case value
      when :on then "#{command} 1"
      when :off then "#{command} 0"
      else "#{command}"
      end
    end

    def setting(command,value,type)
      raise(ArgumentError,"Value out of Range -100..100") unless (-100..100).include?(value)
      adjust_set command, value, type
    end

    def adjust_set(command,value,type = :relative)
      switch = ( type == :relative ? 0 : 1 )
      send "#{command} #{value} #{switch}"
    end

    def send(cmd)
      @stdin.puts(cmd)
      @stdout.gets
    end

  end
end
