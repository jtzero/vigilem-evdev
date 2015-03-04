require 'vigilem/evdev/context_filter'

describe Vigilem::Evdev::ContextFilter do
  
  class ContextFilterHost
    include Vigilem::Evdev::ContextFilter
  end
  
  subject { ContextFilterHost.new }
  
  describe '::included' do
    it 'extends Forwardable' do
      expect(subject.class.singleton_class.included_modules).to include(Forwardable)
    end
  end
  
  describe '#last_known_state' do
    it 'defaults to nil/UKNOWN' do
      expect(subject.last_known_state).to be_nil
    end
  end
  
  describe '#was_on?' do
    it 'compares ON to #last_known_state defaulting to false' do
      expect(subject.was_on?).to be_falsey
    end
    
    it 'returns true if #last_known_state == ON' do
      subject.send(:last_known_state=, described_class::ON)
      expect(subject.was_on?).to be_truthy
    end
  end
  
  describe '#was_off?' do
    it 'compares OFF to #last_known_state defaulting to true' do
      expect(subject.was_off?).to be_truthy
    end
    
    it 'returns true if #last_known_state == OFF' do
      subject.send(:last_known_state=, described_class::ON)
      expect(subject.was_off?).to be_falsey
    end
  end
  
  describe '#on?' do
    it 'raises error because it needs to be overridden' do
      expect { subject.on? }.to raise_error(NotImplementedError)
    end
  end
  
  #alias_method :filtered?, :on?
  
  
  describe '#off?' do
    it 'raises error because it needs to be overridden' do
      expect { subject.off? }.to raise_error(NotImplementedError)
    end
  end
  
  describe '#on_change' do
    it 'updates #last_known_state' do
      subject.on_change(described_class::ON)
      expect(subject.last_known_state).to eql(described_class::ON)
    end
    
    class FakeObserver
      def update(type, value)
        (@updates ||= []).concat([type, value])
      end
      attr_reader :updates
    end
    
    it 'notifies observers' do
      fo = FakeObserver.new
      subject.add_observer(fo)
      subject.on_change(described_class::ON)
      expect(fo.updates).to eql([subject, described_class::ON])
    end
  end
  
  context 'private' do
    describe '#last_known_state=' do
      it 'sets #last_known_state' do
        subject.send(:last_known_state=, described_class::ON)
        expect(subject.last_known_state).to eql(described_class::ON)
      end
    end
    
    describe '#was_on=' do
      it 'sets #was_on?' do
        subject.send(:was_on=, false)
        expect(subject.was_on?).to be_falsey
      end
      
      it 'updates #last_known_state' do
        subject.send(:was_on=, true)
        expect(subject.last_known_state).to eql(described_class::ON)
      end
    end
    
    describe '#was_off=' do
      it 'sets #was_off?' do
        subject.send(:was_off=, true)
        expect(subject.was_off?).to be_truthy
      end
      
      it 'updates #last_known_state' do
        subject.send(:was_off=, true)
        expect(subject.last_known_state).to eql(described_class::OFF)
      end
    end
  end
  
end
