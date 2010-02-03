module MPlayer
  module SlaveSubCommands
    
    # Adjust the subtitle delay
    # :relative is adjust by +/- <value> seconds.
    # :absolute is set it to <value>. (default)
    def sub_delay(value,type = :absolute)
      adjust_set :sub_delay, value, type
    end

    # Step forward in the subtitle list by <value> steps
    # step backwards if <value> is negative
    # can also set type to :backward or :forward and return postive <value>
    def sub_step(value, type = :next)
      val = value.abs
      type = :prev if value < 0
      send(type == :next ? "sub_step #{val}" : "sub_step #{-val}" )
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
      else -2
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

    # Toggle/set  forced subtitles only
    def forced_subs_only(value = nil)
      toggle :forced_subs_only, value
    end
    
  end
end