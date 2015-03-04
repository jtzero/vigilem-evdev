require 'vigilem/_evdev'

require 'vigilem/support/key_map'

module Vigilem
module Evdev
  # 
  # 
  module KeyMapCache
    
    attr_accessor :key_map
    
    attr_writer :default_filename, :default_path
    
    # 
    # @return [String]
    def default_filename
      @default_filename ||= 'key_map_cache'
    end
    
    # 
    # @return [String] 
    def default_path
      @default_path ||= begin
        path = Vigilem::Evdev.data_dir
        Dir.mkdir(path) unless test ?d, path
        File.join(path, default_filename)
      end
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def exists?
      File.exists? default_path
    end
    
    # 
    # @param  [String] path
    # @return 
    def dump(key_map, path=default_path)
      File.open(path, 'w') {|f| f.write(Marshal.dump(key_map)) }
    end
    
    # 
    # @param  [String] path
    # @return [KeyMap || nil]
    def restore(path=default_path)
      key_map = Marshal.restore(File.binread(path))
    end
    
    alias_method :cache, :dump
    
    # 
    # @todo call KeymapLoaders
    #def build
    # 
    #end
    
    
    extend self
    
  end
end
end
