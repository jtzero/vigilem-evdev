require 'vigilem/support/utils'

module Vigilem
  # loading this will load less than the tld
  module Evdev
   
   module_function
    
    # 
    # 
    def data_dir
      @data_dir ||= Support::GemUtils.data_dir(__FILE__)
    end
    
    # 
    # @return [KeyMap]
    def key_map
      System::KeymapLoaders.key_map
    end
    
  end
end

require 'vigilem/evdev/system/keymap_loaders'
