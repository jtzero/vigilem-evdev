require 'spec_helper'

require 'vigilem/evdev/demultiplexer'

describe Vigilem::Evdev::Demultiplexer do
  
  after(:each) do
    (described_class.instance_variables).each do |ivar|
      described_class.send(:remove_instance_variable, ivar)
    end
  end
  
  describe '::acquire' do
    context 'none exists and called with no args' do
      it 'creates a new one' do
        allow(described_class).to receive(:new).and_call_original
        expect(described_class).to receive(:new)
        expect(described_class.acquire()).to be_a described_class
      end
    end
    
    context 'none exists and called with args' do
      
      class FakeStream
        def update(*events)
        end
      end
      
      it 'creates a new one with given args' do
        allow(described_class).to receive(:new).and_call_original
        expect(described_class).to receive(:new)
        a = []
        obs = FakeStream.new
        expect(described_class.acquire([obs])).to match(
          an_object_having_attributes(
            :observers => [obs]
          )
        )
      end
    end
    
  end
  
end
