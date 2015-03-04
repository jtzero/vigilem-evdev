require 'vigilem/evdev/transfer_agent'

describe Vigilem::Evdev::TransferAgent do
  
  after(:each) do
    [(v = ::Vigilem)::Evdev::Multiplexer, v::Evdev::Demultiplexer, 
      v::Core::Multiplexer, v::Core::Demultiplexer, v::Core::TransferAgent,
      described_class].each do |klass|
        klass.instance_variables.each {|ivar| klass.send(:remove_instance_variable, ivar) }
    end
  end
  
  describe '::acquire' do
    
    let(:singleton_var_name) { :@transfer_agent }
    
    context 'none exists and called with no args' do
      it 'the class instance variable will be nil initially' do
        expect(described_class.instance_variable_get(singleton_var_name)).to be_nil
      end
      
      it 'creates a new one' do
        allow(described_class).to receive(:new).and_call_original
        expect(described_class).to receive(:new)
        expect(described_class.acquire()).to be_a described_class
      end
      
      it 'sets the class instance variable' do
        described_class.acquire
        expect(described_class.instance_variable_get(singleton_var_name)).not_to be_nil
      end
    end
    
    context 'none exists and called with args' do
      it 'creates a new one with given args' do
        allow(described_class).to receive(:new).and_call_original
        expect(described_class).to receive(:new)
        a = []
        expect(described_class.acquire(inputs: [a])).to match(
          an_object_having_attributes(
            :demultiplexer => instance_of(Vigilem::Evdev::Demultiplexer),
            :multiplexer => an_object_having_attributes(:inputs => [a])
          )
        )
      end
    end
    
    context 'one exists' do
      
      it 'grabs the existing one' do
        expect(described_class.acquire).to eql(described_class.instance_variable_get(singleton_var_name))
      end
    end
    
  end
  
end
