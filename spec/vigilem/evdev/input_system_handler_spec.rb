require 'spec_helper'

require 'vigilem/evdev/input_system_handler'

require 'timeout'

# @todo allow(inst).to receive(:filtered?) { true }
describe Vigilem::Evdev::InputSystemHandler, :clean_up_test_cache do
  
  after(:each) do
    [(v = ::Vigilem)::Evdev::TransferAgent, v::Evdev::Demultiplexer, 
                              described_class, v::Evdev::Multiplexer].each do |klass|
      (klass.instance_variables).each {|ivar| klass.send(:remove_instance_variable, ivar) }
    end
  end
  
  let(:pipes1) { IO.pipe }
  
  let(:pipes2) { IO.pipe }
  
  let(:pipes3) { IO.pipe }
  
  let(:input_event) { Vigilem::Evdev::System::Input::InputEvent }
  
  let(:read_pipes) { [pipes1, pipes2, pipes3].map(&:first) }
  
  let(:write_pipes) { [pipes1, pipes2, pipes3].map(&:last) }
  
  describe '#initialize' do
    it 'sets up the transfer_agent' do
      sys = described_class.new([])
      expect(sys.instance_variable_get(:@transfer_agent)).not_to be_nil
    end
  end
  
  context 'post init' do
    
    subject do
      inst = described_class.new(*read_pipes)
      inst.context_filters.replace([])
      inst
    end
    
    let(:written_events) { [input_event[[7, 8], 1, 30, 1], input_event[[12, 13], 1, 30, 0]].sort {|a, b| a.time.to_f <=> b.time.to_f} }
    
    let(:one) { written_events[0] }
    
    let(:one_bytes) { one.bytes }
    
    let(:two) { written_events[1] }
    
    let(:two_bytes) { two.bytes }
    
    describe '#read_many_nonblock' do
      
      it 'reads messages without blocking from the source' do
        expect do 
          Timeout.timeout(5) do
            subject.read_many_nonblock
          end
        end.not_to raise_error
      end
      
      it 'defaults to one message' do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(subject.read_many_nonblock.map(&:bytes).join).to eql(one_bytes)
      end
      
      it %q<will read as many of the `max_number_of_events' as available> do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(subject.read_many_nonblock(4).map(&:bytes)).to eql([one_bytes, two_bytes])
      end
      
    end
    
    describe '#read_one_nonblock' do
      it 'attempts to reads one message without blocking from the source' do
        expect do 
          Timeout.timeout(7) do
            subject.read_one_nonblock
          end
        end.not_to raise_error
      end
      
      it 'reads one message' do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(subject.read_one_nonblock.bytes).to eql(one_bytes)
      end
      
      it %q<will read one of the available messages> do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(subject.read_one_nonblock.bytes).to eql(one_bytes)
      end
    end
    
    describe '#read_many' do
      
      it 'reads messages blocking if source is empty' do
        expect do
          Timeout.timeout(3) do
            subject.read_many
          end
        end.to raise_error(Timeout::Error)
      end
      
      it 'defaults to one message' do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(Timeout.timeout(6) { subject.read_many.first.bytes }).to eql(one_bytes)
      end
      
      it %q<will read the number of messages equal to parameter passed in> do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(Timeout.timeout(6) { subject.read_many(2).map(&:bytes) }).to eql([one_bytes, two_bytes])
      end
    end
    
    describe '#read_one' do
      it 'reads a single message, blocking if source is empty' do
        expect do 
          Timeout.timeout(6) do
            subject.read_one
          end
        end.to raise_error(Timeout::Error)
      end
      
      it 'defaults to one message' do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(Timeout.timeout(6) { subject.read_one.bytes }).to eql(one_bytes)
      end
      
      it %q<will read the number of messages equal to parameter passed in> do
        write_pipes[0] << one_bytes
        write_pipes[2] << two_bytes
        expect(Timeout.timeout(6) { subject.read_one.bytes }).to eql(one_bytes)
      end
    end
    
  end
end
