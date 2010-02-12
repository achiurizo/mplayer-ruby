module MPlayer
  module SlaveVideoCommands
    
    # Set/adjust the audio delay.
    # If type is :relative adjust the delay by <value> seconds.
    # If type is :absolute, set the delay to <value> seconds.
    def audio_delay(value,type = :relative)
      adjust_set :audio_delay, value, type
    end
    
    # Toggle OSD mode
    # or set it to <level>
    def osd(level=nil)
      send(level.nil? ? "osd" : "osd #{level}")
    end

    # Show <string> on the OSD.
    # :duration sets the length to display text.
    # :level sets the osd level to display at. (default: 0 => always show)
    def osd_show_text(string,options = {})
      options.reverse_merge!({:duration => 0, :level => 0})
      send("osd_show_text #{string} #{options[:duration]} #{options[:level]}")
    end

    # Show an expanded property string on the OSD
    # see -playing-msg for a list of available expansions
    # :duration sets the length to display text.
    # :level sets the osd level to display at. (default: 0 => always show)
    def osd_show_property_text(string,options={})
      options.reverse_merge!({:duration => 0, :level => 0})
      send("osd_show_property_text #{string} #{options[:duration]} #{options[:level]}")
    end
    
    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def contrast(value, type = :relative)
      setting :contrast, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def gamma(value, type = :relative)
      setting :gamma, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def hue(value, type = :relative)
      setting :hue, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def brightness(value, type = :relative)
      setting :brightness, value, type
    end

    # Set/adjust video parameters.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    # <value> is in the range [-100, 100].
    def saturation(value, type = :relative)
      setting :saturation, value, type
    end
    
    # Toggle/set frame dropping mode
    # if :on, turns on dropping mode
    # if :off, turns off dropping mode
    # call by itself toggles dropping mode
    def frame_drop(value = nil)
      toggle :frame_drop, value
    end

    # switch_audio [value] (currently MPEG*, AVI, Matroska and streams handled by libavformat)
    # <value> Switch to the audio track with the ID <value>.
    # :cycle available tracks if [value] is omitted or negative.
    def switch_audio(value = :cycle)
      select_cycle :switch_audio, value
    end
    # switch_angle [value] (DVDs only)
    # <value> Switch to the DVD angle with the ID [value].
    # :cycle available angles if [value] is omitted or negative.
    def switch_angle(value = :cycle)
      select_cycle :switch_angle, value
    end

    # switch_title [value] (DVDNAV only)
    # <value> Switch to the DVD title with the ID [value].
    # :cycle available titles if [value] is omitted or negative.
    def switch_title(value = :cycle)
      select_cycle :switch_title, value
    end

    # switch_ratio [value]
    # <value> Change aspect ratio at runtime. [value] is the new aspect ratio expressed
    # as a float (e.g. 1.77778 for 16/9).
    # There might be problems with some video filters.
    def switch_ratio(value); send("switch_ratio #{value}"); end

    # switch_vsync [value]
    # :on Toggle vsync on
    # :off Toggle off
    # nil for just Toggle
    def switch_vsync(value = nil)
      toggle :switch_vsync, value
    end
     
    # Toggle/set borderless display
    # :on Toggle on
    # :off Toggle off
    #  nil for Toggle
    def vo_border(value = nil)
      toggle :vo_border, value
    end
    
    # Toggle/set borderless display
    # :on Toggle on
    # :off Toggle off
    #  nil for Toggle
    def vo_border(value = nil)
      toggle :vo_border, value
    end
    
    # Toggle/set fullscreen mode
    # :on Toggle on
    # :off Toggle off
    #  nil for Toggle
    def vo_fullscreen(value = nil)
      toggle :vo_fullscreen, value
    end
    
    # Toggle/set stay-on-top
    # :on Toggle on
    # :off Toggle off
    #  nil for Toggle
    def vo_ontop(value = nil)
      toggle :vo_ontop, value
    end
    
    # Toggle/set playback on root window
    # :on Toggle on
    # :off Toggle off
    #  nil for Toggle
    def vo_rootwin(value = nil)
      toggle :vo_rootwin, value
    end
    
    # Take a screenshot. Requires the screenshot filter to be loaded.
    # nil Take a single screenshot.
    # :toggle Start/stop taking screenshot of each frame.
    def screenshot(toggle=nil)
      switch = toggle == :toggle ? 1 : 0
      send "screenshot #{switch}"
    end    
    
    # Increases or descreases the panscan range by <value>. maximum is 1.0.
    def panscan(value)
      raise ArgumentError, "Value out of Range -1.0 .. 1.0" unless value.abs <= 1
      send "panscan #{value} 0"
    end
    
    # presses the given dvd button
    # available buttons are:
    # :up :down :left :right :menu :select :prev :mouse
    def dvdnav(button)
      unless %w[up down left right menu select prev mouse].include? button.to_s
        raise ArgumentError, "Invalid button name"
      end
      send "dvdnav #{button}"
    end
    
    # Print out the current value of a property.
    # raises an error if it fails to get the property
    def get_property(value)
      resp = send("get_property #{value}",/#{value.to_s}/).gsub(/ANS(.+?)\=/,"")
      raise StandardError,resp if resp =~ /Failed/
      resp
    end
    
    #Set the value to a property
    def set_property(name,value)
      send "set_property #{name} #{value}"
    end
    
    #adjust the propery by steps
    # if value is < 0, steps downards
    # else, steps upward
    def step_property(name,value)
      direction = value < 0 ? -1 : 1
      send "step_property #{name} #{value.abs} #{direction}"
    end
    
    # Returns if it is in fullscreen mode.
    # true if it is fullscreen
    # false if it is windowed
    def get_vofullscreen
      resp = send "get_vofullscreen",/(0|1)/
      return true if resp =~ /1/
      false
    end
    alias :is_fullscreen? :get_vofullscreen
    
    # Returns if it the sub is visibile mode.
    # true if it is fullscreen
    # false if it is windowed
    def get_sub_visibility
      resp = send "get_sub_visibility",/(0|1)/
      return true if resp =~ /1/
      false
    end
    alias :is_sub_visible? :get_sub_visibility
    
    # Seek to the start of a chapter
    # :relative does a relative seek (+/-)
    # :absolute goes to the exact value of chapter
    def seek_chapter(value, type = :relative)
      adjust_set :seek_chapter, value, type
    end
    
    def change_rectangle(coord,value,type = :relative)
      switch = case coord
      when :x then (0 + (type == :relative ? 2 : 0))
      when :y then (1 + (type == :relative ? 2 : 0))
      end
      send("change_rectangle #{switch} #{value}")
    end
    
  end
end