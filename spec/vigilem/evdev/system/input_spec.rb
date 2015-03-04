require 'spec_helper'

require 'vigilem/evdev/system/input'

describe Vigilem::Evdev::System::Input do
  
  class EVIOC
    inline do |builder|
      builder.include '<stdio.h>'
      builder.include '<sys/ioctl.h>'
      builder.include '<linux/input.h>'
      builder.include '<fcntl.h>'
      builder.include '<stddef.h>'
      %w(EVIOCGVERSION EVIOCGID EVIOCGREP EVIOCSREP EVIOCGKEYCODE EVIOCGKEYCODE_V2
      EVIOCSKEYCODE EVIOCSKEYCODE_V2
      EVIOCSFF EVIOCRMFF EVIOCGEFFECTS EVIOCGRAB).map do |mac|
        builder.c "
          long #{mac.gsub(/EVIOC/, '').downcase}() {
            return #{mac};
          }
        "
      end
      %w(EVIOCGNAME EVIOCGPHYS EVIOCGUNIQ EVIOCGPROP EVIOCGKEY EVIOCGLED
      EVIOCGSND EVIOCGSW).map do |mac| 
        builder.c "
          long #{mac.gsub(/EVIOC/, '').downcase}(int len) {
            return #{mac}(len);
          }
        "
      end
      if $major >= 3 and $minor >= 4
        builder.c "
          long gmtslots(int len) {
            return EVIOCGMTSLOTS(len);
          }
        "
        builder.c "
          long sclockid() {
            return EVIOCSCLOCKID;
          }
        "
        $gmtslots_sclockid = true
      else
        warn 'EVIOCGMTSLOTS and EVIOCSCLOCKID untestable'
        $gmtslots_sclockid = false
      end
      
      if $major >= 3 and $minor >= 12
        builder.c "
          long _revoke() {
            return EVIOCREVOKE;
          }
        "
        $revoke = true
      else
        warn 'EVIOCREVOKE untestable'
        $revoke = false
      end
      
      builder.c "
        long gbit(int evtype, int len) {
          return EVIOCGBIT(evtype, len);
        }
      "
      builder.c "
        long gabs(int abs) {
          return EVIOCGABS(abs);
        }
      "
      builder.c "
        long sabs(int abs) {
          return EVIOCSABS(abs);
        }
      "
      
      builder.c '
        long size_of_input_keymap_entry() {
          return sizeof(struct input_keymap_entry);
        }
      '
      
      builder.c '
        long size_of_ff_effect() {
          return sizeof(struct ff_effect);
        }
      '
      
    end
  end
  
  let(:evioc) { EVIOC.new }
  
  describe 'input_keymap_entry' do
    it 'sizeof(input_keymap_entry) will eql it\'s linux counterpart' do
      expect(Vigilem::Support::Sys.sizeof(described_class.input_keymap_entry)).to eql(evioc.size_of_input_keymap_entry)
    end
  end
  
  describe 'ff_effect' do
    it 'sizeof(ff_effect) will eql it\'s linux counterpart' do
      expect(described_class::FFEffect.size).to eql(evioc.size_of_ff_effect)
    end
  end
  
  describe '::EVIOCGVERSION' do
    it 'will not be zero' do
      expect(described_class.EVIOCGVERSION).not_to eql(0)
    end
    
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGVERSION).to eql(evioc.gversion)
    end
  end
  
  describe '::EVIOCGID' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGID).to eql(evioc.gid)
    end
  end
  
  describe '::EVIOCGREP' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGREP).to eql(evioc.grep)
    end
  end
  
  describe '::EVIOCSREP' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCSREP).to eql(evioc.srep)
    end
  end
  
  if $gmtslots_sclockid
    describe '::EVIOCGMTSLOTS' do
      it 'will equal the macro specified in input.h' do
        expect(described_class.EVIOCGMTSLOTS(3)).to eql(evioc.gmtslots(3))
      end
    end
  end
  
  describe '::EVIOCGKEYCODE' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGKEYCODE).to eql(evioc.gkeycode)
    end
  end
  
  let(:ioc_r) { described_class::_IOC_READ }
  
  describe '::EVIOCGKEYCODE_V2' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGKEYCODE_V2).to eql(evioc.gkeycode_v2)
    end
  end
  
  describe '::EVIOCSKEYCODE' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCSKEYCODE).to eql(evioc.skeycode)
    end
  end
  
  describe '::EVIOCSKEYCODE_V2' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCSKEYCODE_V2).to eql(evioc.skeycode_v2)
    end
  end
  
  describe '::EVIOCGNAME' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGNAME(255)).to eql(evioc.gname(255))
    end
  end
  
  describe '::EVIOCGPHYS' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGPHYS(255)).to eql(evioc.gphys(255))
    end
  end
  
  describe '::EVIOCGUNIQ' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGUNIQ(255)).to eql(evioc.guniq(255))
    end
  end
  
  describe '::EVIOCGPROP' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGPROP(255)).to eql(evioc.gprop(255))
    end
  end
  
  describe '::EVIOCGKEY' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGKEY(255)).to eql(evioc.gkey(255))
    end
  end
  
  describe '::EVIOCGLED' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGLED(255)).to eql(evioc.gled(255))
    end
  end
  
  describe '::EVIOCGSND' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGSND(255)).to eql(evioc.gsnd(255))
    end
  end
  
  describe '::EVIOCGSW' do
    it 'will equal the macro specified in input.h' do
      expect(described_class::EVIOCGSW(255)).to eql(evioc.gsw(255))
    end
  end
=begin # @todo
  describe '::EVIOCGBIT' do
    it 'will equal the macro specified in input.h' do
      expect(described_class::EVIOCGBIT(evtype, len)).to eql(evioc.gbit(evtype, len))
    end
  end
  
  describe '::EVIOCGABS' do
    it 'will equal the macro specified in input.h' do
      expect(described_class::EVIOCGABS(abs)).to eql(evioc.gabs(abs))
    end
  end
  
  describe '::EVIOCSABS' do
    it 'will equal the macro specified in input.h' do
      expect(described_class::EVIOCSABS(abs)).to eql(evioc.sabs(abs))
    end
  end
=end
  describe '::EVIOCSFF' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCSFF).to eql(evioc.sff)
    end
  end
  
  describe '::EVIOCRMFF' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCRMFF()).to eql(evioc.rmff)
    end
  end
  
  describe '::EVIOCGEFFECTS' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGEFFECTS()).to eql(evioc.geffects)
    end
  end
  
  describe '::EVIOCGRAB' do
    it 'will equal the macro specified in input.h' do
      expect(described_class.EVIOCGRAB()).to eql(evioc.grab)
    end
  end
  
  # @todo switch to optinos flag >=3.4
  if $revoke
    describe '::EVIOCREVOKE', '>=v4.3' do
      it 'will equal the macro specified in input.h' do
        expect(described_class.EVIOCREVOKE()).to eql(evioc._revoke)
      end
    end
  end
  
  if $gmtslots_sclockid
    describe '::EVIOCSCLOCKID' do
      it 'will equal the macro specified in input.h' do
        expect(described_class.EVIOCSCLOCKID()).to eql(evioc.sclockid)
      end
    end
  end
  
end
