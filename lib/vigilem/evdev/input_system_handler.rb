require 'vigilem/core/input_system_handler'

require 'vigilem/core/eventable'

require 'vigilem/evdev/system'

module Vigilem
module Evdev
  # 
  # Handles input from Evdev InputSystem
  class InputSystemHandler
    
    include Core::InputSystemHandler
    
    include Core::Eventable
    
    # 
    # @param  [Array] devices
    # @return 
    def initialize(*devices)
      self.class.lazy_require
      initialize_input_system_handler
      
      self.context_filters.concat([VTYContextFilter.new, FocusContextFilter.new_if_installed].compact)
      
      @transfer_agent = Evdev::TransferAgent.acquire(:inputs => devices, :outputs => {self.buffer => {:func => :concat}})
      
      @source = @transfer_agent
      
      @link = self.buffer
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def self.lazy_require
      unless @loaded
        require 'vigilem/evdev/at_exit'
        require 'vigilem/evdev/vty_context_filter'
        require 'vigilem/evdev/focus_context_filter'
        require 'vigilem/evdev/transfer_agent'
        @loaded = true
      end
      @loaded
    end
    
    # 
    # @return [Array]
    def context_filters
      @context_filters ||= []
    end
    
    # 
    # @param  [Integer] num, defaults to 1
    # @return [Array<InputEvent>]
    def read_many_nonblock(max_number_of_events=1)
      synchronize {
        raise ArgumentError, "max_number_of_events cannot be <= than 0:`#{max_number_of_events}'" if max_number_of_events.to_i <= 0
        transfer_agent.relay(max_number_of_events) if buffer.empty?
        events = buffer.shift(max_number_of_events)
        context_filters.reduce(events) {|memo, ctx| ctx.process(*memo) }
      }
    end
    
   private
    
    attr_reader :transfer_agent
  end
end
end
