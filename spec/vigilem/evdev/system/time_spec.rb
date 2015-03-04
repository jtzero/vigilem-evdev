require 'spec_helper'

require 'vigilem/evdev/system/time'

describe Vigilem::Evdev::Time do
  
  describe described_class::Timeval do
    describe 'structure' do
      it 'will respond_to #tv_sec' do
        expect(subject).to respond_to(:tv_sec)
      end
      
      it 'will respond_to #tv_usec' do
        expect(subject).to respond_to(:tv_usec)
      end
    end
  end
end
