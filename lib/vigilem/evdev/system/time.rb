require 'vigilem/support'

require 'vigilem/evdev/system/posix_types'

module Vigilem
module Evdev
module Time
  # represents timeval from time.h
  class Timeval < ::VFFIStruct
    layout_with_methods :tv_sec, :__kernel_time_t,
                        :tv_usec, :__kernel_suseconds_t
    
    # 
    # @return [Numeric]
    def to_f
      tv_sec.to_f + (tv_usec.to_f/1000000.0)
    end
  end
end
end
end
