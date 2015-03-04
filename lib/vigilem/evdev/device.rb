require 'vigilem/evdev/system/input'

require 'vigilem/evdev/device_capabilities'

require 'vigilem/support/core_ext/enumerable'

module Vigilem
module Evdev
  # 
  # 
  # 
  class Device < File
    
    BITS_PER_BYTE          = 8
    
    include System::Input
    extend System::Input
    
    include DeviceCapabilities
    
    class << self
      
      alias_method :super_open, :open
      
      private :super_open
      
      # 
      # implement with udev
      # @raises [NotImplemented]
      # @param  fd
      # @param  [String] mode
      # @param  [Hash] opt
      # @return 
      def new(fd, mode='r', opt={})
        raise NotImplemented, 'Cannot create device yet'
      end
      
      # @todo  mode, opt
      # open(filename, mode="r" [, opt])
      # open(filename [, mode [, perm]] [, opt]) {|file| block } → obj
      # /lib/udev/findkeyboards; method_missing -> get_keyboards?
      # @see  File::open
      def open(filename, mode='r', opt={})
        if dev = all.find {|d| File.expand_path(filename) == d.path }
          dev
        else
          raise NotImplemented, "mode of #{mode} not supported yet" if mode != 'r'
          obj_register(super(filename, mode, opt))
        end
      end
      
      # 
      # @return [Array<Device>]
      def all
        @all ||= chardev_glob(default_glob).map {|fp| send(:super_open, fp) }
      end
      
      # defaults to "/dev/input"
      # @return [String]
      def default_dir
        @default_dir ||= '/dev/input'
      end
      
      # defaults to "/dev/input/event*"
      # @return [String]
      def default_glob
        @default_glob ||= File.join(default_dir, 'event*')
      end
      
      attr_writer :default_dir, :default_glob
      
      # @todo 
      #def [](opts={})
      #  
      #end
      
      # executes EVIOCGNAME against known chardev's, and compares that to the
      # regexp. If there is a filename_glob it checks that first.
      # @param  [Regexp] name_regexp
      # @param  [NilClass || String] glob
      # @return [Array<Device>]
      def name_grep(name_regexp, filename_glob=nil)
        if filename_glob
          file_paths = chardev_glob(filename_glob).map {|fn| File.expand_path(fn) }
          file_paths.map {|f_path| dev if (dev = send(:super_open, f_path)).name =~ name_regexp }.compact.uniq
        else
          all.select {|dev| dev.name =~ name_regexp }
        end
      end
      
      # Expands pattern, which is an Array of patterns or a pattern String, 
      # and returns the results as matches or as arguments given to the block.
      # and returns only character devices
      # @see    Dir::glob
      # @param  [String] glob defaults to './*'
      # @return [Array<String>]
      def chardev_glob(glob='./*')
        Dir[glob].select {|f| File::Stat.new(f).chardev? }
      end
    end
    
    # name of this device
    # @return [String]
    def name
      @name ||= begin 
                 ioctl(EVIOCGNAME(len = 256), out_name = " " * len)
                 out_name.rstrip
               end
    end
    
    # 
    # gets the ids of this device in an array
    # @return [Array<Fixnum, Fixnum, Fixnum, Fixnum>] [idbus, idvendor, idproduct, idversion]
    def ids
      @ids ||= begin
                ioctl(EVIOCGID, buf = '\x00' * 8)
                buf.unpack('S!4')
              end
    end
    
    # @todo test
    # @todo this doesn't really belong here
    def led_bits
      
      no_of_bytes = bit_count_to_byte_count(LED_CNT - 1)
      
      ledbit = "\x00" * no_of_bytes
      
      ioctl(EVIOCGLED(System.sizeof("C#{no_of_bytes}")), ledbit)
      
      ledbit[0..no_of_bytes].unpack("b*").first
    end
    
    # 
    # @todo test
    def _bits
      unless @bits
        ioctl(EVIOCGBIT(0), bits = [0].pack('i'))
        @bits = bits.unpack('i')[0]
      end
      return @bits
    end
    
=begin @todo
    def grab
    
    end
    
    def ungrab
     
    end
=end
    
    # 
    # @param  max_len
    # @param  out_buf=nil
    # @return [Array?]
    def read_nonblock(maxlen, out_buf=nil)
      raise Evdev::SizeError, 'maxlen', maxlen, ie_size if maxlen < (ie_size = InputEvent.size)
      super(*[maxlen, out_buf])
    end
    
    # 
    # @param  [Fixnum] length
    # @param  out_buf=nill
    # @return [Array?]
    def read(length=nil, outbuf=nil)
      length ||= Event.size
      raise Evdev::SizeError, arg_name: 'length', arg_size: length, max_size: sze if length < (sze = InputEvent.size)
      super(*[length, outbuf])
    end
    
   private
    # 
    # @todo  test
    def bit_count_to_byte_count(no_of_bits)
      # closest without going over
      (no_of_bits+7)/BITS_PER_BYTE
    end
  end
end
end
