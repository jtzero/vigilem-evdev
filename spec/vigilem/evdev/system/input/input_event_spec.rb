require 'spec_helper'

require 'vigilem/evdev/system/input/input_event'

describe Vigilem::Evdev::System::Input do
  describe described_class::InputEvent do
    describe 'structure' do
      it 'will respond_to #time' do
        expect(subject).to respond_to(:time)
      end
      
      it 'will respond_to #type' do
        expect(subject).to respond_to(:type)
      end
      
      it 'will respond_to #code' do
        expect(subject).to respond_to(:code)
      end
      
      it 'will respond_to #value' do
        expect(subject).to respond_to(:value)
      end
      
    end
    
    describe '#time' do
      it 'will return with a Timeval' do
        expect(subject.time).to be_a Vigilem::Evdev::Time::Timeval
      end
    end
    
  end
end
