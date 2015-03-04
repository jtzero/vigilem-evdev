require 'spec_helper'

require 'vigilem/_evdev'

describe Vigilem::Evdev, :clean_up_test_cache do
  describe '#key_map' do
    it 'loads the keymap' do
      expect(described_class.key_map).to be_a Vigilem::Support::KeyMap
    end
  end
end
