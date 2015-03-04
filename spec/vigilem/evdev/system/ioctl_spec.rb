require 'spec_helper'

require 'vigilem/evdev/system/ioctl'

describe Vigilem::Evdev::System::IOCTL do
  class C
    inline do |builder|
      builder.include '<stdio.h>'
      builder.include '<sys/ioctl.h>'
      builder.include '<linux/input.h>'
      builder.include '<fcntl.h>'
      builder.include '<stddef.h>'
      %w(_IOC_NRBITS _IOC_TYPEBITS _IOC_SIZEBITS _IOC_DIRBITS _IOC_NRMASK
      _IOC_TYPEMASK _IOC_SIZEMASK _IOC_DIRMASK _IOC_NRSHIFT _IOC_TYPESHIFT
      _IOC_SIZESHIFT _IOC_DIRSHIFT IOCSIZE_MASK IOCSIZE_SHIFT).map do |str|
        builder.c "
          long r_#{str}() {
            return #{str};
          }
        "
      end
      
      %w(_IOC_NONE _IOC_WRITE _IOC_READ).map do |str|
        builder.c "
          int r_#{str}() {
            return #{str};
          }
        "
      end
      
      builder.c '
        long r__IO(char type, int nr) {
          return _IO(type, nr);
        }
      '
      builder.c '
        long r_int2_IOC(long dir, char type, int nr) {
          return _IOC(dir, type, nr, sizeof(int[2]));
        }
      '
    end
  end
  
  let(:c) { C.new }
  
  it 'will return zero if sudo is not used' do
    expect(c.r__IOC_NRBITS).not_to eql 0
  end
  
  describe '::_IOC_NRBITS' do
    it 'will match the linux value' do
      expect(described_class::_IOC_NRBITS).to eql(c.r__IOC_NRBITS)
    end
  end
  
  describe '::_IOC_TYPEBITS' do
    it 'will match the linux value' do
      expect(described_class::_IOC_TYPEBITS).to eql(c.r__IOC_TYPEBITS)
    end
  end
  
  describe '::_IOC_SIZEBITS' do
    it 'will match the linux value' do
      expect(described_class::_IOC_SIZEBITS).to eql(c.r__IOC_SIZEBITS)
    end
  end
  
  describe '::_IOC_DIRBITS' do
    it 'will match the linux value' do
      expect(described_class::_IOC_DIRBITS).to eql(c.r__IOC_DIRBITS)
    end
  end
  
  describe '::_IOC_NRMASK' do
    it 'will match the linux value' do
      expect(described_class::_IOC_NRMASK).to eql(c.r__IOC_NRMASK)
    end
  end
  
  describe '::_IOC_TYPEMASK' do
    it 'will match the linux value' do
      expect(described_class::_IOC_TYPEMASK).to eql(c.r__IOC_TYPEMASK)
    end
  end
  
  describe '::_IOC_SIZEMASK' do
    it 'will match the linux value' do
      expect(described_class::_IOC_SIZEMASK).to eql(c.r__IOC_SIZEMASK)
    end
  end
  
  describe '::_IOC_DIRMASK' do
    it 'will match the linux value' do
      expect(described_class::_IOC_DIRMASK).to eql(c.r__IOC_DIRMASK)
    end
  end
  
  describe '::_IOC_NRSHIFT' do
    it 'will match the linux value' do
      expect(described_class::_IOC_NRSHIFT).to eql(c.r__IOC_NRSHIFT)
    end
  end
  
  describe '::_IOC_TYPESHIFT' do
    it 'will match the linux value' do
      expect(described_class::_IOC_TYPESHIFT).to eql(c.r__IOC_TYPESHIFT)
    end
  end
  
  describe '::_IOC_SIZESHIFT' do
    it 'will match the linux value' do
      expect(described_class::_IOC_SIZESHIFT).to eql(c.r__IOC_SIZESHIFT)
    end
  end
  
  describe '::_IOC_DIRSHIFT' do
    it 'will match the linux value' do
      expect(described_class::_IOC_DIRSHIFT).to eql(c.r__IOC_DIRSHIFT)
    end
  end
  
  describe '::IOCSIZE_MASK' do
    it 'will match the linux value' do
      expect(described_class.IOCSIZE_MASK).to eql(c.r_IOCSIZE_MASK)
    end
  end
  
  describe '::IOCSIZE_SHIFT' do
    it 'will match the linux value' do
      expect(described_class.IOCSIZE_SHIFT).to eql(c.r_IOCSIZE_SHIFT)
    end
  end
  
  describe '::_IOC_NONE' do
    it 'will match the linux value' do
      expect(described_class._IOC_NONE).to eql(c.r__IOC_NONE)
    end
  end
  describe '::_IOC_WRITE' do
    it 'will match the linux value' do
      expect(described_class._IOC_WRITE).to eql(c.r__IOC_WRITE)
    end
  end
  
  describe '::_IOC_READ' do
    it 'will match the linux value' do
      expect(described_class._IOC_READ).to eql(c.r__IOC_READ)
    end
  end
  
  let(:i_2) { 'ii' }
  
  let(:i_2_length) { ([0] * 2).pack('ii').length }
  
  let(:ioc_r) { described_class::_IOC_READ }
  let(:ioc_n) { described_class::_IOC_NONE }
  
  describe '::_IOC' do
    it 'will match the linux value' do
      expect(described_class._IOC(ioc_r, 'E', 0x03, i_2_length)).to eql(c.r_int2_IOC(ioc_r, 'E', 0x03))
    end
  end
  
  
  describe '::_IO' do
    it 'will match the linux value' do
      expect(described_class._IO('E', 0x03)).to eql(c.r__IO('E', 0x03))
    end
  end
  
  class Macro
    inline do |builder|
      builder.include '<stdio.h>'
      builder.include '<sys/ioctl.h>'
      builder.include '<fcntl.h>'
      %w(_IOR _IOW _IOWR).map do |str|
        builder.c "
          long #{str.downcase}_int(char type, int nr) {
            return #{str}(type, nr, int);
          }
        "
      end
    end
  end
  
  let(:macro) { Macro.new }
  
  describe '::_IOR' do
    it 'will match the linux value' do
      expect(described_class._IOR('E', 0x03, 'i')).to eql(macro._ior_int('E', 0x03))
    end
  end
  
  describe '::_IOW' do
    it 'will match the linux value' do
      expect(described_class._IOW('E', 0x03, 'i')).to eql(macro._iow_int('E', 0x03))
    end
  end
  
  describe '::_IOWR' do
    it 'will match the linux value' do
      expect(described_class._IOWR('E', 0x03, 'i')).to eql(macro._iowr_int('E', 0x03))
    end
  end
  
end
