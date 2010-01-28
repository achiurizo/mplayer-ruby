module MPlayer
  module SlaveVideoCommands
    
    # Set/adjust the audio delay.
    # If type is :relative adjust the delay by <value> seconds.
    # If type is :absolute, set the delay to <value> seconds.
    def audio_delay(value,type = :relative)
      adjust_set :audio_delay, value, type
    end
    
    # Adjust the subtitle delay
    # :relative is adjust by +/- <value> seconds.
    # :absolute is set it to <value>. (default)
    def sub_delay(value,type = :absolute)
      adjust_set :sub_delay, value, type
    end

    # Step forward in the subtitle list by <value> steps
    # step backwards if <value> is negative
    # can also set type to :backward or :forward and return postive <value>
    def sub_step(value, type = :forward)
      type = :backward if value < 0
      send(type == :forward ? "sub_step #{value.abs}" : "sub_step -#{value.abs}" )
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

    # Adjust/set subtitle position.
    # If :relative, modifies parameter by <value>.
    # If :absolute, parameter is set to <value>.
    def sub_pos(value,type = :relative)
      adjust_set :sub_pos, value, type
    end

    # Toggle/set subtitle alignment. [alignment]
    # :top sets top alignment
    # :center sets center alignment
    # :bottom sets bottom alignment
    def sub_alignment(alignment = nil)
      send case alignment
      when :top then "sub_alignment 0"
      when :center then "sub_alignment 1"
      when :bottom then "sub_alignment 2"
      else "sub_alignment"
      end
    end

    # Toggle/set subtitle visibility.
    # :on turns on visilibity.
    # :off turns off visilibility.
    # else toggles visibility.
    def sub_visibility(value = nil)
      toggle :sub_visibility, value
    end

    # Loads subtitles from <file>.
    def sub_load(file)
      raise ArgumentError, "Invalid File" unless File.exists? file
      send("sub_load #{file}")
    end

    # Removes the selected sub file
    # :all removes all sub files. (Default)
    # <value> removes the sub file at that index.
    def sub_remove(value = :all)
      cmd = (value == :all ? -1 : value)
      send "sub_remove #{cmd}"
    end
    
    # Displays subtitle
    # :cycle will cycle through all sub_titles. (Default)
    # <value> will display the sub_title at that index.
    def sub_select(value = :cycle)
      cmd = (value == :cycle ? -2 : value)
      send "sub_select #{cmd}"
    end

    #  Display first subtitle from <value>
    #  :sub for SUB_SOURCE_SUBS for file subs
    #  :vobsub for  SUB_SOURCE_VOBSUB for VOBsub files
    #  :demux SUB_SOURCE_DEMUX for subtitle embedded in the media file or DVD subs.
    #  :off will turn off subtitle display.
    #  :cycle will cycle between the first subtitle of each currently available sources.
    def sub_source(value = :cycle)
      switch = case value
      when :sub then 0
      when :vobsub then 1
      when :demux then 2
      when :off then -1
      when :cycle then -2
      end
      send "sub_source #{switch}"
    end

    # Display subtitle specifid by <value> for file subs. corresponding to ID_FILE_SUB_ID
    # :off turns off sub
    # :cycle will cycle all file subs. (Default)
    def sub_vob(value = :cycle)
      select_cycle :sub_vob, value
    end

    # Display subtitle specifid by <value> for file subs. corresponding to ID_VOBSUB_ID
    # :off turns off sub
    # :cycle will cycle all file subs. (Default)
    def sub_file(value = :cycle)
      select_cycle :sub_file, value
    end

    # Display subtitle specifid by <value> for file subs. corresponding to ID_SUBTITLE_ID
    # :off turns off sub
    # :cycle will cycle all file subs. (Default)
    def sub_demux(value = :cycle)
      select_cycle :sub_demux, value
    end

    # Adjust the subtitle size by +/- <value>
    # :set set it to <value>
    # :relative adjusts it by value
    def sub_scale(value,type = :relative)
      adjust_set :sub_scale, value, type
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
    
    
  end
end