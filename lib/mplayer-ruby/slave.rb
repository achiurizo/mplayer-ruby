module MPlayer
  class Slave
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file
    include MPlayer::SlaveCommands
    include MPlayer::SlaveVideoCommands

    def initialize(file = "",options ={:path => '/usr/bin/mplayer'})
      raise ArgumentError,"Invalid File" unless File.exists?(file)
      @file = file
      mplayer = "#{options[:path]} -slave -quiet #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
      until @stdout.gets.inspect =~ /playback/ do
      end #fast forward to the desired output
    end


    #Where I'm keeping my todo list.
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


    def send(cmd,match = //)
      @stdin.puts(cmd)
      response = @stdout.gets
      until response =~ match
        response = @stdout.gets
      end
      response.gsub("\e[A\r\e[K","")
    end

    private

    def select_cycle(command,value,match = //)
      switch = case value
      when :off then -1
      when :cycle then -2
      else value
      end
      send "#{command} #{switch}",match
    end

    def toggle(command,value,match = //)
      cmd = case value
      when :on then "#{command} 1"
      when :off then "#{command} 0"
      else "#{command}"
      end
      send cmd,match
    end

    def setting(command,value,type, match = //)
      raise(ArgumentError,"Value out of Range -100..100") unless (-100..100).include?(value)
      adjust_set command, value, type
    end

    def adjust_set(command,value,type = :relative, match = //)
      switch = ( type == :relative ? 0 : 1 )
      send "#{command} #{value} #{switch}",match
    end

  end
end
