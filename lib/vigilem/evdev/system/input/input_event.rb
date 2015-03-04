require 'vigilem/support'

require 'vigilem/support/metadata'

require 'vigilem/evdev/system/input'

require 'vigilem/evdev/system/time'

module Vigilem
module Evdev
module System
module Input
  # 
  # represents struct input_event from input.h
  class InputEvent < ::VFFIStruct
    layout_with_methods :time, Time::Timeval,
                        :type, :__u16,
                        :code, :__u16,
                        :value, :__s32
    
    include Support::Metadata
    
    # @fixme kludge
    attr_accessor :leds
    
  end
end
end
end
end


require 'vigilem/evdev/system/input/event'
