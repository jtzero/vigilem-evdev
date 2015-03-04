require 'spec_helper'

require 'vigilem/evdev/dom/input_event_converter'

describe Vigilem::Evdev::DOM::InputEventConverter, :clean_up_test_cache do
  
  Input = Vigilem::Evdev::System::Input
  
  InputEvent = Input::Event
  
  class Host
    include Vigilem::Evdev::DOM::InputEventConverter
    
    def initialize
      initialize_input_event_converter
    end
    
  end
  
  subject { Host.new }
  
  let(:input_event) do 
    ie = InputEvent[[12, 9], 1, Input::KEY_A, 1]
    ie.leds = "100000000000000000000000"
    ie
  end
  
  let(:input_event_release) do 
    ie = InputEvent[[15, 11], 1, Input::KEY_A, 0]
    ie.leds = "100000000000000000000000"
    ie
  end
  
  describe '#key_map' do
    it 'returns a keymap' do
      expect(subject.key_map).to be_a Vigilem::Support::KeyMap
    end
  end
  
  describe '#keysyms' do
    it 'takes a alpha keycode name and returns it\'s key_syms' do
      expect(subject.keysyms('keycode30')).to match(/\+?(U\+)?(0x)?0061/)
    end
    
    it 'takes a functional keycode name and returns it\'s key_syms' do
      expect(subject.keysyms('keycode97')).to match(/[a-z]+/i)
    end
  end
  
  describe 'dom_key' do
    
    it 'takes a keycode string for an alpha char and returns the dom key' do
      expect(subject.dom_key(input_event.code, subject.leds("100000000000000000000000"))).to eql('a')
    end
    
    it 'takes an InputEvent.code for a control char and returns a dom key' do
      input_event[:code] = Input::KEY_RIGHTCTRL
      expect(subject.dom_key(input_event.code, subject.leds("100000000000000000000000"))).to eql('Control')
    end
  end
  
  describe '#dom_type' do
    
    let(:dom_key_value) { subject.dom_key(input_event.code, subject.leds("100000000000000000000000")) }
    
    it %<takes an 0 and returns ['keydown', 'keypress']> do
      expect(subject.dom_type(input_event.value, dom_key_value)).to eql(%w(keydown keypress))
    end
    
    it %<takes an 0 and with a non-printable character returns ['keydown']> do
      expect(subject.dom_type(input_event.value, 'Control')).to eql(%w(keydown))
    end
    
    it %<takes an 1 and returns 'keyup'> do
      input_event[:value] = 0
      expect(subject.dom_type(input_event.value, dom_key_value)).to eql(['keyup'])
    end
  end
  
  describe '#dom_code' do
    it 'takes an InputEvent with an alpha code and returns the DOM code value' do
      keycode_name = described_class::KEYCODES[event_code = input_event.code]
      expect(subject.dom_code(keycode_name, 
        subject.dom_key(event_code, subject.leds("100000000000000000000000")))
      ).to eql('KeyA')
    end
    
    it 'takes an InputEvent with an numeric code and returns the DOM code value' do
      keycode_name = described_class::KEYCODES[event_code = Input::KEY_4]
      expect(subject.dom_code(keycode_name, 
        subject.dom_key(event_code, subject.leds("100000000000000000000000")))
      ).to eql('Digit4')
    end
    
    it 'takes an InputEvent.code for a control char and returns a dom key' do
      expect(subject.dom_code(Input::KEY_RIGHTCTRL, 
          subject.dom_key(Input::KEY_RIGHTCTRL, subject.leds("100000000000000000000000")))
        ).to eql('ControlRight')
    end
  end
  
  describe '#dom_location' do
    it 'takes an input event code and returns dom location' do
      keycode_name = described_class::KEYCODES[Input::KEY_RIGHTCTRL]
      expect(subject.dom_location(keycode_name)).to eql(2)
    end
  end
  
  describe '#dom_modifiers' do
    it 'takes an input event code and returns dom modifiers' do
      keycode_name = described_class::KEYCODES[Input::KEY_RIGHTCTRL]
      expect(subject.dom_modifiers(keycode_name)).to eql({
        :altKey => false, :ctrlKey => true, :keyModifierStateAltGraph => false,
        :keyModifierStateCapsLock => false, :keyModifierStateFn => false,
        :keyModifierStateFnLock => false, :keyModifierStateHyper => false,
        :keyModifierStateNumLock => false, :keyModifierStateOS => false,
        :keyModifierStateScrollLock => false, :keyModifierStateSuper => false,
        :keyModifierStateSymbol => false, :keyModifierStateSymbolLock => false,
        :metaKey => false, :shiftKey => false })
    end
  end
  
  describe '#current_keys' do
    it 'defaults to an empty array' do
      expect(subject.current_keys).to eql([])
    end
  end
  
  let(:dom_rshift_down) do 
    VDOM::KeyboardEvent.new('keydown', key: 'shift', code: 'ShiftRight', 
      location: VDOM::KeyboardEvent::DOM_KEY_LOCATION_RIGHT, repeat: false)
  end
  
  let(:dom_rshift_press) do 
    VDOM::KeyboardEvent.new('keypress', key: 'shift', code: 'ShiftRight', 
      location: VDOM::KeyboardEvent::DOM_KEY_LOCATION_RIGHT, repeat: false)
  end
  
  let(:dom_lalt_down) do 
    VDOM::KeyboardEvent.new('keydown', key: 'alt', code: 'AltRight', 
      location: VDOM::KeyboardEvent::DOM_KEY_LOCATION_LEFT, repeat: false)
  end
  
  let(:dom_lalt_press) do 
    VDOM::KeyboardEvent.new('keypress', key: 'alt', code: 'AltRight', 
      location: VDOM::KeyboardEvent::DOM_KEY_LOCATION_LEFT, repeat: false)
  end
  
  describe '#current_mod_keys_w_loc' do
    it 'defaults to an empty array' do
      expect(subject.current_mod_keys_w_loc).to eql([])
    end
    
    it 'converts current keys that are modifiers and returns an array containing the key and location' do
      subject.current_keys.replace([dom_rshift_down, dom_rshift_press, dom_lalt_down, dom_lalt_press])
      expect(subject.current_mod_keys_w_loc).to eql([["shift", "r"], ["alt", "l"]])
    end
  end
  
  let(:key_hash) do
    {
      bubbles: false, cancelable: false,
      code: 'KeyA', detail: 0, isTrusted: true, isComposing: false, 
      key: 'a', location: 0, 
      modifier_state: {"Accel"=>false, "Alt"=>false, "AltGraph"=>false,
         "CapsLock"=>false, "Control"=>false, "Fn"=>false,
         "FnLock"=>false, "Hyper"=>false, "Meta"=>false,
         "NumLock"=>false, "OS"=>false, "ScrollLock"=>false,
         "Shift"=>false, "Super"=>false, "Symbol"=>false, 
         "SymbolLock"=>false
      }, 
      os_specific: {
        :time=> {:tv_sec=>12, :tv_usec=>9}, 
        :type=>1, :code=>Input::KEY_A, :value=>1
      }, repeat: false, timeStamp: kind_of(Integer), type: 'keydown',
      view: nil
    }
  end
  
  let(:key_press_hash) { key_hash.dup.tap {|obj| obj[:type] = 'keypress' } }
        
  let(:dom_a_keydown) do
    ::VDOM::KeyboardEvent.new(key_hash[:type], key_hash)
  end
  
  let(:dom_a_keypress) do
    ::VDOM::KeyboardEvent.new(key_press_hash[:type], key_press_hash)
  end
  
  describe '#remove_from_current_keys' do
    it %q<#delete's items from #current_keys> do
      subject.current_keys.concat([dom_a_keydown, dom_a_keypress])
      subject.remove_from_current_keys(key_hash[:os_specific], key_hash[:location])
      expect(subject.current_keys).to eql([])
    end
  end
  
  describe '#to_dom_key_event' do
    
    context 'alpha character' do
    
      before(:all) { @converter = Host.new }
      
      it 'converts input_events to dom key event' do
        expect(@converter.to_dom_key_event(input_event)).to match [
            an_object_having_attributes(key_hash),
            an_object_having_attributes(key_press_hash)
          ] and be_a Vigilem::DOM::KeyboardEvent
      end
      
      it 'adds to the #current_keys' do
        expect(@converter.current_keys).to match [
            an_object_having_attributes(key_hash),
            an_object_having_attributes(key_press_hash)
          ] and be_a Vigilem::DOM::KeyboardEvent
      end
      
      it 'removes items from the #current_keys' do
        @converter.current_keys.concat([dom_a_keydown, dom_a_keypress])
        
        @converter.to_dom_key_event(input_event_release)
        expect(@converter.current_keys).to eql([])
      end
    end
    
    context 'functional character' do
      before(:all) { @converter = Host.new }
      
      let(:key_hash_functional) do 
        key_hash[:key] = 'Control'
        key_hash[:code] = 'ControlLeft'
        key_hash[:modifier_state]['Control'] = true
        key_hash[:location] = 1
        key_hash[:os_specific][:code] = Input::KEY_LEFTCTRL
        key_hash
      end
      
      it 'converts input_events to dom key event' do
        input_event[:code] = Input::KEY_LEFTCTRL
        expect(@converter.to_dom_key_event(input_event)).to match [
            an_object_having_attributes(key_hash_functional)
          ] and be_a Vigilem::DOM::KeyboardEvent
      end
      
      it 'adds to the #current_keys' do
        expect(@converter.current_keys).to match [
            an_object_having_attributes(key_hash_functional)
          ] and be_a Vigilem::DOM::KeyboardEvent
      end
    end
  end
  
end
