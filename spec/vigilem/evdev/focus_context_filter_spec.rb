require 'spec_helper'

require 'vigilem/evdev/focus_context_filter'

describe Vigilem::Evdev::FocusContextFilter, :clean_up_test_cache do
  
  describe '::env_display' do
    it 'pulls the display from the environment variable' do
      allow(ENV).to receive(:[]).with('DISPLAY') { ':0.0' }
      expect(ENV).to receive(:[]).with('DISPLAY')
      described_class.env_display
    end
  end
  
  context 'instance-level' do
    
    before(:all) do
      described_class.lazy_require
    end
    
    describe '#has_focus?' do
      it 'uses the X11 function to check for focus' do
        allow(Xlib).to receive(:XGetInputFocus)
        expect(Xlib).to receive(:XGetInputFocus)
        subject.has_focus?
      end
      
      it 'checks XQueryTree because GTK puts the focus on a child window' do
        allow(Xlib).to receive(:XQueryTree)
        expect(Xlib).to receive(:XQueryTree)
        subject.has_focus?
      end
    end
    
    describe '#has_focus?' do
      context 'initial focus' do
        it 'will check the X11 for focus' do
          allow(Xlib).to receive(:XGetInputFocus)
          expect(Xlib).to receive(:XGetInputFocus)
          subject.has_focus?
        end
      end
    end
    
    describe '#had_focus?' do
      it 'will be the opposite of #was_on?' do
        expect(subject.was_on?).to eql(!subject.had_focus?)
      end
    end
    
    describe '#had_focus=' do
      it 'will set the #had_focus?' do
        subject.send(:had_focus=, true)
        expect(subject.had_focus?).to be_truthy
      end
    end
    
    describe '#gained_focus?,' do
      it 'returns false when event the window already #had_focus?' do
        subject.send(:had_focus=, true)
        expect(subject.gained_focus?).to be_falsey
      end
      
      it 'returns true when not #had_focus? and #has_focus?' do
        subject.send(:had_focus=, false)
        allow(subject).to receive(:has_focus?) { true }
        expect(subject.gained_focus?).to be_truthy
      end
    end
    
    describe '#lost_focus?,' do
      it 'returns true when #had_focus? and not #has_focus?' do
        subject.send(:had_focus=, true)
        allow(subject).to receive(:has_focus?) { false }
        expect(subject.lost_focus?).to be_truthy
      end
      
      it 'returns false when not #had_focus?' do
        allow(subject).to receive(:has_focus?) { false }
        subject.send(:had_focus=, false)
        expect(subject.lost_focus?).to be_falsey
      end
    end
    
    describe '#on?' do
      it 'sets #last_known_status = OFF when #gained_focus? == true' do
        allow(subject).to receive(:gained_focus?) { true }
        subject.on?
        expect(subject.last_known_state).to eql(described_class::OFF)
      end
      
      it 'when #gained_focus? == true, it returns false' do
        allow(subject).to receive(:gained_focus?) { true }
        expect(subject.on?).to eql(false)
      end
      
      it 'sets #last_known_status = ON when #lost_focus? == true' do
        allow(subject).to receive(:gained_focus?) { false }
        allow(subject).to receive(:lost_focus?) { true }
        subject.on?
        expect(subject.last_known_state).to eql(described_class::ON)
      end
      
      it 'when #lost_focus? == true, it returns true' do
        allow(subject).to receive(:gained_focus?) { false }
        allow(subject).to receive(:lost_focus?) { true }
        expect(subject.on?).to eql(true)
      end
    end
    
  end
end
