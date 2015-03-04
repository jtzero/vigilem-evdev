RSpec.configure do |config|
  
  config.before :all do |example_group|
    klass = example_group.class
    
    (klass.descendants - [klass]).each do |egc|
      if egc.metadata.key?(:clean_up_test_cache)
        require 'fileutils'
        require 'vigilem/evdev/key_map_cache'
        test_name = 'key_map_cache_test'
        egc.before(:each) do
          Vigilem::Evdev::KeyMapCache.default_path = nil
          Vigilem::Evdev::KeyMapCache.default_filename = test_name
        end
        egc.after(:each) do
          Vigilem::Evdev::KeyMapCache.default_path = nil
          Vigilem::Evdev::KeyMapCache.default_filename = nil
          pth = File.join(Bundler.root, 'data', test_name)
          FileUtils.remove(pth) if File.exists?(pth)
        end
      end
    end
    
  end
  
end
