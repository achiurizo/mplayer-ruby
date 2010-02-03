module MPlayer
  module SlaveTvCommands
    
    # Start automatic TV channel scanning
    def tv_start_scan
      send("tv_start_scan")
    end
    
    # Select the next/previous TV Channel
    # :next selects next channel
    # :prev select previous channel
    def tv_step_channel(action)
      value = action ==  :prev ? -1 : 1
      send "tv_step_channel #{value}"
    end
    
    # next TV channel
    def next_channel
      tv_step_channel :next
    end
    
    #previous TV channel
    def prev_channel
      tv_step_channel :prev
    end
    
    # Change TV norm
    def tv_step_norm
      send("tv_step_norm")
    end
    
    # Change TV Channel list
    def tv_step_chanlist
      send("tv_step_chanlist")
    end
    
    # Set TV Channel to <value>
    def tv_set_channel(value)
      send("tv_set_channel #{value}")
    end
    alias :set_channel :tv_set_channel
    
    # Set the current TV Channel to the last channel
    def tv_last_channel
      send("tv_last_channel")
    end
    alias :last_channel :tv_last_channel
    
    # set TV Frequency in MHz
    def tv_set_freq(value)
      send("tv_set_freq #{value}")
    end
    
    # set the TV frequency relative to the current frequency
    def tv_step_freq(value)
      send("tv_step_freq #{value}")
    end
    
    # Set the TV tuner norm (PAL, SECAM, NTSC, ... ).
    def tv_set_norm(value)
      send("tv_set_norm #{value.to_s.upcase}")
    end
    
    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def tv_set_contrast(value, type = :relative)
      setting :tv_set_contrast, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def tv_set_hue(value, type = :relative)
      setting :tv_set_hue, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def tv_set_brightness(value, type = :relative)
      setting :tv_set_brightness, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def tv_set_saturation(value, type = :relative)
      setting :tv_set_saturation, value, type
    end
    

    
  end
end