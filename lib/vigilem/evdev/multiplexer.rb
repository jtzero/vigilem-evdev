require 'vigilem/core/multiplexer'

require 'vigilem/core/buffer'

require 'vigilem/evdev/system/input/input_event'

module Vigilem
module Evdev
  # 
  # 
  class Multiplexer 
    
    include Core::Multiplexer
    
    Input = System::Input
    
    InputEvent = Input::InputEvent
    
    # 
    # [#from_string, #time, #size]
    attr_reader :event_type
    
    # 
    # @param  [Array || IO] in_ios_or_arrays
    # @param  [Array || IO] out
    def initialize(in_ios_or_arrays, out=nil)
      @event_type = InputEvent
      initialize_multiplexer(in_ios_or_arrays, out)
    end
    
    # calls the inputs and returns the converted array
    # @param  [Integer] num, how much to read from each stream
    # @return [Array<InputEvent>]
    def sweep(num)
      [*ready?].map do |input|
        begin
          event_ary = [*if input.respond_to? :read_nonblock
            events = event_type.from_string(input.read_nonblock(num * event_type.size))
            events
          else
            input.slice!(num)
          end]
          event_ary.each do |event|
            # @fixme kludge, &block?
            if input.respond_to? :leds? and input.leds? and input.respond_to? :led_bits
              event.leds = input.led_bits
            end
            event.metadata[:source] = input
          end
        rescue EOFError, Errno::EAGAIN => e
          
        end
      end.flatten.compact.sort {|a,b| a.time.to_f <=> b.time.to_f }
    end
    
    class << self
      # @param  [Array]
      # @return [Evdev::Multiplexer]
      def acquire(inputs=[])
        if not @multiplexer
          @multiplexer ||= new(inputs)
        else
          @multiplexer.add_inputs(*inputs)
          @multiplexer
        end
      end
      
      private :new
    end
    
  end
end
end
