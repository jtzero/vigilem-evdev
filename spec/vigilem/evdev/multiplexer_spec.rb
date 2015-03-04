require 'vigilem/evdev/multiplexer'

describe Vigilem::Evdev::Multiplexer do
  
  let(:input_event) { Vigilem::Evdev::System::Input::InputEvent }
  
  let(:out) { [] }
  
  let(:pipes1) { IO.pipe }
  
  let(:pipes2) { IO.pipe }
  
  let(:pipes3) { IO.pipe }
  
  subject { described_class.acquire([pipes1, pipes2, pipes3].map(&:first))  }
  
  describe '#sweep' do
    it %q<checks the io's and returns sorted InputEvents> do
      written_events = [input_event[[7, 8], 9, 10, 11], input_event[[12, 13], 14, 15, 16]]
      pipes1.last << written_events[0].bytes
      pipes2.last << written_events[1].bytes
      expect(subject.sweep(1).map(&:bytes)).to eql(written_events.sort {|a,b| a.time.to_f <=> b.time.to_f }.map(&:bytes))
    end
  end
  
  describe '::acquire' do
    
    let(:singleton_var_name) { :@multiplexer }
    
    context 'none exists' do
      before(:all) { described_class.send(:remove_instance_variable, :@multiplexer) }
      
      it 'the class instance variable will be nil' do
        expect(described_class.instance_variable_get(singleton_var_name)).to be_nil
      end
      
      it 'creates a new one' do
        expect(described_class.acquire()).to be_a described_class
      end
      
      it 'the class instance variable will be set' do
        expect(described_class.instance_variable_get(singleton_var_name)).not_to be_nil
      end
    end
    
    context 'one exists' do
      
      it 'grabs the existing one' do
        described_class.acquire
        expect(described_class.acquire()).to eql(described_class.instance_variable_get(singleton_var_name))
      end
    end
  end
  
end
