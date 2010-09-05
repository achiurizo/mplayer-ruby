module MPlayer
  class Slave
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file
    include MPlayer::SlaveCommands
    include MPlayer::SlaveVideoCommands
    include MPlayer::SlaveTvCommands
    include MPlayer::SlaveSubCommands


    # Initializes a new instance of MPlayer.
    # set :path to point to the location of mplayer
    # defaults to '/usr/bin/mplayer'
    def initialize(file = "",options ={})
      raise ArgumentError,"Invalid File" unless File.exists?(file)
      options[:path] ||= '/usr/bin/mplayer'
      @file = file

      mplayer_options = "-slave -quiet"
      mplayer_options += " -vf screenshot" if options[:screenshot]

      mplayer = "#{options[:path]} #{mplayer_options} #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
      until @stdout.gets.inspect =~ /playback/ do
      end #fast forward past mplayer's initial output
    end

    # commands command to mplayer stdin and retrieves stdout.
    # If match is provided, fast-forwards stdout to matching response.
    def command(cmd,match = //)
      @stdin.puts(cmd)
      response = ""
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
      command "#{command} #{switch}",match
    end

    def toggle(command,value,match = //)
      cmd = case value
      when :on then "#{command} 1"
      when :off then "#{command} 0"
      else "#{command}"
      end
      command cmd,match
    end

    def setting(command,value,type, match = //)
      raise(ArgumentError,"Value out of Range -100..100") unless (-100..100).include?(value)
      adjust_set command, value, type, match
    end

    def adjust_set(command,value,type = :relative, match = //)
      switch = ( type == :relative ? 0 : 1 )
      command "#{command} #{value} #{switch}",match
    end

  end
end
