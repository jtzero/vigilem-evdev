require 'vigilem/core/transfer_agent'

require 'vigilem/evdev/demultiplexer'

require 'vigilem/evdev/multiplexer'

module Vigilem
module Evdev
  # 
  # 
  class TransferAgent < Core::TransferAgent
    
    class << self
      
      # @todo move away from singleton and look at the one used by x11
      # @param  args [Hash]
      # @param  :inputs [Array]
      # @param  :outputs [Hash{observer_object => {event_opts}] 
      #         @see Demultiplexer#add_oberver
      # @return [TransferAgent]
      def acquire(args={})
        if @transfer_agent
          @transfer_agent.multiplexer.add_inputs(*args[:inputs]) if args[:inputs]
          @transfer_agent.add_observers(args[:outputs]) if args[:outputs]
          if ((din = @transfer_agent.demultiplexer.input) || (mout = @transfer_agent.multiplexer.out)).nil? or not mout.equal?(din)
            @transfer_agent.demultiplexer.input = @transfer_agent.multiplexer.out = (mout || din || [])
          end
          @transfer_agent
        else
          m = Multiplexer.acquire(args[:inputs])
          d = Demultiplexer.acquire(args[:outputs])
          @transfer_agent = new(d, m)
        end
      end
      
    end
    
  end
end
end
