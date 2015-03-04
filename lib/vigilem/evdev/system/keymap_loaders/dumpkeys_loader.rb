require 'vigilem/support/key_map'

require 'vigilem/support/key_map_info'

module Vigilem
module Evdev
module System
module KeymapLoaders
  # 
  # this takes longer than keymap_loader, but is more thorough
  class DumpkeysLoader
    
    KeyMap = Support::KeyMap
    
    attr_writer :key_map
    
    # 
    # @param  [String] args 
    # @return [KeyMap]
    def exec(args='')
      @key_map = if self.class.available?
            if args =~ /\s+/
              raise ArgumentError, "Argument: `#{args}' invalid"
            else
              k = KeyMap.load_string(self.class.run_dumpkeys("fn#{args}"))
              k.metadata[:loader] = self
              k
            end
          end
      key_map_info
      @key_map
    end
    
    alias_method :key_map!, :exec
    
    # 
    # @return [KeyMap]
    def key_map
      @key_map ||= exec
    end
    
    # 
    # @return [KeyMapInfo]
    def key_map_info
      key_map.info ||= key_map.info(self.class.run_dumpkeys('l'))
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def available?
      self.class.available?
    end
    
    class << self
      # 
      # @return [FalseClass || TrueClass]
      def available?
        tty and command
      end
      
      # 
      # @return [String || NilClass] returns the command path, otherwise 
      #         returns nil if there isn't one
      def command
        if not @checked_for_command
          str = `which dumpkeys`.chomp
          @checked_for_command = true
          @command = str.empty? ? nil : str
        else
          @command
        end
      end
      
      # as long as it's sudo does this matter?
      # @return [String || nil] 
      def tty
        @tty_command ||= `which tty`.chomp
        @tty ||= `#{@tty_command}` if @tty_command
      end
      
      # needs sudo on xserver
      # loads dumpkeys string from system command
      # @param  [Array] *dumpkeys_args
      # @raise  command not run?
      # @return [String || nil] 
      def run_dumpkeys(*dumpkeys_args)
        if tty and command
          args = dumpkeys_args.empty? ? '' : "-#{dumpkeys_args.join}"
          `#{command} #{args} < #{tty}`
        end
      end
    end
    
  end
end
end
end
end
