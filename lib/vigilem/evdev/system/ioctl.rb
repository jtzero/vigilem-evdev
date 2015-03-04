require 'vigilem/evdev/system'

module Vigilem
module Evdev
module System
  # @see http://lxr.free-electrons.com/source/include/uapi/asm-generic/ioctl.h
  # @todo consider the possibility of switching to RubyInline?
  #       - RubyInline (and ZenTest) gave significant problems
  #         installing "invalid gem: package metadata is missing" 
  #         updating to the newest rubygems and clearing the gem from the cache worked
  #         A C/C++ compiler (the same one that compiled your ruby interpreter)
  #         irb keeps throwing
  #         Errno::ENOENT: No such file or directory - /...home dir.../(irb)
  #         from /.../.rvm/gems/ruby-1.9.3-p545/gems/RubyInline-3.12.3/lib/inline.rb:532:in `mtime'
  #       - move this note to it's own file
  module IOCTL
    
    include Support::Sys
    
    # versions which are compatible with 
    # this file
    # @return [Array<Integer>]
    def self.kernel_versions
      %w(3.7 3.8 3.9 3.10 3.11 3.12 3.13 3.14 3.15 3.16)
    end
    
    # @return [Integer] 8
    def _IOC_NRBITS; 8; end
    # @return [Integer] 8
    def _IOC_TYPEBITS; 8; end
    # @return [Integer] 14
    def _IOC_SIZEBITS; 14; end
    # @return [Integer] 2
    def _IOC_DIRBITS; 2; end
    # @return [Integer]
    def _IOC_NRMASK; ((1 << _IOC_NRBITS)-1); end
    # @return [Integer]
    def _IOC_TYPEMASK; ((1 << _IOC_TYPEBITS)-1); end
    # @return [Integer]
    def _IOC_SIZEMASK; ((1 << _IOC_SIZEBITS)-1); end
    # @return [Integer]
    def _IOC_DIRMASK; ((1 << _IOC_DIRBITS)-1); end
    # @return [Integer]
    def _IOC_NRSHIFT; 0; end
    # @return [Integer]
    def _IOC_TYPESHIFT; (_IOC_NRSHIFT+_IOC_NRBITS); end
    # @return [Integer]
    def _IOC_SIZESHIFT; (_IOC_TYPESHIFT+_IOC_TYPEBITS); end
    # @return [Integer]
    def _IOC_DIRSHIFT; (_IOC_SIZESHIFT+_IOC_SIZEBITS); end
    #
    def IOC_IN;          (_IOC_WRITE << _IOC_DIRSHIFT); end
    #
    def IOC_OUT;         (_IOC_READ << _IOC_DIRSHIFT); end
    #
    def IOC_INOUT;       ((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT); end
    #
    def IOCSIZE_MASK;    (_IOC_SIZEMASK << _IOC_SIZESHIFT); end
    #
    def IOCSIZE_SHIFT;   (_IOC_SIZESHIFT); end
    
    # @return [Integer]
    def IOCSIZE_MASK; (_IOC_SIZEMASK << _IOC_SIZESHIFT); end
    # @return [Integer]
    def IOCSIZE_SHIFT; (_IOC_SIZESHIFT); end
    
    # direction bits
    
    # no data transfer
    # @return [Integer] 0
    def _IOC_NONE; 0; end
    # @return [Integer] 1
    def _IOC_WRITE; 1; end
    # @return [Integer] 2
    def _IOC_READ; 2; end
    
    # 
    # @param  [Integer] dir The direction of data transfer 
    # @option dir [Integer] _IOC_NONE
    # @option dir [Integer] _IOC_READ
    # @option dir [Integer] _IOC_WRITE
    # @option dir [Integer] _IOC_READ|_IOC_WRITE
    # @!macro type_nr_fmt_return_Integer
    def _IOC(dir, type, nr, size)
      (System.native_signed_long(dir << _IOC_DIRSHIFT) | (type.ord << _IOC_TYPESHIFT) | 
           (nr << _IOC_NRSHIFT) | (size << _IOC_SIZESHIFT))
    end
    
    # /* used to create numbers */
    
    # an ioctl with no parameters
    # @!macro type_nr
    # @return [Integer]
    def _IO(type,nr); return _IOC(_IOC_NONE,type.ord,nr,0); end
    # for reading data (copy_to_user)
    # @!macro type_nr_fmt_return_Integer
    def _IOR(type,nr,fmt_or_size); return _IOC(_IOC_READ,type.ord,nr,_size_of(fmt_or_size)); end
    # for writing data (copy_from_user)
    # @!macro type_nr_fmt_return_Integer
    def _IOW(type,nr,fmt_or_size); return _IOC(_IOC_WRITE,(type.ord),(nr),_size_of(fmt_or_size)); end
    # for bidirectional transfers
    # @!macro type_nr_fmt_return_Integer
    def _IOWR(type,nr,fmt_or_size); return _IOC(_IOC_READ|_IOC_WRITE,(type.ord),(nr),_size_of(fmt_or_size)); end

    #define _IOR_BAD(type,nr,size)  _IOC(_IOC_READ,(type),(nr),sizeof(size))
    #define _IOW_BAD(type,nr,size)  _IOC(_IOC_WRITE,(type),(nr),sizeof(size))
    #define _IOWR_BAD(type,nr,size) _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),sizeof(size))
    
    # /* used to decode ioctl numbers.. */
    
    # 
    # @!macro nr
    # @return [Integer]
    def _IOC_DIR(nr); return (((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK); end
    # @!macro nr
    # @return [Integer]
    def _IOC_TYPE(nr); return (((nr) >> _IOC_TYPESHIFT) & _IOC_TYPEMASK); end
    # @!macro nr
    # @return [Integer]
    def _IOC_NR(nr); return (((nr) >> _IOC_NRSHIFT) & _IOC_NRMASK); end
    # @!macro nr
    # @return [Integer]
    def _IOC_SIZE(nr); return (((nr) >> _IOC_SIZESHIFT) & _IOC_SIZEMASK); end
    
    # 
    # @param  [String || Numeric] numeric_or_format
    # @return [Fixnum]
    def _size_of(numeric_or_format)
      if numeric_or_format.is_a? String
        sizeof(numeric_or_format)
      elsif numeric_or_format.is_a? Numeric
        numeric_or_format
      else numeric_or_format.respond_to? :size
        numeric_or_format.size
      end
    end
    
    extend self
    
  end
end
end
end
