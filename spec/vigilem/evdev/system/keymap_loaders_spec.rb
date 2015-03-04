require 'spec_helper'

require 'vigilem/evdev/system/keymap_loaders'

require 'vigilem/evdev/system/keymap_loaders/dumpkeys_loader'
require 'vigilem/evdev/system/keymap_loaders/kmap_loader'

describe Vigilem::Evdev::System::KeymapLoaders, :clean_up_test_cache do
  
  describe '::load_key_map' do
    it 'raises an error if a keymap cannot be loaded' do
      described_class.all = []
      expect { described_class.exec }.to raise_error(NotImplementedError)
    end
    
    it 'loads a key_map attempting multiple sources' do
      described_class.all += [described_class::KmapLoader.new, described_class::DumpkeysLoader.new]
      expect(described_class.exec).to be_a Vigilem::Support::KeyMap
    end
  end
  
end
