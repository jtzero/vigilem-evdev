require 'zlib'

require 'vigilem/support/key_map'

module Vigilem
module Evdev
module System
module KeymapLoaders
  # 
  # change name to console-setup kmap
  class KmapLoader
    
    KeyMap = Support::KeyMap
    
    attr_writer :cache_glob, :key_map
    
    # 
    # @param  [NilClass || String] path
    # @return [KeyMap]
    def exec(path=nil)
      k = if not path
        if filepath = filepaths.find {|f| File.extname(f) !~ /\.g(un)?z(ip)?/ }
          KeyMap.load_string(File.read(filepath))
        elsif filepath = filepaths.find {|f| File.extname(f) =~ /\.g(un)?z(ip)?/ }
          KeyMap.load_string(Zlib::GzipReader.open(filepath).read)
        end
      else
        KeyMap.load_string(Zlib::GzipReader.open(path).read)
      end
      k.metadata[:loader] = self
      @key_map = k
      key_map_info
      @key_map
    end
    
    alias_method :keymap!, :exec
    
    # 
    # @return 
    def key_map
      @key_map ||= exec
    end
    
    # 
    # @return [KeyMapInfo]
    def key_map_info
      @key_map_info ||= if DumpkeysLoader.available? 
        key_map.info(DumpkeysLoader.run_dumpkeys('l'))
      end
    end
    
    # 
    # @return [Array<String>]
    def filepaths
      @filepaths ||= Dir[cache_glob]
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def available?
      filepaths.any? {|f| File.exists? f }
    end
    
    # 
    # @return [String] glob
    def cache_glob
      @cache_glob ||= '/etc/console-setup/cached*.kmap*'
    end
    
  end
end
end
end
end
