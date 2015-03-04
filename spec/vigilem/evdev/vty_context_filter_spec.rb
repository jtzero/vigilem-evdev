require 'spec_helper'

require 'vigilem/evdev/vty_context_filter'

require 'vigilem/evdev/system/input'

# @todo based on this system keymap, need to "double"
describe Vigilem::Evdev::VTYContextFilter, :clean_up_test_cache do
  
  let(:key_map_class) { Vigilem::Support::KeyMap }
  
  describe '::console_keys' do
    it 'gets all the /console_\d+/i keys from the keymap' do
      cmap = described_class.console_keys(Vigilem::Evdev.key_map)
      expect(cmap.values.all? {|v| v =~ /console_\d+/i}).to be_truthy
    end
  end
  
  describe 'instance-level' do
    
    let(:key_num) { 65 }
    
    let(:keycode) { subject.keysym_or_keycode("keycode#{key_num}") }
    
    let(:alt_key_num) { 56 }
    
    let(:alt_key_sym) { subject.keysym_or_keycode(alt_key_num) }
    
    let(:shift_key_sym) { subject.keysym_or_keycode(42) }
    
    describe '#initialize' do
      
      it %q<initialize's #current_console_num, #current_console_keys, #other_console_keys> do
        
        expect([
          subject.current_console_num,
          subject.current_console_keys,
          subject.other_console_keys
        ]).to match [
          a_kind_of(Integer), a_kind_of(key_map_class), a_kind_of(key_map_class)
        ]
      end
      
    end
    
    describe '#key_map' do
      it 'the default is to return Evdev.key_map' do
        expect(subject.key_map).to eql(Vigilem::Evdev.key_map)
      end
      
      class FakeKmapLoader
      end
      
      it 'can be changed by the argument sent in to initialize' do
        arg = Vigilem::Support::KeyMap.new({})
        arg.metadata[:loader] = FakeKmapLoader.new
        inst = described_class.new(arg)
        expect(inst.key_map).to eql(arg)
      end
    end
    
    describe '#keysym' do
      context 'key_map.metadata[:loader].class.name =~ /KmapLoader/' do
        it 'converts a keycode to keysym' do
          expect(subject.keysym("keycode#{alt_key_num}")).to eql(alt_key_sym)
        end
      end
      context 'key_map.metadata[:loader].class.name =~ /DumpkeysLoader/' do
        it 'converts a keycode to keysym' do
          a = Vigilem::Evdev::System::KeymapLoaders::DumpkeysLoader.new.exec
          described_class.new(a)
          expect(subject.keysym("keycode#{alt_key_num}")).to eql(alt_key_sym)
        end
      end
    end
    
    describe '#keysym_or_keycode' do
      #it '' do
        
      #end
    end
    
    describe '#add_key' do
      it 'adds keys to the current list of keys' do
        subject.add_key(keycode)
        expect(subject.current_keys).to eql([keycode])
      end
    end
    
    describe '#remove_key' do
      it 'removes a key from the #current_keys' do
        subject.add_key(alt_key_sym)
        subject.add_key(shift_key_sym)
        subject.add_key(keycode)
        subject.remove_key(alt_key_sym)
        expect(subject.current_keys).not_to include(alt_key_sym)
      end
    end
    
    describe '#reverted_vty?' do
      it 'returns if #was_on? and #current_keys matches one of #current_console_keys' do
        subject.send(:was_on=, true)
        subject.current_keys.replace(["control", "alt", "keycode88"])
        
        subject.current_console_keys[["control", "alt", "keycode88"]] = "Console_12"
        expect(subject.reverted_vty?).to be_truthy
      end
    end
    
    describe '#changed_vty?' do
      it 'returns if #was_off? and #current_keys matches one of #other_console_keys' do
        subject.send(:was_off=, true)
        subject.current_keys.replace(["control", "alt", "keycode88"])
        
        subject.other_console_keys[["control", "alt", "keycode88"]] = "Console_12"
        expect(subject.changed_vty?).to be_truthy
      end
    end
    
    describe '#on?' do
      it 'checks is the vty changed' do
        allow(subject).to receive(:changed_vty?) { false }
        allow(subject).to receive(:reverted_vty?) { false }
        expect(subject).to receive(:changed_vty?)
        subject.on?
      end
      
      it 'checks is the vty changed reverted back' do
        allow(subject).to receive(:changed_vty?) { false }
        allow(subject).to receive(:reverted_vty?) { false }
        expect(subject).to receive(:reverted_vty?)
        subject.on?
      end
      
      it 'will call on_change with the new status when #changed_vty? == true' do
        allow(subject).to receive(:changed_vty?) { true }
        allow(subject).to receive(:reverted_vty?) { false }
        expect(subject).to receive(:on_change) { described_class::ON }
        subject.on?
      end
      
      it 'will call on_change with the new status when #reverted_vty? == true' do
        allow(subject).to receive(:changed_vty?) { false }
        allow(subject).to receive(:reverted_vty?) { true }
        expect(subject).to receive(:on_change) { described_class::OFF }
        subject.on?
      end
    end
    
    describe '#off?' do
      it 'performs the same actions as #on?' do
        allow(subject).to receive(:on?)
        expect(subject).to receive(:on?)
        subject.off?
      end
      
      it 'inverts the result of #on?' do
        expect(subject.off?).to eql(!subject.on?)
      end
    end
    
    context 'private' do
      describe '#current_keys_hash_cache' do
        it 'defaults to the #current_keys.hash' do
          expect(subject.send(:current_keys_hash_cache)).to eql(subject.current_keys.hash)
        end
      end
      
      describe '#current_keys_changed?' do
        it 'returns false when the #hash of #current_keys has not changed' do
          expect(subject.send(:current_keys_changed? )).to be_falsey
        end
        
        it 'returns true when the #hash of #current_keys changed' do
          subject.current_keys << 'f7'
          expect(subject.send(:current_keys_changed? )).to be_truthy
        end
        
      end
      
      describe '#current_keys_downcase' do
        it 'gets the downcase of all #current_keys' do
          subject.instance_variable_set(:@current_keys, %w(Alt Control keycode63))
          expect(subject.send(:current_keys_downcase)).to eql(%w(alt control keycode63))
        end
        
        it 'changes when #current_keys changes' do
          lower = subject.send(:current_keys_downcase)
          subject.current_keys.replace(%w(Alt Control keycode63))
          expect(lower).not_to eql(subject.send(:current_keys_downcase))
        end
      end
      
      describe '#allow_release?' do
        it 'determines whether the event can be released while #on?' do
          allow(subject).to receive(:on?) { true }
          subject.send(:filter_ommisions=, [shift_key_sym.downcase])
          expect(subject.send(:allow_release?, shift_key_sym.downcase)).to be_truthy
        end
        
        it 'determines whether the event can be released while #off?' do
          allow(subject).to receive(:on?) { false }
          subject.send(:filter_ommisions=, [shift_key_sym.downcase])
          expect(subject.send(:allow_release?, shift_key_sym.downcase)).to be_falsey
        end
      end
      
      describe '#filter_ommisions=, #filter_ommisions' do
        it '#filter_ommisions=, sets  #filter_ommisions' do
          subject.send(:filter_ommisions=, [shift_key_sym.downcase])
          expect(subject.send(:filter_ommisions)).to eql([shift_key_sym.downcase])
        end
      end
      
    end #private
    
    describe '#current_keys' do
      it 'defaults to []' do
        expect(subject.current_keys).to eql([])
      end
      
      it 'updates @current_keys_hash_cache' do
        ckhc = subject.instance_variable_get(:@current_keys_hash_cache)
        subject.current_keys
        expect(ckhc).not_to eql(subject.instance_variable_get(:@current_keys_hash_cache))
      end
    end
    
    describe '#process' do
      
      TestInput = Vigilem::Evdev::System::Input
      
      let(:syn_1_event) { TestInput::Event[[12, 9], TestInput::EV_SYN, 1, 1] }
      
      let(:syn_2_event) { TestInput::Event[[7, 8], TestInput::EV_SYN, 0, 0] }
      
      it 'passes all non EV_KEY events if off? == true' do
        allow(subject).to receive(:off?) { true }
        events = [syn_1_event, syn_2_event]
        expect(subject.process(*events)).to eql(events)
      end
      
      let(:key_a_event) { TestInput::Event[[12, 9], TestInput::EV_KEY, TestInput::KEY_LEFTSHIFT, 1] }
      
      let(:key_b_event) { TestInput::Event[[7, 8], TestInput::EV_KEY, TestInput::KEY_LEFTALT, 0] }
      
      it 'passes on EV_KEY events if off? == true and not in filter_ommisions' do
        allow(subject).to receive(:off?) { true }
        events = [key_a_event, key_b_event]
        subject.send(:filter_ommisions=, [])
        expect(subject.process(*events)).to eql(events)
      end
      
      it 'filters out EV_KEY events if off? == false and not in filter_ommisions' do
        allow(subject).to receive(:off?) { false }
        events = [key_a_event, key_b_event]
        subject.send(:filter_ommisions=, [])
        expect(subject.process(*events)).to eql([])
      end
      
      it 'passes on EV_KEY events if on? == true and in filter_ommisions and value == 0' do
        allow(subject).to receive(:off?) { false }
        allow(subject).to receive(:on?) { true }
        events = [key_a_event, key_b_event]
        subject.send(:filter_ommisions=, [alt_key_sym.downcase])
        expect(subject.process(*events)).to eql([key_b_event])
      end
      
      it 'filters on EV_KEY events if off? == true and in filter_ommisions and value == 0' do
        allow(subject).to receive(:off?) { true }
        events = [key_a_event, key_b_event]
        
        subject.send(:filter_ommisions=, [alt_key_sym.downcase])
        
        expect(subject.process(*events)).to eql([key_a_event])
      end
      
    end
    
  end
  
end
