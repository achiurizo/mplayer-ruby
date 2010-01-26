module MPlayer
  class Slave
    attr_accessor :stdin
    attr_reader :pid,:stdout,:stderr,:file

    def initialize(file = "")
      raise ArgumentError,"Invalid File" unless File.exists?(file)
      @file = file
      mplayer = "/usr/bin/mplayer -slave -quiet #{@file}"
      @pid,@stdin,@stdout,@stderr = Open4.popen4(mplayer)
    end

    # Increase/decrease volume
    # :up increase volume
    # :down decreases volume
    # :set sets the volume at <value>
    def volume(action,value=30)
      cmd =
      case action
      when :up then "volume 1"
      when :down then "volume 0"
      when :set then "volume #{value} 1"
      else return false
      end
      send cmd
    end

    # Returns a hash of the meta information of the file.
    def meta_info
      #TODO
      # meta = "get_meta_%s"
      # album = send meta('album')
      # artist = send meta('artist')
      # comment = send meta('comment')
      # genre = send meta('genre')
      # title = send meta('title')
      # track = send meta('track')
      # year = send meta('year')
      # {:album => album,:artist => artist, :comment => comment, :genre => genre, :title => title, :track => track, :year => year}
    end

    # Seek to some place in the file
    # :relative is a relative seek of +/- <value> seconds (default).
    # :perecent is a seek to <value> % in the file.
    # :absolute is a seek to an absolute position of <value> seconds.
    def seek(value,type = :relative)
      send case type
      when :percent then "seek #{value} 1"
      when :absolute then "seek #{value} 2"
      else "seek #{value} 0"
      end
    end

    # Set/adjust the audio delay.
    # If type is :relative adjust the delay by <value> seconds.
    # If type is :absolute, set the delay to <value> seconds.
    def audio_delay(value,type = :relative)
      adjust_set :audio_delay, value, type
    end


    # Adjusts the current playback speed
    # :increment adds <value> to the current speed
    # :multiply multiplies the current speed by <value>
    # :set sets the current speed to <value>.(default)
    def speed(value,type = :set)
      case type
      when :increment then speed_incr(value)
      when :multiply then speed_mult(value)
      else speed_set(value)
      end
    end

    # Adjust/set how many times the movie should be looped.
    # :none means no loop
    # :forever means loop forever.(default)
    # :set sets the amount of times to loop. defaults to one loop.
    def loop(action = :forever,value = 1)
      send case action
      when :none then "loop -1"
      when :set then "loop #{value}"
      else "loop 0"
      end
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

    # Go to the next/previous entry in the playtree. The sign of <value> tells
    # the direction.  If no entry is available in the given direction it will do
    # nothing unless [force] is non-zero.
    def pt_step(value,force = :no_force)
      send(force == :force ? "pt_step #{value} 1" : "pt_step #{value} 0")
    end

    # Similar to pt_step but jumps to the next/previous entry in the parent list.
    # Useful to break out of the inner loop in the playtree.
    def pt_up_step(value,force = :no_force)
      send(force == :force ? "pt_up_step #{value} 1" : "pt_up_step #{value} 0")
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

    def balance(value,type = :relative)
      #TODO
      return false
    end

    # Switch volume control between master and PCM.
    def use_master; send("use_master"); end

    # Toggle sound output muting or set it to [value] when [value] >= 0
    #     (1 == on, 0 == off).
    def mute(value = nil)
      toggle :mute, value
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

    def vobsub_lang(value = nil)
      # TODO
      return false
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
    #  : demux SUB_SOURCE_DEMUX for subtitle embedded in the media file or DVD subs.
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
    
    def sub_log
      #TODO
      send("sub_log")
      @stdout.gets
    end
    
    # Adjust the subtitle size by +/- <value> 
    # :set set it to <value>
    # :relative adjusts it by value
    def sub_scale(value,type = :relative)
      adjust_set :sub_scale, value, type
    end

    # switch_audio [value] (currently MPEG*, AVI, Matroska and streams handled by libavformat)
    #     Switch to the audio track with the ID [value]. Cycle through the
    #     available tracks if [value] is omitted or negative.
    def switch_audio(value = :cycle)
      select_cycle :switch_audio, value
    end
    # switch_angle [value] (DVDs only)
    #     Switch to the DVD angle with the ID [value]. Cycle through the
    #     available angles if [value] is omitted or negative.
    def switch_angle(value = :cycle)
      select_cycle :switch_angle, value
    end
    
    # switch_title [value] (DVDNAV only)
    #     Switch to the DVD title with the ID [value]. Cycle through the
    #     available titles if [value] is omitted or negative.
    def switch_title(value = :cycle)
      select_cycle :switch_title, value
    end 
    
    # switch_ratio [value]
    #     Change aspect ratio at runtime. [value] is the new aspect ratio expressed
    #     as a float (e.g. 1.77778 for 16/9).
    #     There might be problems with some video filters.
    #
    def switch_ratio(value); send("switch_ratio #{value}"); end
    
    # switch_vsync [value]
    #     Toggle vsync (1 == on, 0 == off). If [value] is not provided,
    #     vsync status is inverted.
    def switch_vsync(value = nil)
      toggle :switch_vsync, value
    end


    # Loads the file into MPlayer
    # :append loads the file and appends it to the current playlist
    # :no_append will stop playback and play new loaded file
    def load_file(file,append = :no_append)
      raise ArgumentError,"Invalid File" unless File.exists? file
      switch = (append == :append ? 1 : 0)
      send "loadfile #{file} #{switch}"
    end
    
    # Loads the playlist into MPlayer
    # :append loads the playlist and appends it to the current playlist
    # :no_append will stop playback and play new loaded playlist
    def load_list(file,append = :no_append)
      raise ArgumentError,"Invalid File" unless File.exists? file
      switch = (append == :append ? 1 : 0)
      send "loadlist #{file} #{switch}"
    end

    # When more than one source is available it selects the next/previous one.
    # ASX Playlist ONLY
    def alt_src_step(value); send("alt_src_step #{value}"); end

    # Add <value> to the current playback speed.
    def speed_incr(value); send("speed_incr #{value}"); end

    # Multiply the current speed by <value>.
    def speed_mult(value); send("speed_mult #{value}"); end

    # Set the speed to <value>.
    def speed_set(value); send("speed_set #{value}"); end

    # Play one frame, then pause again.
    def frame_step; send("frame_step"); end

    # Write the current position into the EDL file.
    def edl_mark; send("edl_mark"); end

    # Pauses/Unpauses the file.
    def pause; send("pause") ; end

    # Quits MPlayer
    def quit; send('quit') ; end


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

    def send(cmd); @stdin.puts(cmd); return true; end

    def meta(field); "get_meta_#{field}"; end
  end
end
