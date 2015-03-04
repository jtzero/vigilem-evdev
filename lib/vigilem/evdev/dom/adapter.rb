require 'vigilem/core/adapters'

require 'vigilem/core/event_handler'

require 'vigilem/core/eventable'

require 'vigilem/evdev'

require 'vigilem/evdev/dom/input_event_converter'

module Vigilem
module Evdev
  class KeyEvent < SimpleDelegator
    
    # 
    # 
    def is_a?
      __getobj__.is_a?
    end
    
    # 
    # 
    def self.cast(event)
      new(event)
    end
  end
module DOM
  # 
  # 
  class Adapter
    
    include InputEventConverter
    
    include Core::Adapters::BufferedAdapter
    
    include Core::EventHandler
    
    default_handler()
    
    # 
    # @param  devices
    def initialize(*devices)
      initialize_buffered(InputSystemHandler.new(*devices))
      on(KeyEvent) {|event| to_dom_key_event(event) } 
    end
    
    # 
    # @return [Hash]
    def type_hash
      @type_hash ||= { System::Input::EV_KEY => KeyEvent }
    end
    
    # 
    # 
    def to_dom_event(event)
      handle(event)
    end
    
    include Core::Eventable
    
    # 
    # @param  [Integer] limit, defaults to 1
    # @return [Array<DOM::Event>]
    def read_many_nonblock(limit=1)
      synchronize {
        buffered!(limit) do |len_remainder|
          dom_src_events = link.read_many_nonblock(len_remainder).map do |event| 
            handle(cast(event))
          end.compact.flatten
          # the DOM converter may return more events than called for
          ret, to_buffer = Support::Utils.split_at(dom_src_events, len_remainder)
          buffer.concat([*to_buffer])
          ret
        end
      }
    end
    
    # 
    # @param  event
    def cast(event)
      type_hash[event.type].respond.cast(event)
    end
    
  end
end
end
end
