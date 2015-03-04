require 'spec_helper'

require 'vigilem/evdev/key_map_cache'

describe Vigilem::Evdev::KeyMapCache do
  
  context 'unaugmented filename' do
    
    describe '::default_filename' do
      it %q<returns the default filename> do
        expect(described_class.default_filename).to eql('key_map_cache')
      end
    end
    
    describe '::default_path' do
      
      let(:filepath) { File.join(Bundler.root, 'data', described_class.default_filename) }
      
      it %q<returns the default path> do
        expect(described_class.default_path).to eql(filepath)
      end
    end
  end
  
  context 'augmented filename for test', :clean_up_test_cache do
    
    let(:test_filename) { 'key_map_cache_test' }
    
    let(:test_cache_path) { File.join(Bundler.root, 'data', test_filename) }
    
    describe '::exists?' do
      
      it %q<returns false when the file doesn't exist> do
        expect(described_class.exists?).to eql(false)
      end
      
      context 'testfile block' do
        it %q<returns true when the file does exist> do
          FileUtils.touch(test_cache_path)
          expect(described_class.exists?).to eql(true)
        end
      end
      
    end
    
    let(:key_map) { Vigilem::Support::KeyMap.new("keycode1"=>"Escape") }
    
    describe '::dump' do
      
      it 'marshals the key_map and stores it in the #default_path' do
        described_class.dump(key_map, test_cache_path)
        expect(File.binread(test_cache_path)).to eql(Marshal.dump(key_map))
      end
    end
    
    describe '::restore' do
      
      it 'marshals the key_map and stores it in the #default_path' do
        described_class.dump(key_map, test_cache_path)
        expect(described_class.restore(test_cache_path)).to eql(key_map)
      end
    end
  end
  
end
