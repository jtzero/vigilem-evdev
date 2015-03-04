require 'spec_helper'

require 'vigilem/evdev/dom/input_event_utils'

describe Vigilem::Evdev::DOM::InputEventUtils, :clean_up_test_cache do
  describe '#event_code_to_keycode_str' do
    it 'converts a InputEvent#code to a keycode\d+' do
      expect(subject.event_code_to_keycode_str(30)).to eql('keycode30')
    end
  end
  
  describe '#location_str_from_keycode_name' do
    it 'gets the location from the keycode_name' do
      expect(subject.location_str_from_keycode_name('KEY_RIGHTCTRL')).to eql('Right')
    end
  end
  
  describe '#modifier_keymap_name' do
    it 'takes a modifier keycode name and returns it\'s keymap equivilant' do
      expect(subject.modifier_keymap_name('KEY_RIGHTCTRL')).to eql('ctrlr')
    end
  end
end
