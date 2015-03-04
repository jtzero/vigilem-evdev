require 'spec_helper'

require 'vigilem/evdev/device'

describe Vigilem::Evdev::Device do
  
  after_each_example_group do
    (described_class.instance_variables).each do |ivar| 
      described_class.instance_variable_set(ivar, nil)
    end
  end
  
  describe '::open' do
    
    #@todo this is system dependent and will fail if no events in '/dev/input'
    it 'opens a device based on device path' do
      expect(described_class.open('/dev/input/event1')).to be_a described_class
    end
    
    it 'adds a new Device to the ::all Array' do
      dev = described_class.open('/dev/input/event1')
      expect(described_class.all).to include(dev)
    end
    
    it 'returns an existing Device is there is one' do
      dev = described_class.open('/dev/input/event1')
      expect(described_class.open('/dev/input/event1')).to eql(dev)
    end
    
  end
  
  describe '::all' do
    
    it 'to checks the default_dir' do
      allow(described_class).to receive(:chardev_glob) { [] }
      expect(described_class).to receive(:chardev_glob).with('/dev/input/event*')
      described_class.all
    end
  end
  
  describe '::default_dir' do
    it 'will defaults to "/dev/input"' do
      expect(described_class.default_dir).to eql('/dev/input')
    end
  end
  
  describe '::default_glob' do
    it 'will default to "/dev/input/event*"' do
      expect(described_class.default_glob()).to eql('/dev/input/event*')
    end
  end
  
  describe '#name' do
    it 'gets the EVIOCGNAME of the device' do
      expect(described_class.open('/dev/input/event2').name).to be_a(String) and not be_empty
    end
  end
  
  describe '::name_grep' do
    
    before(:each) do
      allow(described_class).to receive(:EVIOCGNAME) { "AT Translated Set 2 keyboard#{'\x00' * 229}" }
    end
    
    it %q<greps the EVIOCGNAME's of existing devices> do
      #expect(described_class.name_grep(/keyboard/)).to eql([instance_of(described_class)]) #hangs?
      expect(described_class.name_grep(/keyboard/)).to match [instance_of(described_class)]
    end
  end
  
  describe '::chardev_glob' do
    it 'globs a dir and returns an Array of chacter device file paths' do
      pending('testable isolated chardev')
      expect(described_class.chardev_glob(char_device_glob)).to eql(char_device)
    end
    
    it 'defaults to the current dir' do
      allow(Dir).to receive(:[]).with('./*') { [] }
      expect(Dir).to receive(:[]).with('./*')
      described_class.chardev_glob
    end
  end
  
  describe '::open' do
    it 'opens a device based on device path' do
      expect(described_class.open('/dev/input/event1')).to be_a described_class
    end
  end
  
  describe '#ids' do
    it %q<gets the id's of the device> do
      pending('implementeation gets fixed')
      expect(described_class.open('/dev/input/event2').ids).to eql([instance_of(Integer)] * 4)
    end
  end
  
end
