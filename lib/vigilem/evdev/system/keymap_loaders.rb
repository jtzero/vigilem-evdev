require 'vigilem/support/key_map'

require 'vigilem/evdev/key_map_cache'

module Vigilem
module Evdev
module System
  # 
  # the entry point for loading keymaps 
  module KeymapLoaders
    
    extend Support::Metadata
      
    KeyMap = Support::KeyMap
    
    attr_writer :all
    
    attr_reader :loader
    
    # 
    # @return [Array<KeymapLoader>]
    def all
      @all ||= []
    end
    
    # 
    # @return [FalseClass || TrueClass]
    def cached?
      Evdev::KeyMapCache.exists?
    end
    
    # 
    # @raise  [NotImplementedError] 'Cannot find keymap'
    # @return [KeyMap]
    def exec
      attempt ||= 1
      if cached?
        k = KeyMapCache.restore
        @loader = k.metadata[:loader]
        metadata[:cached] = true
      else
            #@todo just gets the first
        if @loader = all.find(&:available?)
          @loader.exec
        else
          raise NotImplementedError, 'Cannot find keymap'
        end
      end
    rescue ArgumentError #, 'marshal data too short'
      KeyMapCache.delete
      retry unless (attempts -= 1).zero?
    else
      KeyMapCache.dump((mapping = @loader.key_map))
      mapping[:cached] = true
      mapping.left_side_aliases(:keycode, :keycodes)
      mapping.right_side_aliases(:keysym, :keysyms, :char_ref, :char_refs)
      mapping
    end
    
    # 
    # @return [Array<KeymapLoader>]
    def set_default
      if not @set
        @set = true
        all.concat([DumpkeysLoader.new, KmapLoader.new])
      end
    end
    
    # returns the default system keymap
    # @return [KeyMap]
    def key_map
      set_default
      if loader
        loader.key_map
      else
        exec
      end
    end
      
    alias_method :build_cache, :key_map
      
    extend self
  end
end
end
end

require 'vigilem/evdev/system/keymap_loaders/dumpkeys_loader'
require 'vigilem/evdev/system/keymap_loaders/kmap_loader'
